/** Chapter 12 Practice - Creating Machine Learning Datasets Using SQL **/

/** Datasets for Time Series Models **/

SELECT min(cp.market_date) as first_market_date_of_week,
round(sum(cp.quantity * cp.cost_to_customer_per_qty),2) as weekly_sales
FROM farmers_market.customer_purchases as cp
Left join farmers_market.market_date_info as md
on cp.market_date = md.market_date
group by md.market_year, md.market_week
order by md.market_year, md.market_week;

/** Datasets for Binary Classification **/
/** Creating the Dataset **/

WITH customer_markets_attended AS
(SELECT DISTINCT customer_id, market_date
 FROM farmers_market.customer_purchases
 ORDER BY customer_id, market_date)
   
SELECT cp.market_date, cp.customer_id,
SUM(cp.quantity * cp.cost_to_customer_per_qty) AS purchase_total,
COUNT(DISTINCT cp.vendor_id) AS vendors_patronized,
COUNT(DISTINCT cp.product_id) AS different_products_purchased,
	(SELECT MIN(cma.market_date) 
	 FROM customer_markets_attended AS cma
	 WHERE cma.customer_id = cp.customer_id 
	 AND cma.market_date> cp.market_date
     GROUP BY cma.customer_id) AS customer_next_market_date,
		DATEDIFF(
            (SELECT MIN(cma2.market_date) 
			 FROM customer_markets_attended AS cma2
			 WHERE cma2.customer_id = cp.customer_id 
             AND cma2.market_date> cp.market_date
             GROUP BY cma2.customer_id), cp.market_date) 
             AS days_until_customer_next_market_date,
				CASE WHEN
				DATEDIFF(
					(SELECT MIN(cma3.market_date) 
					 FROM customer_markets_attended AS cma3
					 WHERE cma3.customer_id = cp.customer_id 
					 AND cma3.market_date> cp.market_date
                     GROUP BY cma3.customer_id), cp.market_date) <=30 
					 THEN 1 ELSE 0 END AS purchased_again_within_30_days
FROM farmers_market.customer_purchases AS cp
GROUP BY cp.customer_id, cp.market_date
ORDER BY cp.customer_id, cp.market_date;

/** Expanding the Feature Set **/

WITH customer_markets_attended AS
(SELECT DISTINCT customer_id, market_date
FROM farmers_market.customer_purchases
ORDER BY customer_id, market_date)
   
SELECT cp.market_date, cp.customer_id,
SUM(cp.quantity * cp.cost_to_customer_per_qty) AS purchase_total,
COUNT(DISTINCT cp.vendor_id) AS vendors_patronized,
MAX(CASE WHEN cp.vendor_id = 7 THEN 1 ELSE 0 END) AS purchased_from_vendor_7,
MAX(CASE WHEN cp.vendor_id = 8 THEN 1 ELSE 0 END) AS purchased_from_vendor_8,
COUNT(DISTINCT cp.product_id) AS different_products_purchased,
	DATEDIFF(cp.market_date,
	(SELECT MAX(cma.market_date) 
	FROM customer_markets_attended AS cma
	WHERE cma.customer_id = cp.customer_id 
	AND cma.market_date < cp.market_date
	GROUP BY cma.customer_id)) AS days_since_last_customer_market_date,
        CASE WHEN
        DATEDIFF((SELECT MIN(cma.market_date) 
		FROM customer_markets_attended AS cma
		WHERE cma.customer_id = cp.customer_id 
		AND cma.market_date> cp.market_date
		GROUP BY cma.customer_id),
        cp.market_date) <=30 THEN 1 ELSE 0 END AS purchased_again_within_30_days
FROM farmers_market.customer_purchases AS cp
GROUP BY cp.customer_id, cp.market_date
ORDER BY cp.customer_id, cp.market_date;

/** Using window function ROW NUMBER **/

WITH customer_markets_attended AS
(SELECT customer_id, market_date,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date) AS market_count
FROM farmers_market.customer_purchases
GROUP BY customer_id, market_date 
ORDER BY customer_id, market_date)

select cp.customer_id, cp.market_date, 
	(SELECT COUNT(market_date) 
	FROM customer_markets_attended AS cma
	WHERE cma.customer_id = cp.customer_id 
	AND cma.market_date < cp.market_date
	AND DATEDIFF(cp.market_date, cma.market_date) <= 30) AS customer_markets_attended_30days_count
FROM farmers_market.customer_purchases AS cp
GROUP BY cp.customer_id, cp.market_date
ORDER BY cp.customer_id, cp.market_date;

/** Feature Engineering **/ 

WITH customer_markets_attended AS
(SELECT customer_id, market_date,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date) AS market_count
FROM farmers_market.customer_purchases
GROUP BY customer_id, market_date 
ORDER BY customer_id, market_date)
   
SELECT cp.customer_id, cp.market_date,
EXTRACT(MONTH FROM cp.market_date) as market_month,
SUM(cp.quantity * cp.cost_to_customer_per_qty) AS purchase_total,
COUNT(DISTINCT cp.vendor_id) AS vendors_patronized,
MAX(CASE WHEN cp.vendor_id = 7 THEN 1 ELSE 0 END) purchased_from_vendor_7,
MAX(CASE WHEN cp.vendor_id = 8 THEN 1 ELSE 0 END) purchased_from_vendor_8,
COUNT(DISTINCT cp.product_id) AS different_products_purchased,
DATEDIFF(cp.market_date,
	(SELECT MAX(cma.market_date) 
	FROM customer_markets_attended AS cma
	WHERE cma.customer_id = cp.customer_id 
	AND cma.market_date < cp.market_date
	GROUP BY cma.customer_id)) as days_since_last_customer_market_date,
		(SELECT MAX(market_count) 
		FROM customer_markets_attended AS cma
		WHERE cma.customer_id = cp.customer_id 
		AND cma.market_date <= cp.market_date) AS customer_markets_attended_count,
			(SELECT COUNT(market_date) 
			FROM customer_markets_attended AS cma
			WHERE cma.customer_id = cp.customer_id 
			AND cma.market_date < cp.market_date
			AND DATEDIFF(cp.market_date, cma.market_date) <= 30) AS customer_markets_attended_30days_count,
				CASE WHEN
				DATEDIFF(
				(SELECT MIN(cma.market_date) 
                FROM customer_markets_attended AS cma
                WHERE cma.customer_id = cp.customer_id 
				AND cma.market_date> cp.market_date
                GROUP BY cma.customer_id), cp.market_date) <=30 THEN 1 ELSE 0 
				END AS purchased_again_within_30_days
FROM farmers_market.customer_purchases AS cp
GROUP BY cp.customer_id, cp.market_date
ORDER BY cp.customer_id, cp.market_date;



















