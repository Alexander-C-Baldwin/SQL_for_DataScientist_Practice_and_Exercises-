/** Chapter 3 Exercises. The WHERE Clause and Subqueries **/

/** Q1. Refer to the data in Table 3.1. Write a query that returns all customer purchases of product IDs 4 and 9 **/

SELECT *
FROM farmers_market.customer_purchases
WHERE product_id = 4 or product_id = 9;

/** Q2. Refer to the data in Table 3.1. Write two queries, one using two conditions with an AND operator, 
and one using the BETWEEN operator, that will return all customer purchases made from vendors
 with vendor IDs between 8 and 10 (inclusive). **/
SELECT *
FROM farmers_market.customer_purchases 
WHERE vendor_id>= 8 AND vendor_id <= 10;
 
SELECT *
FROM farmers_market.customer_purchases
WHERE vendor_id between 8 AND 10;


/** Q3. Can you think of two different ways to change the final query in the chapter so it would return purchases
 from days when it wasn't raining? **/

SELECT market_date, customer_id, vendor_id, round(quantity * cost_to_customer_per_qty, 2) price
FROM farmers_market.customer_purchases
WHERE market_date IN
(SELECT market_date
FROM farmers_market.market_date_info
WHERE market_rain_flag = 1)
LIMIT 5;










