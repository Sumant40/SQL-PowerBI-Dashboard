WITH monthly AS (
  SELECT 
    DATE_TRUNC('month', "Order Date"::date) AS month,
    SUM("Sales")::numeric AS revenue
  FROM superstore
  GROUP BY 1
)
SELECT 
  month,
  revenue,
  LAG(revenue) OVER (ORDER BY month) AS prev_month,
  (revenue - LAG(revenue) OVER (ORDER BY month)) 
  / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100 AS growth_pct
FROM monthly;