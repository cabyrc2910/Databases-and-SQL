USE myfirstdb;
-- выборки (* - всех) данных
SELECT * FROM test;

SELECT name, password
FROM test
-- сторока ("test1234") записывается в ковычках
WHERE login = "test1234";

SELECT name, password, email
FROM test;

