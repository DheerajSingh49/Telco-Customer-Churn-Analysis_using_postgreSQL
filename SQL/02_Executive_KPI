-- Q1. Which contract type has the highest customer churn rate?

SELECT
contract,
COUNT(*) AS total_customers,
SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate
FROM churn
GROUP BY contract
ORDER BY churn_rate DESC;


-- Q2. Which internet service has the highest customer churn rate?

SELECT
internet_service,
COUNT(*) AS total_customers,
SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate
FROM churn
GROUP BY internet_service
ORDER BY churn_rate DESC;


-- Q3. Which payment method is associated with the highest churn rate?

SELECT
payment_method,
COUNT(*) AS total_customers,
SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate
FROM churn
GROUP BY payment_method
ORDER BY churn_rate DESC;


-- Q4. How does customer tenure influence churn?

SELECT
CASE
WHEN tenure < 12 THEN 'New'
WHEN tenure BETWEEN 12 AND 24 THEN 'Growing'
WHEN tenure BETWEEN 25 AND 48 THEN 'Established'
ELSE 'Loyal'
END AS tenure_group,
COUNT(*) AS customers,
SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate
FROM churn
GROUP BY tenure_group
ORDER BY churn_rate DESC;


-- Q5. Which combination of contract, internet service, and payment method has the highest churn rate?

SELECT
contract,
internet_service,
payment_method,
COUNT(*) AS customers,
SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END) AS churned,
ROUND(SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate
FROM churn
GROUP BY contract,internet_service,payment_method
HAVING COUNT(*)>=20
ORDER BY churn_rate DESC;


-- Q6. How much revenue has been lost due to churn across each contract type?

SELECT
contract,
ROUND(SUM(CASE WHEN churn='Yes' THEN total_charges ELSE 0 END),2) AS revenue_lost
FROM churn
GROUP BY contract
ORDER BY revenue_lost DESC;


-- Q7. How much revenue has been lost due to churn across each internet service?

SELECT
internet_service,
ROUND(SUM(CASE WHEN churn='Yes' THEN total_charges ELSE 0 END),2) AS revenue_lost
FROM churn
GROUP BY internet_service
ORDER BY revenue_lost DESC;


-- Q8. Who are the top 20 highest-value customers who have churned?

SELECT
customer_id,
contract,
tenure,
monthly_charges,
total_charges
FROM churn
WHERE churn='Yes'
ORDER BY total_charges DESC
LIMIT 20;


-- Q9. Rank churned customers based on their monthly subscription charges.

SELECT
customer_id,
contract,
monthly_charges,
RANK() OVER(ORDER BY monthly_charges DESC) AS bill_rank
FROM churn
WHERE churn='Yes';


-- Q10. Build a rule-based churn risk score for each customer.

SELECT
customer_id,
contract,
internet_service,
payment_method,
tenure,
monthly_charges,
(
CASE WHEN contract='Month-to-month' THEN 3 ELSE 0 END +
CASE WHEN internet_service='Fiber optic' THEN 2 ELSE 0 END +
CASE WHEN payment_method='Electronic check' THEN 2 ELSE 0 END +
CASE WHEN tenure<12 THEN 3 ELSE 0 END +
CASE WHEN tech_support='No' THEN 2 ELSE 0 END +
CASE WHEN online_security='No' THEN 2 ELSE 0 END
) AS churn_risk_score
FROM churn
ORDER BY churn_risk_score DESC,monthly_charges DESC;


-- Q11. Rank contract types based on total revenue lost from churned customers.

WITH revenue_loss AS
(
SELECT
contract,
SUM(CASE WHEN churn='Yes' THEN total_charges ELSE 0 END) AS revenue_lost
FROM churn
GROUP BY contract
)

SELECT
contract,
ROUND(revenue_lost,2) AS revenue_lost,
DENSE_RANK() OVER(ORDER BY revenue_lost DESC) AS revenue_rank
FROM revenue_loss;


-- Q12. Which combinations of support and protection services are most common among churned customers?

SELECT
online_security,
tech_support,
device_protection,
COUNT(*) AS customers
FROM churn
WHERE churn='Yes'
GROUP BY online_security,tech_support,device_protection
ORDER BY customers DESC;
