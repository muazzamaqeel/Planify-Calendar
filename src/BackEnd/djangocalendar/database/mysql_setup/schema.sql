-- Create schema if it doesn't exist
CREATE DATABASE IF NOT EXISTS PlanifyDB;

-- Use the schema
USE PlanifyDB;

-- Drop the 'persons' table if it exists
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS persons;

-- Create the 'persons' table
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

-- Insert sample data into the 'persons' table
INSERT INTO persons (name, username, age, gender, email, password)
VALUES
    ('Aida', 'aida', 12, 'Female', 'aida@example.com', '1234'),
    ('Muazzam', 'muazzam', 12, 'Male', 'muazzam@example.com', '1234'),
    ('Tom', 'tom', 12, 'Male', 'tom@example.com', '1234'),
    ('David', 'david', 12, 'Male', 'david@example.com', '1234');

-- Create the 'events' table
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    event_name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    description TEXT,
    location VARCHAR(255),
    tag VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key to link with the 'persons' table
    FOREIGN KEY (user_id) REFERENCES persons(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;
