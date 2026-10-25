CREATE DATABASE retail_analytics;
USE retail_analytics;-- 1. Customers Dimension Table
CREATE TABLE dim_customers (
    Customer_ID VARCHAR(10) PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Segment VARCHAR(20),
    City VARCHAR(50),
    State VARCHAR(50)
);

-- 2. Products Dimension Table
CREATE TABLE dim_products (
    Product_ID VARCHAR(10) PRIMARY KEY,
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50)
);

-- 3. Orders Fact Table
CREATE TABLE fact_orders (
    Order_ID VARCHAR(10) PRIMARY KEY,
    Order_Date DATE,
    Customer_ID VARCHAR(10),
    Product_ID VARCHAR(10),
    Quantity INT,
    Discount DECIMAL(5,2),
    Gross_Sales DECIMAL(10,2),
    Net_Sales DECIMAL(10,2),
    Total_Cost DECIMAL(10,2),
    Profit DECIMAL(10,2),
    FOREIGN KEY (Customer_ID) REFERENCES dim_customers(Customer_ID),
    FOREIGN KEY (Product_ID) REFERENCES dim_products(Product_ID)
);

-- 4. Delivery Fact Table
CREATE TABLE fact_delivery (
    Order_ID VARCHAR(10) PRIMARY KEY,
    Delivery_Date DATE,
    Delivery_Status VARCHAR(20),
    FOREIGN KEY (Order_ID) REFERENCES fact_orders(Order_ID)
);



-- =========================================================================
-- PHASE 2: ANALYTICAL SQL QUERIES (Revenue, Profit, and Regional Performance)
-- =========================================================================

USE retail_analytics;

-- 1. Top 5 Cities by Total Net Sales and Total Profit
-- Ye query batayegi ki kin 5 cities se sabse zyada revenue aur profit aa raha hai.
SELECT 
    c.City, 
    SUM(o.Net_Sales) AS Total_Revenue, 
    SUM(o.Profit) AS Total_Profit
FROM fact_orders o
JOIN dim_customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.City
ORDER BY Total_Revenue DESC
LIMIT 5;


-- 2. Category-wise Profit Margin Percentage
-- Ye query product categories ke hisaab se total sales, profit, aur profit margin % nikal kar degi.
SELECT 
    p.Category, 
    SUM(o.Net_Sales) AS Revenue, 
    SUM(o.Profit) AS Profit,
    (SUM(o.Profit) / SUM(o.Net_Sales)) * 100 AS Profit_Margin_Percentage
FROM fact_orders o
JOIN dim_products p ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Profit_Margin_Percentage DESC;


-- 3. Segment-wise Total Orders and Revenue[cite: 1]
-- Ye check karne ke liye hai ki kaunsa customer segment (Consumer, Corporate, Home Office) sabse zyada orders aur revenue de raha hai.
SELECT 
    c.Segment, 
    COUNT(o.Order_ID) AS Total_Orders, 
    SUM(o.Net_Sales) AS Revenue
FROM fact_orders o
JOIN dim_customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Segment
ORDER BY Revenue DESC;

SELECT COUNT(*) FROM fact_orders;





USE retail_analytics;

SELECT 'dim_customers' AS Table_Name, COUNT(*) AS Total_Rows FROM dim_customers
UNION ALL
SELECT 'dim_products', COUNT(*) FROM dim_products
UNION ALL
SELECT 'fact_orders', COUNT(*) FROM fact_orders
UNION ALL
SELECT 'fact_delivery', COUNT(*) FROM fact_delivery;