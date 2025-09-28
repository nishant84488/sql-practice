# 📊 SQL practice Project

A hands-on SQL-based HR analytics system built on an `employee_data` table of 30 sample employees. This project showcases real-world data exploration and manipulation using raw SQL.

---

## 📌 Overview

This project demonstrates SQL queries across various HR analytics dimensions, including:

- 💰 Salary analysis  
- 🌟 Performance insights  
- 🏢 Department-level trends  
- 📈 Hiring patterns  
- 🧹 Data cleaning techniques  
- 🔍 Advanced analytics using window functions  

---

## 🗂 Folder Structure

```
sql-employee-project/
├── README.md
├── schema.sql
├── data.sql
└── queries/
    ├── salary_analysis.sql
    ├── performance_analysis.sql
    ├── department_analysis.sql
    ├── hiring_trends.sql
    ├── data_cleaning.sql
    └── advanced_queries.sql
```

---

## 🛠 Features

### 💰 Salary Analysis
- Average, min, max, and median salaries
- Employees earning above department average
- High earners across company

### 🌟 Performance Analysis
- Top performers per department
- Identify NULL performance scores
- Above-average contributors
- Top 25% performers company-wide

### 🏢 Department Insights
- Employee headcount per department
- Remote vs onsite distributions
- Departments with high remote work
- Cities with more than 2 employees

### 📈 Hiring Trends
- Employees hired in the last 2 years
- Yearly/monthly hiring patterns
- Rolling average salary trends

### 🧹 Data Cleaning
- Handle NULLs in role, salary, age
- Standardize department names
- Impute missing salaries using department medians

### 🔍 Advanced Analytics
- Rank employees by salary within department
- Identify employees below company median salary
- Pair employees in same department for collaboration

---

## 🚀 How to Use

1. **Run the schema**  
   ```bash
   mysql -u <user> -p <database_name> < schema.sql
   ```

2. **Insert the data**  
   ```bash
   mysql -u <user> -p <database_name> < data.sql
   ```

3. **Explore queries**  
   Open files under the `queries/` folder and run them in your SQL tool (MySQL, Postgres, or SQLite depending on your setup).

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



## 📄 queries/data\_cleaning.sql

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



## 📄 queries/advanced\_queries.sql

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


## 📊 Sample Insights

- Engineering has ~50% remote workers  
- Sales top earners make over $64,000  
- Hiring peaked in 2022–2023  
- Wide salary disparity across departments  
- Some departments have >30% remote workforce  

---

## 🧠 Tech Concepts Used

- `GROUP BY`, `HAVING`, `CASE`, `COALESCE`  
- Subqueries and Correlated Subqueries  
- `NTILE`, `RANK`, `ROW_NUMBER`  
- Common Table Expressions (CTEs)  
- Window Functions for advanced ranking and aggregations  

---

## 🧩 Ideal For

- SQL practice for job interviews  
- HR data analytics demo  
- Exploring data cleaning + window functions  
- Learning correlated subqueries and CTEs  

---

## 👨‍💻 Author

Chinmay Raiker  
Built for hands-on SQL data exploration and analytics use cases.

---

## ✅ License

MIT License – free to use and modify.