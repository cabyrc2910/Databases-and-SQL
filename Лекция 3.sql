DROP DATABASE IF EXISTS myfirstdb;
-- создаём базу данных
CREATE DATABASE myfirstdb;
-- обращение к базе данных
USE myfirstdb;

-- создание таблиц
CREATE TABLE Products
(
Id INT AUTO_INCREMENT PRIMARY KEY,
ProductName VARCHAR(30) NOT NULL,
Manufacturer VARCHAR(20) NOT NULL,
ProductCount INT DEFAULT 0,
Price DECIMAL NOT NULL
);
INSERT INTO Products (ProductName, Manufacturer, ProductCount, Price)
VALUES
('iPhone X', 'Apple', 3, 76000),
('iPhone 8', 'Apple', 3, 51000),
('iPhone 7', 'Apple', 3, 32000),
('Galaxy S9', 'Samsung', 6, 56000),
('Galaxy S8', 'Samsung', 2, 46000),
('Nokia 8', 'HMD Global', 6, 38000),
('Honor 10', 'Huawei', 3, 28000);

USE myfirstdb;

SELECT * 
FROM Products
ORDER BY Price;  -- (ASC) сортировка по возрастанию от большего к меньшему

SELECT * 
FROM Products
ORDER BY Price DESC;  -- сортировка по возрастанию от меньшему к большего  

-- Агрегатные функции
SELECT COUNT(*) -- кол-во столбцов = 7
FROM Products;
 
SELECT COUNT(*) AS Count -- хотим увидеть в ответе столбец с именем Count
FROM Products;

SELECT * FROM Products
LIMIT 5;  -- вывод только первых 5 строчек таблицы  

SELECT * FROM Products
LIMIT 1,2;  -- 1 - сколько строчек необходимо пропустить 2 -  с какой строки начинаем выводить итоговый результат - с 3

SELECT SUM(Price) FROM Products;  --  итоговая сумма
SELECT SUM(Price) AS totalSum FROM Products;  --  итоговая сумма

SELECT * FROM Products;  -- выводим все данные

SELECT MIN(Price) 
FROM Products
WHERE Manufacturer = 'Apple'; -- минимальную сумму по Apple 

SELECT MIN(Price), MAX(Price), AVG(Price) -- минимальную сумму по Huawei, максимальную и среднюю
FROM Products
WHERE Manufacturer = 'Apple'; 

SELECT MIN(Price), MAX(Price), AVG(Price) -- минимальную сумму по Samsung, максимальную и среднюю
FROM Products
WHERE Manufacturer = 'Samsung'; 

SELECT Manufacturer, COUNT(*) AS Models, Price, ProductCount  -- повторяющиеся значения удаляются, пишется наибольшее из Apple и Samsung
FROM Products
WHERE Price > 40000
GROUP BY Manufacturer;






