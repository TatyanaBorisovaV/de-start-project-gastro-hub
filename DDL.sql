CREATE SCHEMA cafe; -- создание схемы для проекта.

CREATE TYPE cafe.restaurant_type AS ENUM -- пользовательский тип данных с типом заведения
    ('coffee_shop', 'restaurant', 'bar', 'pizzeria');

CREATE TABLE cafe.restaurants ( -- создание таблицы  таблицу с информацией о ресторанах.
	restaurant_uuid uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	cafe_name VARCHAR, -- наименование ресторана или кафе
	type cafe.restaurant_type,   -- тип кафе из созданного пользовательского типа данных
	menu jsonb
);

/*Создание таблицы cafe.managers с информацией о менеджерах. 
 * В качестве первичного ключа - случайно сгенерированный uuid. 
 Таблица хранит: manager_uuid, имя менеджера и его телефон.*/
CREATE TABLE cafe.managers (
	manager_uuid uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	manager VARCHAR,
	manager_phone VARCHAR
);

/*Таблица хранит: restaurant_uuid, manager_uuid, дату начала работы в ресторане и 
 * дату окончания работы в ресторане.
 * Составной первичный ключ из двух полей: restaurant_uuid и manager_uuid.
 * Работа менеджера в ресторане от даты начала до даты окончания — единый период, без перерывов.*/
CREATE TABLE cafe.restaurant_manager_work_dates(
	restaurant_uuid uuid,
	manager_uuid uuid,
	start_date date,
	dismiss_date date,
	PRIMARY KEY (restaurant_uuid, manager_uuid) -- составной ключ из двух полей
);
	
CREATE TABLE cafe.sales(
	date date, 
	restaurant_uuid uuid, 
	avg_check numeric(6, 2),
	PRIMARY KEY (date, restaurant_uuid) -- составной ключ из двух полей
);