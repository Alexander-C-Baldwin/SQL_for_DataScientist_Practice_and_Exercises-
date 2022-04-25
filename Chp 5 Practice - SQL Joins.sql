
/* Chapter 5 Practice - SQL JOINS */

SELECT * 
FROM product
LEFT JOIN product_category 
ON product.product_category_id = product_category.product_category_id;

SELECt product.product_id, product.product_name,
	product.product_category_id AS product_prod_cat_id,
	product_category.product_category_id AS category_prod_cat_id,
	product_category.product_category_name
FROM product 
LEFT JOIN product_category    
ON product.product_category_id = product_category.product_category_id;

SELECT p.product_id, p.product_name, pc.product_category_id, pc.product_category_name
FROM product AS p 
LEFT JOIN product_category AS pc
ON p.product_category_id = pc.product_category_id
ORDER BY pc.product_category_name, p.product_name;

SELECT v.*, vba.*
FROM farmers_market.vendor as v
Inner join farmers_market.vendor_booth_assignments AS vba
On v.vendor_id = vba.vendor_id
ORDER BY v.vendor_name, vba.market_date;

SELECT * 
FROM farmers_market.customer AS c
RIGHT JOIN farmers_market.customer_purchases AS cp
ON c.customer_id = cp.customer_id;

SELECT c.* 
FROM customer AS c
LEFT JOIN customer_purchases AS cp
ON c.customer_id = cp.customer_id
WHERE cp.customer_id IS NULL;

SELECT DISTINCT c.* 
FROM customer AS c
LEFT JOIN customer_purchases AS cp
ON c.customer_id = cp.customer_id
WHERE (cp.market_date <> '2019-03-02' OR cp.market_date IS NULL);

/* JOINS with more than 2 tables */

SELECT b.booth_number, b.booth_type, vba.market_date, v.vendor_id, 
	v.vendor_name, v.vendor_type
FROM booth AS b 
LEFT JOIN vendor_booth_assignments AS vba ON b.booth_number = vba.booth_number
LEFT JOIN vendor AS v ON v.vendor_id = vba.vendor_id
ORDER BY b.booth_number, vba.market_date;































































