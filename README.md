# 📊 SQL Employee Analytics Project

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