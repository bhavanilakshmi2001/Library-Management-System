-- ========================
-- Create Database
-- ========================
CREATE DATABASE IF NOT EXISTS library_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library_db;

-- ========================
-- 1. Users Table
-- ========================
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20) ,
  address VARCHAR(255),
  gender ENUM('Male', 'Female') NOT NULL,
  dob DATE NOT NULL,
  role ENUM('admin', 'user') DEFAULT 'user',
  status ENUM('pending', 'active', 'inactive') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);





-- ========================
-- 2. Books Table
-- ========================
CREATE TABLE IF NOT EXISTS books (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(200),
  category VARCHAR(100),
  isbn VARCHAR(50),
  copies INT DEFAULT 1,
  publisher VARCHAR(200),
  pub_year INT,
  language VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Books
INSERT INTO books 
(title, author, category, isbn, publisher, pub_year, language, copies) 
VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', '9780743273565', 'Scribner', 1925, 'English', 5),
('Atomic Habits', 'James Clear', 'Self-help', '9780735211292', 'Penguin Random House', 2018, 'English', 3),
('Clean Code', 'Robert C. Martin', 'Programming', '9780132350884', 'Prentice Hall', 2008, 'English', 7),
('Wings of Fire', 'A. P. J. Abdul Kalam', 'Biography', '9788173711466', 'Universities Press', 1999, 'English', 4);

-- ========================
-- 3. Borrow Requests Table
-- ========================
CREATE TABLE borrow_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  book_id INT NOT NULL,
  request_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  status ENUM('pending','approved','rejected','returned') DEFAULT 'pending',
  issue_date DATE,
  expiry_date DATE,
  return_date DATE,
  fine_amount DECIMAL(10,2) DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- Sample Borrow Requests
INSERT INTO borrow_requests (user_id, book_id, status, issue_date, expiry_date)
VALUES
(2, 1, 'approved', '2025-08-10', '2025-08-15'),
(3, 2, 'pending', NULL, NULL),
(2, 3, 'returned', '2025-07-20', '2025-07-25');




