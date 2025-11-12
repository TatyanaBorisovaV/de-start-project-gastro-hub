-- Задание 5
-- Найдите самую дорогую пиццу для каждой пиццерии.

CREATE VIEW cafe.v_expensive_pizza AS
WITH menu_cte AS (
    SELECT 
        cafe_name,
        'Пицца' AS dish_type,
        SPLIT_PART(TRIM(json_each_text(menu::json -> 'Пицца')::text, '()'), ',', 1) AS pizza_name,  
        SPLIT_PART(TRIM(json_each_text(menu::json -> 'Пицца')::text, '()'), ',', 2)::integer AS price
    FROM 
        (SELECT *
         FROM cafe.restaurants
         WHERE menu::jsonb ? 'Пицца') AS pizza 
),
ranked_pizza AS (
    SELECT 
        cafe_name,
        dish_type,
        pizza_name,
        price,
        ROW_NUMBER() OVER (PARTITION BY cafe_name ORDER BY price DESC) AS rank  -- Ранжируем виды пицц по цене от самой дорогой по каждому заведению.
    FROM menu_cte
)
	SELECT -- Итоговый запрос, где будут строки только с самой дорогой пиццей.
		cafe_name,
        dish_type,
        pizza_name,
        price
	FROM ranked_pizza
	WHERE rank = 1
 	ORDER BY cafe_name;