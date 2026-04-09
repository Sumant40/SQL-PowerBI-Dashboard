SELECT 
    "Sub-Category",
    ROUND(
        (SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100)::numeric, 
        2
    ) AS profit_margin_pct
FROM superstore 
GROUP BY "Sub-Category" 
ORDER BY profit_margin_pct;