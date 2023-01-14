SELECT
	product_name,
	unit_price AS product_unit_price 
FROM
	products 
WHERE
	unit_price > 10 
	AND unit_price < 50 
	AND discontinued = 0
ORDER BY
	product_name;