SELECT d.department_name, AVG(j.max_salary) AS avg_max_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN jobs j ON e.job_id = j.job_id
GROUP BY d.department_id, d.department_name
HAVING avg_max_salary > 8000;

