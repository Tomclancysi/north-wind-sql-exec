SELECT
	category_name,
	CONCAT ( FIN.first_name, ' ', FIN.last_name ) AS employee_full_name,
	FIN.total_person_category AS total_sale_amount,
	ROUND( ( FIN.total_person_category / tot.tot_amount ) :: NUMERIC, 5 ) AS percent_of_employee_sales,
	ROUND( ( FIN.total_person_category / FIN.total_person ) :: NUMERIC, 5 ) AS percent_of_category_sales 
FROM
	((
		(
			SELECT 
			  EO.employee_id AS employee_id,
				EO.employee_id AS FINAL_ID,
				PC.category_name AS category_name,
				SUM( EO.unit_price ) AS total_person_category
			FROM
				(
					(
					  SELECT
							E.employee_id AS employee_id,
							O.product_id AS product_id,
							O.unit_price AS unit_price
						FROM
							employees AS E
							LEFT JOIN ( orders LEFT JOIN order_details ON orders.order_id = order_details.order_id ) AS O ON E.employee_id = O.employee_id 
					) AS EO
					LEFT JOIN ( 
						SELECT
							products.category_id,
							product_id,
							category_name 
						FROM
							products INNER JOIN categories ON products.category_id = categories.category_id
					) AS PC ON EO.product_id = PC.product_id 
				) 
			GROUP BY
				PC.category_name,
				EO.employee_id 
		) AS per_cat_person
		INNER JOIN (
			SELECT
			employees.employee_id,
			SUM(unit_price) AS total_person
			FROM
			employees LEFT JOIN (orders INNER JOIN order_details ON orders.order_id = order_details.order_id) AS O1 ON employees.employee_id = O1.employee_id
			GROUP BY
			employees.employee_id
		) AS per_person ON per_cat_person.employee_id = per_person.employee_id 
	) AS fn LEFT JOIN employees ON fn.FINAL_ID = employees.employee_id) AS FIN,
	( SELECT SUM ( O1.unit_price ) AS tot_amount FROM order_details AS O1 ) AS tot
	ORDER BY category_name, total_sale_amount DESC;