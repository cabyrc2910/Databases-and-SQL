-- Задача 1. Создать сущность с подборкой фильмов (movies). 
-- 1.id --уникальный идентификатор фильма,
-- 1.id --уникальный идентификатор фильма,
-- 2.title--название фильма
-- 3.title_eng--название фильмана английском языке
-- 4.year_movie--год выхода
-- 5.count_min--длительность фильма в минутах
-- 6.storyline--сюжетная линия, небольшое описание фильма
-- Все поля(кроме title_eng, count_minи storyline) обязательны для заполнения.
-- Поле id: первичный ключ, который заполняется автоматически.


DROP DATABASE IF EXISTS lesson_2;
CREATE DATABASE lesson_2;
USE lesson_2;

-- фильмы
DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	title VARCHAR(50) NOT NULL,
	title_eng VARCHAR(50),
	year_movie  YEAR NOT NULL,
	count_min  INT,
	storyline TEXT
);

-- Задача 2. Заполните табличку тестовыми данными, используя оператор INSERT INTO.
-- наполнение данными 
INSERT INTO `movies` (title, title_eng, year_movie, count_min, storyline)
VALUES 
('Игры разума', 'A Beautiful Mind', 2001, 135, 'От всемирной известности до греховных глубин — все это познал на своей шкуре Джон Форбс Нэш-младший. Математический гений, он на заре своей карьеры сделал титаническую работу в области теории игр, которая перевернула этот раздел математики и практически принесла ему международную известность. Однако буквально в то же время заносчивый и пользующийся успехом у женщин Нэш получает удар судьбы, который переворачивает уже его собственную жизнь.'),
('Форрест Гамп', 'Forrest Gump', 1994, 142, 'Сидя на автобусной остановке, Форрест Гамп — не очень умный, но добрый и открытый парень — рассказывает случайным встречным историю своей необыкновенной жизни. С самого малолетства парень страдал от заболевания ног, соседские мальчишки дразнили его, но в один прекрасный день Форрест открыл в себе невероятные способности к бегу. Подруга детства Дженни всегда его поддерживала и защищала, но вскоре дороги их разошлись.'),
('Иван Васильевич меняет профессию', NULL, 1998, 128,'Инженер-изобретатель Тимофеев сконструировал машину времени, которая соединила его квартиру с далеким шестнадцатым веком - точнее, с палатами государя Ивана Грозного. Туда-то и попадают тезка царя пенсионер-общественник Иван Васильевич Бунша и квартирный вор Жорж Милославский. На их место в двадцатом веке «переселяется» великий государь. Поломка машины приводит ко множеству неожиданных и забавных событий...'),
('Назад в будущее', 'Back to the Future', 1985, 116, 'Подросток Марти с помощью машины времени, сооружённой его другом-профессором доком Брауном, попадает из 80-х в далекие 50-е. Там он встречается со своими будущими родителями, ещё подростками, и другом-профессором, совсем молодым.'),
('Криминальное чтиво', 'Pulp Fiction', 1994, 154, NULL);


-- жанры
DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	name VARCHAR(100) NOT NULL
);

-- актеры
DROP TABLE IF EXISTS actors;
CREATE TABLE actors (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	firstname VARCHAR(100) NOT NULL ,
	lastname VARCHAR(100) COMMENT 'Фамилия' -- COMMENT на случай, если имя неочевидное
);

-- Операции с таблицами. Задачи
-- 1.Переименовать сущностьm ovies в cinema.
-- 2.Добавить сущности cinema новый атрибут status_active(тип BIT)и атрибут genre_idпосле атрибута title_eng.
-- 3.Удалить атрибут status_active сущности cinema.
-- 4.Удалить сущность actorsиз базы данных
-- 5.Добавить внешний ключ на атрибут genre_idсущности cinemaи направить его на атрибут idсущности genres.
-- 6.Очистить сущность genresот данных и обнулить автоинкрементное поле.


-- 1. переименование сущность (таблицы) movies в cinema   
RENAME TABLE movies TO cinema;

-- 2. добавление новых атрибут (столбцов) status_active и genre_id в сущности (таблицу) cinema
ALTER TABLE cinema
ADD COLUMN status_active BIT DEFAULT b'1',  -- добавление колонки  status, BIT- битовое поле, по умолчанию '1'
ADD genre_id BIGINT UNSIGNED AFTER title_eng;  -- добавление колонки genre, боьшое целое число (BIGINT), беззнаковое (UNSIGNED).

-- 3. удаление атрибут (столбца) status_active из сущности (таблицы) cinema
ALTER TABLE cinema
DROP COLUMN status_active;

-- 4. удаление сущность (таблицы) actors
DROP TABLE actors;

-- 5. добавление внешнего ключа от атрибут (поля) genre_id сущности (таблицы) cinema к атрибут (полю) id сущности (таблицы) genres
ALTER TABLE cinema
ADD FOREIGN KEY(genre_id) REFERENCES genres(id);
 
-- 6.Очистить сущность genres от данных и обнулить автоинкрементное поле:TRUNCATE TABLE genres;

ALTER TABLE cinema
DROP FOREIGN KEY cinema_ibfk_1;

TRUNCATE TABLE genres; -- быстрое удаление всех данных таблицы

ALTER TABLE cinema
ADD FOREIGN KEY(genre_id) REFERENCES genres(id) 
ON UPDATE CASCADE ON DELETE SET NULL;  -- CASCADE - изменение значения которое было в таблице и изменнение всех записей которые были с этим значением

-- Задача 3.
-- Выведите id, название фильма и категорию фильма, согласно следующего перечня:
-- Д-Детская,П–Подростковая, В–Взрослая, Не указана

-- добавим поле возрастная категория фильмов
ALTER TABLE cinema
ADD COLUMN age_category CHAR(1);

-- присвоение фильмам категорий 
UPDATE cinema SET age_category='П' WHERE id=1;
UPDATE cinema SET age_category='Д' WHERE id=4;
UPDATE cinema SET age_category='В' WHERE id=5;

/*
 В зависимости от поля age_category, выведите столбец с именем “Категория”
 Д- Десткая, П – Подростковая, В – Взрослая, Не указана
 */
SELECT 
	id AS 'Номер фильма',
	title AS 'Название фильма',
	CASE age_category 
		WHEN 'Д' THEN 'Детская'
		WHEN 'П' THEN 'Подростковая'
		WHEN 'В' THEN 'Взрослая'
		ELSE 'Не указана'
	END AS 'Категория'	
FROM cinema;

-- Задача 4. 
-- Выведите id, название фильма, продолжительность, тип в зависимости от продолжительности (с использованием CASE).

-- изменение продолжительности фильмов 
UPDATE cinema SET count_min = 88 WHERE id=2;
UPDATE cinema SET count_min = NULL WHERE id=3;
UPDATE cinema SET count_min = 34 WHERE id=4;

/* Расставить фильмы в зависимости от продолжительности.
До 50 минут -  Короткометражный фильм
От 50 минут до 100 минут  -  Среднеметражный фильм
Более 100 минут  -  Полнометражный фильм
Иначе  - Не определено
 */
SELECT 
	id AS 'Номер фильма',
	title AS 'Название фильма',
	count_min AS 'Продолжительность',
	CASE 
		WHEN count_min < 50 THEN 'Короткометражный фильм'
		WHEN count_min BETWEEN 50 AND 100 THEN 'Среднеметражный фильм'
		WHEN count_min > 100 THEN 'Полнометражный фильм'
		ELSE 'Не определено'
	END AS 'Тип'	
FROM cinema;


-- Задача 5. 
-- Выведите id, название фильма, продолжительность, тип в зависимости от продолжительности (с использованием IF). 

-- функция IF()
-- IF( condition, [value_if_true], [value_if_false] )

-- Если 100<200, то печатаем 'Да'; иначе - 'Нет'

SELECT IF(100<200, 'Да', 'Нет') AS Result;

SELECT 
	id AS 'Номер фильма',
	title AS 'Название фильма',
	count_min AS 'Продолжительность',
	IF (count_min < 50, 'Короткометражный фильм', 
		IF (count_min BETWEEN 50 AND 100, 'Среднеметражный фильм', 
			IF (count_min > 100, 'Полнометражный фильм', 'Не определено')  
			)
		) AS 'Тип'	
FROM cinema;