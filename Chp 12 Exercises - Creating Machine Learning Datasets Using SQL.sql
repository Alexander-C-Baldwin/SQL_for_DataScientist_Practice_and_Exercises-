/** Chp 12 Exercises

/** Q1. Add a column to the final query in the chapter that counts how many markets were attended 
by each customer in the past 14 days. **/


(SELECT COUNT(market_date) 
FROM customer_markets_attended cma
WHERE cma.customer_id = cp.customer_id 
AND cma.market_date < cp.market_date
AND DATEDIFF(cp.market_date, cma.market_date) <= 14) AS customer_markets_attended_14days_count,


/** Q2 Add a column to the final query in the chapter that contains a 1 if the customer purchased an item that cost over $10, 
and a 0 if not. HINT: The calculation will follow the same form as the purchased_from_vendor_x flags. **/

MAX(CASE WHEN cp.cost_to_customer_per_qty> 10 THEN 1 ELSE 0 END) purchased_item_over_10_dollars,



/** Let's say that the farmer's market started a customer reward program that gave customers a market goods gift basket
 and branded reusable market bag when they had spent at least $200 total. 
 Create a flag field (with a 1 or 0) that indicates whether the customer has reached this loyal customer status.
 HINT: One way to accomplish this involves modifying the CTE (WITH clause) to include purchase totals, 
 and adding a column to the main query with a similar structure to the one that calculates 
customer_markets_attended_count, to calculate a running total spent. **/

WITH customer_markets_attended AS
(SELECT customer_id, market_date, SUM(quantity * cost_to_customer_per_qty) AS purchase_total,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date) AS market_count
FROM farmers_market.customer_purchases
GROUP BY customer_id, market_date 
ORDER BY customer_id, market_date)

SELECT cp.customer_id, cp.market_date,
EXTRACT(MONTH FROM cp.market_date) AS market_month,
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
   GROUP BY cma.customer_id)) days_since:last_customer_market_date,
		(SELECT MAX(market_count) 
		FROM customer_markets_attended cma
		WHERE cma.customer_id = cp.customer_id 
		AND cma.market_date <= cp.market_date) AS customer_markets_attended_count,
			(SELECT COUNT(market_date) 
			FROM customer_markets_attended cma
			WHERE cma.customer_id = cp.customer_id 
			AND cma.market_date < cp.market_date
			AND DATEDIFF(cp.market_date, cma.market_date) <= 30) AS customer_markets_attended_30days_count,
					(SELECT COUNT(market_date) 
					FROM customer_markets_attended cma
					WHERE cma.customer_id = cp.customer_id 
					AND cma.market_date < cp.market_date
					AND DATEDIFF(cp.market_date, cma.market_date) <= 14) AS customer_markets_attended_14days_count,
					MAX(CASE WHEN cp.cost_to_customer_per_qty> 10 THEN 1 ELSE 0 END) AS purchased_item_over_10_dollars,
						(SELECT SUM(purchase_total) 
						FROM customer_markets_attended cma
						WHERE cma.customer_id = cp.customer_id 
						AND cma.market_date <= cp.market_date) AS total_spent_to_date,
						CASE WHEN 
						(SELECT SUM(purchase_total) 
						FROM customer_markets_attended cma
						WHERE cma.customer_id = cp.customer_id 
						AND cma.market_date <= cp.market_date)> 200
						THEN 1 ELSE 0 END AS customer_has_spent_over_200,
						CASE WHEN DATEDIFF(
						(SELECT MIN(cma.market_date) 
						FROM customer_markets_attended AS cma
						WHERE cma.customer_id = cp.customer_id 
						AND cma.market_date> cp.market_date
						GROUP BY cma.customer_id),
						cp.market_date) <=30 THEN 1 ELSE 0 END AS purchased_again_within_30_days
FROM farmers_market.customer_purchases AS cp
GROUP BY cp.customer_id, cp.market_date
ORDER BY cp.customer_id, cp.market_date;







