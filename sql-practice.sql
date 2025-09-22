CREATE TABLE employee_data (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    department VARCHAR(50),
    role VARCHAR(50),
    city VARCHAR(50),
    join_date DATE,
    salary DECIMAL(10, 2),
    performance_score INT,
    is_remote BOOLEAN
);
INSERT INTO employee_data (emp_id, name, age, department, role, city, join_date, salary, performance_score, is_remote) VALUES
(1, 'Alice', 28, 'HR', 'HR Manager', 'New York', '2020-05-12', 55000.00, 8, FALSE),
(2, 'Bob', NULL, 'Engineering', 'Software Engineer', 'Los Angeles', '2019-03-15', 72000.50, 9, TRUE),
(3, 'Charlie', 25, 'Sales', 'Sales Executive', 'Chicago', '2021-07-01', 47000.75, NULL, TRUE),
(4, 'Diana', 31, NULL, 'Team Lead', 'Houston', '2018-11-23', 68000.20, 7, FALSE),
(5, 'Ethan', 29, 'HR', 'Recruiter', NULL, '2022-01-10', NULL, 6, TRUE),
(6, 'Fiona', 36, 'Engineering', 'Senior Engineer', 'Philadelphia', '2017-08-30', 82000.90, 9, FALSE),
(7, 'George', NULL, 'Marketing', 'Content Creator', 'San Antonio', '2020-06-19', 49000.00, 5, TRUE),
(8, 'Hannah', 30, 'Sales', 'Sales Manager', 'San Diego', NULL, 60000.40, 8, FALSE),
(9, 'Ian', 33, 'Marketing', 'Brand Manager', 'Dallas', '2019-09-14', 66000.00, 7, FALSE),
(10, 'Jane', 26, 'Engineering', 'DevOps Engineer', 'Austin', '2023-04-22', 53000.10, NULL, TRUE),
(11, 'Kyle', 27, 'Engineering', 'Software Engineer', 'Denver', '2020-10-15', 70000.00, 7, TRUE),
(12, 'Lily', NULL, 'HR', 'HR Executive', 'Boston', '2021-02-01', 54000.00, 6, FALSE),
(13, 'Mike', 32, 'Finance', 'Accountant', NULL, '2018-07-20', 62000.00, 8, TRUE),
(14, 'Nina', 35, 'Finance', 'Finance Manager', 'Atlanta', '2016-03-12', 75000.00, 9, FALSE),
(15, 'Omar', 30, 'Sales', 'Sales Executive', 'Phoenix', '2019-11-05', 48000.00, 6, TRUE),
(16, 'Paul', NULL, 'Engineering', 'Tech Lead', 'San Jose', '2020-01-18', NULL, 9, FALSE),
(17, 'Quinn', 28, 'Marketing', 'SEO Specialist', 'Miami', '2022-06-25', 56000.00, 7, TRUE),
(18, 'Rita', 31, 'HR', NULL, 'Seattle', '2021-09-10', 52000.00, NULL, TRUE),
(19, 'Sam', 29, 'Finance', 'Auditor', 'Chicago', '2023-02-14', 61000.00, 8, TRUE),
(20, 'Tina', 33, 'Engineering', 'Software Engineer', 'New York', '2017-05-05', 72000.00, 9, FALSE),
(21, 'Uma', 26, 'Engineering', 'QA Analyst', NULL, '2020-11-03', 51000.00, 7, TRUE),
(22, 'Victor', 34, 'Sales', 'Sales Executive', 'Los Angeles', '2019-08-27', 49000.00, 6, FALSE),
(23, 'Wendy', 38, 'Finance', 'Accountant', 'New York', '2015-04-10', 66000.00, 9, FALSE),
(24, 'Xander', 40, 'Engineering', 'Senior Developer', 'Austin', '2014-09-30', 88000.00, 9, FALSE),
(25, 'Yara', 29, 'Marketing', 'Social Media Manager', 'Orlando', NULL, 58000.00, 7, TRUE),
(26, 'Zack', NULL, 'HR', 'Recruiter', 'Boston', '2023-01-12', 53000.00, 6, TRUE),
(27, 'Ava', 27, 'Finance', 'Data Analyst', 'Chicago', '2022-08-08', NULL, 7, TRUE),
(28, 'Ben', 31, 'Sales', 'Account Manager', 'Dallas', '2021-04-03', 64000.00, 8, FALSE),
(29, 'Clara', 35, 'Engineering', 'Scrum Master', 'Denver', '2018-06-16', 79000.00, NULL, FALSE),
(30, 'David', 30, 'HR', 'HR Manager', 'New York', '2019-12-20', 58000.00, 8, FALSE);
SELECT * FROM employee_data;
-------------
Find all employees whose salary is greater than 60,000.
SELECT *
FROM employee_data
WHERE salary >= 60000;
-----------------
List employees who have NULL in their performance_score.
SELECT *
FROM employee_data
WHERE performance_score IS NULL;
-----------------
Count the number of employees in each department.
SELECT department, COUNT(*) AS emp_count
FROM employee_data
GROUP BY department;
-------------------
Find the average salary in the company.
SELECT AVG(salary) AS avg_salary 
FROM employee_data;
-------------------------
List employees who joined in the last 2 years.
SELECT *
FROM employee_data
WHERE join_date >= '2020-01-01';

SELECT * FROM employee_data
WHERE YEAR(join_date) >= 2023;
----------------------------
Which cities have more than 3 employees?

SELECT city, COUNT(*) AS employee_count
FROM employee_data
WHERE city IS NOT NULL
GROUP BY city
HAVING count(*) >= 2;
-------------------------------
Calculate the average, minimum, and maximum salary for each department.
SELECT department, AVG(salary) AS avg_salary
FROM employee_data
GROUP BY department;
----
SELECT department, MIN(salary) AS Minn, MAX(salary) AS Maxx
FROM employee_data
GROUP BY department;
----------------------------------
Find the top 3 highest paid employees in the Sales department.

SELECT *
FROM employee_data
WHERE department = 'Sales'
ORDER BY salary DESC
LIMIT 3 ;
------------------------------------
Get the number of remote vs non-remote employees.

SELECT is_remote, 
COUNT(*) AS REMO_E
FROM employee_data
GROUP BY is_remote;
----------------------------------
For each department, find the employee with the highest performance score.

SELECT * FROM
(SELECT name,department,performance_score,
       ROW_NUMBER() OVER(PARTITION BY department ORDER BY performance_score DESC) AS AP
       FROM employee_data) AS High
WHERE AP <=2;

       
---------------------------
List employees who are earning above the average salary of their department.

SELECT AVG(salary) AS avg_sal, department
FROM employee_data
GROUP BY department;


SELECT name, department, salary
FROM employee_data e
WHERE salary > (
    SELECT AVG(salary)
    FROM employee_data
    
    WHERE department = e.department
    
);
----------------------------- performance -------
SELECT name, age, performance_score,rolee,department
FROM employee_data e
WHERE performance_score > ( SELECT AVG(performance_score)
                            FROM employee_data
                            WHERE department = e.department) ;
						
                            
                            
SELECT *
FROM (
    SELECT name, age, performance_score, rolee, department,salary,
           ROW_NUMBER() OVER (PARTITION BY department ORDER BY performance_score DESC) AS q
    FROM employee_data e
    WHERE salary > (SELECT AVG(salary)
					FROM employee_data
					WHERE department = e.department)
	) AS w
WHERE q = 1;               
------------------
How many employees have missing (NULL) join dates or roles?

SELECT COUNT(*) AS e
FROM employee_data
WHERE join_date IS NULL OR role IS NULL;       
--------------------------------------------------
Use a window function to rank employees by salary within each department.

SELECT * FROM employee_data;

SELECT * FROM
(SELECT name,department,salary,
RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS a
FROM employee_data) AS b
WHERE a <= 3;
-------------------------------------------------
Get the rolling average salary over join dates (by year or month).

SELECT 
  DATE_FORMAT(join_date, '%Y') AS join_month,
  AVG(salary) OVER (
    ORDER BY DATE_FORMAT(join_date, '%Y')
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS rolling_avg_salary
FROM employee_data
WHERE join_date IS NOT NULL;  

SELECT 
  join_date,
  AVG(salary) OVER (ORDER BY join_date
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                   ) AS rolling_avg_salary
FROM employee_data
WHERE join_date IS NOT NULL;  
-------------------------------------
List employees whose performance score is in the top 25% across the company.

SELECT * FROM
(SELECT name, department, performance_score,
       NTILE(4) OVER (ORDER BY performance_score DESC) AS rank_in_department
FROM employee_data) AS q
WHERE rank_in_department=1 ;

------------------------------------------
Find the median salary per department
 
 WITH cte AS( SELECT *,
		      ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary ASC) AS a,
              ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS d
              FROM employee_data) 
              SELECT department, AVG(salary) AS M
              FROM cte
              WHERE ABS(CAST(a AS SIGNED) - CAST(d AS SIGNED))
              GROUP BY department
              ORDER BY department;
              
SELECT * FROM employee_data;


WITH cte AS (SELECT *,
       ROW_NUMBER() OVER(ORDER BY salary ASC) AS a,
       ROW_NUMBER() OVER( ORDER BY salary DESC) AS d
       FROM employee_data) 
    SELECT AVG(salary) AS avg_age
    FROM cte
    WHERE ABS(CAST(a AS SIGNED)-CAST(d AS SIGNED)) <= 1 
    GROUP BY rolee
    ORDER BY rolee
    ;
       
       
       ALTER TABLE employee_data
       CHANGE role rolee VARCHAR(100); 
-----------------------------------------

List departments where more than 30% of employees work remotely.      



SELECT 
    department,( SUM(CASE WHEN is_remote = 1 THEN 1 ELSE 0 END) / COUNT(*))*100 AS t
FROM employee_data
GROUP BY department
HAVING (SUM(CASE WHEN is_remote = 1 THEN 1 ELSE 0 END) / COUNT(*))*100 >= 44;

----------------------------------

Identify employees who are earning below the median salary of the company.



WITH cte AS (
  SELECT *,
         ROW_NUMBER() OVER (ORDER BY salary ASC) AS a,
         ROW_NUMBER() OVER (ORDER BY salary DESC) AS d
  FROM employee_data
),
median AS (SELECT AVG(salary) AS median
FROM cte
WHERE ABS(CAST(a AS SIGNED) - CAST(d AS SIGNED)) <= 1 )
SELECT e.*
FROM employee_data e
JOIN median m
ON e.salary < m.median

SELECT 
    department,
    SUM(salary * 0.10) AS additional_cost
FROM employee_data
WHERE remote = TRUE
GROUP BY department;
-----------------------
Replace NULL values in the role column with "Unknown".

SELECT role,COALESCE(role, 'Unknown')
FROM employee_data
----------------------------------------
Fill missing salaries with the median salary per department.
SELECT * FROM employee_data;
 
    
    WITH cte AS (
    SELECT 
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary) AS rn_asc,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn_desc
    FROM employee_data
    WHERE salary IS NOT NULL
),
median_cte AS (
    SELECT 
        department,
        AVG(salary) AS median_salary
    FROM cte
    WHERE rn_asc = rn_desc OR ABS(CAST(rn_asc AS SIGNED) - CAST(rn_desc AS SIGNED)) = 1
    GROUP BY department
)
UPDATE employee_data e
JOIN median_cte m
  ON e.department = m.department
SET e.salary = m.median_salary
WHERE e.salary IS NULL;

----------------------------
Standardize Department Names (Convert to Lowercase)

UPDATE employee_data
SET department = LOWER(department)

---------------------------------------

Extract Year and Month from join_date (for Trend Analysis)

ALTER TABLE employee_data
ADD COLUMN join_year INT,
ADD COLUMN join_month INT;

UPDATE employee_data
SET join_year = YEAR(join_date),
	join_month = MONTH(join_date)
    
--------------------------------------
Group Employees by Year & Month (Hiring Trend Analysis)

SELECT 
    YEAR(join_date) AS join_year,
    MONTH(join_date) AS join_month,
    COUNT(*) AS total_hires
FROM employee_data
GROUP BY YEAR(join_date), MONTH(join_date)
ORDER BY join_year, join_month;

-----------------------------------------------


UPDATE employee_data
SET age = (SELECT AVG(age) FROM (SELECT * FROM employee_data) AS t)
WHERE age IS NULL;
       
       
SELECT * FROM employee_data       

SELECT *,emp_id,
(CASE WHEN emp_id % 2 = 1 THEN LAG(name) OVER(ORDER BY emp_id)
     ELSE COALESCE (LEAD(name) OVER(ORDER BY emp_id),name)
     END) s
FROM employee_data   

------------------/////////////////////////////////////////////
SELECT  DISTINCT d.name, d.department
FROM employee_data d
JOIN employee_data e
ON d.department = e.department
 AND d.name<>e.name
 
 SELECT * FROM employee_data       
---------------------------------------------------
