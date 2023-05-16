DROP DATABASE IF EXISTS lesson_5;
CREATE DATABASE lesson_5;
USE lesson_5;

-- Персонал
DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	firstname VARCHAR(45),
	lastname VARCHAR(45),
	post VARCHAR(100),
	seniority INT, 
	salary INT, 
	age INT
);

-- Наполнение данными
INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
('Вася', 'Петров', 'Начальник', '40', 100000, 60),
('Петр', 'Власов', 'Начальник', '8', 70000, 30),
('Катя', 'Катина', 'Инженер', '2', 70000, 25),
('Саша', 'Сасин', 'Инженер', '12', 50000, 35),
('Ольга', 'Васютина', 'Инженер', '2', 70000, 25),
('Петр', 'Некрасов', 'Уборщик', '36', 16000, 59),
('Саша', 'Петров', 'Инженер', '12', 50000, 49),
('Иван', 'Сидоров', 'Рабочий', '40', 50000, 59),
('Петр', 'Петров', 'Рабочий', '20', 25000, 40),
('Сидр', 'Сидоров', 'Рабочий', '10', 20000, 35),
('Антон', 'Антонов', 'Рабочий', '8', 19000, 28),
('Юрий', 'Юрков', 'Рабочий', '5', 15000, 25),
('Максим', 'Максимов', 'Рабочий', '2', 11000, 22),
('Юрий', 'Галкин', 'Рабочий', '3', 12000, 24),
('Людмила', 'Маркина', 'Уборщик', '10', 10000, 49),
('Юрий', 'Онегин', 'Начальник', '8', 100000, 39);

-- ОКОННЫЕ ФУНКЦИИ

-- Ранжирование 
-- 1. Вывести список всех сотрудников и указать место в рейтинге по зарплатам в порядке убывания
SELECT 
	DENSE_RANK() OVER(ORDER BY salary DESC) AS rank_salary,
	CONCAT(firstname, ' ', lastname),
	post, 
	salary
FROM staff;

-- 2. Вывести список всех сотрудников и указать место в рейтинге по зарплатам, но по каждой должности
SELECT 
	DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS rank_salary, -- группируем по должности , сортируем по зарплате
	CONCAT(firstname, ' ', lastname),
	post, 
	salary
FROM staff;

-- 3. Найти самых высокооплачиваемых сотрудников по каждой должности
SELECT rank_salary, 
	staff,
	post, 
	salary
FROM 	
(SELECT 
	DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS rank_salary, 
	CONCAT(firstname, ' ', lastname) AS staff,
	post, 
	salary
FROM staff) AS list
WHERE rank_salary=1
ORDER BY salary DESC;
	
-- Сравнение со смещением 
-- 4. Вывести список всех сотрудников, отсортировав по зарплатам в порядке убывания и 
-- указать на сколько процентов ЗП меньше, чем у сотрудника со следующей (по значению) зарплатой

SELECT 
	id,
	CONCAT(firstname, ' ', lastname) AS staff,
	post, 
	salary,
	LAG (salary) OVER(ORDER BY salary DESC) AS prev_salary, 
	LEAD(salary, 1, 0) OVER(ORDER BY salary DESC) AS last_salary, 
	ROUND((salary-LEAD(salary, 1, 0) OVER(ORDER BY salary DESC))*100/salary) AS diff_percent
FROM staff;


--  Агрегация
-- 5. Вывести всех сотрудников, отсортировав по зарплатам в рамках каждой должности и рассчитать:
SELECT 
	id,
	CONCAT(firstname, ' ', lastname) AS staff,
	post, 
	salary,
	SUM(salary) OVER w AS sum_salary,                     -- общую сумму зарплат для каждой должности
	ROUND(salary*100/SUM(salary) OVER w) AS percent_sum,  -- процентное соотношение каждой зарплаты от общей суммы по должности
	AVG(salary) OVER w AS avg_salary,                     -- среднюю зарплату по каждой должности 
	ROUND(salary*100/AVG(salary) OVER w) AS percent_avg   -- процентное соотношение каждой зарплаты к средней зарплате по должности
FROM staff
WINDOW w AS (PARTITION BY post);  

-- 6. примеры использования оконных функций
SELECT 
	id, firstname, lastname, salary,
	ROW_NUMBER() OVER(ORDER BY salary DESC) AS 'ROW_NUMBER', -- нумерация всех записей
	RANK() OVER(ORDER BY salary DESC) AS 'RANK',            -- нумерация с пропусками
 	DENSE_RANK() OVER(ORDER BY salary DESC) AS 'DENSE_RANK', -- нумерация без пропусков
 	NTILE(3) OVER(ORDER BY salary DESC) AS 'NTILE'           -- делим все записи на определённое кол-во строк
FROM staff;



-- Оценки учеников
DROP TABLE IF EXISTS academic_record;
CREATE TABLE academic_record (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	name VARCHAR(45),
	quartal  VARCHAR(45),
    subject VARCHAR(45),
	grade INT
);

INSERT INTO academic_record (name, quartal, subject, grade)
values
	('Александр','1 четверть', 'математика', 4),
	('Александр','2 четверть', 'русский', 4),
	('Александр', '3 четверть','физика', 5),
	('Александр', '4 четверть','история', 4),
	('Антон', '1 четверть','математика', 4),
	('Антон', '2 четверть','русский', 3),
	('Антон', '3 четверть','физика', 5),
	('Антон', '4 четверть','история', 3),
    ('Петя', '1 четверть', 'физика', 4),
	('Петя', '2 четверть', 'физика', 3),
	('Петя', '3 четверть', 'физика', 4),
	('Петя', '2 четверть', 'математика', 3),
	('Петя', '3 четверть', 'математика', 4),
	('Петя', '4 четверть', 'физика', 5);


/* Задача 1
Получить с помощью оконных функции: */
SELECT 
	name, quartal, subject, grade, 
	AVG(grade) OVER(PARTITION BY name) AS avg_grade,    -- средний балл ученика
	MIN(grade) OVER(PARTITION BY name) AS min_grade,    -- наименьшую оценку ученика
	MAX(grade) OVER(PARTITION BY name) AS max_grade,    -- наибольшую оценку ученика
	SUM(grade) OVER(PARTITION BY name) AS sum_grade,    -- сумму всех оценок ученика
	COUNT(grade) OVER(PARTITION BY name) AS count_grade -- количество всех оценок ученика
FROM academic_record; 

-- с использованием псевдонима
SELECT 
	name, quartal, subject, grade, 
	AVG(grade) OVER w AS avg_grade,
	MIN(grade) OVER w AS min_grade,
	MAX(grade) OVER w AS max_grade,
	SUM(grade) OVER w AS sum_grade,
	COUNT(grade) OVER w AS count_grade
FROM academic_record
WINDOW w AS (PARTITION BY name); 

/* Задача 2. 
Получить информацию об оценках Пети по четвертям: */
 -- * текущая успеваемость по физике
 
SELECT 
	name, quartal, subject, 
	grade, 
	LAG(grade) OVER w AS prev_grade,   -- * оценка по физике в предыдущей четверти      
	LAG(grade, 1, 'нет оценки') OVER w AS prev_grade,    -- смещение на 1 и вместо NULL будет 0
	LEAD(grade) OVER w AS last_grade,  -- * оценка по физике в следующей четверти 
	LEAD(grade, 1, 0) OVER w AS last_grade -- смещение на 1 и вместо NULL будет 0
FROM academic_record  
WHERE name = 'Петя' AND subject = 'физика'
WINDOW w AS (ORDER BY  quartal); 


-- TEMPORARY TABLE, СTE, VIEW
-- получение друзей пользователя с id=1 из базы lesson_4
SELECT initiator_user_id AS friend_id FROM lesson_4.friend_requests 
WHERE target_user_id=1 AND status='approved' -- ID друзей, заявку которых подтвердили
UNION
SELECT target_user_id FROM  lesson_4.friend_requests  
WHERE  initiator_user_id=1 AND status='approved'; -- ID друзей, подтвердивших заявку 4, 3, 10

-- ВРЕМЕННАЯ ТАБЛИЦА
DROP TABLE IF EXISTS tbl_friends;
CREATE TEMPORARY TABLE tbl_friends 
SELECT initiator_user_id AS user_id, target_user_id AS friend_id FROM lesson_4.friend_requests 
WHERE  status='approved' -- ID друзей, заявку которых подтвердили
UNION
SELECT target_user_id, initiator_user_id FROM  lesson_4.friend_requests  
WHERE  status='approved'; -- ID друзей, подтвердивших заявку

-- вывод всех данных по дружбе пользователей
SELECT * FROM tbl_friends

SELECT friend_id FROM tbl_friends
WHERE user_id=1;

-- ОБЩЕЕ ТАБЛИЧНОЕ ВЫРАЖЕНИЕ
WITH friends AS  
(SELECT initiator_user_id AS user_id, target_user_id AS friend_id FROM lesson_4.friend_requests 
WHERE  status='approved' -- ID друзей, заявку которых подтвердили
UNION
SELECT target_user_id, initiator_user_id FROM  lesson_4.friend_requests  
WHERE  status='approved') -- ID друзей, подтвердивших заявку

SELECT friend_id FROM friends
WHERE user_id=1;

-- С помощью СТЕ реализуйте таблицу квадратов чисел от 1 до 10
WITH RECURSIVE cte AS
(
	SELECT 1 AS a, 1 as result
	UNION ALL
	SELECT a + 1, pow(a+1,2) as result FROM cte
	WHERE a < 10
)
SELECT a, result FROM cte;


-- ПРЕДСТАВЛЕНИЯ

CREATE OR REPLACE VIEW v_friends AS  
(SELECT initiator_user_id AS user_id, target_user_id AS friend_id FROM lesson_4.friend_requests 
WHERE  status='approved' -- ID друзей, заявку которых подтвердили
UNION
SELECT target_user_id, initiator_user_id FROM  lesson_4.friend_requests  
WHERE  status='approved'); -- ID друзей, подтвердивших заявку

SELECT friend_id FROM v_friends
WHERE user_id=1;

-- Задача 3 
-- 1. Создайте представление, в котором будут выводится все сообщения, в которых принимал участие пользователь с id = 1.
CREATE OR REPLACE VIEW v_messages_user AS
SELECT id, body FROM lesson_4.messages
WHERE from_user_id = 1 -- от пользователя
OR to_user_id = 1; -- к пользователю

SELECT id, body FROM v_messages_user;

-- 2. Найдите друзей у  друзей пользователя с id = 1 и поместите выборку в представление; 
-- (решение задачи с помощью CTE) 
-- вариант 1
CREATE OR REPLACE VIEW v_friends_friends AS
WITH friends AS (
	SELECT initiator_user_id AS id
    FROM lesson_4.friend_requests
    WHERE status = 'approved' AND target_user_id = 1 
    UNION
    SELECT target_user_id AS id
    FROM lesson_4.friend_requests
    WHERE status = 'approved' AND initiator_user_id = 1 
)
SELECT fr.initiator_user_id AS friend_id
FROM friends f
JOIN lesson_4.friend_requests fr ON fr.target_user_id = f.id
WHERE fr.initiator_user_id != 1  AND fr.status = 'approved'
UNION
SELECT fr.target_user_id
FROM  friends f
JOIN  lesson_4.friend_requests fr ON fr.initiator_user_id = f.id 
WHERE fr.target_user_id != 1  AND status = 'approved';

SELECT friend_id FROM v_friends_friends;

-- вариант 2 c использованием вложеного запроса
WITH friends AS (
	SELECT initiator_user_id AS user_id, target_user_id AS friend_id FROM lesson_4.friend_requests
    WHERE status = 'approved'
    UNION
    SELECT target_user_id, initiator_user_id FROM lesson_4.friend_requests
    WHERE status = 'approved')
SELECT friend_id FROM friends WHERE user_id
IN (SELECT friend_id FROM friends
WHERE user_id = 1) AND friend_id != 1;

-- вариант 3 c использованием JOIN
WITH friends AS (
	SELECT initiator_user_id AS user_id, target_user_id AS friend_id FROM lesson_4.friend_requests
    WHERE status = 'approved'
    UNION
    SELECT target_user_id, initiator_user_id FROM lesson_4.friend_requests
    WHERE status = 'approved')
SELECT f2.friend_id 
FROM friends f1
JOIN friends f2 ON f1.friend_id = f2.user_id
WHERE f1.user_id = 1 AND f2.friend_id != 1;  -- исключаем 1 пользователя

-- 3. Найдите друзей у  друзей пользователя с id = 1. 
-- (решение задачи с помощью представления “друзья”)

SELECT fr.initiator_user_id AS friend_id
FROM v_friends f
JOIN lesson_4.friend_requests fr ON fr.target_user_id = f.friend_id
WHERE fr.initiator_user_id != 1 AND f.user_id=1  AND fr.status = 'approved' -- выбираем инициаторов
UNION
SELECT fr.target_user_id
FROM  v_friends f
JOIN  lesson_4.friend_requests fr ON fr.initiator_user_id = f.friend_id 
WHERE fr.target_user_id != 1  AND f.user_id=1 AND  status = 'approved';  -- выбираем получателей









