/* Chapter 11 Practice - More Advanced Query Structure */

/* UNIONs */

SELECT market_year, MIN(market_date) AS first_market_date
FROM farmers_market.market_date_info
WHERE market_year = '2019'
 
UNION
 
SELECT market_year, MIN(market_date) AS first_market_date
FROM farmers_market.market_date_info
WHERE market_year = '2020';

WITH product_quantity_by_date AS
(SELECT vi.market_date, vi.product_id, p.product_name,
SUM(vi.quantity) AS total_quantity_available,
p.product_qty_type
FROM farmers_market.vendor_inventory vi 
LEFT JOIN farmers_market.product p
ON vi.product_id = p.product_id
GROUP BY market_date, product_id) 
 
SELECT * FROM

(SELECT market_date, product_id, product_name, total_quantity_available, product_qty_type,
RANK() OVER (PARTITION BY market_date ORDER BY total_quantity_available DESC) AS quantity_rank
FROM product_quantity_by_date
WHERE product_qty_type = 'unit'

UNION

SELECT market_date, product_id, product_name, total_quantity_available, product_qty_type,
RANK() OVER (PARTITION BY market_date ORDER BY total_quantity_available DESC) AS quantity_rank
FROM product_quantity_by_date
WHERE product_qty_type = 'lbs') x
WHERE x.quantity_rank = 1
ORDER BY market_date;

WITH product_quantity_by_date AS
(SELECT vi.market_date, vi.product_id, p.product_name,       
SUM(vi.quantity) AS total_quantity_available, p.product_qty_type
FROM farmers_market.vendor_inventory vi
LEFT JOIN farmers_market.product p
ON vi.product_id = p.product_id
GROUP BY market_date, product_id),

rank_by_qty_type AS
(SELECT market_date, product_id, product_name, total_quantity_available, product_qty_type,
RANK() OVER (PARTITION BY market_date, product_qty_type ORDER BY total_quantity_available DESC) AS quantity_rank
FROM product_quantity_by_date)
 
SELECT * FROM rank_by_qty_type
WHERE quantity_rank = 1
ORDER BY market_date;

/* Self-Join to Determine To-Date Maximum */

WITH  sales_per_market_date AS
(SELECT market_date, 
ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS sales
FROM farmers_market.customer_purchases
GROUP BY market_date
ORDER BY market_date)
SELECT * 
FROM sales_per_market_date
LIMIT 10;


WITH sales_per_market_date AS
(SELECT market_date, 
ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS sales
FROM farmers_market.customer_purchases
GROUP BY market_date   
ORDER BY market_date)

SELECT * 
FROM sales_per_market_date AS cm
LEFT JOIN sales_per_market_date AS pm
ON pm.market_date < cm.market_date
WHERE cm.market_date = '2019-04-13';

WITH sales_per_market_date AS
(SELECT market_date, 
ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS sales
FROM farmers_market.customer_purchases
GROUP BY market_date
ORDER BY market_date)
   
SELECT cm.market_date, cm.sales,
MAX(pm.sales) AS previous_max_sales
FROM sales_per_market_date AS cm
LEFT JOIN sales_per_market_date AS pm
ON pm.market_date < cm.market_date
WHERE cm.market_date = '2019-04-13'
GROUP BY cm.market_date, cm.sales;

WITH sales_per_market_date AS
(SELECT market_date, 
ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS sales
FROM farmers_market.customer_purchases
GROUP BY market_date
ORDER BY market_date)

SELECT cm.market_date, cm.sales,
MAX(pm.sales) AS previous_max_sales,
CASE WHEN cm.sales> MAX(pm.sales) THEN "YES"
ELSE "NO" END sales_record_set
FROM sales_per_market_date AS cm
LEFT JOIN sales_per_market_date AS pm
ON pm.market_date < cm.market_date
GROUP BY cm.market_date, cm.sales;

/* Counting New vs. Returning Customers by Week */

SELECT DISTINCT customer_id, market_date,
MIN(market_date) OVER(PARTITION BY cp.customer_id) AS first_purchase_date
FROM farmers_market.customer_purchases cp;


WITH customer_markets_attended AS
(SELECT DISTINCT customer_id, market_date,
MIN(market_date) OVER(PARTITION BY cp.customer_id) AS first_purchase_date
FROM farmers_market.customer_purchases cp)

SELECT md.market_year, md.market_week,
COUNT(customer_id) AS customer_visit_count,
COUNT(DISTINCT customer_id) AS distinct_customer_count
FROM customer_markets_attended AS cma
LEFT JOIN farmers_market.market_date_info AS md
ON cma.market_date = md.market_date
GROUP BY md.market_year, md.market_week
ORDER BY md.market_year, md.market_week;

WITH customer_markets_attended AS
(SELECT DISTINCT customer_id, market_date,
MIN(market_date) OVER(PARTITION BY cp.customer_id) AS first_purchase_date
FROM farmers_market.customer_purchases cp)

SELECT md.market_year, md.market_week,
COUNT(customer_id) AS customer_visit_count,
COUNT(DISTINCT customer_id) AS distinct_customer_count,
COUNT(DISTINCT CASE WHEN cma.market_date = cma.first_purchase_date 
THEN customer_id 
ELSE NULL END)AS new_customer_count,
COUNT(DISTINCT CASE WHEN cma.market_date = cma.first_purchase_date 
THEN customer_id 
ELSE NULL END) / COUNT(DISTINCT customer_id)AS new_customer_percent
FROM customer_markets_attended AS cma
LEFT JOIN farmers_market.market_date_info AS md
ON cma.market_date = md.market_date
GROUP BY md.market_year, md.market_week
ORDER BY md.market_year, md.market_week;

/** Chap 11 Q1. Starting with the query associated with Figure 11.5, put the larger 
SELECT statement in a second CTE, and write a query that queries from its results 
to display the current record sales and associated market date. 
Can you think of another way to generate the same results? **\



/** Q2 Modify the “New vs. Returning Customers Per Week” report (associated with Figure 11.8)
 to summarize the counts by vendor by week. **\


/** Q3 Using a UNION, write a query that displays the market dates with the highest and lowest total sales. **\






