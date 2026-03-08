show tables;
select * from fraud_detection;
rename table fraud_detection to transactions;
show tables;
select * from transactions;

-- Q1 What is the overall fraud rate percentage in the dataset?
SELECT 
    COUNT(CASE WHEN isFraud = 1 THEN 1 END) * 100.0 / COUNT(*) AS fraud_rate_percentage
FROM transactions;

-- Q2 What is the total financial loss caused by fraudulent transactions?
SELECT 
    SUM(amount) AS total_fraud_loss
FROM transactions
WHERE isFraud = 1;

-- Q3 What is the fraud rate by transaction type?
 SELECT 
    type,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage
FROM transactions
GROUP BY type
ORDER BY fraud_rate_percentage DESC;

-- Q4 Who are the top 10 customers contributing the highest fraud amount?
SELECT 
    nameOrig,
    SUM(amount) AS total_fraud_amount
FROM transactions
WHERE isFraud = 1
GROUP BY nameOrig
ORDER BY total_fraud_amount DESC
LIMIT 10;

-- Q5 Which customers are repeat fraud offenders (more than one fraud transaction)?
SELECT 
    nameOrig,
    COUNT(*) AS fraud_count
FROM transactions
WHERE isFraud = 1
GROUP BY nameOrig
HAVING COUNT(*) > 1
ORDER BY fraud_count DESC;

-- Q6 How does fraud trend over time (step-based analysis)?
SELECT 
    step,
    COUNT(*) AS fraud_cases,
    SUM(amount) AS fraud_loss
FROM transactions
WHERE isFraud = 1
GROUP BY step
ORDER BY step;

-- Q7 What is the daily fraud trend (grouping steps into days)?
SELECT 
    FLOOR(step / 24) AS day_number,
    COUNT(*) AS fraud_cases,
    SUM(amount) AS fraud_loss
FROM transactions
WHERE isFraud = 1
GROUP BY day_number
ORDER BY day_number;

-- Q8 What is the fraud rate across different transaction amount categories (Low, Medium, High)?
SELECT 
    CASE 
        WHEN amount < 1000 THEN 'Low'
        WHEN amount BETWEEN 1000 AND 10000 THEN 'Medium'
        ELSE 'High'
    END AS amount_category,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage
FROM transactions
GROUP BY amount_category
ORDER BY fraud_rate_percentage DESC;

-- Q9 Which customers have unusually high transaction frequency (potential suspicious behavior)?
SELECT 
    nameOrig,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY nameOrig
HAVING COUNT(*) > 50
ORDER BY total_transactions DESC;

-- Q10 How many transactions were flagged as fraud by the system versus actually confirmed as fraud?
SELECT 
    isFlaggedFraud,
    isFraud,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY isFlaggedFraud, isFraud
ORDER BY isFlaggedFraud, isFraud;

