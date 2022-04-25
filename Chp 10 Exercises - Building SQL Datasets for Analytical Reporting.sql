/** Chapter 10 Exercises - Building SQL Datasets for Analytical Reporting **/


/** Q1. Using the view created in this chapter called farmers_market.vw_sales_by_day_vendor, 
referring to Figure 10.3 for a preview of the data in the dataset, write a query to build a 
report that summarizes the sales per vendor per market week.**/

SELECT market_week, vendor_id, vendor_name, 
SUM(sales) AS weekly_sales
FROM farmers_market.vw_sales_by_day_vendor AS s
GROUP BY market_week, vendor_id, vendor_name
ORDER BY market_date;

/** Q2. Rewrite the query associated with Figure 7.11 using a CTE (WITH clause). **/
WITH x AS
(SELECT market_date, vendor_id, booth_number,
LAG(booth_number,1) OVER (PARTITION BY vendor_id ORDER BY market_date, vendor_id) AS previous_booth_number
FROM farmers_market.vendor_booth_assignments
ORDER BY market_date, vendor_id, booth_number)

SELECT * 
FROM x
WHERE x.market_date = '2020-03-13' AND (x.booth_number <> x.previous_booth_number OR x.previous_booth_number IS NULL);

/** Q3. If you were asked to build a report of total and average market sales by vendor booth type, 
how might you modify the query associated with Figure 10.3 to include the information needed for your report? **/

SELECT cp.market_date, md.market_day, md.market_week, md.market_year, cp.vendor_id, 
   v.vendor_name, v.vendor_type, vba.booth_number, b.booth_type,
ROUND(SUM(cp.quantity * cp.cost_to_customer_per_qty),2) AS sales
FROM farmers_market.customer_purchases AS cp
LEFT JOIN farmers_market.market_date_info AS md
 ON cp.market_date = md.market_date
LEFT JOIN farmers_market.vendor AS v
 ON cp.vendor_id = v.vendor_id
LEFT JOIN farmers_market.vendor_booth_assignments AS vba
 ON cp.vendor_id = vba.vendor_id
AND cp.market_date = vba.market_date
LEFT JOIN farmers_market.booth AS b
 ON vba.booth_number = b.booth_number
GROUP BY cp.market_date, cp.vendor_id
ORDER BY cp.market_date, cp.vendor_id;