/* Chapter 9 Practice - Exploratory Data Analysis with SQL */

/* Exploring the Products Table */

select * from farmers_market.product
limit 10;

select product_id, count(*)
from farmers_market.product
group by product_id
having count(*)>1;

select * from farmers_market.product_category;

select count(*) from farmers_market.product;

select pc.product_category_id, pc.product_category_name, count(product_id) as count_of_products
from farmers_market.product_category as pc
left join farmers_market.product as p
on pc.product_category_id = p.product_category_id
group by pc.product_category_id;

/* Exploring Possible Column Values */

SELECT DISTINCT product_qty_type
FROM farmers_market.product;

SELECT * FROM farmers_market.vendor_inventory
LIMIT 10;

select market_date, vendor_id, product_id, count(*)
from farmers_market.vendor_inventory
group by market_date, vendor_id, product_id
having count(*)>1;

select min(market_date), max(market_date)
from farmers_market.vendor_inventory;

select vendor_id, min(market_date), max(market_date)
from farmers_market.vendor_inventory
group by vendor_id
order by min(market_date), max(market_date);

/* Exploring Changes Over Time */

select
extract(year from market_date) as market_year,
extract(month from market_date) as market_month,
count(distinct vendor_id) as vendor_with_inventory
from farmers_market.vendor_inventory
group by extract(year from market_date), extract(month from market_date)
order by extract(year from market_date), extract(month from market_date);

select * from farmers_market.vendor_inventory
where vendor_id = 7
order by market_date, product_id;

/* Exploring Multiple Tables Simultaneously */

select * from farmers_market.customer_purchases
limit 10;

select * from farmers_market.customer_purchases
where vendor_id = 7 and product_id = 4
order by market_date, transaction_time;

SELECT * FROM farmers_market.customer_purchases
WHERE vendor_id = 7 AND product_id = 4 AND customer_id = 12
ORDER BY customer_id, market_date, transaction_time;

select market_date, vendor_id, product_id, sum(quantity) as quantity_sold,
sum(quantity * cost_to_customer_per_qty) as total_sales
from farmers_market.customer_purchases
where vendor_id = 7 and product_id = 4
group by market_date, vendor_id, product_id
order by market_date, vendor_id, product_id;

/* Exploring Inventory vs. Sales */

select * from farmers_market.vendor_inventory as vi
left join
( select market_date, vendor_id, product_id, sum(quantity) as quantity_sold,
sum(quantity * cost_to_customer_per_qty) as total_sales
from farmers_market.customer_purchases
group by market_date, vendor_id, product_id) as sales
on vi.market_date = sales.market_date
and vi.vendor_id = sales.vendor_id
and vi.product_id = sales.product_id
order by vi.market_date, vi.vendor_id, vi.product_id
limit 10;

SELECT vi.market_date, vi.vendor_id, v.vendor_name, vi.product_id, p.product_name,
vi.quantity AS quantity_available, sales.quantity_sold, vi.original_price, sales.total_sales
FROM farmers_market.vendor_inventory AS vi
LEFT JOIN
(SELECT market_date, vendor_id, product_id, SUM(quantity) AS quantity_sold, 
SUM(quantity * cost_to_customer_per_qty) AS total_sales
FROM farmers_market.customer_purchases
GROUP BY market_date, vendor_id, product_id) AS sales
ON vi.market_date = sales.market_date 
AND vi.vendor_id = sales.vendor_id AND vi.product_id = sales.product_id
LEFT JOIN farmers_market.vendor v 
ON vi.vendor_id = v.vendor_id
LEFT JOIN farmers_market.product p
ON vi.product_id = p.product_id
WHERE vi.vendor_id = 7 
AND vi.product_id = 4
ORDER BY vi.market_date, vi.vendor_id, vi.product_id;
















































