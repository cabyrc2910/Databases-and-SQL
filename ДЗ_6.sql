USE lesson_4;

/*1.Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицуusers_old. (использование транзакции с выбором commitили rollback–обязательно).*/
-- создаём базу данных

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (id INT AUTO_INCREMENT PRIMARY KEY, 
  firstname VARCHAR(50),
  lastname VARCHAR(50),
  email VARCHAR(120)
  ) ENGINE ARCHIVE;

DROP PROCEDURE IF EXISTS users_old;
DELIMITER  //
CREATE PROCEDURE users_old (
  firstname VARCHAR (50),
  id INT,
  lastname VARCHAR (50),
  email VARCHAR(120)
)
BEGIN
	INSERT INTO users_old (append_firstname, pk_id, append_lastname, append_emai) VALUES (firstname, id, lastname, email);
END //
DELIMITER ;

START TRANSACTION;

SELECT * FROM users WHERE id = 2;
INSERT INTO users_old  SELECT * FROM users WHERE id = 2;
DELETE FROM users WHERE id = 2; 
COMMIT;

/*2.Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 —"Добрый вечер", 
с 00:00 до 6:00 —"Доброй ночи".*/

DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
RETURNS VARCHAR(45) READS SQL DATA
BEGIN
	DECLARE request VARCHAR(45);
	SET request = (SELECT 
		CASE
			WHEN CURRENT_TIME BETWEEN '06:00:00' AND '11:59:59' THEN "Доброе утро!"
			WHEN CURRENT_TIME BETWEEN '12:00:00' AND '17:59:59' THEN "Добрый день!"
			WHEN CURRENT_TIME BETWEEN '18:00:00' AND '23:59:59' THEN "Добрый вечер!"
			WHEN CURRENT_TIME BETWEEN '00:00:00' AND '05:59:59' THEN "Доброй ночи!"
			ELSE "Ошибка настройки"
		END);
	RETURN request;
END //
DELIMITER ;

-- вызов функции приветствия.
SELECT hello();	
