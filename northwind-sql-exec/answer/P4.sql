SELECT
	dt.year_month,
	COUNT ( * ) AS total_number_orders,
	ROUND(SUM(freight)::numeric) AS total_freight
FROM
	(
	SELECT
		*,
		CONCAT ( EXTRACT ( YEAR FROM order_date ), '-', TO_CHAR( EXTRACT ( MONTH FROM order_date ), 'fm00' ), '-01' ) AS year_month 
	FROM
		orders 
	WHERE
		EXTRACT ( YEAR FROM order_date ) >= 1996 
		AND EXTRACT ( YEAR FROM order_date ) <= 1997
) AS dt 
GROUP BY
	dt.year_month 
HAVING
	COUNT ( * ) > 20 
	AND SUM ( freight ) > 2500 
ORDER BY
	SUM ( freight ) DESC;