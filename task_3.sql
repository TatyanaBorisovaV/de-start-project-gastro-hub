/*Задание 3
Найдите топ-3 заведения, где чаще всего менялся менеджер за весь период.*/

CREATE VIEW cafe.v_top3_flow_managers AS
	SELECT 
		r.cafe_name,
		COUNT(*) AS quantity_managers		
	FROM cafe.restaurant_manager_work_dates	
	JOIN cafe.restaurants AS r USING(restaurant_uuid)
	GROUP BY r.cafe_name
	ORDER BY quantity_managers DESC
	LIMIT 3;
	
	