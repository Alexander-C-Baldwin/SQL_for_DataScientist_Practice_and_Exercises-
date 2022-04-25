/** Chp 4 practice. CASE Statements **/

select * from farmers_market.vendor limit 5;

select vendor_id, vendor_name, vendor_type,
Case when LOWER(vendor_type) like '%fresh%' then 'Fresh Produce'
else 'other' end as vendor_type_condensed
from farmers_market.vendor;
 
 /** Creating Binary flags using CASE **/
 
SELECT 
 market_date,
 market_day
FROM farmers_market.market_date_info
LIMIT 5;

SELECT market_day, market_date,
Case when market_day = 'Saturday' or 'Sunday' then 1
else 0 end as weekend_flag
from farmers_market.market_date_info
limit 10;

/** Grouping or Binning Continuous Values Using CASE  **/
SELECT market_date, customer_id, vendor_id, ROUND(quantity * cost_to_customer_per_qty, 2) AS price,
 CASE WHEN quantity * cost_to_customer_per_qty> 50 
 THEN 1
 ELSE 0
 END AS price_over_50
FROM farmers_market.customer_purchases;

select vendor_id from farmers_market.customer_purchases;
select vendor_id from farmers_market.vendor;

SELECT `vendor_id` FROM `farmers_market`.`customer_purchases`;

SELECT market_date, customer_id, vendor_id, ROUND(quantity * cost_to_customer_per_qty, 2) AS price,
CASE WHEN quantity * cost_to_customer_per_qty < 5.00 THEN 'Under $5'
WHEN quantity * cost_to_customer_per_qty < 10.00 THEN '$5-$9.99'
WHEN quantity * cost_to_customer_per_qty < 20.00 THEN '$10-$19.99'
WHEN quantity * cost_to_customer_per_qty>= 20.00 THEN '$20 and Up'
END AS price_bin
FROM farmers_market.customer_purchases
LIMIT 10;

/** Categorical Encoding Using CASE **/ 

SELECT booth_number, booth_price_level,
 CASE WHEN booth_price_level = 'A' THEN 1
 WHEN booth_price_level = 'B' THEN 2
 WHEN booth_price_level = 'C' THEN 3
END AS booth_price_level_numeric
FROM farmers_market.booth
LIMIT 5;

SELECT vendor_id, vendor_name, vendor_type,
CASE WHEN vendor_type = 'Arts & Jewelry' THEN 1 ELSE 0 
END AS vendor_type_arts_jewelry,
CASE WHEN vendor_type = 'Eggs & Meats' THEN 1 ELSE 0 
END AS vendor_type_eggs_meats,
CASE WHEN vendor_type = 'Fresh Focused' THEN 1 ELSE 0 
END AS vendor_type_fresh_focused, 
CASE WHEN vendor_type = 'Fresh Variety: Veggies & More' THEN  1 Else 0 
END AS vendor_type_fresh_variety,
CASE WHEN vendor_type = 'Prepared Foods' THEN 1 ELSE 0 
END AS vendor_type_prepared
FROM farmers_market.vendor;

SELECT `product_qty_type` FROM `farmers_market`.`product`;




