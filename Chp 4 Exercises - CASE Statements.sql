/* Chapter 4 Exercises - CASE Statements */

/** Q1. 
Products can be sold by the individual unit or by bulk measures like lbs. or oz. Write a query that outputs the 
product_id and product_name columns from the product table, and add a column called 
prod_qty_type_condensed that displays the word “unit” if the 
product_qty_type is “unit,” and otherwise displays the word “bulk.” **/

select product_id, product_name,
 Case when product_qty_type = 'unit' then 'unit'
 else 'bulk' end as product_qty_type_condensed
from farmers_market.product;

/** Q2. We want to flag all of the different types of pepper products that are sold at the market. Add a column to the previous query called 
pepper_flag that outputs a 1 if the product_name
contains the word “pepper” (regardless of capitalization), and otherwise outputs 0. **/

select product_id, product_name,
 Case when product_qty_type = 'unit' then 'unit'
 else 'bulk' end as product_qty_type_condensed,
 case when lower(product_name) like '%pepper%' then 1 else 0
 end as pepper_flag
 from farmers_market.product;
 
 /** Q3. Can you think of a situation when a pepper product might not get flagged 
 as a pepper product using the code from the previous exercise? **/
 /** A3. When the spelling is incorrect or doesnt include 'pepper' **/