-- Q1. Display all customer records to understand the dataset structure.

SELECT * FROM churn;

-- Q2. Check whether duplicate customer IDs exist in the dataset.

SELECT
customer_id,
COUNT(*) AS record_count
FROM churn
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Q3. Identify missing values in critical business columns.

SELECT
COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
COUNT(*) FILTER (WHERE tenure IS NULL) AS tenure_nulls,
COUNT(*) FILTER (WHERE monthly_charges IS NULL) AS monthly_charge_nulls,
COUNT(*) FILTER (WHERE total_charges IS NULL) AS total_charge_nulls,
COUNT(*) FILTER (WHERE contract IS NULL) AS contract_nulls,
COUNT(*) FILTER (WHERE churn IS NULL) AS churn_nulls
FROM churn;

-- Q4. Validate the unique values present in key categorical columns.

SELECT DISTINCT
churn,
contract,
internet_service,
payment_method
FROM churn;

-- Q5. Check for customers with invalid (negative) tenure values.

SELECT *
FROM churn
WHERE tenure < 0;

-- Q6. Check for customers with invalid (negative) monthly charges.

SELECT *
FROM churn
WHERE monthly_charges < 0;

-- Q7. Identify customers whose total charges are less than a single month's charge despite having more than one month of tenure.

SELECT
customer_id,
tenure,
monthly_charges,
total_charges
FROM churn
WHERE tenure > 1
AND total_charges < monthly_charges;

-- Q8. Generate descriptive statistics for monthly charges.

SELECT
MIN(monthly_charges) AS minimum_charge,
MAX(monthly_charges) AS maximum_charge,
ROUND(AVG(monthly_charges),2) AS average_charge,
ROUND(STDDEV(monthly_charges),2) AS std_deviation
FROM churn;

-- Q9. Divide customers into four spending quartiles based on monthly charges.

SELECT
customer_id,
monthly_charges,
NTILE(4) OVER(ORDER BY monthly_charges DESC) AS spending_quartile
FROM churn;

-- Q10. Identify customers with unusually high monthly charges using the 2-standard-deviation rule.

SELECT
customer_id,
monthly_charges
FROM churn
WHERE monthly_charges >
(SELECT AVG(monthly_charges) + 2 * STDDEV(monthly_charges)
FROM churn)
ORDER BY monthly_charges DESC;

-- Q11. Calculate the percentage distribution of customers across contract types.

SELECT
contract,
COUNT(*) AS customers,
ROUND(
COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),
2) AS percentage_of_customers
FROM churn
GROUP BY contract
ORDER BY customers DESC;
