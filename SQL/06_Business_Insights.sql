-- Q1. Which contract type contributes the highest revenue loss?

SELECT
contract,
COUNT(*) AS churned_customers,
ROUND(SUM(total_charges),2) AS revenue_lost
FROM churn
WHERE churn='Yes'
GROUP BY contract
ORDER BY revenue_lost DESC;


-- Q2. Which payment method contributes the highest revenue loss?

SELECT
payment_method,
COUNT(*) AS churned_customers,
ROUND(SUM(total_charges),2) AS revenue_lost
FROM churn
WHERE churn='Yes'
GROUP BY payment_method
ORDER BY revenue_lost DESC;


-- Q3. Which internet service contributes the highest revenue loss?

SELECT
internet_service,
COUNT(*) AS churned_customers,
ROUND(SUM(total_charges),2) AS revenue_lost
FROM churn
WHERE churn='Yes'
GROUP BY internet_service
ORDER BY revenue_lost DESC;


-- Q4. Top 10 customer groups with highest churn

SELECT
contract,
internet_service,
payment_method,
COUNT(*) AS customers,
ROUND(SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate
FROM churn
GROUP BY contract,internet_service,payment_method
HAVING COUNT(*)>=20
ORDER BY churn_rate DESC
LIMIT 10;


-- Q5. Which tenure group generates the highest revenue?

SELECT
CASE
WHEN tenure<12 THEN 'New'
WHEN tenure BETWEEN 12 AND 24 THEN 'Growing'
WHEN tenure BETWEEN 25 AND 48 THEN 'Established'
ELSE 'Loyal'
END AS tenure_group,
ROUND(SUM(total_charges),2) AS total_revenue
FROM churn
GROUP BY tenure_group
ORDER BY total_revenue DESC;


-- Q6. Revenue and churn by gender

SELECT
gender,
COUNT(*) AS customers,
ROUND(SUM(total_charges),2) AS revenue,
ROUND(SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate
FROM churn
GROUP BY gender;


-- Q7. Revenue and churn by senior citizen

SELECT
senior_citizen,
COUNT(*) AS customers,
ROUND(SUM(total_charges),2) AS revenue,
ROUND(SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate
FROM churn
GROUP BY senior_citizen;


-- Q8. Which customers should be retained first?

SELECT
customer_id,
contract,
tenure,
monthly_charges,
total_charges
FROM churn
WHERE churn='Yes'
AND total_charges>(
SELECT AVG(total_charges)
FROM churn)
ORDER BY total_charges DESC;


-- Q9. Top 20 customers by lifetime value

SELECT
customer_id,
total_charges,
DENSE_RANK() OVER(ORDER BY total_charges DESC) AS customer_rank
FROM churn
LIMIT 20;


-- Q10. Final Executive Dashboard

SELECT
COUNT(*) AS total_customers,
SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate,
ROUND(SUM(monthly_charges),2) AS monthly_revenue,
ROUND(SUM(CASE WHEN churn='Yes' THEN monthly_charges ELSE 0 END),2) AS monthly_revenue_at_risk,
ROUND(AVG(total_charges),2) AS avg_customer_value,
ROUND(AVG(tenure),2) AS avg_customer_tenure
FROM churn;
