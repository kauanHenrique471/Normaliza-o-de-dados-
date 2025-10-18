
CREATE DATABASE erp_db;
USE erp_db;

-- ------------------------
-- TABELA CATEGORIES
-- ------------------------
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(255),
    Description TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Categories.csv'
INTO TABLE Categories
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ------------------------
-- TABELA SUPPLIERS
-- ------------------------
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactName VARCHAR(100),
    Address VARCHAR(150),
    City VARCHAR(50),
    PostalCode VARCHAR(20),
    Country VARCHAR(50),
    Phone VARCHAR(30)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Suppliers.csv'
INTO TABLE Suppliers
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ------------------------
-- TABELA PRODUCTS
-- ------------------------
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    SupplierID INT,
    CategoryID INT,
    Unit VARCHAR(50),
    Price DECIMAL(10,2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Products.csv'
INTO TABLE Products
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(ProductID, ProductName, SupplierID, CategoryID, Unit, @Price)
SET Price = REPLACE(@Price, ',', '.');

-- ------------------------
-- TABELA CUSTOMERS
-- ------------------------
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(255),
    ContactName VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ------------------------
-- TABELA EMPLOYEES
-- ------------------------
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    LastName VARCHAR(255),
    FirstName VARCHAR(255),
    BirthDate DATE,
    Photo VARCHAR(100),
    Notes TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Employees.csv'
INTO TABLE Employees
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(EmployeeID, LastName, FirstName, @BirthDate, Photo, Notes)
SET BirthDate = STR_TO_DATE(@BirthDate, '%d/%m/%Y');

-- ------------------------
-- TABELA SHIPPERS
-- ------------------------
CREATE TABLE Shippers (
    ShipperID INT PRIMARY KEY,
    ShipperName VARCHAR(100),
    Phone VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Shippers.csv'
INTO TABLE Shippers
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ------------------------
-- TABELA ORDERS
-- ------------------------
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATE,
    ShipperID INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(OrderID, CustomerID, EmployeeID, @OrderDate, ShipperID)
SET OrderDate = STR_TO_DATE(@OrderDate, '%d/%m/%Y');

-- ------------------------
-- TABELA ORDERDETAILS
-- ------------------------
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/OrderDetails.csv'
INTO TABLE OrderDetails
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ------------------------
-- RELAÇÕES (FOREIGN KEYS)
-- ------------------------
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Suppliers
FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID);

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Employees
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Shippers
FOREIGN KEY (ShipperID) REFERENCES Shippers(ShipperID);

ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_Orders
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);

ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_Products
FOREIGN KEY (ProductID) REFERENCES Products(ProductID);
