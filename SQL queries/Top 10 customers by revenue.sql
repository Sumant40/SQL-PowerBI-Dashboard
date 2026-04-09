SELECT 
    "Customer Name", 
    ROUND(SUM("Sales")::numeric, 2) AS revenue
FROM superstore 
GROUP BY "Customer Name" 
ORDER BY revenue DESC 
LIMIT 10;