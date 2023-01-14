-- for each category, it has multi product, each product has multi order, each order has its price, so what is the price range if a category min price is 3 and max price is 200 ?
SELECT
	category_name,
	price_range,
	ROUND( SUM ( dt.order_bill ) :: NUMERIC, 2 ) AS total_amount,
	SUM ( dt.order_cnt ) AS total_number_orders 
FROM
	(
	SELECT
		product_id,
		COUNT ( * ) AS order_cnt,
		MAX ( unit_price ) AS max_up,
		MIN ( unit_price ) AS min_up,
		SUM ( unit_price * quantity * ( 1-discount ) ) AS order_bill,
		(
			CASE
			WHEN MIN ( unit_price ) >= 50 THEN
				'Over $50' 
			WHEN MAX ( unit_price ) < 50 
				AND MIN ( unit_price ) >= 20 THEN
				'$20-$50' 
			WHEN MAX ( unit_price ) < 20 
					AND MIN ( unit_price ) >= 10 THEN
				'$10-$20' 
			ELSE'Below $10' 
			END 
		) AS price_range,
		(
			CASE
			WHEN MIN ( unit_price ) >= 50 THEN
				3
			WHEN MAX ( unit_price ) < 50 
				AND MIN ( unit_price ) >= 20 THEN
				2
			WHEN MAX ( unit_price ) < 20 
					AND MIN ( unit_price ) >= 10 THEN
				1
			ELSE 0
			END 
		) AS PR
	FROM
		order_details 
	GROUP BY
		product_id 
	) AS dt LEFT JOIN ( products AS l LEFT JOIN categories AS r ON l.category_id = r.category_id ) AS pdct ON dt.product_id = pdct.product_id 
GROUP BY
	category_name, price_range, PR
ORDER BY
category_name, PR;