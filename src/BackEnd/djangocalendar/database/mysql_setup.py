import os
import mysql.connector
from mysql.connector import errorcode

# Read database connection parameters from environment variables
DB_NAME = os.getenv("DB_NAME", "djangocalendar")
DB_USER = os.getenv("DB_USER", "root")
DB_PASSWORD = os.getenv("DB_PASSWORD", "muazzamaida")
DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = int(os.getenv("DB_PORT", 3306))

DROP_TABLE_QUERY = "DROP TABLE IF EXISTS persons"
CREATE_TABLE_QUERY = """
CREATE TABLE persons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
"""

# Insert sample data with realistic names and details
INSERT_SAMPLE_DATA = """
INSERT INTO persons (name, username, age, gender, email, password)
VALUES
    ('Aida', 'aida', 12, 'Female', 'aida@example.com', '1234'),
    ('Muazzam', 'muazzam', 12, 'Male', 'muazzam@example.com', '1234'),
    ('Tom', 'tom', 12, 'Male', 'tom@example.com', '1234'),
    ('David', 'david', 12, 'Male', 'david@example.com', '1234');
"""

def main():
    try:
        print(f"Connecting to MySQL at {DB_HOST}:{DB_PORT} ...")
        cnx = mysql.connector.connect(
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=DB_PORT,
            database=DB_NAME
        )
        cursor = cnx.cursor()

        # Drop the table if it exists
        cursor.execute(DROP_TABLE_QUERY)
        print("Dropped table 'persons' if it existed.")

        # Create the new table
        cursor.execute(CREATE_TABLE_QUERY)
        cnx.commit()
        print("Table 'persons' created successfully.")

        # Insert sample data into the table
        cursor.execute(INSERT_SAMPLE_DATA)
        cnx.commit()
        print("Sample data inserted into 'persons' successfully.")

    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Access denied: Check your username or password.")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print(f"Database '{DB_NAME}' does not exist.")
        else:
            print(f"Error: {err}")
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'cnx' in locals() and cnx.is_connected():
            cnx.close()

if __name__ == "__main__":
    main()
