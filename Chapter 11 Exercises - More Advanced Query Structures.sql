/** Chapter 11 Exercises **/

/** Chap 11 Q1. Starting with the query associated with Figure 11.5, put the larger 
SELECT statement in a second CTE, and write a query that queries from its results 
to display the current record sales and associated market date. 
Can you think of another way to generate the same results? **/

WITH sales_per_market_date AS
(SELECT market_date, 
ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS sales
FROM farmers_market.customer_purchases
GROUP BY market_date
ORDER BY market_date),
record_sales_per_market_date AS
(SELECT cm.market_date, cm.sales,
MAX(pm.sales) AS previous_max_sales,
CASE WHEN cm.sales> MAX(pm.sales) THEN "YES"
ELSE "NO" END sales_record_set
FROM sales_per_market_date AS cm
LEFT JOIN sales_per_market_date AS pm
ON pm.market_date < cm.market_date
GROUP BY cm.market_date, cm.sales)

SELECT market_date, sales
FROM record_sales_per_market_date
WHERE sales_record_set = 'YES'
ORDER BY market_date DESC
LIMIT 1

/** Q2 Modify the “New vs. Returning Customers Per Week” report (associated with Figure 11.8)
 to summarize the counts by vendor by week. **/

WITH customer_markets_vendors AS
(SELECT DISTINCT customer_id, vendor_id, market_date,
MIN(market_date) OVER (PARTITION BY cp.customer_id, cp.vendor_id) AS
first_purchase_from_vendor_date
FROM farmers_market.customer_purchases AS cp)

SELECT md.market_year, md.market_week, cmv.vendor_id,
COUNT(customer_id) AS customer_visit_count,
COUNT(DISTINCT customer_id) AS distinct_customer_count,
COUNT(DISTINCT CASE WHEN cmv.market_date = cmv.first_purchase_from_vendor_date
THEN customer_id ELSE NULL END)
/ COUNT(DISTINCT customer_id) AS new_customer_percent
FROM customer_markets_vendors AS cmv
LEFT JOIN farmers_market.market_date_info AS md
ON cmv.market_date = md.market_date
GROUP BY md.market_year, md.market_week, cmv.vendor_id
ORDER BY md.market_year, md.market_week, cmv.vendor_id;


/** Q3 Using a UNION, write a query that displays the market dates with the highest and lowest total sales. **/

WITH sales_per_market AS
(SELECT market_date, ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS sales
FROM farmers_market.customer_purchases
GROUP BY market_date),
market_dates_ranked_by_sales AS
(SELECT market_date, sales,
RANK() OVER (ORDER BY sales) AS sales_rank_asc,
RANK() OVER (ORDER BY sales DESC) AS sales_rank_desc
FROM sales_per_market)

SELECT market_date, sales, sales_rank_desc AS sales_rank
FROM market_dates_ranked_by_sales
WHERE sales_rank_asc = 1 

UNION

SELECT market_date, sales, sales_rank_desc AS sales_rank
FROM market_dates_ranked_by_sales
WHERE sales_rank_desc = 1;








