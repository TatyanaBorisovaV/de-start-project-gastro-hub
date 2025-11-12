/*Задание 7
Руководство GastroHub приняло решение сделать единый номер телефонов для всех менеджеров. 
Новый номер — 8-800-2500-***, где порядковый номер менеджера выставляется по алфавиту, начиная с номера 100. 
Старый и новый номер нужно будет хранить в массиве, где первый элемент массива — новый номер, а второй — старый.
Во время проведения этих изменений таблица managers должна быть недоступна для изменений со стороны других пользователей, но доступна для чтения.*/

SELECT *
FROM cafe.managers;

-- Приведение поля ФИО к общему правильному виду данных с порядком: фамилия, имя, отчество (в дампе эти варианты записаны как ИОФ).
WITH correct_cte AS(
	SELECT 
		manager_uuid,
		SPLIT_PART(manager::text, ' ', 3) || ' ' || REPLACE(manager, SPLIT_PART(manager::text, ' ', 3), '') as correct_manager	
	FROM cafe.managers
	WHERE manager LIKE '%Муравьева'
	   OR manager LIKE '%Горбунов'
	   OR manager LIKE '%Владимиров'
	   OR manager LIKE '%Доронин'
	   OR manager LIKE '%Большаков'
	   OR manager LIKE '%Рогов'
	   OR manager LIKE '%Кудряшова'
	   OR manager LIKE '%Щербаков'
	   OR manager LIKE '%Кудрявцев'
	   OR manager LIKE '%Архипова'
	   OR manager LIKE '%Дементьева'
)
UPDATE cafe.managers AS m
SET m.manager = correct_cte.correct_manager
FROM correct_cte
WHERE m.manager_uuid = correct_cte.manager_uuid;

BEGIN; -- Открываем транзакцию для блокировки записей для изменений, но доступ для чтения таблицы будет открыт для пользователей. 
/*Теперь сортируем по алфавиту поле с ФИО и ранжируем для того, чтобы использовать этот номер в телефоне. 
Проранжируем отсортированные данные и добавим этот ранж в номер телефона.*/ 
SELECT * FROM cafe.managers FOR SHARE;

WITH rank_fio AS( 
	SELECT *, 
		row_number() OVER (ORDER BY manager) AS rank		
	FROM cafe.managers
)
UPDATE cafe.managers AS m
SET manager_phone = ARRAY['8-800-2500-' || (100 + rank_fio.rank::integer - 1)::text, m.manager_phone::text]
FROM rank_fio 
WHERE m.manager_uuid = rank_fio.manager_uuid;

-- проверка:
SELECT * FROM cafe.managers;
ROLLBACK; -- Откатка, в случае, если я накосячу. Пусть побудет тут!
COMMIT; -- Завершение успешной транзакции.


