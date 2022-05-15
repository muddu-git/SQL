-- Question 71
-- Table: Customer

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | name          | varchar |
-- | visited_on    | date    |
-- | amount        | int     |
-- +---------------+---------+
-- (customer_id, visited_on) is the primary key for this table.
-- This table contains data about customer transactions in a restaurant.
-- visited_on is the date on which the customer with ID (customer_id) have visited the restaurant.
-- amount is the total paid by a customer.
 

-- You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).

-- Write an SQL query to compute moving average of how much customer paid in a 7 days window (current day + 6 days before) .

-- The query result format is in the following example:

-- Return result table ordered by visited_on.

-- average_amount should be rounded to 2 decimal places, all dates are in the format ('YYYY-MM-DD').

 

-- Customer table:
-- +-------------+--------------+--------------+-------------+
-- | customer_id | name         | visited_on   | amount      |
-- +-------------+--------------+--------------+-------------+
-- | 1           | Jhon         | 2019-01-01   | 100         |
-- | 2           | Daniel       | 2019-01-02   | 110         |
-- | 3           | Jade         | 2019-01-03   | 120         |
-- | 4           | Khaled       | 2019-01-04   | 130         |
-- | 5           | Winston      | 2019-01-05   | 110         | 
-- | 6           | Elvis        | 2019-01-06   | 140         | 
-- | 7           | Anna         | 2019-01-07   | 150         |
-- | 8           | Maria        | 2019-01-08   | 80          |
-- | 9           | Jaze         | 2019-01-09   | 110         | 
-- | 1           | Jhon         | 2019-01-10   | 130         | 
-- | 3           | Jade         | 2019-01-10   | 150         | 
-- +-------------+--------------+--------------+-------------+

-- Result table:
-- +--------------+--------------+----------------+
-- | visited_on   | amount       | average_amount |
-- +--------------+--------------+----------------+
-- | 2019-01-07   | 860          | 122.86         |
-- | 2019-01-08   | 840          | 120            |
-- | 2019-01-09   | 840          | 120            |
-- | 2019-01-10   | 1000         | 142.86         |
-- +--------------+--------------+----------------+

-- 1st moving average from 2019-01-01 to 2019-01-07 has an average_amount of (100 + 110 + 120 + 130 + 110 + 140 + 150)/7 = 122.86
-- 2nd moving average from 2019-01-02 to 2019-01-08 has an average_amount of (110 + 120 + 130 + 110 + 140 + 150 + 80)/7 = 120
-- 3rd moving average from 2019-01-03 to 2019-01-09 has an average_amount of (120 + 130 + 110 + 140 + 150 + 80 + 110)/7 = 120
-- 4th moving average from 2019-01-04 to 2019-01-10 has an average_amount of (130 + 110 + 140 + 150 + 80 + 110 + 130 + 150)/7 = 142.86



Table Creation Script:
create table customer 
(customer_id int,
name varchar(50),
visited_on date,
amount int)

insert into customer (customer_id,name,visited_on,amount)
values(1,'Jhon','2019-01-01',100)

insert into customer (customer_id,name,visited_on,amount)
values(2,'Daniel','2019-01-02',110)

insert into customer (customer_id,name,visited_on,amount)
values(3,'Jade','2019-01-03',120)

insert into customer (customer_id,name,visited_on,amount)
values(4,'Khaled','2019-01-04',130)

insert into customer (customer_id,name,visited_on,amount)
values(5,'Winston','2019-01-05',110)

insert into customer (customer_id,name,visited_on,amount)
values(6,'Elvis','2019-01-06',140)

insert into customer (customer_id,name,visited_on,amount)
values(7,'Anna','2019-01-07',150)

insert into customer (customer_id,name,visited_on,amount)
values(8,'Maria','2019-01-08',80)

insert into customer (customer_id,name,visited_on,amount)
values(9,'Jaze','2019-01-09',110)

insert into customer (customer_id,name,visited_on,amount)
values(1,'Jhon','2019-01-10',130)

insert into customer (customer_id,name,visited_on,amount)
values(3,'Jade','2019-01-10',150)


With Window Function:

select 
visited_on,
sum(amount) over(order by visited_on rows between 6 preceding and current row) as amount,
round(avg(cast(amount as float)) over(order by visited_on rows between 6 preceding and current row),2) as average_amount
from 
(select visited_on,sum(amount) as amount
from customer
group by visited_on
) cust
order by visited_on offset 6 rows

--offset 6 rows means it will skip first 6 rows after ordering as we need only average for previous 6 days....5 days average,4 days average,3 days average,2 days average,1 day average are ignored
--Before applying round function in ms sql, we have to cast it to float to get the appropriate result
--we cannot use 'range between' function for 6 preceding and current row in mssql...it is applicable only for unbounded preceding and current row
--There are duplicate dates '2019-01-10' in table.Hence we applied group by to make it unique,then applied rolling average on the top of it

Without Window Function:

select cust1.visited_on,sum(cust2.amount) as amount,round(avg(cast(cust2.amount as float)),2) as average_amount
from (select visited_on,sum(amount) as amount
from customer
group by visited_on) cust1 cross join (select visited_on,sum(amount) as amount
from customer
group by visited_on) cust2
where cust2.visited_on between dateadd(dd,-6,cust1.visited_on) and cust1.visited_on
group by cust1.visited_on
order by visited_on offset 6 rows



