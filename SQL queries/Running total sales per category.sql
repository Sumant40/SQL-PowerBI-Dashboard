SELECT 
    "Category",
    "Order Date"::date AS order_date,
    "Sales",
    SUM("Sales") OVER (
        PARTITION BY "Category" 
        ORDER BY "Order Date"::date
    ) AS running_total
FROM superstore;