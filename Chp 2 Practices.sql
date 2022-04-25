/** Chapter 2 - The SELECT statement and simple inline calculation **/

select quantity * cost_to_customer_per_qty as price
from farmers_market.customer_purchases;

/** Order by, Rounding, & Concatenating**/ 

select round(quantity * cost_to_customer_per_qty, 2) as price
from farmers_market.customer_purchases;

select customer_id, concat(customer_first_name, " ", customer_last_name) as customer_name
from farmers_market.customer
limit 10;

select customer_id, concat(customer_first_name, " ", customer_last_name) as customer_name
from farmers_market.customer
order by customer_last_name, customer_first_name
limit 10;

select customer_id, upper(concat(customer_last_name, ", ", customer_first_name)) as customer_name
from farmers_market.customer
order by customer_last_name, customer_first_name
limit 10;

SELECT market_date, customer_id, vendor_id, 
    ROUND(quantity * cost_to_customer_per_qty, 2) AS price 
FROM farmers_market.customer_purchases;


