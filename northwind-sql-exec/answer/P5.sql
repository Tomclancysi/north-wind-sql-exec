SELECT
*
FROM
(
	SELECT 
	product_name,
	unit_price AS current_price,
	POP.old_price AS previous_unit_price,
	ROUND(((unit_price / POP.old_price)*100 - 100)::numeric, 4) AS percentage_increase
	FROM
	(
		SELECT 
		O.unit_price AS old_price,
		PD.product_id AS product_id
		FROM
		(
			SELECT product_id, MIN(order_date) AS old_date FROM
			(SELECT order_details.order_id AS order_id, unit_price, order_date, product_id FROM order_details INNER JOIN orders on order_details.order_id = orders.order_id) AS dt
			GROUP BY product_id
		) AS PD LEFT JOIN (order_details INNER JOIN orders on order_details.order_id = orders.order_id) AS O ON PD.old_date = O.order_date AND PD.product_id = O.product_id
	) AS POP INNER JOIN products ON POP.product_id = products.product_id
) AS fn
WHERE
percentage_increase < 10 OR percentage_increase > 30
ORDER BY
percentage_increase;