/* Chapter 9 Exercises - Exploratory Data Analysis */

/* Q1. In the chapter, it was suggested that we should see if the 
customer_purchases data was collected for the same time frame as the 
vendor_inventory table. Write a query that gets the earliest and latest dates in the 
customer_purchases table. */
 
select min(market_date), max(market_date)
from farmers_market.customer_purchases;

/* Q2. There is a MySQL function DAYNAME()that returns the name of the day of the week for a date. Using the DAYNAME
 and EXTRACT functions on the customer_purchases table, select and group by the weekday and hour of the day, 
 and count the distinct number of customers during each hour of the Wednesday and Saturday markets. 
 See Chapters 6, “Aggregating Results for Analysis,” and 8, “Date and Time Functions,” for information on the 
COUNT DISTINCT and EXTRACT functions.*/

Select market_date, count(Distinct customer_id) as number_of_customers,
dayname(market_date) as Name_of_day,
extract(hour from transaction_time) as Hour_of_day
from farmers_market.customer_purchases
group by market_date, dayname(market_date), extract(hour from transaction_time)
order by market_date, extract(hour from transaction_time);

SELECT DAYNAME(market_date), 
EXTRACT(HOUR FROM transaction_time), 
COUNT(DISTINCT customer_id)
FROM farmers_market.customer_purchases
GROUP BY DAYNAME(market_date), EXTRACT(HOUR FROM transaction_time)
ORDER BY DAYNAME(market_date), EXTRACT(HOUR FROM transaction_time);


/* Q3. What other questions haven't we yet asked about the data in these tables that you would be curious about? 
Write two more queries further exploring or summarizing the data in the 
product, vendor_inventory, or customer_purchases tables. */

/* How many customers made purchases at each market? */
SELECT market_date, COUNT(DISTINCT customer_id)
FROM customer_purchases
GROUP BY market_date
ORDER BY market_date;

/* What is the total value of the inventory each vendor brought to each market? */

SELECT market_date, vendor_id,
ROUND(SUM(quantity * original_price),2) AS inventory_value 
FROM vendor_inventory
GROUP BY market_date, vendor_id
ORDER BY market_date, vendor_id;
