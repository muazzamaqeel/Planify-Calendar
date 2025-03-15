-- [tag: drop_persons_table]
DROP TABLE IF EXISTS persons;

-- [tag: create_persons_table]
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

-- [tag: insert_sample_data]
INSERT INTO persons (name, username, age, gender, email, password)
VALUES
    ('Aida', 'aida', 12, 'Female', 'aida@example.com', '1234'),
    ('Muazzam', 'muazzam', 12, 'Male', 'muazzam@example.com', '1234'),
    ('Tom', 'tom', 12, 'Male', 'tom@example.com', '1234'),
    ('David', 'david', 12, 'Male', 'david@example.com', '1234');
