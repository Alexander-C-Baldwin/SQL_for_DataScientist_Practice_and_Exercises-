# Chapter 13 Analytical Dataset Development Examples

# What factors correlate with fresh produce sales

SELECT * FROM farmers_market.product_category;

SELECT * FROM farmers_market.product
WHERE product_category_id IN (1, 5, 6)
ORDER BY product_category_id;

SELECT * 
FROM customer_purchases AS cp
INNER JOIN product AS p
ON cp.product_id = p.product_id
WHERE p.product_category_id = 1;

SELECT mdi.market_date, mdi.market_week, mdi.market_year, mdi.market_rain_flag, mdi.market_snow_flag, 
		cp.market_date, cp.customer_id, cp.quantity, cp.cost_to_customer_per_qty, p.product_category_id
FROM customer_purchases AS cp
INNER JOIN product AS p
ON cp.product_id = p.product_id
AND p.product_category_id = 1
RIGHT JOIN market_date_info AS mdi
ON mdi.market_date = cp.market_date;

SELECT mdi.market_year, mdi.market_week,
MAX(mdi.market_rain_flag) AS market_week_rain_flag, 
MAX(mdi.market_snow_flag) AS market_week_snow_flag,
MIN(mdi.market_min_temp) AS minimum_temperature,
MAX(mdi.market_max_temp) AS maximum_temperature,
MIN(mdi.market_season) AS _market_season,
ROUND(COALESCE(SUM(cp.quantity * cp.cost_to_customer_per_qty), 0), 2) AS weekly_category1_sales
FROM customer_purchases AS cp
INNER JOIN product AS p
ON cp.product_id = p.product_id
AND p.product_category_id = 1
RIGHT JOIN market_date_info AS mdi
ON mdi.market_date = cp.market_date
GROUP BY mdi.market_year, mdi.market_week;

SELECT mdi.market_date, mdi.market_year, mdi.market_week, vi.*, p.*
FROM vendor_inventory AS vi
INNER JOIN product AS p
ON vi.product_id = p.product_id
AND p.product_category_id = 1
RIGHT JOIN market_date_info AS mdi
ON mdi.market_date = vi.market_date;

SELECT mdi.market_year, mdi.market_week,
COUNT(DISTINCT vi.vendor_id) AS vendor_count,
COUNT(DISTINCT vi.product_id) AS unique_product_count,
SUM(CASE WHEN p.product_qty_type = 'unit' THEN vi.quantity ELSE 0 END) AS unit_products_qty,
SUM(CASE WHEN p.product_qty_type = 'lbs' THEN vi.quantity ELSE 0 END) AS bulk_products_lbs,
ROUND(COALESCE(SUM(vi.quantity * vi.original_price), 0), 2) AS total_product_value,
MAX(CASE WHEN p.product_id = 16 THEN 1 ELSE 0 END) AS corn_available_flag
FROM vendor_inventory vi
INNER JOIN product p
ON vi.product_id = p.product_id
RIGHT JOIN market_date_info mdi
ON mdi.market_date = vi.market_date
GROUP BY mdi.market_year, mdi.market_week;


SELECT mdi.market_year, mdi.market_week,
COUNT(DISTINCT vi.vendor_id) AS vendor_count,
COUNT(DISTINCT vi.product_id) AS unique_product_count,
COUNT(DISTINCT CASE WHEN p.product_category_id = 1 THEN vi.product_id ELSE NULL END) AS unique_product_count_product_category1,
SUM(CASE WHEN p.product_qty_type = 'unit' THEN vi.quantity ELSE 0 END) AS unit_products_qty,
SUM(CASE WHEN p.product_category_id = 1 AND p.product_qty_type = 'unit' THEN vi.quantity ELSE 0 END) AS unit_products_qty_product_category1,
SUM(CASE WHEN p.product_qty_type = 'lbs' THEN vi.quantity ELSE 0 END) AS bulk_products_lbs,
SUM(CASE WHEN p.product_category_id = 1 AND p.product_qty_type = 'lbs' THEN vi.quantity ELSE 0 END) AS bulk_products_lbs_product_category1,
ROUND(COALESCE(SUM(vi.quantity * vi.original_price), 0), 2) AS total_product_value,
ROUND(COALESCE(SUM(CASE WHEN p.product_category_id = 1 THEN vi.quantity * vi.original_price ELSE 0 END), 0), 2) AS total_product_value_product_category1,
MAX(CASE WHEN p.product_id = 16 THEN 1 ELSE 0 END) AS corn_available_flag
FROM vendor_inventory vi
INNER JOIN product p
ON vi.product_id = p.product_id
RIGHT JOIN market_date_info mdi
ON mdi.market_date = vi.market_date
GROUP BY mdi.market_year, mdi.market_week;

WITH my_customer_purchases AS
(
SELECT mdi.market_year, mdi.market_week,
MAX(mdi.market_rain_flag) AS market_week_rain_flag, 
MAX(mdi.market_snow_flag) AS market_week_snow_flag,
MIN(mdi.market_min_temp) AS minimum_temperature,
MAX(mdi.market_max_temp) AS maximum_temperature,
MIN(mdi.market_season) AS market_season,
ROUND(COALESCE(SUM(cp.quantity * cp.cost_to_customer_per_qty), 0), 2) AS weekly_category1_sales
FROM customer_purchases AS cp
INNER JOIN product AS p
ON cp.product_id = p.product_id
AND p.product_category_id = 1
RIGHT JOIN market_date_info AS mdi
ON mdi.market_date = cp.market_date
GROUP BY mdi.market_year, mdi.market_week
),
my_vendor_inventory AS
(SELECT mdi.market_year, mdi.market_week,
COUNT(DISTINCT vi.vendor_id) AS vendor_count,
COUNT(DISTINCT CASE WHEN p.product_category_id = 1 THEN vi.vendor_id ELSE NULL END) AS vendor_count_product_category1,
COUNT(DISTINCT vi.product_id) AS unique_product_count,
COUNT(DISTINCT CASE WHEN p.product_category_id = 1 THEN vi.product_id ELSE NULL END) AS unique_product_count_product_category1,
SUM(CASE WHEN p.product_qty_type = 'unit' THEN vi.quantity ELSE 0 END) AS unit_products_qty,
SUM(CASE WHEN p.product_category_id = 1 AND p.product_qty_type = 'unit' THEN vi.quantity ELSE 0 END) AS unit_products_qty_product_category1,
SUM(CASE WHEN p.product_qty_type = 'lbs' THEN vi.quantity ELSE 0 END) AS bulk_products_lbs,
SUM(CASE WHEN p.product_category_id = 1 AND p.product_qty_type = 'lbs' THEN vi.quantity ELSE 0 END) AS bulk_products_lbs_product_category1,
ROUND(COALESCE(SUM(vi.quantity * vi.original_price), 0), 2) AS total_product_value,
ROUND(COALESCE(SUM(CASE WHEN p.product_category_id = 1 THEN vi.quantity * vi.original_price ELSE 0 END), 0), 2) AS total_product_value_product_category1,
MAX(CASE WHEN p.product_id = 16 THEN 1 ELSE 0 END) AS corn_available_flag
FROM vendor_inventory vi
INNER JOIN product p
ON vi.product_id = p.product_id
RIGHT JOIN market_date_info mdi
ON mdi.market_date = vi.market_date
GROUP BY mdi.market_year, mdi.market_week
)

SELECT *
FROM my_vendor_inventory
LEFT JOIN my_customer_purchases
ON my_vendor_inventory.market_year = my_customer_purchases.market_year
AND my_vendor_inventory.market_week = my_customer_purchases.market_week
ORDER BY my_vendor_inventory.market_year, my_vendor_inventory.market_week;

WITH my_customer_purchases AS
(
SELECT mdi.market_year, mdi.market_week,
MAX(mdi.market_rain_flag) AS market_week_rain_flag, 
MAX(mdi.market_snow_flag) AS market_week_snow_flag,
MIN(mdi.market_min_temp) AS minimum_temperature,
MAX(mdi.market_max_temp) AS maximum_temperature,
MIN(mdi.market_season) AS market_season,
ROUND(COALESCE(SUM(cp.quantity * cp.cost_to_customer_per_qty), 0), 2) AS weekly_category1_sales
FROM customer_purchases AS cp
INNER JOIN product AS p
ON cp.product_id = p.product_id
AND p.product_category_id = 1
RIGHT JOIN market_date_info AS mdi
ON mdi.market_date = cp.market_date
GROUP BY mdi.market_year, mdi.market_week
),
my_vendor_inventory AS
(SELECT mdi.market_year, mdi.market_week,
COUNT(DISTINCT vi.vendor_id) AS vendor_count,
COUNT(DISTINCT CASE WHEN p.product_category_id = 1 THEN vi.vendor_id ELSE NULL END) AS vendor_count_product_category1,
COUNT(DISTINCT vi.product_id) AS unique_product_count,
COUNT(DISTINCT CASE WHEN p.product_category_id = 1 THEN vi.product_id ELSE NULL END) AS unique_product_count_product_category1,
SUM(CASE WHEN p.product_qty_type = 'unit' THEN vi.quantity ELSE 0 END) AS unit_products_qty,
SUM(CASE WHEN p.product_category_id = 1 AND p.product_qty_type = 'unit' THEN vi.quantity ELSE 0 END) AS unit_products_qty_product_category1,
SUM(CASE WHEN p.product_qty_type <> 'unit' THEN vi.quantity ELSE 0 END) AS bulk_products_qty,
SUM(CASE WHEN p.product_category_id = 1 AND p.product_qty_type <> 'unit' THEN vi.quantity ELSE 0 END) AS bulk_products_qty_product_category1,
SUM(CASE WHEN p.product_qty_type = 'lbs' THEN vi.quantity ELSE 0 END) AS bulk_products_lbs,
SUM(CASE WHEN p.product_category_id = 1 AND p.product_qty_type = 'lbs' THEN vi.quantity ELSE 0 END) AS bulk_products_lbs_product_category1,
ROUND(COALESCE(SUM(vi.quantity * vi.original_price), 0), 2) AS total_product_value,
ROUND(COALESCE(SUM(CASE WHEN p.product_category_id = 1 THEN vi.quantity * vi.original_price ELSE 0 END), 0), 2) AS total_product_value_product_category1,
MAX(CASE WHEN p.product_id = 16 THEN 1 ELSE 0 END) AS corn_available_flag
FROM vendor_inventory vi
INNER JOIN product p
ON vi.product_id = p.product_id
RIGHT JOIN market_date_info mdi
ON mdi.market_date = vi.market_date
GROUP BY mdi.market_year, mdi.market_week
)

SELECT  mvi.market_year, mvi.market_week, mcp.market_week_rain_flag, mcp.market_week_snow_flag, mcp.minimum_temperature,
		mcp.maximum_temperature, mcp.market_season, mvi.vendor_count, mvi.vendor_count_product_category1,
		mvi.unique_product_count, mvi.unique_product_count_product_category1, mvi.unit_products_qty, 
        mvi.unit_products_qty_product_category1, mvi.bulk_products_qty, mvi.bulk_products_qty_product_category1,
        mvi.total_product_value, mvi.total_product_value_product_category1,
        LAG(mcp.weekly_category1_sales, 1) OVER (ORDER BY mvi.market_year, mvi.market_week) AS previous_week_category1_sales,
        mcp.weekly_category1_sales
FROM my_vendor_inventory AS mvi
LEFT JOIN my_customer_purchases AS mcp
ON mvi.market_year = mcp.market_year
AND mvi.market_week = mcp.market_week
ORDER BY mvi.market_year, mvi.market_week;

# How Do Sales Vary by Customer Zip Code, Market Distance, and Demographic Data?

SELECT c.customer_id, c.customer_zip,
DATEDIFF(MAX(market_date), MIN(market_date)) AS customer_duration_days,
COUNT(DISTINCT market_date) AS number_of_markets,
ROUND(SUM(quantity * cost_to_customer_per_qty), 2) AS total_spent,
ROUND(SUM(quantity * cost_to_customer_per_qty) / COUNT(DISTINCT market_date), 2) AS average_spent_per_market
FROM farmers_market.customer AS c
LEFT JOIN farmers_market.customer_purchases AS cp
ON cp.customer_id = c.customer_id
GROUP BY c.customer_id;

SELECT * FROM zip_data;

SELECT c.customer_id,
DATEDIFF(MAX(market_date), MIN(market_date)) AS customer_duration_days,
COUNT(DISTINCT market_date) AS number_of_markets,
ROUND(SUM(quantity * cost_to_customer_per_qty), 2) AS total_spent,
ROUND(SUM(quantity * cost_to_customer_per_qty) / COUNT(DISTINCT market_date), 2) AS average_spent_per_market,
c.customer_zip, z.median_household_income AS zip_median_household_income,
z.percent_high_income AS zip_percent_high_income,
z.percent_under_18 AS zip_percent_under_18, z.percent_over_65 AS zip_percent_over_65,
z.people_per_sq_mile AS zip_people_per_sq_mile, z.latitude, z.longitude
FROM farmers_market.customer c
LEFT JOIN farmers_market.customer_purchases cp
ON cp.customer_id = c.customer_id
LEFT JOIN zip_data z
ON c.customer_zip = z.zip_code_5
GROUP BY c.customer_id;

SELECT c.customer_id,
DATEDIFF(MAX(market_date), MIN(market_date)) AS customer_duration_days,
COUNT(DISTINCT market_date) AS number_of_markets,
ROUND(SUM(quantity * cost_to_customer_per_qty), 2) AS total_spent,
ROUND(SUM(quantity * cost_to_customer_per_qty) / COUNT(DISTINCT market_date), 2) AS average_spent_per_market,
c.customer_zip, z.median_household_income AS zip_median_household_income,
z.percent_high_income AS zip_percent_high_income, z.percent_under_18 AS zip_percent_under_18,
z.percent_over_65 AS zip_percent_over_65, z.people_per_sq_mile AS zip_people_per_sq_mile,
ROUND(2 * 3961 * ASIN(SQRT(POWER(SIN(RADIANS((z.latitude - 38.4463) / 2)),2) + COS(RADIANS(38.4463)) * COS(RADIANS(z.latitude)) * POWER((SIN(RADIANS((z.longitude - -78.8712) / 2))), 2)))) AS zip_miles_from_market
FROM farmers_market.customer AS c
LEFT JOIN farmers_market.customer_purchases AS cp
ON cp.customer_id = c.customer_id
LEFT JOIN zip_data AS z
ON c.customer_zip = z.zip_code_5
GROUP BY c.customer_id;

WITH customer_zip_data AS
(
SELECT c.customer_id,
DATEDIFF(MAX(market_date), MIN(market_date)) AS customer_duration_days,
COUNT(DISTINCT market_date) AS number_of_markets,
ROUND(SUM(quantity * cost_to_customer_per_qty), 2) AS total_spent,
ROUND(SUM(quantity * cost_to_customer_per_qty) / COUNT(DISTINCT market_date), 2) AS average_spent_per_market,
c.customer_zip, z.median_household_income AS zip_median_household_income,
z.percent_high_income AS zip_percent_high_income, z.percent_under_18 AS zip_percent_under_18,
z.percent_over_65 AS zip_percent_over_65, z.people_per_sq_mile AS zip_people_per_sq_mile,
ROUND(2 * 3961 * ASIN(SQRT(POWER(SIN(RADIANS((z.latitude - 38.4463) / 2)),2) + COS(RADIANS(38.4463)) * COS(RADIANS(z.latitude)) * POWER((SIN(RADIANS((z.longitude - -78.8712) / 2))), 2)))) AS zip_miles_from_market
FROM farmers_market.customer AS c
LEFT JOIN farmers_market.customer_purchases AS cp
ON cp.customer_id = c.customer_id
LEFT JOIN zip_data AS z
ON c.customer_zip = z.zip_code_5
GROUP BY c.customer_id
)

SELECT cz.customer_zip,
COUNT(cz.customer_id) AS customer_count,
ROUND(AVG(cz.total_spent)) AS average_total_spent,
MIN(cz.zip_miles_from_market) AS zip_miles_from_market
FROM customer_and_zip_data AS cz
GROUP BY cz.customer_zip;
























