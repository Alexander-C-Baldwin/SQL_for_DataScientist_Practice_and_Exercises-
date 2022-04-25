/** Chapter 7 Practice - Window Functions and Subqueries **/

SELECT vendor_id, 
MAX(original_price) AS highest_price
FROM farmers_market.vendor_inventory
GROUP BY vendor_id
ORDER BY vendor_id;

/** Row Number **/

SELECT vendor_id, market_date, product_id, original_price,
ROW_NUMBER() OVER (PARTITION BY vendor_id ORDER BY original_price DESC) AS price_rank
FROM farmers_market.vendor_inventory ORDER BY vendor_id, original_price DESC;

/** Row number w Simple Subquery **/

SELECT * FROM
(SELECT vendor_id, market_date, product_id, original_price,
ROW_NUMBER() OVER (PARTITION BY vendor_id ORDER BY original_price DESC) AS price_rank
FROM farmers_market.vendor_inventory 
ORDER BY vendor_id) x
WHERE x.price_rank = 1;

/** RANK and DENSE RANK **/

SELECT vendor_id, market_date, product_id, original_price,
RANK() OVER (PARTITION BY vendor_id ORDER BY original_price DESC) AS price_rank
FROM farmers_market.vendor_inventory
ORDER BY vendor_id, original_price DESC;

/** NTILE **/

SELECT vendor_id, market_date,product_id, original_price,
NTILE(10) OVER (ORDER BY original_price DESC) AS price_ntile
FROM farmers_market.vendor_inventory
ORDER BY original_price DESC;

/** Aggregate Window Functions **/

SELECT vendor_id, market_date, product_id, original_price,
AVG(original_price) OVER (PARTITION BY market_date ORDER BY market_date) 
AS average_cost_product_by_market_date
FROM farmers_market.vendor_inventory;

SELECT * FROM
(SELECT vendor_id, market_date, product_id, original_price,
ROUND(AVG(original_price) OVER (PARTITION BY market_date ORDER BY market_date), 2) 
AS average_cost_product_by_market_date
FROM farmers_market.vendor_inventory) x
WHERE x.vendor_id = 8 
AND x.original_price > x.average_cost_product_by_market_date
ORDER BY x.market_date, x.original_price DESC;

SELECT vendor_id, market_date, product_id, original_price,
COUNT(product_id) OVER (PARTITION BY market_date, vendor_id) vendor_product_count_per_market_date
FROM farmers_market.vendor_inventory 
ORDER BY vendor_id, market_date, original_price DESC;

SELECT customer_id, market_date, vendor_id, product_id, 
quantity * cost_to_customer_per_qty AS price,
SUM(quantity * cost_to_customer_per_qty) OVER (ORDER BY market_date, transaction_time, customer_id, product_id) AS running_total_purchases
FROM farmers_market.customer_purchases;

SELECT customer_id, market_date, vendor_id, product_id, 
quantity * cost_to_customer_per_qty AS price,
SUM(quantity * cost_to_customer_per_qty) OVER (PARTITION BY customer_id ORDER BY market_date, transaction_time, product_id) AS customer_spend_running_total
FROM farmers_market.customer_purchases;

/** Lag and Lead **/

SELECT market_date, vendor_id, booth_number,
LAG(booth_number,1) OVER (PARTITION BY vendor_id ORDER BY market_date, vendor_id) AS previous_booth_number
FROM farmers_market.vendor_booth_assignments
ORDER BY market_date, vendor_id, booth_number;

SELECT * FROM
(SELECT market_date, vendor_id, booth_number,
LAG(booth_number,1) OVER (PARTITION BY vendor_id ORDER BY market_date, vendor_id) AS previous_booth_number
FROM farmers_market.vendor_booth_assignments
ORDER BY market_date, vendor_id, booth_number) x
WHERE x.market_date = '2019-04-10'
AND (x.booth_number <> x.previous_booth_number OR x.previous_booth_number IS NULL);








