SELECT
	dt.category_name,
	P1.product_name,
	P1.unit_price,
	dt.cat_avg AS average_unit_price,
	dt.cat_med AS median_unit_price,
	(CASE
	WHEN P1.unit_price = dt.cat_avg THEN
		'Average'
	WHEN P1.unit_price < dt.cat_avg THEN
		'Below Average'
	ELSE
		'Over Average'
	END) AS average_unit_price_position,
	(CASE
	WHEN P1.unit_price = dt.cat_med THEN
		'Median'
	WHEN P1.unit_price < dt.cat_med THEN
		'Below Median'
	ELSE
		'Over Median'
	END) AS median_unit_price_position

FROM
	products AS P1
	INNER JOIN (
	SELECT 
	  ROUND(AVG( unit_price )::numeric, 2) AS cat_avg,
		ROUND((PERCENTILE_CONT ( 0.5 ) WITHIN GROUP ( ORDER BY unit_price ))::numeric, 2) AS cat_med,
		C.category_name,
		C.category_id 
	FROM
		products
		AS P INNER JOIN categories AS C ON P.category_id = C.category_id 
	GROUP BY
		C.category_name,
	  C.category_id 
	) AS dt ON P1.category_id = dt.category_id
	ORDER BY dt.category_name, P1.product_name;