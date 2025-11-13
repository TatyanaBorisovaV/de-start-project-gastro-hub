/*Задание 2
Создайте материализованное представление, которое покажет, как изменяется средний чек для каждого заведения
от года к году за все года за исключением 2023 года. 
Все столбцы со средним чеком округлите до второго знака после запятой.*/
DROP VIEW cafe.v_check_per_years; -- удаление представления с неверным округлением.
CREATE VIEW cafe.v_check_per_years AS
WITH current_year AS(
	SELECT
		restaurant_uuid,
		EXTRACT(YEAR FROM date) AS year,
		ROUND(AVG(avg_check), 2) AS current_average,
		LAG (ROUND(AVG(avg_check), 2)) OVER (PARTITION BY restaurant_uuid ORDER BY EXTRACT(YEAR FROM date)) AS previous_year
	FROM cafe.sales   
	WHERE EXTRACT(YEAR FROM date) < 2023
	GROUP BY restaurant_uuid, year
	ORDER BY restaurant_uuid, year
)
SELECT 
	year,
	r.cafe_name,
	r.type,
    current_average,
    previous_year,
	ROUND(((current_average - previous_year) / current_average) * 100, 2) AS changing_avg
FROM current_year
JOIN cafe.restaurants AS r USING (restaurant_uuid);

