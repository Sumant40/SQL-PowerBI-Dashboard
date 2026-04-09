SELECT 
  AVG("Discount") AS avg_discount,
  SUM("Profit") AS total_profit,
  SUM("Sales") AS total_sales
FROM superstore
GROUP BY "Sub-Category";