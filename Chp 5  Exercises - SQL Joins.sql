
/* Chapter 5 Exercises - SQL JOINS */


/* Q1. Write a query that INNER JOINs the vendor table to the vendor_booth_assignments
table on the vendor_id field they both have in common, and sorts the result by vendor_name,
 then market_date */

SELECT *
FROM vendor AS v 
INNER JOIN vendor_booth_assignments AS vba
ON v.vendor_id = vba.vendor_id
ORDER BY v.vendor_name, vba.market_date;

/* Q2. Is it possible to write a query that produces an output identical to the output of the following query, but using a 
LEFT JOIN instead of a RIGHT JOIN?

SELECT * 
FROM customer AS c
RIGHT JOIN customer_purchases AS cp
   
 ON c.customer_id = cp.customer_id */    

SELECT c.*, cp.* 
FROM customer_purchases AS cp
LEFT JOIN customer AS c
ON cp.customer_id = c.customer_id;


/* Q3. At the beginning of this chapter, the analytical question 
“When is each type of fresh fruit or vegetable in season, locally?” was asked, 
and it was explained that the answer requires data from the 
product_category table, the product table, and the vendor_inventory
table. What type of JOINs do you expect would be needed to combine these three tables in order
to be able to answer this question? */

INNER JOIN and LEFT JOIN


