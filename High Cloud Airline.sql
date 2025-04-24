--  --
select 
extract(year from date) as "Year",
extract(month from date) as "Month",
to_char(date, 'Month') as "Month Name",
extract(quarter from date) as "Quarter",
to_char(date, 'YYYY-MMM') as "Year Month",
to_char(date, 'D') as "Week Day Number",
to_char(date, 'Day') as "Week Day Name",
((extract(month from date)::int + 8) % 12) + 1 as "Financial Month",
(((extract(month from date)::int + 8) % 12) / 3) + 1 as "Financial Quarter"
from maindata
order by 2 asc


-- load Factor percentage on a yearly , Quarterly , Monthly basis --
select year, 
round((sum(transportedpassengers)::numeric / sum(availableseats)::numeric) * 100, 2) as "Load Factor Yearly"
from maindata
group by year

select to_char(date, 'Month') as "Month", 
round((sum(transportedpassengers)::numeric / sum(availableseats)::numeric) * 100, 2) as "Load Factor Monthly"
from maindata
group by to_char(date, 'Month')

select extract(quarter from date) as "Quarter", 
round((sum(transportedpassengers)::numeric / sum(availableseats)::numeric) * 100, 2) as "Load Factor Quarterly"
from maindata
group by extract(quarter from date)
order by 1


-- load Factor percentage on a Carrier Name basis --
select carriername,
round((sum(transportedpassengers)::numeric / sum(availableseats)::numeric) * 100, 2) as "Load Factor Carrier Name Wise"
from maindata
group by carriername
having sum(availableseats) > 0
order by 2 desc


-- Top 10 Carrier Names based passengers preference  --
select carriername,
round((sum(transportedpassengers)::numeric / sum(availableseats)::numeric) * 100, 2) as "Load Factor Carrier Name Wise"
from maindata
group by carriername
having sum(availableseats) > 0
order by 2 desc
limit 10


-- top Routes ( from-to City) based on Number of Flights --
select fromtostate as "Route",
count(*) as "Number of Flights"
from maindata
group by fromtostate
order by 2 desc
limit 10


-- load factor is occupied on Weekend vs Weekdays. --
select 
round((sum(transportedpassengers)::numeric / sum(availableseats)::numeric) * 100, 2) as "Load Factor on Weekdays"
from maindata
where (to_char(date, 'D'))::int between 2 and 6

select 
round((sum(transportedpassengers)::numeric / sum(availableseats)::numeric) * 100, 2) as "Load Factor on Weekends"
from maindata
where (to_char(date, 'D'))::int in (1, 7)


-- number of flights based on Distance group --
select 
d.distanceinterval as "Distance Group",
count(*) as "Number of Flights"
from 
maindata m inner join  distancegroups d
on m.distancegroupid = d.distancegroupid
group by d.distanceinterval
order by 2



