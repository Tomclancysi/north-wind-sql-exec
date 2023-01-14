SELECT
	category_name,
	country AS supplier_region,
	SUM ( unit_in_stock ) AS units_in_stock,
	SUM ( unit_on_order ) AS units_on_order,
	SUM ( reorder_level ) AS reorder_level 
FROM
	( products AS P INNER JOIN suppliers AS S ON P.supplier_id = S.supplier_id )
	INNER JOIN categories AS C ON P.category_id = C.category_id 
GROUP BY
	category_name,
	country
ORDER BY
	supplier_region, category_name, reorder_level;