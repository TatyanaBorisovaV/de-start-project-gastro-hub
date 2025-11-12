-- Заполнение таблиц:
INSERT INTO cafe.restaurants (cafe_name, type, menu)
SELECT DISTINCT  s.cafe_name, s.type::cafe.restaurant_type, m.menu
FROM raw_data.sales AS s
RIGHT JOIN raw_data.menu AS m USING(cafe_name);

INSERT INTO cafe.managers (manager, manager_phone)
SELECT DISTINCT manager, manager_phone
FROM raw_data.sales;

INSERT INTO cafe.restaurant_manager_work_dates(restaurant_uuid,	manager_uuid, start_date, dismiss_date)
SELECT r.restaurant_uuid, mn.manager_uuid, MIN(s.report_date), MAX(s.report_date)
FROM raw_data.sales AS s
JOIN cafe.restaurants AS r USING (cafe_name)
JOIN cafe.managers AS mn USING (manager)
GROUP BY r.restaurant_uuid, mn.manager_uuid
ORDER BY r.restaurant_uuid, MIN(s.report_date), mn.manager_uuid;

INSERT INTO cafe.sales(date, restaurant_uuid, avg_check)
SELECT s.report_date, r.restaurant_uuid, s.avg_check
FROM raw_data.sales AS s
JOIN cafe.restaurants AS r USING(cafe_name);



