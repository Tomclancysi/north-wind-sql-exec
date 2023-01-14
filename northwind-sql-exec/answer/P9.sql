-- D E difference ?
SELECT
	CONCAT ( E.first_name, ' ', E.last_name ) AS employee_full_name,
	E.title AS employee_title,
	ROUND((total_sale_amount_including_discount - total_discount_amount)::numeric, 2) AS total_sale_amount_excluding_discount,
	number_unique_orders,
	number_orders,
	ROUND(average_product_amount::numeric, 2) AS average_product_amount,
	ROUND(average_order_amount::numeric, 2) AS average_order_amount,
	ROUND(total_discount_amount::numeric, 2) AS total_discount_amount,
	ROUND(total_sale_amount_including_discount::numeric, 2) AS total_sale_amount_including_discount,
	ROUND( ( dt.total_discount_amount / dt.total_sale_amount_including_discount * 100 ) :: NUMERIC, 2 ) AS total_discount_percentage 
FROM
	(
	SELECT
	employee_id,
	SUM(number_orders) AS number_orders,
	SUM(number_unique_orders) AS number_unique_orders,
	SUM(average_product_amount) AS average_product_amount,
	SUM(average_order_amount) AS average_order_amount,
	SUM(total_discount_amount) AS total_discount_amount,
	SUM(total_sale_amount_including_discount) AS total_sale_amount_including_discount
	FROM 
		(
		SELECT
			employee_id,
			COUNT ( * ) AS number_orders,
			COUNT(DISTINCT orders.order_id) AS number_unique_orders,
			CASE WHEN discount_eq_0 = 1 THEN AVG ( unit_price * ( 1 - discount ) ) ELSE 0 END AS average_product_amount, -- no discount
			CASE WHEN discount_eq_0 = 1 THEN AVG ( unit_price * quantity * ( 1 - discount ) ) ELSE 0 END AS average_order_amount, -- no discount
			SUM ( unit_price * quantity * discount ) AS total_discount_amount,
			SUM ( unit_price * quantity ) AS total_sale_amount_including_discount 
		FROM
			orders
			INNER JOIN (SELECT *, CASE WHEN discount = 0 THEN 1 ELSE 0 END AS discount_eq_0 FROM order_details) as order_details_t ON orders.order_id = order_details_t.order_id 
		GROUP BY
			employee_id, discount_eq_0
		) as temp
	GROUP BY employee_id
	) AS dt
	INNER JOIN employees AS E ON dt.employee_id = E.employee_id
	ORDER BY total_sale_amount_including_discount DESC;