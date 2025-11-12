/*Задание 4
Найдите пиццерию с самым большим количеством пицц в меню. Если таких пиццерий несколько, выведите все.*/

WITH count_pizza AS (
    SELECT 
        cafe_name,
        jsonb_object_keys(menu::jsonb -> 'Пицца') 
    FROM 
        (SELECT *
         FROM cafe.restaurants
         WHERE menu::jsonb ? 'Пицца') AS pizza
),
ranked_pizza AS (
    SELECT 
        cafe_name,
        COUNT(*) AS quantity_pizza,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
    FROM count_pizza
    GROUP BY cafe_name
)
SELECT 
    cafe_name,
    quantity_pizza
FROM ranked_pizza
WHERE rank = 1;
