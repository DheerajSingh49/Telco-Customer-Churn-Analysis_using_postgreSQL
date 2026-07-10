# Customer Churn Analysis using PostgreSQL

## Project Overview

Customer churn is one of the most important business problems for subscription-based companies. This project analyzes customer behavior, identifies the primary drivers of churn, estimates revenue at risk, and segments customers using SQL.

The project was built using PostgreSQL and focuses on solving real business questions through analytical SQL rather than simple practice queries.

## Objectives
- Perform data quality assessment before analysis.
- Measure customer churn and revenue impact.
- Identify the major drivers of customer churn.
- Segment customers based on value and behavior.
- Generate business insights for customer retention.

## Dataset

- **Dataset:** IBM Telco Customer Churn
- **Records:** 7,032 Customers
- **Database:** PostgreSQL
- 
The dataset contains customer demographics, subscription details, billing information, tenure, and churn status.

## Project Structure

Customer-Churn-Analysis
│
├── Dataset
│   └── Telco_Customer_Churn.csv
│
├── SQL
│   ├── 01_Data_Audit.sql
│   ├── 02_Executive_KPIs.sql
│   ├── 03_Churn_Driver_Analysis.sql
│   ├── 04_Advanced_Analytics.sql
│   ├── 05_Customer_Segmentation.sql
│   └── 06_Business_Insights.sql
│
└── README.md
```

---

## SQL Concepts Used

- Aggregate Functions
- CASE Expressions
- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- NTILE()
- PERCENT_RANK()
- CUME_DIST()
- Subqueries
- Correlated Subqueries
- Conditional Aggregation
- Statistical Functions
- Data Validation

---

## Business Questions Answered

- Which contract type has the highest churn rate?
- Which payment method is associated with the highest churn?
- Which internet service contributes the most revenue loss?
- Which customer segments are most likely to churn?
- Which customers should be prioritized for retention?
- How much revenue is currently at risk?
- Which customer profiles generate the highest lifetime value?

---

## Tools Used

- PostgreSQL
- pgAdmin 4
- GitHub

---

## Author

**Dheeraj Singh**
