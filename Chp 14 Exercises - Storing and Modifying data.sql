# Chp 14 Exercises - Storing and Modifying Data

# Storing SQL Datasets as Tables and Views

#Q1. If you include a CURRENT_TIMESTAMP column when you create a view, what would you expect the values 
#	of that column to be when you query the view?

# The timestamp returned when you query the view will be the current time (on the server), 
# because unlike with a table, the view isn't storing any data and is generating the results of the query when it is run.


#Q2. Write a query to determine what the data from the  vendor_booth_assignment table looked like on October 3, 2020 
#    by querying the vendor_booth_log table created in this chapter. 
# (Assume that records have been inserted into the log table any time changes were made to the vendor_booth_assignment table.)

SELECT x.* FROM
(SELECT vendor_id, booth_number, market_date, snapshot_timestamp,
 MAX(snapshot_timestamp) OVER (PARTITION BY vendor_id, booth_number) AS max_timestamp_in_filter
 FROM farmers_market.vendor_booth_log
 WHERE DATE(snapshot_timestamp) <= '2020-10-04'
) AS x
WHERE x.snapshot_timestamp = x.max_timestamp_in_filter;