-- Q1. Segment customers based on lifetime revenue

SELECT
customer_id,
total_charges,
CASE
WHEN total_charges < 1000 THEN 'Low Value'
WHEN total_charges < 3000 THEN 'Medium Value'
WHEN total_charges < 6000 THEN 'High Value'
ELSE 'Premium'
END AS customer_segment
FROM churn;


-- Q2. Customer distribution by segment

SELECT
CASE
WHEN total_charges < 1000 THEN 'Low Value'
WHEN total_charges < 3000 THEN 'Medium Value'
WHEN total_charges < 6000 THEN 'High Value'
ELSE 'Premium'
END AS customer_segment,
COUNT(*) AS customers,
ROUND(AVG(monthly_charges),2) AS avg_monthly_bill,
ROUND(AVG(tenure),2) AS avg_tenure
FROM churn
GROUP BY customer_segment
ORDER BY customers DESC;


-- Q3. Which customer segment has the highest churn?

SELECT
CASE
WHEN total_charges < 1000 THEN 'Low Value'
WHEN total_charges < 3000 THEN 'Medium Value'
WHEN total_charges < 6000 THEN 'High Value'
ELSE 'Premium'
END AS customer_segment,
COUNT(*) AS customers,
SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END) AS churned,
ROUND(SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate
FROM churn
GROUP BY customer_segment
ORDER BY churn_rate DESC;


-- Q4. Service adoption score

SELECT
customer_id,
(
CASE WHEN online_security='Yes' THEN 1 ELSE 0 END +
CASE WHEN online_backup='Yes' THEN 1 ELSE 0 END +
CASE WHEN device_protection='Yes' THEN 1 ELSE 0 END +
CASE WHEN tech_support='Yes' THEN 1 ELSE 0 END +
CASE WHEN streaming_tv='Yes' THEN 1 ELSE 0 END +
CASE WHEN streaming_movies='Yes' THEN 1 ELSE 0 END
) AS service_score
FROM churn
ORDER BY service_score DESC;


-- Q5. Average service score by churn status

WITH service_score AS
(
SELECT
customer_id,
churn,
(
CASE WHEN online_security='Yes' THEN 1 ELSE 0 END +
CASE WHEN online_backup='Yes' THEN 1 ELSE 0 END +
CASE WHEN device_protection='Yes' THEN 1 ELSE 0 END +
CASE WHEN tech_support='Yes' THEN 1 ELSE 0 END +
CASE WHEN streaming_tv='Yes' THEN 1 ELSE 0 END +
CASE WHEN streaming_movies='Yes' THEN 1 ELSE 0 END
) AS score
FROM churn
)

SELECT
churn,
ROUND(AVG(score),2) AS avg_service_score
FROM service_score
GROUP BY churn;


-- Q6. Premium customers who churned

SELECT
customer_id,
contract,
tenure,
total_charges
FROM churn
WHERE churn='Yes'
AND total_charges>=6000
ORDER BY total_charges DESC;


-- Q7. Customers paying high monthly charges but low lifetime revenue

SELECT
customer_id,
monthly_charges,
total_charges,
tenure
FROM churn
WHERE monthly_charges>(
SELECT AVG(monthly_charges) FROM churn)
AND total_charges<(
SELECT AVG(total_charges) FROM churn)
ORDER BY monthly_charges DESC;


-- Q8. Customer persona

SELECT
customer_id,
CASE
WHEN tenure<12 AND monthly_charges>70 THEN 'High Risk New Customer'
WHEN tenure>=48 AND churn='No' THEN 'Loyal Customer'
WHEN total_charges>=6000 THEN 'Premium Customer'
WHEN churn='Yes' THEN 'Lost Customer'
ELSE 'Regular Customer'
END AS customer_persona
FROM churn;


-- Q9. Persona distribution

WITH personas AS
(
SELECT
CASE
WHEN tenure<12 AND monthly_charges>70 THEN 'High Risk New Customer'
WHEN tenure>=48 AND churn='No' THEN 'Loyal Customer'
WHEN total_charges>=6000 THEN 'Premium Customer'
WHEN churn='Yes' THEN 'Lost Customer'
ELSE 'Regular Customer'
END AS persona
FROM churn
)

SELECT
persona,
COUNT(*) AS customers
FROM personas
GROUP BY persona
ORDER BY customers DESC;


-- Q10. Top 10 highest-value active customers

SELECT
customer_id,
contract,
tenure,
total_charges
FROM churn
WHERE churn='No'
ORDER BY total_charges DESC
LIMIT 10;
