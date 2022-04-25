/** Chapter 6 Exercises - Aggregating Results for Analysis **/




/** Q1. Write a query that determines how many times each vendor has rented a booth 
at the farmer’s market. In other words, count the vendor booth assignments per 
--vendor_id */

select vendor_id, count(booth_number) as assingments
FROM farmers_market.vendor_booth_assignments
group by vendor_id;

SELECT vendor_id, count(*) AS count_of_booth_assignments
FROM farmers_market.vendor_booth_assignments
GROUP BY vendor_id;


/* Q2. Write a query that displays the product category name, 
product name, earliest date available, and latest date available for every product
 in the “Fresh Fruits & Vegetables” product category. */
 
select pc.product_category_name, p.product_name, 
min(v.market_date) as 'earliest date available',
max(v.market_date) as 'latest date available'
from farmers_market.vendor_inventory as v
inner join farmers_market.product as p
on v.product_id = p.product_id
inner join product_category as pc
on p.product_category_id = pc.product_category_id
where pc.product_category_name = "Fresh Fruits & Vegetables";

/* Q3. The Farmer's Market Customer Appreciation Committee wants to give a bumper sticker 
to everyone who has ever spent more than $50 at the market. 
Write a query that generates a list of customers for them to give stickers to, s
orted by last name, then first name. 
(HINT: This query requires you to join two tables, use an aggregate function, and use the 
HAVING keyword.) */

select concat(c.customer_first_name, " ", c.customer_last_name) as customer,
round(sum(quantity * cost_to_customer_per_qty), 2) as customer_spend
from farmers_market.customer as c
join farmers_market.customer_purchases as cp
on c.customer_id = cp.customer_id
group by cp.customer_id
having customer_spend > 50
order by c.customer_last_name, customer_first_name;










