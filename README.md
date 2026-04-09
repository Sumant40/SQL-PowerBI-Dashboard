# Superstore Sales Analysis — SQL + Power BI Dashboard

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue)
![PowerBI](https://img.shields.io/badge/PowerBI-Dashboard-yellow)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

## Problem Statement

A retail superstore wants to maximize profit by understanding:
- **Which regions and products are most/least profitable?**
- **How is excessive discounting affecting margins?**
- **Who are the highest-value customers?**
- **What are seasonal demand patterns?**

**Approach:** Use SQL for detailed analytical queries, then visualize findings in Power BI for stakeholder communication.

---

## Dataset

- **Source:** Superstore Sales Dataset (Kaggle)
- **Link:** https://www.kaggle.com/datasets/vivek468/superstore-dataset-final
- **Size:** 9,994 orders × 21 columns
- **Period:** 2014–2017
- **Key columns:** Order Date, Region, Category, Sub-Category, Sales,
  Quantity, Discount, Profit, Customer Segment

---

## Project Structure

```
SQL-dashboard/
│
├── Create_table.sql                          # DDL for superstore table
│
├── SQL queries/
│   ├── total_sales_profit_by_region.sql      # Sales & profit aggregation by region
│   ├── Top 10 customers by revenue.sql       # Top N customers query
│   ├── Monthly revenue trend (year-over-month).sql  # Trend analysis with DATE_TRUNC
│   ├── Profit margin by sub-category.sql     # Profit margin % calculation
│   ├── Rank products by sales within each category.sql  # CTE + RANK window function
│   ├── Running total sales per category.sql  # Running totals with window function
│   ├── Month-over-month growth rate.sql      # YoY growth analysis with LAG()
│   └── Discount impact.sql                   # Discount impact on profit
│
├── output/
│   └── figures/
│       ├── page 1.jpg                        # Dashboard overview & KPIs
│       ├── page 2.jpg                        # Regional & sales analysis
│       ├── page 3.jpg                        # Product categories & margins
│       └── page 4.jpg                        # Trends & growth rates
│
└── README.md
```

---

## SQL Queries Covered

### Overview of queries included

| Query | Type | Purpose |
|-------|------|---------|
| total_sales_profit_by_region.sql | Basic aggregation + GROUP BY | Total sales and profit breakdown by region |
| Top 10 customers by revenue.sql | TOP N + ORDER BY | Identify high-value customers |
| Monthly revenue trend (year-over-month).sql | Window function + DATE_TRUNC | Track monthly revenue patterns across years |
| Profit margin by sub-category.sql | Derived metric calculation | Identify profitable vs. unprofitable categories |
| Rank products by sales within each category.sql | CTE + RANK() | Top 3 products per category |
| Running total sales per category.sql | Window function (running sum) | Cumulative sales tracking per category |
| Month-over-month growth rate.sql | Window function LAG() | Calculate month-to-month revenue growth % |
| Discount impact.sql | Aggregation + GROUP BY | Analyze relationship between discounts and profit |

### Key SQL Techniques Demonstrated

✅ **DDL:** Table creation with appropriate data types (Create_table.sql)
✅ **Aggregations:** SUM, ROUND, GROUP BY, ORDER BY
✅ **Window Functions:** LAG(), RANK() OVER (PARTITION BY), Running totals
✅ **CTEs:** Common Table Expressions for complex queries
✅ **Date Functions:** DATE_TRUNC for time-based grouping
✅ **Conditional Logic:** CASE WHEN for discount categorization
✅ **Null Handling:** NULLIF to prevent division errors

### Sample Query — Month-over-Month Growth (Window Function with LAG)

```sql
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
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100,
        2
    ) AS growth_pct
FROM monthly;
```

### Sample Query — Top 3 Products per Category (CTE + RANK)

```sql
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
```

### Sample Query — Profit Margin by Sub-Category

```sql
SELECT
    "Sub-Category",
    ROUND(
        (SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100)::numeric,
        2
    ) AS profit_margin_pct
FROM superstore
GROUP BY "Sub-Category"
ORDER BY profit_margin_pct;
```

---

## Power BI Dashboard

### Dashboard Overview (4 Pages)

**Page 1: Overview & KPIs**
![Dashboard Overview](output/figures/page%201.jpg)

**Page 2: Regional & Sales Analysis**
![Regional Analysis](output/figures/page%202.jpg)

**Page 3: Product Categories & Profit Margins**
![Product Analysis](output/figures/page%203.jpg)

**Page 4: Trends & Growth Rates**
![Trend Analysis](output/figures/page%204.jpg)

### Visualizations Included

- **KPI Cards:** Total Sales, Total Profit, Order Count, Average Discount
- **Regional Breakdown:** Sales and profit by region with map visualization
- **Category Analysis:** Profit margin by sub-category, treemap of sales distribution
- **Trend Analysis:** Monthly revenue trends, year-over-year comparison
- **Slicers:** Filter by Region and Year for dynamic analysis

---

## Key Findings

### 1. **Regional Profitability Mismatch**
The West region generates the highest sales ($725K+) but has lower profit margins compared to other regions. This suggests excessive discounting is eroding margins in the largest revenue-generating region. Central region achieves better margin efficiency despite lower sales volume.

### 2. **Negative Profit Sub-Categories**
Two critical problem areas identified:
- **Tables:** Negative profit margins due to deep discounting strategy
- **Bookcases:** Similarly unprofitable despite reasonable sales volumes
- **Recommendation:** Review pricing strategy or consider discontinuation

### 3. **Technology Category Performance**
Technology consistently shows the strongest profit margins with minimal discounting pressure. Sub-categories like Phones and Copiers are profit powerhouses, suggesting customers are less price-sensitive for technology products.

### 4. **Seasonal Revenue Peaks**
Q4 consistently outperforms other quarters:
- November and December account for ~32% of annual revenue
- Strong holiday season demand drives consistent YoY growth
- Opportunity for strategic inventory and staffing planning

### 5. **Customer Segment Insights**
- **Consumer segment** drives 51% of sales by volume
- **Corporate segment** generates higher average order values ($800+ vs $500)
- **Home Office segment** has smallest volume but worth targeted retention efforts

### 6. **Month-over-Month Growth Volatility**
Revenue shows seasonal patterns with Q4 peaks and Q1 troughs, suggesting potential for predictive modeling and demand forecasting

---

## How to Run

### Using the SQL Queries

1. **Set up PostgreSQL database**
   ```bash
   # Using PostgreSQL locally
   psql -U postgres -d your_database
   ```

2. **Create the superstore table**
   ```bash
   \i 'Create_table.sql'
   ```

3. **Load the data**
   - Import the Superstore CSV dataset to the `superstore` table
   - Ensure column names match the CREATE TABLE statement exactly

4. **Run any query**
   ```bash
   \i 'SQL queries/total_sales_profit_by_region.sql'
   \i 'SQL queries/Top 10 customers by revenue.sql'
   # ... and so on
   ```

### Alternative: AWS RDS or Cloud DB
- Use AWS RDS PostgreSQL for cloud-based setup
- Same SQL queries work without modification
- Ideal for sharing dashboards with team

### Power BI Dashboard Setup

1. Download and install **Power BI Desktop** (free): https://powerbi.microsoft.com/desktop

2. Open Power BI and connect to your database:
   - Get Data → PostgreSQL
   - Enter server details and database connection
   - Connect to the `superstore` table

3. Refresh data and interact with dashboards

4. **For sharing:** Export to Power BI Service for team collaboration

---

## Limitations & Future Work

### Current Limitations
- Dataset covers 2014–2017 period — may not reflect current retail trends
- Analysis is snapshot-based; no real-time data pipeline
- Limited to Superstore dataset without external market data
- Customer demographics not available for deeper segmentation

### Future Enhancements
- **Live Data Pipeline:** Connect Power BI directly to PostgreSQL for real-time updates
- **Predictive Analytics:** Add forecasting models for Q4 seasonality and demand planning
- **Advanced Segmentation:** RFM (Recency, Frequency, Monetary) analysis for customer clustering
- **Cohort Analysis:** Track customer lifetime value by acquisition period
- **Profit Optimization:** Linear programming models to optimize discount levels per category
- **Automated Alerts:** Dashboard alerts when profit margin or growth metrics fall below thresholds
- **Competitive Benchmarking:** Compare metrics against industry standards

---

## Technology Stack

| Component | Tool/Language | Purpose |
|-----------|---------------|---------|
| Database | PostgreSQL | Data storage & querying |
| SQL | PostgreSQL SQL | Complex analytical queries with window functions |
| Dashboard | Power BI Desktop | Data visualization & interactive analysis |
| Dataset | Superstore Sales (Kaggle) | 9,994 orders across 4 years |

---

## Author

**Sumant Jadiyappagoudar**
*Bioengineering Graduate | Data Analysis & SQL Specialist*

📧 [Email](mailto:sumantjadiyappagoudar@gmail.com) |
🔗 [LinkedIn](https://linkedin.com/in/sumantjadiyappagoudar) |
💻 [GitHub](https://github.com/sumantjadiyappagoudar)

---

*This is a portfolio project demonstrating SQL analytics, data visualization, and business intelligence capabilities.*

*Part of my data science portfolio.
Other projects: [HR Attrition analysis](https://github.com/Sumant40/hr-attrition-analysis.git) | [A/B Testing](#) | [Pharma Analytics](#) | [NLP Sentiment Analysis](#)*