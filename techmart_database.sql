-- TechMart E-commerce Database Setup
-- Session 1: Database Foundations & SQL Essentials

-- Change to Master
USE master;
GO

-- Drop the database if it exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'TechMart')
BEGIN
  ALTER DATABASE TechMart SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE TechMart;
END
GO

-- Create Database
CREATE DATABASE TechMart
GO

ALTER AUTHORIZATION ON DATABASE::TechMart TO sa
GO

USE TechMart
GO

-- 1. Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(50) NOT NULL,
    Description VARCHAR(255)
)
GO

-- 2. Products Table  
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT DEFAULT 0,
    Brand VARCHAR(50),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
)
GO

-- 3. Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    City VARCHAR(50),
    Region VARCHAR(50),
    Country VARCHAR(50) DEFAULT 'UK',
    JoinDate DATE DEFAULT GETDATE()
)
GO

-- 4. Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    OrderDate DATE DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    OrderStatus VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)
GO

-- 5. OrderItems Table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
)
GO

-- INSERT SAMPLE DATA

-- Categories
INSERT INTO Categories (CategoryName, Description) VALUES 
('Laptops', 'Portable computers and notebooks'),
('Smartphones', 'Mobile phones and accessories'),
('Tablets', 'Tablet computers and e-readers'),
('Accessories', 'Computer and mobile accessories'),
('Gaming', 'Gaming consoles and peripherals');

-- Products
INSERT INTO Products (ProductName, CategoryID, Price, StockQuantity, Brand) VALUES 
-- Laptops
('ThinkPad X1 Carbon', 1, 1299.99, 15, 'Lenovo'),
('MacBook Air M2', 1, 1249.00, 8, 'Apple'),
('Dell XPS 13', 1, 999.99, 12, 'Dell'),
('HP Pavilion 15', 1, 649.99, 20, 'HP'),
-- Smartphones  
('iPhone 15', 2, 799.00, 25, 'Apple'),
('Samsung Galaxy S24', 2, 749.99, 18, 'Samsung'),
('Google Pixel 8', 2, 599.00, 22, 'Google'),
('OnePlus 12', 2, 549.99, 15, 'OnePlus'),
-- Tablets
('iPad Pro 12.9"', 3, 1099.00, 10, 'Apple'),
('Samsung Galaxy Tab S9', 3, 649.99, 14, 'Samsung'),
('Microsoft Surface Pro', 3, 899.99, 8, 'Microsoft'),
-- Accessories
('AirPods Pro', 4, 249.00, 30, 'Apple'),
('Logitech MX Master 3', 4, 89.99, 25, 'Logitech'),
('Dell USB-C Hub', 4, 79.99, 40, 'Dell'),
('Anker PowerCore 10000', 4, 29.99, 50, 'Anker'),
-- Gaming
('PlayStation 5', 5, 479.99, 5, 'Sony'),
('Xbox Series X', 5, 449.99, 7, 'Microsoft'),
('Nintendo Switch OLED', 5, 309.99, 12, 'Nintendo');

-- Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, City, Region, Country, JoinDate) VALUES 
('James', 'Smith', 'james.smith@email.com', '07700123456', 'London', 'England', 'UK', '2024-01-15'),
('Sarah', 'Johnson', 'sarah.j@email.com', '07700234567', 'Manchester', 'England', 'UK', '2024-02-03'),
('David', 'Williams', 'david.williams@email.com', '07700345678', 'Birmingham', 'England', 'UK', '2024-01-28'),
('Emma', 'Brown', 'emma.brown@email.com', '07700456789', 'Leeds', 'England', 'UK', '2024-03-12'),
('Michael', 'Jones', 'michael.jones@email.com', '07700567890', 'Liverpool', 'England', 'UK', '2024-02-20'),
('Sophie', 'Davis', 'sophie.davis@email.com', '07700678901', 'Edinburgh', 'Scotland', 'UK', '2024-01-08'),
('Oliver', 'Miller', 'oliver.miller@email.com', '07700789012', 'Glasgow', 'Scotland', 'UK', '2024-03-05'),
('Jessica', 'Wilson', 'jessica.wilson@email.com', '07700890123', 'Cardiff', 'Wales', 'UK', '2024-02-14'),
('Thomas', 'Moore', 'thomas.moore@email.com', '07700901234', 'Belfast', 'Northern Ireland', 'UK', '2024-01-30'),
('Charlotte', 'Taylor', 'charlotte.taylor@email.com', '07701012345', 'Bristol', 'England', 'UK', '2024-03-18'),
('Daniel', 'Anderson', 'daniel.anderson@email.com', '07701123456', 'Newcastle', 'England', 'UK', '2024-02-07'),
('Lucy', 'Thomas', 'lucy.thomas@email.com', '07701234567', 'Nottingham', 'England', 'UK', '2024-01-25'),
('Ryan', 'Jackson', 'ryan.jackson@email.com', '07701345678', 'Sheffield', 'England', 'UK', '2024-03-01'),
('Amy', 'White', 'amy.white@email.com', '07701456789', 'Leicester', 'England', 'UK', '2024-02-28'),
('Jack', 'Harris', 'jack.harris@email.com', '07701567890', 'Coventry', 'England', 'UK', '2024-01-12');

-- Orders (will be inserted after we calculate totals)
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, OrderStatus) VALUES 
(1, '2024-03-01', 1548.99, 'Delivered'),
(2, '2024-03-02', 749.99, 'Delivered'),
(3, '2024-03-03', 1179.98, 'Shipped'),
(1, '2024-03-05', 338.99, 'Delivered'),
(4, '2024-03-07', 999.99, 'Processing'),
(5, '2024-03-08', 629.98, 'Delivered'),
(6, '2024-03-10', 1348.00, 'Shipped'),
(2, '2024-03-12', 89.99, 'Delivered'),
(7, '2024-03-14', 479.99, 'Processing'),
(8, '2024-03-15', 909.98, 'Delivered'),
(9, '2024-03-16', 249.00, 'Shipped'),
(3, '2024-03-18', 79.99, 'Delivered'),
(10, '2024-03-20', 1299.99, 'Processing'),
(11, '2024-03-21', 549.99, 'Delivered'),
(12, '2024-03-22', 719.98, 'Shipped');

-- OrderItems
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES 
-- Order 1 (James Smith): Laptop + Accessories
(1, 1, 1, 1299.99),  -- ThinkPad X1 Carbon
(1, 12, 1, 249.00),  -- AirPods Pro
-- Order 2 (Sarah Johnson): Smartphone
(2, 6, 1, 749.99),   -- Samsung Galaxy S24
-- Order 3 (David Williams): Laptop + Mouse
(3, 4, 1, 649.99),   -- HP Pavilion 15
(3, 13, 1, 89.99),   -- Logitech MX Master 3
(3, 15, 2, 29.99),   -- Anker PowerCore (x2)
-- Order 4 (James Smith - 2nd order): Gaming + Power Bank
(4, 18, 1, 309.99),  -- Nintendo Switch OLED
(4, 15, 1, 29.99),   -- Anker PowerCore
-- Order 5 (Emma Brown): Laptop
(5, 3, 1, 999.99),   -- Dell XPS 13
-- Order 6 (Michael Jones): Smartphone + Accessories
(6, 7, 1, 599.00),   -- Google Pixel 8
(6, 15, 1, 29.99),   -- Anker PowerCore
-- Order 7 (Sophie Davis): iPhone + iPad
(7, 5, 1, 799.00),   -- iPhone 15
(7, 9, 1, 549.99),   -- iPad Pro (discounted)
-- Order 8 (Sarah Johnson - 2nd order): Mouse
(8, 13, 1, 89.99),   -- Logitech MX Master 3
-- Order 9 (Oliver Miller): Gaming Console
(9, 16, 1, 479.99),  -- PlayStation 5
-- Order 10 (Jessica Wilson): Tablet + Accessories
(10, 11, 1, 899.99), -- Microsoft Surface Pro
(10, 15, 1, 29.99),  -- Anker PowerCore
-- Order 11 (Thomas Moore): AirPods
(11, 12, 1, 249.00), -- AirPods Pro
-- Order 12 (David Williams - 2nd order): USB-C Hub
(12, 14, 1, 79.99),  -- Dell USB-C Hub
-- Order 13 (Charlotte Taylor): Laptop
(13, 1, 1, 1299.99), -- ThinkPad X1 Carbon
-- Order 14 (Daniel Anderson): Smartphone
(14, 8, 1, 549.99),  -- OnePlus 12
-- Order 15 (Lucy Thomas): Tablet + Mouse
(15, 10, 1, 649.99), -- Samsung Galaxy Tab S9
(15, 13, 1, 89.99);  -- Logitech MX Master 3

