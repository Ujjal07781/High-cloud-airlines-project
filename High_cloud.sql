create database high_cloud_airline;

use high_cloud_airline;

# Createing new column Date Field
ALTER TABLE Maindata ADD COLUMN Date_Field DATE;
SET SQL_SAFE_UPDATES = 0;

UPDATE maindata
SET full_date = STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d');

SELECT 
  year,
  month,
  day,
  -- Constructed full date
  STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d') AS Date_Field
  ,

  -- Month Name
  DATE_FORMAT(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d'), '%M') AS `Month Name`,

  -- Quarter
  QUARTER(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d')) AS `Quarter`,

  -- Week Day Number (1 = Sunday, 7 = Saturday)
  DAYOFWEEK(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d')) AS `Week Day Number`,

  -- Week Day Name
  DATE_FORMAT(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d'), '%W') AS `Week Day Name`,

  -- Year-Month format (e.g. 2024-Jun)
  DATE_FORMAT(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d'), '%Y-%b') AS `Year Month`,

  -- Financial Month (April = 1, March = 12)
  ((MONTH(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d')) + 8) % 12 + 1) AS `Financial Month`,

  -- Financial Quarter (Q1 starts in April)
  FLOOR(((MONTH(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d')) + 8) % 12) / 3) + 1 AS `Financial Quarter`

FROM maindata;


# load Factor stands for ( Transported passengers / Available seats)
# Find the load Factor percentage on a yearly , Quarterly , Monthly basis 

select year,
round(sum(transported_passengers) * 100 / sum(available_seats),2) as load_factor_percentage
from maindata group by year order by year;

select year,quarter(date_field) as quarter,
round(sum(transported_passengers) * 100 / sum(available_seats),2) as load_factor_percentage
from maindata group by year, quarter(date_field) order by year, quarter;

select year,month,
round(sum(transported_passengers) * 100 / sum(available_seats),2) as load_factor_percentage
from maindata group by year, month order by year, month;


# The load Factor percentage on a Carrier Name basis

SELECT 
    carrier_name,
    ROUND(SUM(transported_passengers) * 100.0 / SUM(available_seats), 2) AS load_factor_percentage
FROM 
    maindata
GROUP BY 
    carrier_name
ORDER BY 
    load_factor_percentage DESC;
  
  
  # Identify Top 10 Carrier Names based passengers preference
    
    SELECT 
    carrier_name,
    SUM(transported_passengers) AS total_passengers
FROM 
    maindata
GROUP BY 
    carrier_name
ORDER BY 
    total_passengers DESC
LIMIT 10;


#  Display top Routes (from-to City) based on Number of Flights.

SELECT 
    from_To_City,
    COUNT(*) AS total_flights
FROM 
    maindata
GROUP BY 
    from_To_City
ORDER BY 
    total_flights DESC
LIMIT 10;


# Identify the how much load factor is occupied on Weekend vs Weekdays.

SELECT
    CASE 
        WHEN DAYOFWEEK(date_field) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    ROUND(SUM(transported_passengers) * 100.0 / SUM(available_seats), 2) AS load_factor_percentage
FROM 
    maindata
GROUP BY 
    day_type;


# Identify number of flights based on Distance groups
    
SELECT 
    d.distance_group_id,
    d.distance_interval,
    COUNT(distinct f.airline_id) AS total_flights
FROM 
    maindata as f
JOIN 
    `distance groups` as d ON f.distance_group_id = d.distance_group_id
GROUP BY 
     d.distance_group_id, d.distance_interval
ORDER BY 
    total_flights desc;