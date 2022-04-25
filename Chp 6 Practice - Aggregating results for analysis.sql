/** Chapter 6 Practice - Aggregating Results for Analysis **/

/* GROUP BY syntax */

select market_date, customer_id
from farmers_market.customer_purchases
order by market_date, customer_id;

select market_date, customer_id
from farmers_market.customer_purchases
group by market_date, customer_id
order by market_date, customer_id;

/* Displaying Group Summaries */

select market_date, customer_id, count(*) as items_purchased
from farmers_market.customer_purchases
group by market_date, customer_id
order by market_date, customer_id
LIMIT 10;


select market_date, customer_id, sum(quantity) as items_purchased
from farmers_market.customer_purchases
group by market_date, customer_id
order by market_date, customer_id
LIMIT 10;


select market_date, customer_id, count(distinct product_ID) as diff_products_purchased
from farmers_market.customer_purchases
group by market_date, customer_id
order by market_date, customer_id
limit 10;


select market_date, customer_id, count(distinct product_ID) as diff_products_purchased,
sum(quantity) as items_purchased
from farmers_market.customer_purchases
group by market_date, customer_id
order by market_date, customer_id
limit 10;

/* Performing Calculations Inside Aggregate Functions */

SELECT market_date, customer_id, vendor_id, quantity * cost_to_customer_per_qty AS price
FROM farmers_market.customer_purchases
WHERE customer_id = 3
ORDER BY market_date, vendor_id;


SELECT customer_id, market_date, SUM(quantity * cost_to_customer_per_qty) AS total_spent
FROM farmers_market.customer_purchases
WHERE customer_id = 3
GROUP BY market_date
ORDER BY market_date;


SELECT customer_id, vendor_id, SUM(quantity * cost_to_customer_per_qty) AS total_spent
FROM farmers_market.customer_purchases
WHERE customer_id = 3
GROUP BY customer_id, vendor_id
ORDER BY customer_id, vendor_id;


SELECT customer_id, SUM(quantity * cost_to_customer_per_qty) AS total_spent
FROM farmers_market.customer_purchases
GROUP BY customer_id
ORDER BY customer_id;

/* With JOINED tables */

SELECT c.customer_first_name, c.customer_last_name, cp.customer_id,
v.vendor_name, cp.vendor_id, round(sum(cp.quantity * cp.cost_to_customer_per_qty), 2) AS total_spent
FROM farmers_market.customer c
LEFT JOIN farmers_market.customer_purchases cp
ON c.customer_id = cp.customer_id
LEFT JOIN farmers_market.vendor v
ON cp.vendor_id = v.vendor_id
WHERE cp.customer_id = 3
group by c.customer_first_name, c.customer_last_name, cp.customer_id, v.vendor_id
ORDER BY cp.customer_id, cp.vendor_id;


SELECT c.customer_first_name, c.customer_last_name, cp.customer_id,
v.vendor_name, cp.vendor_id, round(sum(cp.quantity * cp.cost_to_customer_per_qty), 2) AS total_spent
FROM farmers_market.customer c
LEFT JOIN farmers_market.customer_purchases cp
ON c.customer_id = cp.customer_id
LEFT JOIN farmers_market.vendor v
ON cp.vendor_id = v.vendor_id
WHERE cp.vendor_id = 8
group by c.customer_first_name, c.customer_last_name, cp.customer_id, v.vendor_id
ORDER BY cp.customer_id, cp.vendor_id;


/* COUNT and COUNT DISTINCT */

SELECT market_date, COUNT(product_id) AS product_count
FROM farmers_market.vendor_inventory
GROUP BY market_date
ORDER BY market_date;

SELECT vendor_id, COUNT(DISTINCT product_id) AS different_products_offered
FROM farmers_market.vendor_inventory
GROUP BY vendor_id
ORDER BY vendor_id;

SELECT vendor_id, COUNT(DISTINCT product_id) AS different_products_offered
FROM farmers_market.vendor_inventory
WHERE market_date BETWEEN '2019-03-02' AND '2019-03-16'
GROUP BY vendor_id
ORDER BY vendor_id;


/* Average */

SELECT vendor_id, 
COUNT(DISTINCT product_id) AS different_products_offered,
AVG(original_price) AS average_product_price
FROM farmers_market.vendor_inventory
WHERE market_date BETWEEN '2019-03-02' AND '2019-03-16'
GROUP BY vendor_id
ORDER BY vendor_id;


SELECT vendor_id, 
COUNT(DISTINCT product_id) AS different_products_offered,
SUM(quantity * original_price) AS value_of_inventory,
SUM(quantity) AS inventory_item_count,
ROUND(SUM(quantity * original_price) / SUM(quantity), 2) AS average_item_price
FROM farmers_market.vendor_inventory
WHERE market_date BETWEEN '2019-03-02' AND '2019-03-16'
GROUP BY vendor_id
ORDER BY vendor_id;

/* MIN and MAX */

SELECT MIN(original_price) AS minimum_price, MAX(original_price) AS maximum_price
FROM farmers_market.vendor_inventory
ORDER BY original_price;

SELECT pc.product_category_name, p.product_category_id,
MIN(vi.original_price) AS minimum_price,
MAX(vi.original_price) AS maximum_price
FROM farmers_market.vendor_inventory AS vi
INNER JOIN farmers_market.product AS p
ON vi.product_id = p.product_id
INNER JOIN farmers_market.product_category AS pc
ON p.product_category_id = pc.product_category_id
GROUP BY pc.product_category_name, p.product_category_id;


/* Filtering with HAVING */

SELECT vendor_id, 
COUNT(DISTINCT product_id) AS different_products_offered,
SUM(quantity * original_price) AS value_of_inventory,
SUM(quantity) AS inventory_item_count,
ROUND(SUM(quantity * original_price) / SUM(quantity), 2) AS average_item_price
FROM farmers_market.vendor_inventory
GROUP BY vendor_id
HAVING inventory_item_count>= 5500
ORDER BY vendor_id;


/* CASE Statements Inside Aggregate Functions */ 

SELECT cp.market_date, cp.vendor_id, cp.customer_id, cp.product_id,
cp.quantity, p.product_name, p.product_size, p.product_qty_type
FROM farmers_market.customer_purchases AS cp
INNER JOIN farmers_market.product AS p
ON cp.product_id = p.product_id;


SELECT cp.market_date, cp.vendor_id, cp.customer_id, cp.product_id,
CASE WHEN product_qty_type = "unit" THEN quantity ELSE 0 END AS quantity_units,
CASE WHEN product_qty_type = "lbs" THEN quantity ELSE 0 END AS quantity_lbs,
CASE WHEN product_qty_type NOT IN ("unit","lbs") THEN quantity ELSE 0 END 
AS quantity_other, p.product_qty_type
FROM farmers_market.customer_purchases cp
INNER JOIN farmers_market.product p
ON cp.product_id = p.product_id;


SELECT    cp.market_date, cp.customer_id,
SUM(CASE WHEN product_qty_type = "unit" THEN quantity ELSE 0 END) AS qty_units_purchased,
SUM(CASE WHEN product_qty_type = "lbs" THEN quantity ELSE 0 END) AS qty_lbs_purchased,
SUM(CASE WHEN product_qty_type NOT IN ("unit","lbs") THEN quantity ELSE 0 END) AS qty_other_purchased
FROM farmers_market.customer_purchases cp
INNER JOIN farmers_market.product p
ON cp.product_id = p.product_id
GROUP BY market_date, customer_id
ORDER BY market_date, customer_id;























