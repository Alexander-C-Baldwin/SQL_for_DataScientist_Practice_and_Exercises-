/** Q1. Write a query that returns everything in the customer table. **/

select * from farmers_market.customer;

/** Q2 Write a query that displays all of the columns and 10 rows from the customer table, 
sorted by customer_last_name, then customer_first_name. **/

select *
from farmers_market.customer
order by customer_last_name, customer_first_name
limit 10;

/** Q3 Write a query that lists all customer IDs and first names in the customer table, sorted by first_name. **/

select customer_id, customer_first_name
from farmers_market.customer
order by customer_first_name;
