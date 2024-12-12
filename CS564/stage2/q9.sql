SELECT d.department_name
FROM departments d
JOIN employees e ON d.department_id = e.department_id
WHERE e.salary = (SELECT MAX(salary) FROM employees)
LIMIT 1;

