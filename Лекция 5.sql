DROP DATABASE IF EXISTS Лекция_5;
-- создаём базу данных
CREATE DATABASE Лекция_5;
-- обращение к базе данных
USE Лекция_5;

-- создание таблиц
CREATE TABLE sales(
	sales_employee VARCHAR(50) NOT NULL,
	fiscal_year INT NOT NULL,
	sale DECIMAL (14,2) NOT NULL,
    PRIMARY KEY(sales_employee, fiscal_year)
);

-- наполнение списка
INSERT INTO sales(sales_employee, fiscal_year, sale)
VALUES
('Alice', '2016', 100),
('Alice', '2017', 150),
('Alice', '2018', 200),
('Bob', '2016', 150),
('Bob', '2017', 100),
('Bob', '2018', 200),
('John', '2016', 200),
('John', '2017', 150),
('John', '2018', 200);

SELECT * FROM sales;  -- выводим все данные

SELECT SUM(sale)  -- выводим все данные
FROM sales;

SELECT fiscal_year, SUM(sale) -- общий обьём продаж по финансовым годам
FROM sales
GROUP BY fiscal_year;

-- создание таблиц
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	date DATE,
	medium VARCHAR(45),
	conversions INT
    );

-- наполнение списка
INSERT INTO Orders(date, medium, conversions)
VALUES
('10.05.2020', 'cpa', 1),
('10.05.2020', 'cpc', 2),
('10.05.2020', 'organic', 1),
('11.05.2020', 'cpa', 1),
('11.05.2020', 'cpc', 3),
('11.05.2020', 'organic', 2),
('11.05.2020', 'diffect', 1),
('12.05.2020', 'cpc', 1),
('12.05.2020', 'organic', 2);

SELECT Date, Medium, Conversions, SUM(Conversions) OVER() AS 'Sum'
FROM Orders;

-- PARTITION BY -- столбец для группировки

-- PARTITION -- набор строк для оконной функции для одного или несколько столюбцов по которым мы проводим выборку
-- ORDER BY -- столбец для сортировки
-- ROWS  или  RANGE  - выражение для огранничения стрлок в пределлах группы

SELECT Date, Medium, Conversions, SUM(Conversions) OVER(PARTITION BY DATE) AS 'Sum'
FROM Orders;

-- ORDER BY
SELECT Date, Medium, Conversions, SUM(Conversions) OVER(PARTITION BY DATE ORDER BY Medium) AS 'Sum'
FROM Orders;

-- LAG или LEAD -- функцию можно использовать для того, чтобы сравнивать текущее значение строки с предыдущим или следующим
-- LAG обращается к данным из предыдущей строки окна, а 
-- LEAD к данным из следующей строки.

SELECT Date, Medium, Conversions, 
LAG(Conversions) OVER(PARTITION BY DATE ORDER BY DATE) AS 'LAG',
LEAD(Conversions) OVER(PARTITION BY DATE ORDER BY DATE) AS 'LEAD',
FIRST_VALUE(Conversions) OVER(PARTITION BY DATE ORDER BY DATE) AS 'FIRST_VALUE',
LAST_VALUE(Conversions) OVER(PARTITION BY DATE ORDER BY DATE) AS 'LAST_VALUE'
FROM Orders;

USE myfirstdb;
SELECT * FROM myfirstdb.products;

DROP VIEW IF EXISTS CopyProducts;
CREATE VIEW CopyProducts AS
SELECT Price, ProductCount, Manufacturer
FROM Products
WHERE Manufacturer = 'Apple';

SELECT * FROM CopyProducts;

-- Удаление виртуальной таблицы
DROP VIEW IF EXISTS CopyProducts;

-- Создание и Удаление таблицы
CREATE TABLE Test
(
	Id INT,
    Count INT
);
DROP TABLE test;

-- Операции с передставлениями: изменение
DROP VIEW IF EXISTS CopyProducts;
CREATE VIEW CopyProducts AS
SELECT Price, ProductCount, Manufacturer
FROM Products
WHERE Manufacturer = 'Apple';

-- Добавляем колонку ProductName
SELECT * FROM CopyProducts;
ALTER VIEW CopyProducts AS
SELECT Price, ProductCount, Manufacturer, ProductName
FROM Products
WHERE Manufacturer = 'Apple';

SELECT * FROM CopyProducts;

-- Добавляем колонку  в таблицу test
ALTER TABLE test ADD COLUMN TestString VARCHAR(40);
SELECT * FROM test;

-- Добавляем столбец в таблицу test
-- ALTER TABLE name_table ADD COLUMN column_name ;

-- Удалить строку из test
ALTER TABLE test DROP COLUMN TestString;
SELECT * FROM test;

-- Задача: создайте представление, которое показывало бы всех заказчиков, имеющих самые высокие рейтинги.
-- Привязке к таблице нет, колонки таблицы воображаемые
CREATE VIEW Highratings 
AS SELECT *
FROM Customers
WHERE rating = (SELECT MAX(rating) FROM Customers);