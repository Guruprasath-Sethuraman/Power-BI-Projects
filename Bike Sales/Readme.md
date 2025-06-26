# 📊 Power BI Sales Analytics Dashboard

This project presents a comprehensive **Sales Performance Dashboard** built using **Power BI**, with data sourced from a normalized sales database (Northwind-style ERD). It provides actionable insights across key business areas like revenue, product performance, customer behavior, and staff efficiency.

---

## 🔧 Tools & Technologies Used

- **Power BI Desktop**
- **SQL Server (Views created for optimization)**
- **DAX (Data Analysis Expressions)**
- **Power Query (ETL)**
- **Data Modelling (Star Schema)**

---

## 🗃️ Data Model Overview

To ensure optimal performance, data was loaded via **SQL Views** derived from a normalized schema (ERD). A **star schema** was created with:

- **Fact Table:** Sales Table  
- **Dimension Tables:** Customers Table, Products Table, Calendar Table, Staffs Table

![Data Model](./images/data-model.png)![Data modelling](https://github.com/user-attachments/assets/a9e13cf8-6712-4a2b-90d8-00f65dd5994a)


From The below ERD diagram 
![Data ERD](./images/data-ERD.png)![SQL-Server-Sample-Database](https://github.com/user-attachments/assets/9fa1c50d-7c72-4395-b8de-8491c62da626)

---

## 📌 Key Business Questions Answered

### ✅ Performance KPIs (Landing Page)

- 💰 What is the total revenue?
- 📦 How many orders and units were sold?
- 💳 What is the average order value?
- 📈 What is the YoY (Year-over-Year) change for revenue, orders, units?

> KPIs with monthly trends and YoY performance metrics using DAX.

---

### 📊 Product & Sales Analysis

- Which products and categories generated the highest sales?
- What is the stock in hand vs. units sold?
- Which brands are underperforming?
- How has product sales varied over time?

---

### 🧍‍♂️ Customer Insights

- Who are the top customers by revenue?
- How many orders did each customer place?
- What is the distribution of customers by state/region?
- Who are new vs. returning customers?

---

### 🧑‍💼 Staff & Store Performance

- Which staff processed the most orders?
- Sales performance by store and staff member.
- YoY growth in orders handled per agent.

---

### 🗓️ Time Intelligence

- Monthly and Quarterly sales trends
- Comparison of performance across different time periods
- Seasonality in revenue or order volume

---

## 👤 Author

**Guruprasath S**  
🔗 [LinkedIn Profile](https://www.linkedin.com/in/guru-prasath-sethuraman-49446b56/)

