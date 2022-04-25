/* Chapter 8 Exercises - Date and Time Functions */


/* Q1. Get the customer_id, month, and year (in separate columns) of every purchase in the 
farmers_market.customer_purchases table. */

SELECT customer_id, 
EXTRACT(MONTH FROM market_date) as Month,
EXTRACT(YEAR FROM market_date) as Year
FROM farmers_market.customer_purchases;


/* Q2. Write a query that filters to purchases made in the past two weeks, returns the earliest 
market_date in that range as a field called sales_since_date, and a sum of the sales 
(quantity * cost_to_customer_per_qty) during that date range. Your final answer should use the CURDATE() function, 
but if you want to test it out on the Farmer's Market database, you can replace your CURDATE() with the value ‘2019-03-31’
to get the report for the two weeks prior to March 31, 2019 
(otherwise your query will not return any data, because none of the dates in the database will have occurred within two weeks of you writing the query). */

SELECT MIN(market_date) AS sales_since_date, 
SUM(quantity * cost_to_customer_per_qty) AS total_sales
FROM farmers_market.customer_purchases
WHERE DATEDIFF('2019-03-31', market_date) <= 14;


/* Q3. In MySQL, there is a DAYNAME() function that returns the full name of the day of the week on which a date occurs. 
Query the Farmer's Market database market_date_info table, return the market_date, the market_day,
and your calculated day of the week name that each market_date occurred on. Create a calculated column using a 
CASE statement that indicates whether the recorded day in the database differs from your calculated day of the week. 
This is an example of a quality control query that could be used to check manually entered data for correctness. */

SELECT market_date, market_day, 
DAYNAME(market_date) AS calculated_market_day,
CASE WHEN market_day <> DAYNAME(market_date) then "INCORRECT"
ELSE "CORRECT" END AS entered_correctly
FROM farmers_market.market_date_info;








