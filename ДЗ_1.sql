-- * Задача 1
-- 1. Создайте таблицу с мобильными телефонами (mobile_phones), используя графический интерфейс. Заполните БД данными.

-- удаляем базу данных
DROP DATABASE IF EXISTS DZ_1;
-- создаём базу данных
CREATE DATABASE DZ_1;
-- обращение к базе данных
USE DZ_1;

-- создание таблиц
CREATE TABLE mobile_phones (
    id INT  NOT NULL, 
    product_name VARCHAR(45),
    manufacturer VARCHAR(45),
    product_count INT,
    price INT,
    PRIMARY KEY(id)
);

-- наполнение нужными данными
INSERT INTO mobile_phones (id, product_name, manufacturer, product_count, price)
VALUES 
(1, 'iPhone X', 'Apple', 3, 76000),
(2, 'iPhone 8', 'Apple', 2, 51000),
(3, 'Galaxy S9', 'Samsung', 2, 56000),
(4, 'Galaxy S8', 'Samsung', 1, 41000),
(5, 'P20 Pro', 'Huawei', 5, 36000);	

-- выборки данных
-- * Задача 2  Выведите название, производителя и цену для товаров, количество которых превышает 2
SELECT product_name, manufacturer, price, product_count FROM mobile_phones WHERE product_count > 2;

-- * Задача 3  Выведите весь ассортимент товаров марки “Samsung”
SELECT product_name, manufacturer  FROM mobile_phones WHERE manufacturer = 'Samsung';

-- * Задача 4. (по желанию)* С помощью регулярных выражений найти:
-- 4.1. Товары, в которых есть упоминание "Iphone"
SELECT product_name, manufacturer FROM mobile_phones WHERE product_name LIKE'Iphone%';

-- 4.2. Товары, в которых есть упоминание "Samsung"
SELECT product_name, manufacturer FROM mobile_phones WHERE manufacturer LIKE'Samsung%';

-- 4.3. Товары, в которых есть ЦИФРЫ
-- SELECT id, product_name FROM mobile_phones WHERE product_name =    ;

-- 4.4. Товары, в которых есть ЦИФРА "8"
-- SELECT id, product_name FROM mobile_phones WHERE product_name =    ;
