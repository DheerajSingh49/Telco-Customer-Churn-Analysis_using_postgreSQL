-- Q1. Rank customers by total revenue within each contract

SELECT
customer_id,
contract,
total_charges,
DENSE_RANK() OVER(PARTITION BY contract ORDER BY total_charges DESC) AS revenue_rank
FROM churn;


-- Q2. Compare customer spending against the average of their contract type

SELECT
customer_id,
contract,
total_charges,
ROUND(AVG(total_charges) OVER(PARTITION BY contract),2) AS contract_avg,
ROUND(total_charges-AVG(total_charges) OVER(PARTITION BY contract),2) AS difference_from_avg
FROM churn;


-- Q3. Find customers whose total revenue is above the company average

SELECT
customer_id,
contract,
total_charges
FROM churn
WHERE total_charges>(
SELECT AVG(total_charges)
FROM churn)
ORDER BY total_charges DESC;


-- Q4. Revenue percentile of every customer

SELECT
customer_id,
total_charges,
ROUND(PERCENT_RANK() OVER(ORDER BY total_charges),4) AS revenue_percentile
FROM churn;


-- Q5. Cumulative distribution of customer revenue

SELECT
customer_id,
total_charges,
ROUND(CUME_DIST() OVER(ORDER BY total_charges),4) AS cumulative_distribution
FROM churn;


-- Q6. Top 25% highest spending customers

WITH customer_rank AS
(
SELECT
customer_id,
total_charges,
NTILE(4) OVER(ORDER BY total_charges DESC) AS revenue_quartile
FROM churn
)

SELECT *
FROM customer_rank
WHERE revenue_quartile=1;


-- Q7. Highest paying customer in every contract

WITH ranked_customers AS
(
SELECT
customer_id,
contract,
total_charges,
ROW_NUMBER() OVER(PARTITION BY contract ORDER BY total_charges DESC) AS rn
FROM churn
)

SELECT
customer_id,
contract,
total_charges
FROM ranked_customers
WHERE rn=1;


-- Q8. Revenue contribution by contract

WITH revenue AS
(
SELECT
contract,
SUM(total_charges) AS total_revenue
FROM churn
GROUP BY contract
)

SELECT
contract,
total_revenue,
ROUND(total_revenue*100/SUM(total_revenue) OVER(),2) AS revenue_share
FROM revenue
ORDER BY revenue_share DESC;


-- Q9. Compare churn rate with overall churn rate

SELECT
contract,
ROUND(
SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),
2
) AS contract_churn_rate,

ROUND(
(
SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*)
)
-
(
SELECT
SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*)
FROM churn
),
2
) AS difference_from_company
FROM churn
GROUP BY contract;


-- Q10. Find customers paying more than the average of their tenure group

WITH tenure_group AS
(
SELECT
customer_id,
tenure,
monthly_charges,
CASE
WHEN tenure<12 THEN 'New'
WHEN tenure BETWEEN 12 AND 24 THEN 'Growing'
WHEN tenure BETWEEN 25 AND 48 THEN 'Established'
ELSE 'Loyal'
END AS tenure_segment
FROM churn
)

SELECT
customer_id,
tenure_segment,
monthly_charges
FROM tenure_group t
WHERE monthly_charges>
(
SELECT AVG(monthly_charges)
FROM tenure_group
WHERE tenure_segment=t.tenure_segment
);


-- Q11. Revenue category using NTILE()

SELECT
customer_id,
total_charges,
NTILE(10) OVER(ORDER BY total_charges DESC) AS revenue_decile
FROM churn;


-- Q12. Customers with above-average tenure and above-average revenue

SELECT
customer_id,
tenure,
total_charges
FROM churn
WHERE tenure>(SELECT AVG(tenure) FROM churn)
AND total_charges>(SELECT AVG(total_charges) FROM churn)
ORDER BY total_charges DESC;
