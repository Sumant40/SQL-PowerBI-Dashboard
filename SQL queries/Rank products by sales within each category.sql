WITH ranked AS (
  SELECT 
      "Sub-Category",
      "Category",
      ROUND(SUM("Sales")::numeric, 2) AS total_sales,
      RANK() OVER (
          PARTITION BY "Category" 
          ORDER BY SUM("Sales") DESC
      ) AS rnk
  FROM superstore 
  GROUP BY "Sub-Category", "Category"
)
SELECT * 
FROM ranked 
WHERE rnk <= 3;