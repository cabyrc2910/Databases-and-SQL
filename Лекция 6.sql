DROP DATABASE IF EXISTS Лекция_5;
-- создаём базу данных
CREATE DATABASE Лекция_6;
-- обращение к базе данных
USE Лекция_6;


SET @variable_name :=value;
SET @counter :=100;

SELECT @variable_name :=value;

-- SET
SET @test :=5;
SELECT @test;

-- SELECT
SELECT @test_var :=50;

/*Примеры переменных MySQL: получаем самый дорогой продукт в таблице products
и назначает цену пользовательской переменной @msrp*/
SELECT
	@msrp:=MAX(msrp)
FROM
	products;products