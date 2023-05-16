DROP DATABASE IF EXISTS Лекция_4;
-- создаём базу данных
CREATE DATABASE Лекция_4;
-- обращение к базе данных
USE Лекция_4;

-- создание таблиц
CREATE TABLE Customers
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	AccountSum DECIMAL
);

-- наполнение списка
INSERT INTO Customers(FirstName, lastName, AccountSum)
VALUES
('Tom', 'Smith', 2000),
('Sam', 'Brown', 3000),
('Mark', 'Adams', 2500),
('Paul', 'Ins', 4200),
('John', 'Smith', 2800),
('Tim', 'Cook', 2800);

SELECT * FROM Customers;  -- выводим все данные

-- создание таблиц
CREATE TABLE Imployees
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL
);

-- наполнение списка
INSERT INTO Imployees(FirstName, lastName)
VALUES
('Homer', 'Simpson'),
('Tom', 'Smith'),
('Mark', 'Adams'),
('Nick', 'Svensson');

SELECT * FROM Imployees;  -- выводим все данные

-- * Операторы UNION
-- Берём 2 таблицы с повторяющимися значениями
SELECT FirstName,lastName
FROM Customers
UNION SELECT FirstName, lastName From Imployees
-- произвеём сортировку с помощью ORDER BY по FirstName
ORDER BY FirstName DESC;


-- * Оператор union all - выводит все строчки без исключения(обьединение выборок)
SELECT FirstName,lastName
FROM Customers
UNION ALL SELECT FirstName, lastName 
From Imployees
-- произведём сортировку с помощью ORDER BY по FirstName
ORDER BY FirstName;

-- начисляем проценты на вклад
SELECT FirstName, lastName, AccountSum + AccountSum * 0,1 AS TotalSum
FROM Customers WHERE AccountSum < 3000
UNION SELECT FirstName, lastName, AccountSum + AccountSum * 0.3 AS TotalSum
FROM Customers WHERE AccountSum >= 3000;


-- * Соединение таблиц — JOIN
-- создание таблиц
CREATE TABLE Products
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
	ProductName VARCHAR(30) NOT NULL,
	Manufactured VARCHAR(20) NOT NULL,
	ProductCount INT Default 0,
	Price Decimal NOT NULL
);

-- наполнение списка
INSERT INTO Products (ProductName, Manufactured, ProductCount, Price)
VALUES
('iPhone X', 'Apple', 3, 76000),
('iPhone 8', 'Apple', 2, 51000),
('Galaxy S9', 'Samsung', 2, 56000),
('Galaxy S8', 'Samsung', 1, 41000),
('P20 Pro', 'Huawei', 5, 36000);

SELECT * FROM Products;  -- выводим все данные

-- создание таблиц
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
	FirstName VARCHAR(30) NOT NULL
);

-- наполнение списка
INSERT INTO Customers(FirstName)
VALUES
('Tom'),
('Sam'),
('Mark'),
('Paul'),
('John'),
('Tim');

SELECT * FROM Customers;  -- выводим все данные

-- создание таблиц
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
	ProductId INT NOT NULL,
	CustomerId INT NOT NULL,
	CreatedAt DATE NOT NULL,
	ProductCount INT DEFAULT 1,
	Price DECIMAL NOT NULL,
	FOREIGN KEY(ProductId) REFERENCES Products(Id) ON DELETE CASCADE,
	FOREIGN KEY(CustomerId) REFERENCES Customers(Id) ON DELETE CASCADE
);

-- наполнение списка
INSERT INTO Orders (ProductId, CustomerId, CreatedAt, ProductCount, Price)
VALUES
(3, 3, '2018-05-23', 3, 76000),
(2, 2, '2018-05-21', 2, 51000),
(2, 2, '2018-06-19', 2, 56000),
(1, 1, '2018-07-02', 1, 41000),
(5, 5, '2018-02-22', 5, 36000);

SELECT * FROM Orders;  -- выводим все данные

-- * INNER JOIN
SELECT Orders.CreatedAt, Orders.ProductCount,  Products.ProductName
FROM Orders
Join Products ON Products.Id = Orders.ProductId;

-- * INNER JOIN: пример с использованием псевдонимов
SELECT O.CreatedAt, O.ProductCount,  P.ProductName
FROM Orders AS o
Join Products AS P
ON P.Id = O.ProductId;

-- * LEFT OUTER JOIN
SELECT FirstName, CreatedAt, ProductCount,  Price
FROM Orders LEFT JOIN Customers
ON Orders.CustomerId = Customers.Id;

-- * RIGHT OUTER JOIN
SELECT FirstName, CreatedAt, ProductCount,  Price
FROM Customers RIGHT JOIN Orders
ON Orders.CustomerId = Customers.Id;


-- создание таблиц
DROP TABLE IF EXISTS Products;
CREATE TABLE Products
(
	product_id INT NOT NULL,
	category INT,
	product_name VARCHAR(30) NOT NULL
);

-- наполнение списка
INSERT INTO Products (product_id, category, product_name)
VALUES
(1, 1, 'Системный блок'),
(2, 1, 'Монитор'),
(3, 2, 'Холодильник'),
(4, 2, 'Телевизор'),
(5, 0, 'Операционная система');

SELECT * FROM Products;  -- выводим все данные

-- создание таблиц
DROP TABLE IF EXISTS Categories;
CREATE TABLE Categories
(
	category_id INT NOT NULL,
	category_name VARCHAR(30) NOT NULL
);

-- наполнение списка
INSERT INTO Categories (category_id, category_name)
VALUES
(1, 'Комплектующие компьютера'),
(2, 'Бытовая техника'),
(3, 'Мобильные устройства');

SELECT * FROM Categories;  -- выводим все данные


-- * FULL JOIN: пример замены через UNION
SELECT p.product_name, c.category_name
FROM products p 
LEFT JOIN categories c ON p.category = c.category_id

UNION

SELECT p.product_name, c.category_name
FROM products p 
RIGHT JOIN categories c ON p.category = c.category_id;


-- создание таблиц
DROP TABLE IF EXISTS Products;
CREATE TABLE Products
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
	ProductName VARCHAR(30) NOT NULL,
	Manufactured VARCHAR(20) NOT NULL,
	ProductCount INT Default 0,
	Price Decimal NOT NULL
);

-- наполнение списка
INSERT INTO Products (ProductName, Manufactured, ProductCount, Price)
VALUES
('iPhone X', 'Apple', 3, 76000),
('iPhone 8', 'Apple', 2, 51000),
('Galaxy S9', 'Samsung', 2, 56000),
('Galaxy S8', 'Samsung', 1, 41000),
('P20 Pro', 'Huawei', 5, 36000);

SELECT * FROM Products;  -- выводим все данные

-- * Подзапросы: оператор IN
-- Выберем все товары из таблицы Products, на которые есть заказы в таблице Orders:
SELECT * FROM Products
WHERE Id IN(SELECT ProductId FROM Orders);

-- Можем выбрать те товары, на которые нет заказов в таблице Orders:
SELECT * FROM Products
WHERE Id NOT IN(SELECT ProductId FROM Orders);

-- * Подзапросы: оператор EXISTS
SELECT * FROM Products
WHERE EXISTS
(SELECT * FROM Orders WHERE  Orders.ProductId =  Products.Id);

-- * CREATE TABLE SELECT -- создать и склонировать содержимое новой таблицы
CREATE TABLE SelectIntoDemo
(
	Id INT,
    FirstName VARCHAR (200)
);
INSERT INTO SelectIntoDemo VALUES(1, 'Bob'),(2, 'Carol'),(3, 'David');

SELECT * FROM SelectIntoDemo;
CREATE TABLE yourTempTable SELECT * FROM SelectIntoDemo;
SELECT * FROM yourTempTable;



CREATE TABLE test
(
	Id INT,
    Name VARCHAR (45)
);
INSERT INTO test VALUES(1, 'Bob'),(2, 'Tom'),(3, 'Tim');

SELECT * FROM test;
CREATE TABLE copy SELECT * FROM test;
SELECT * FROM copy;

-- Порядок выполнения запроса
SELECT [DISTINCT | ALL] поля_таблиц
FROM список_таблиц
[WHERE условия_на_ограничения_строк]  - сокращаем данные применяя фильтр
[GROUP BY условия_группировки]  - группировка
[HAVING условия_ на_ограничение_строк_после_группировки] - убирает лишнее после группировки
[ORDER BY порядок_сортировки[ASC | DESC]]
[LIMIT ограничение_количества_записей]


-- создание таблиц
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
	Name VARCHAR(20) NOT NULL,
	Address VARCHAR(20) NOT NULL,
	Phone BIGINT UNSIGNED,
	Salary INT
);
INSERT INTO Orders (Name, Address, Phone, Salary)
VALUES
('Nikhil', 'Delhi', 9878906543, 8000),
('Divya', 'Ranchi', 8990076543, 5000),
('Ravi', 'Bareily', 7789945765, 7000),
('Anna', 'Noida', 9789945760, 4000),
('Surbhi', 'Jaipur', 7800541123, 5500);

SELECT * FROM Orders;  -- выводим все данные