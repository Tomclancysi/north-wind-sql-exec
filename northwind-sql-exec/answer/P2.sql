SELECT
	dt.ship_country AS shipping_country,
	ROUND(AVG ( dt.delay ), 2) AS average_dayas_between_order_shipping,
	COUNT ( * ) AS total_volume_orders 
FROM
	( SELECT *, ( shipped_date - order_date ) AS delay FROM orders WHERE EXTRACT ( YEAR FROM order_date ) = 1997 ) AS dt 
GROUP BY
	ship_country 
HAVING
	AVG ( dt.delay ) >= 3 
	AND AVG ( dt.delay ) < 20 
	AND COUNT ( * ) > 5 
ORDER BY
	AVG ( dt.delay ) DESC;