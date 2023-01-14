SELECT
	CONCAT ( L.first_name, ' ', L.last_name ) AS employee_full_name,
	L.title AS employee_title,
	DATE_PART( 'year', L.hire_date ) - DATE_PART( 'year', L.birth_date ) AS employee_age,
	DATE_PART( 'year', now( ) ) - DATE_PART( 'year', L.hire_date ) AS employee_tenure,
	CONCAT ( R.first_name, ' ', R.last_name ) AS manager_full_name,
	R.title AS manager_title
FROM
	employees AS L
	LEFT JOIN employees AS R 
ON
	L.reports_to = R.employee_id
ORDER BY
	employee_age, employee_full_name;