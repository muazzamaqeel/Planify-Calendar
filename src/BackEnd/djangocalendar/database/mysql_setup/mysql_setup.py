import os
import time
import re
import MySQLdb

def read_sql_file(file_path):
    """Read the SQL file and return its contents as a string."""
    with open(file_path, "r", encoding="utf-8") as file:
        return file.read()

def parse_tagged_sql(sql_script):
    """
    Parse a SQL script into tagged SQL blocks.
    Each block starts with a tag comment of the form:
      -- [tag: some_tag]
    Returns a list of tuples: (tag, sql_query).
    """
    # Regex captures tag and everything until the next tag or end-of-file.
    pattern = re.compile(
        r'--\s*\[tag:\s*(?P<tag>.*?)\s*\](?P<query>.*?)(?=(?:--\s*\[tag:)|\Z)',
        re.DOTALL | re.IGNORECASE
    )
    blocks = []
    for match in pattern.finditer(sql_script):
        tag = match.group("tag").strip()
        query = match.group("query").strip().rstrip(";")  # Remove trailing semicolon if any.
        blocks.append((tag, query))
    return blocks

def execute_sql_block(cursor, tag, query):
    """
    Execute a SQL block and print a descriptive action based on the tag.
    """
    # Hardcoded actions for known tags
    if tag.lower() == "drop_persons_table":
        print("Action: Dropping table 'persons' if it exists.")
    elif tag.lower() == "create_persons_table":
        print("Action: Creating table 'persons' with all required columns.")
    elif tag.lower() == "insert_sample_data":
        print("Action: Inserting sample data into the 'persons' table.")
    else:
        print(f"Action: Executing query with unrecognized tag '{tag}'.")
    
    print(f"Executing SQL:\n{query}\n")
    cursor.execute(query)

def connect_to_database(host, port, user, password, db, max_retries=10):
    """Try to connect to the database with retry logic."""
    conn = None
    for attempt in range(1, max_retries + 1):
        try:
            conn = MySQLdb.connect(host=host, port=port, user=user, passwd=password, db=db)
            print("Connection established.")
            break
        except MySQLdb.OperationalError as e:
            print(f"Attempt {attempt} failed: {e}")
            if attempt < max_retries:
                print("Retrying in 5 seconds...")
                time.sleep(5)
            else:
                print("Max retries reached. Could not connect to the database.")
                return None
    return conn

def main():
    # Load environment variables
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_PORT = int(os.getenv("DB_PORT", "3306"))
    DB_NAME = os.getenv("DB_NAME", "djangocalendar")
    DB_USER = os.getenv("DB_USER", "root")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "")

    print(f"Connecting to MySQL at {DB_HOST}:{DB_PORT} ...")
    conn = connect_to_database(DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME)
    if not conn:
        return

    try:
        # Build the absolute path to schema.sql relative to this file's directory
        script_dir = os.path.dirname(os.path.abspath(__file__))
        schema_path = os.path.join(script_dir, "schema.sql")
        print(f"Reading schema from: {schema_path}")
        sql_script = read_sql_file(schema_path)
        
        # Parse the SQL script into tagged blocks
        tagged_blocks = parse_tagged_sql(sql_script)
        if not tagged_blocks:
            print("No tagged SQL blocks found.")
            return

        with conn.cursor() as cursor:
            for tag, query in tagged_blocks:
                execute_sql_block(cursor, tag, query)
        conn.commit()
        print("Database schema applied successfully.")

    except FileNotFoundError:
        print("schema.sql not found. Ensure it exists in the same folder as mysql_setup.py.")
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    main()
