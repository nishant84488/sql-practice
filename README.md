sql-employee-project/

│

├── README.md

├── schema.sql

├── data.sql

├── queries/

│   ├── salary\_analysis.sql

│   ├── performance\_analysis.sql

│   ├── department\_analysis.sql

│   ├── hiring\_trends.sql

│   ├── data\_cleaning.sql

│   └── advanced\_queries.sql

```



---



\## 📄 README.md (Documentation)

```markdown

\# SQL Employee Analytics Project



\## 📌 Overview

This project is a SQL-based \*\*HR Analytics System\*\* built on an `employee\_data` table with 30 employees. It demonstrates salary analysis, performance insights, departmental breakdowns, hiring trends, and data cleaning using SQL.



\## 🛠 Features

\- \*\*Salary analysis\*\* → avg, min, max, median, above-department-average

\- \*\*Performance analysis\*\* → top performers, null handling, above-average scorers

\- \*\*Department insights\*\* → employee counts, remote vs onsite, cross-department comparisons

\- \*\*Hiring trends\*\* → employees joined recently, trends by year/month, rolling averages

\- \*\*Data cleaning\*\* → filling nulls, standardizing names, deriving year/month fields

\- \*\*Advanced analytics\*\* → median salaries, ranking, window functions



\## 🚀 Usage

1\. Run `schema.sql` to create the table.

2\. Load data with `data.sql`.

3\. Execute queries in `queries/` grouped by category.



\## 📊 Example Insights

\- Around half of the Engineering team works remotely.

\- Sales top earners make up to 64k+.

\- Hiring has picked up in recent years with spikes in 2022–2023.

\- Median salaries differ significantly across departments.



👨‍💻 This project shows \*\*end-to-end SQL analytics\*\* for HR data.

```



---



\## 📄 schema.sql

```sql

CREATE TABLE employee\_data (

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

```



---



\## 📄 data.sql

Includes all `INSERT INTO employee\_data (...) VALUES (...)` statements from your file.



---



\## 📄 queries/salary\_analysis.sql

```sql

-- Employees with salary greater than 60,000

-- Purpose: Identify high earners for budgeting.

SELECT \* FROM employee\_data WHERE salary >= 60000;



-- Average salary across the company

-- Purpose: Provides a benchmark for comparisons.

SELECT AVG(salary) AS avg\_salary FROM employee\_data;



-- Department-wise avg/min/max salary

-- Purpose: Understand salary distribution per department.

SELECT department, AVG(salary) AS avg\_salary FROM employee\_data GROUP BY department;

SELECT department, MIN(salary) AS min\_salary, MAX(salary) AS max\_salary FROM employee\_data GROUP BY department;



-- Employees above their department’s average salary

SELECT name, department, salary FROM employee\_data e

WHERE salary > (SELECT AVG(salary) FROM employee\_data WHERE department = e.department);



-- Median salary per department

WITH cte AS (

&nbsp; SELECT department, salary,

&nbsp;        ROW\_NUMBER() OVER(PARTITION BY department ORDER BY salary ASC) AS rn\_asc,

&nbsp;        ROW\_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS rn\_desc

&nbsp; FROM employee\_data WHERE salary IS NOT NULL

)

SELECT department, AVG(salary) AS median\_salary

FROM cte WHERE rn\_asc = rn\_desc OR ABS(rn\_asc - rn\_desc) = 1

GROUP BY department;

```



---



\## 📄 queries/performance\_analysis.sql

```sql

-- Employees with NULL performance score

SELECT \* FROM employee\_data WHERE performance\_score IS NULL;



-- Top performer in each department

SELECT \* FROM (

&nbsp; SELECT name, department, performance\_score,

&nbsp;        ROW\_NUMBER() OVER(PARTITION BY department ORDER BY performance\_score DESC) AS r

&nbsp; FROM employee\_data

) t WHERE r = 1;



-- Employees above department average performance

SELECT name, age, performance\_score, department

FROM employee\_data e

WHERE performance\_score > (SELECT AVG(performance\_score) FROM employee\_data WHERE department = e.department);



-- Top 25% performers across company

SELECT \* FROM (

&nbsp; SELECT name, department, performance\_score,

&nbsp;        NTILE(4) OVER (ORDER BY performance\_score DESC) AS quartile

&nbsp; FROM employee\_data

) q WHERE quartile = 1;

```



---



\## 📄 queries/department\_analysis.sql

```sql

-- Employee count per department

SELECT department, COUNT(\*) AS emp\_count FROM employee\_data GROUP BY department;



-- Remote vs non-remote employees

SELECT is\_remote, COUNT(\*) AS emp\_count FROM employee\_data GROUP BY is\_remote;



-- Departments with >30% remote workers

SELECT department,

&nbsp;      (SUM(CASE WHEN is\_remote = 1 THEN 1 ELSE 0 END) \* 1.0 / COUNT(\*)) \* 100 AS remote\_pct

FROM employee\_data GROUP BY department HAVING remote\_pct > 30;



-- Cities with more than 2 employees

SELECT city, COUNT(\*) AS employee\_count FROM employee\_data

WHERE city IS NOT NULL GROUP BY city HAVING COUNT(\*) >= 2;

```



---



\## 📄 queries/hiring\_trends.sql

```sql

-- Employees joined in the last 2 years

SELECT \* FROM employee\_data WHERE join\_date >= '2021-01-01';



-- Hiring by year/month

SELECT YEAR(join\_date) AS join\_year, MONTH(join\_date) AS join\_month, COUNT(\*) AS total\_hires

FROM employee\_data

GROUP BY YEAR(join\_date), MONTH(join\_date)

ORDER BY join\_year, join\_month;



-- Rolling average salary by join date

SELECT join\_date,

&nbsp;      AVG(salary) OVER (ORDER BY join\_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rolling\_avg\_salary

FROM employee\_data WHERE join\_date IS NOT NULL;

```



---



\## 📄 queries/data\_cleaning.sql

```sql

-- Replace NULL roles with 'Unknown'

SELECT role, COALESCE(role, 'Unknown') FROM employee\_data;



-- Standardize department names

UPDATE employee\_data SET department = LOWER(department);



-- Fill missing salaries with department median

WITH cte AS (

&nbsp;   SELECT department, salary,

&nbsp;          ROW\_NUMBER() OVER(PARTITION BY department ORDER BY salary) AS rn\_asc,

&nbsp;          ROW\_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS rn\_desc

&nbsp;   FROM employee\_data WHERE salary IS NOT NULL

),

median\_cte AS (

&nbsp;   SELECT department, AVG(salary) AS median\_salary

&nbsp;   FROM cte WHERE rn\_asc = rn\_desc OR ABS(rn\_asc - rn\_desc) = 1

&nbsp;   GROUP BY department

)

UPDATE employee\_data e

SET salary = (SELECT median\_salary FROM median\_cte m WHERE m.department = e.department)

WHERE e.salary IS NULL;



-- Fill missing ages with average age

UPDATE employee\_data SET age = (SELECT AVG(age) FROM employee\_data WHERE age IS NOT NULL) WHERE age IS NULL;

```



---



\## 📄 queries/advanced\_queries.sql

```sql

-- Rank employees by salary within department

SELECT name, department, salary,

&nbsp;      RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rank\_in\_dept

FROM employee\_data;



-- Employees below company median salary

WITH cte AS (

&nbsp; SELECT salary,

&nbsp;        ROW\_NUMBER() OVER (ORDER BY salary ASC) AS a,

&nbsp;        ROW\_NUMBER() OVER (ORDER BY salary DESC) AS d

&nbsp; FROM employee\_data

),

median AS (

&nbsp; SELECT AVG(salary) AS median\_salary

&nbsp; FROM cte WHERE ABS(a - d) <= 1

)

SELECT e.\* FROM employee\_data e, median m WHERE e.salary < m.median\_salary;



-- Pair employees in same department (for collaboration insights)

SELECT DISTINCT d.name, d.department

FROM employee\_data d

JOIN employee\_data e ON d.department = e.department AND d.name <> e.name;

```



---



✅ Now you have a \*\*clean, documented, GitHub-ready SQL project\*\* with schema, data, queries, and explanations.



Would you like me to also prepare a set of \*\*CSV outputs for each query\*\* so that the insights/results are visible directly on GitHub without running SQL?



