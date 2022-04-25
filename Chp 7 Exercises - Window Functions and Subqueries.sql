/** Chapter 7 Exercises - Window Functions and Subqueries **/

/*Do the following two steps:

Q1a. Write a query that selects from the customer_purchases table and numbers each customer's visits to the farmer’s market 
(labeling each market date with a different number). Each customer's first visit is labeled 1, second visit is labeled 2, etc. 
(We are of course not counting visits where no purchases are made, because we have no record of those.) You can either display all rows in the 
customer_purchases table, with the counter changing on each new market date for each 
customer, or select only the unique market dates per customer (without purchase details) and number those visits. 
HINT: One of these approaches uses ROW_NUMBER() and one uses DENSE_RANK() */

Select market_date, customer_id,
dense_rank() over (partition by market_date order by customer_id) as customer_visits
from farmers_market.customer_purchases;

Select market_date, customer_id,
dense_rank() over (partition by customer_id order by market_date) as customer_visits
from farmers_market.customer_purchases;

select cp.market_date, cp.customer_id,
DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY market_date) AS visit_number
FROM farmers_market.customer_purchases AS cp
ORDER BY customer_id, market_date;

select customer_id, market_date, 
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date) AS visit_number
FROM farmers_market.customer_purchases
GROUP BY customer_id, market_date
ORDER BY customer_id, market_date;

SELECT * FROM
(select customer_id, market_date, 
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date DESC) AS visit_number
FROM farmers_market.customer_purchases
GROUP BY customer_id, market_date
ORDER BY customer_id, market_date) x
where x.visit_number = 1;

/* Q1b. Reverse the numbering of the query from a part so each customer's most recent visit is labeled 1, 
then write another query that uses this one as a subquery and filters the results to only the customer's
 most recent visit. */
 
select customer_id, market_date, 
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date DESC) AS visit_number
FROM farmers_market.customer_purchases
GROUP BY customer_id, market_date
ORDER BY customer_id, market_date;

SELECT * FROM
(select customer_id, market_date, 
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date DESC) AS visit_number
FROM farmers_market.customer_purchases
GROUP BY customer_id, market_date
ORDER BY customer_id, market_date) x
where x.visit_number = 1;

select cp.*,
DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY market_date DESC) AS visit_number
FROM farmers_market.customer_purchases AS cp
ORDER BY customer_id, market_date;



/* Q2. Using a COUNT()window function, include a value along with each row of the 
customer_purchases table that indicates how many different times that customer has purchased that product_id*/


select product_id, customer_id,
count(product_id) over (partition by customer_id, product_id) as times_bought
from farmers_market.customer_purchases;

select distinct(product_id), customer_id,
count(customer_id) over (partition by product_id order by customer_id) as times_bought
from farmers_market.customer_purchases;

select cp.*,
COUNT(product_id) OVER (PARTITION BY customer_id, product_id) AS product_purchase_count
FROM farmers_market.customer_purchases AS cp
ORDER BY customer_id, product_id, market_date;

/** Q3. In the last query associated with Figure 7.14 from the chapter, we used LAG and sorted by 
market_date. Can you think of a way to use LEAD in place of LAG, but get the exact same output? **/

SELECT market_date, 
SUM(quantity * cost_to_customer_per_qty) AS market_date_total_sales,
Lead(SUM(quantity * cost_to_customer_per_qty), 1) OVER (ORDER BY market_date desc) AS previous_market_date_total_sales
FROM farmers_market.customer_purchases
GROUP BY market_date
ORDER BY market_date;


