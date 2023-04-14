USE myfirstdb;

-- CREATE TABLE - создаёт базу данных
CREATE TABLE Customer
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
    Age int,
    FirstName VARCHAR(20),
    LastName Varchar(20)
);

# это коментарий
/*
Это многострочный коментарий
И это коментарий
*/
SELECT * FROM Customer;
SELECT 3+5;
SELECT 3-5;
/*
Умножение "*"
*/
SELECT 3*5;


USE myfirstdb;
CREATE TABLE Products
(
Id INT AUTO_INCREMENT PRIMARY KEY,
ProductName VARCHAR(30) NOT NULL,
Manufacturer VARCHAR(20) NOT NULL,
ProductCount INT DEFAULT 0,
Price DECIMAL
);
INSERT INTO Products (ProductName, Manufacturer, ProductCount, Price)
VALUES
('iPhone X', 'Apple', 3, 76000),
('iPhone 8', 'Apple', 2, 51000),
('Galaxy S9', 'Samsung', 2, 56000),
('Galaxy S8', 'Samsung', 1, 41000),
('P20 Pro', 'Huawei', 5, 36000);

# информация до увеличения цены 
-- Выбрать только производителей "Apple"и "Samsung"
SELECT * FROM Products
WHERE Manufacturer IN ("Apple", "Samsung");

-- Выбрать только НЕ производителей  "Apple"и "Samsung"
SELECT * FROM Products
WHERE NOT Manufacturer IN ("Apple", "Samsung");









