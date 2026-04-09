SELECT 
    "Region", 
    ROUND(SUM("Sales")::numeric, 2) AS total_sales,
    ROUND(SUM("Profit")::numeric, 2) AS total_profit
FROM superstore
GROUP BY "Region"
ORDER BY total_sales DESC;