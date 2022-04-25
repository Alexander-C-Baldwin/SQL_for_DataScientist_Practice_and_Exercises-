/* Chapter  10 Practice - Building SQL Datasets for Analytical Reporting */

/* Thinking Through Analytical Dataset Requirements */

select * from farmers_market.customer_purchases;

select market_date, vendor_id, 
round(sum(quantity * cost_to_customer_per_qty),2) as sale
from farmers_market.customer_purchases
group by market_date, vendor_id
order by market_date, vendor_id;

/* Using Custom Analytical Datasets in SQL: CTEs and Views */

SELECT cp.market_date, md.market_day, md.market_week,
md.market_year, cp.vendor_id, v.vendor_name, v.vendor_type,
ROUND(SUM(cp.quantity * cp.cost_to_customer_per_qty),2) AS sales
FROM farmers_market.customer_purchases AS cp
LEFT JOIN farmers_market.market_date_info AS md
ON cp.market_date = md.market_date
LEFT JOIN farmers_market.vendor AS v
ON cp.vendor_id = v.vendor_id
GROUP BY cp.market_date, cp.vendor_id
ORDER BY cp.market_date, cp.vendor_id;

WITH sales_by_day_vendor AS
(SELECT cp.market_date, md.market_day,
 md.market_week, md.market_year, cp.vendor_id, v.vendor_name, v.vendor_type,
 ROUND(SUM(cp.quantity * cp.cost_to_customer_per_qty),2) AS sales 
 FROM farmers_market.customer_purchases AS cp
 LEFT JOIN farmers_market.market_date_info AS md
 ON cp.market_date = md.market_date
 LEFT JOIN farmers_market.vendor AS v
 ON cp.vendor_id = v.vendor_id
 GROUP BY cp.market_date, cp.vendor_id   
 ORDER BY cp.market_date, cp.vendor_id)

SELECT s.market_year, s.market_week, SUM(s.sales) AS weekly_sales
FROM sales_by_day_vendor AS s
GROUP BY s.market_year, s.market_week;


CREATE VIEW farmers_market.vw_sales_by_day_vendor AS
SELECT cp.market_date, md.market_day,
 md.market_week, md.market_year, cp.vendor_id, v.vendor_name, v.vendor_type,
 ROUND(SUM(cp.quantity * cp.cost_to_customer_per_qty),2) AS sales 
 FROM farmers_market.customer_purchases AS cp
 LEFT JOIN farmers_market.market_date_info AS md
 ON cp.market_date = md.market_date
 LEFT JOIN farmers_market.vendor AS v
 ON cp.vendor_id = v.vendor_id
 GROUP BY cp.market_date, cp.vendor_id   
 ORDER BY cp.market_date, cp.vendor_id;
 
SELECT * FROM farmers_market.vw_sales_by_day_vendor AS s
WHERE s.market_date BETWEEN '2020-04-01' AND '2020-04-30'
AND s.vendor_id = 7
ORDER BY market_date;

/* Taking SQL Reporting Further*/

CREATE VIEW farmers_market.vw_sales_per_date_vendor_product AS
SELECT vi.market_date, vi.vendor_id, v.vendor_name, vi.product_id, 
p.product_name, vi.quantity AS quantity_available, sales.quantity_sold,
ROUND((sales.quantity_sold / vi.quantity) * 100, 2) AS percent_of_available_sold,
vi.original_price, 
(vi.original_price * sales.quantity_sold) - sales.total_sales AS discount_amount,
sales.total_sales
FROM farmers_market.vendor_inventory AS vi
LEFT JOIN
(SELECT market_date, vendor_id, product_id, SUM(quantity) quantity_sold, 
SUM(quantity * cost_to_customer_per_qty) AS total_sales
FROM farmers_market.customer_purchases
GROUP BY market_date, vendor_id, product_id) AS sales
ON vi.market_date = sales.market_date 
AND vi.vendor_id = sales.vendor_id
AND vi.product_id = sales.product_id
LEFT JOIN farmers_market.vendor v 
ON vi.vendor_id = v.vendor_id
LEFT JOIN farmers_market.product p
ON vi.product_id = p.product_id
ORDER BY vi.vendor_id, vi.product_id, vi.market_date;

select s.market_date, s.vendor_id, s.vendor_name, s.product_id, s.product_name,
round(s.total_sales, 2) as vendor_product_sales_on_market_date,
round(sum(s.total_sales) over (partition by market_date, vendor_id), 2) 
	as vendor_total_sales_on_market_date,
round((s.total_sales / sum(s.total_sales) over (partition by market_date, vendor_id)) * 100, 1)
	as product_percent_of_vendor_sales
from farmers_market.vw_sales_per_date_vendor_product as s
order by market_date, vendor_id;

SELECT market_date, vendor_name, product_name, quantity_available, quantity_sold
FROM farmers_market.vw_sales_per_date_vendor_product AS s
WHERE market_date BETWEEN '2020-06-01' AND '2020-07-31'
AND vendor_name = 'Marco''s Peppers'
AND product_id IN (2, 4)
ORDER BY market_date, product_id;







