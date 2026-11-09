-- =====================================================================
-- E-Commerce Customer Churn, Cohort Retention & RFM Analysis
-- Author: Nakshatra Khanna (Junior Business Analyst)
-- Database: PostgreSQL / MySQL Compatible
-- Description: Business Analytics queries assessing customer churn,
--              cohort retention rates, and Recency-Frequency-Monetary (RFM)
-- =====================================================================

-- 1. KPI Summary: Total Revenue, Distinct Customers, Average Order Value (AOV)
SELECT 
    COUNT(DISTINCT CustomerID) AS Total_Active_Customers,
    COUNT(DISTINCT InvoiceID) AS Total_Orders,
    ROUND(SUM(OrderValue_INR), 2) AS Gross_Revenue_INR,
    ROUND(AVG(OrderValue_INR), 2) AS Average_Order_Value_INR,
    ROUND(AVG(Discount_Pct), 2) AS Average_Discount_Given
FROM ecommerce_orders;

-- 2. Monthly Revenue & MoM Growth Analysis
WITH MonthlySales AS (
    SELECT 
        DATE_TRUNC('month', OrderDate::DATE) AS Sales_Month,
        SUM(OrderValue_INR) AS Monthly_Revenue,
        COUNT(DISTINCT InvoiceID) AS Order_Volume
    FROM ecommerce_orders
    GROUP BY 1
)
SELECT 
    TO_CHAR(Sales_Month, 'YYYY-Mon') AS Period,
    Monthly_Revenue,
    Order_Volume,
    LAG(Monthly_Revenue, 1) OVER (ORDER BY Sales_Month) AS Prev_Month_Revenue,
    ROUND(
        (Monthly_Revenue - LAG(Monthly_Revenue, 1) OVER (ORDER BY Sales_Month)) 
        / NULLIF(LAG(Monthly_Revenue, 1) OVER (ORDER BY Sales_Month), 0) * 100, 
        2
    ) AS MoM_Growth_Pct
FROM MonthlySales;

-- 3. Cohort Retention Matrix (First Purchase Month vs Subsequent Orders)
WITH CustomerFirstOrder AS (
    SELECT 
        CustomerID,
        DATE_TRUNC('month', MIN(OrderDate::DATE)) AS Cohort_Month
    FROM ecommerce_orders
    GROUP BY CustomerID
),
OrderPeriods AS (
    SELECT 
        o.CustomerID,
        c.Cohort_Month,
        DATE_TRUNC('month', o.OrderDate::DATE) AS Order_Month,
        (EXTRACT(YEAR FROM o.OrderDate::DATE) - EXTRACT(YEAR FROM c.Cohort_Month)) * 12 +
        (EXTRACT(MONTH FROM o.OrderDate::DATE) - EXTRACT(MONTH FROM c.Cohort_Month)) AS Month_Offset
    FROM ecommerce_orders o
    JOIN CustomerFirstOrder c ON o.CustomerID = c.CustomerID
)
SELECT 
    TO_CHAR(Cohort_Month, 'YYYY-Mon') AS Cohort,
    COUNT(DISTINCT CASE WHEN Month_Offset = 0 THEN CustomerID END) AS Month_0_Initial,
    COUNT(DISTINCT CASE WHEN Month_Offset = 1 THEN CustomerID END) AS Month_1_Active,
    COUNT(DISTINCT CASE WHEN Month_Offset = 2 THEN CustomerID END) AS Month_2_Active,
    COUNT(DISTINCT CASE WHEN Month_Offset = 3 THEN CustomerID END) AS Month_3_Active,
    ROUND(COUNT(DISTINCT CASE WHEN Month_Offset = 1 THEN CustomerID END)::NUMERIC / 
          NULLIF(COUNT(DISTINCT CASE WHEN Month_Offset = 0 THEN CustomerID END), 0) * 100, 1) AS Month_1_Retention_Pct
FROM OrderPeriods
GROUP BY Cohort_Month
ORDER BY Cohort_Month;

-- 4. RFM (Recency, Frequency, Monetary) Segmentation
WITH RFM_Base AS (
    SELECT 
        CustomerID,
        MIN(DaysSinceLastPurchase) AS Recency_Days,
        COUNT(DISTINCT InvoiceID) AS Frequency_Orders,
        SUM(OrderValue_INR) AS Monetary_Value
    FROM ecommerce_orders
    GROUP BY CustomerID
),
RFM_Scores AS (
    SELECT 
        CustomerID,
        Recency_Days,
        Frequency_Orders,
        Monetary_Value,
        NTILE(4) OVER (ORDER BY Recency_Days DESC) AS R_Score, -- 4 is most recent
        NTILE(4) OVER (ORDER BY Frequency_Orders ASC) AS F_Score,
        NTILE(4) OVER (ORDER BY Monetary_Value ASC) AS M_Score
    FROM RFM_Base
)
SELECT 
    CustomerID,
    Recency_Days,
    Frequency_Orders,
    Monetary_Value,
    (R_Score + F_Score + M_Score) AS Composite_RFM,
    CASE 
        WHEN R_Score >= 3 AND F_Score >= 3 THEN 'Champions / High Loyalty'
        WHEN R_Score >= 3 AND F_Score < 3 THEN 'Promising / New Customers'
        WHEN R_Score <= 2 AND F_Score >= 3 THEN 'At Risk / Need Retention'
        ELSE 'Hibernating / Likely Churned'
    END AS Customer_Segment
FROM RFM_Scores
ORDER BY Monetary_Value DESC;

-- 5. Churn Rate by Product Category & Discount Impact
SELECT 
    ProductCategory,
    COUNT(DISTINCT CustomerID) AS Total_Shoppers,
    ROUND(SUM(OrderValue_INR), 2) AS Category_Revenue,
    ROUND(AVG(Discount_Pct), 1) AS Avg_Discount,
    ROUND(
        COUNT(DISTINCT CASE WHEN ReturnCustomerFlag = 0 THEN CustomerID END)::NUMERIC / 
        COUNT(DISTINCT CustomerID) * 100, 
        2
    ) AS Churn_Rate_Pct
FROM ecommerce_orders
GROUP BY ProductCategory
ORDER BY Churn_Rate_Pct DESC;
