/*Задание 1
Чтобы выдать премию менеджерам, нужно понять, у каких заведений самый высокий средний чек. 
Создайте представление, которое покажет топ-3 заведения внутри каждого типа заведений 
по среднему чеку за все даты. Столбец со средним чеком округлите до второго знака после запятой.*/
DROP VIEW cafe.v_top3;  -- Удаление представления с округлением до сотен.
CREATE VIEW cafe.v_top3 AS   -- Создание представления.
WITH ranked_restaurants AS (
    SELECT 
        r.type,
        r.cafe_name,
        ROUND(AVG(s.avg_check), 2) AS average_check, -- Вычисление среднего чека заведения по всем датам. Округление до 2го знака после запятой.
        ROW_NUMBER() OVER (PARTITION BY r.type ORDER BY AVG(s.avg_check) DESC) AS rank -- Оконная функция для ранжирования в группе по типу заведения.
    FROM cafe.restaurants AS r
    JOIN cafe.sales AS s USING (restaurant_uuid)
    GROUP BY r.type, r.cafe_name
)
SELECT     
    cafe_name,
    type,
    average_check
FROM 
    ranked_restaurants
WHERE 
    rank <= 3;