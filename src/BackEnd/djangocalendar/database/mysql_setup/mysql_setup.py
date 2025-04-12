import os
import time
import MySQLdb

def read_sql_file(file_path):
    """Reads the SQL file and returns its content as a string."""
    with open(file_path, "r", encoding="utf-8") as file:
        return file.read()

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
    DB_NAME = os.getenv("DB_NAME", "PlanifyDB")
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

        # Split the SQL file by semicolon and execute each statement sequentially.
        # (Assumes that semicolon is only used as a statement delimiter.)
        queries = sql_script.split(";")
        with conn.cursor() as cursor:
            for query in queries:
                stmt = query.strip()
                if stmt:
                    print("Executing SQL statement:")
                    print(stmt)
                    cursor.execute(stmt)
        conn.commit()
        print("Database schema applied successfully.")

    except FileNotFoundError:
        print("schema.sql not found. Ensure it exists in the same folder as mysql_setup.py.")
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    main()
