-- Question 67
-- Table: Products

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | new_price     | int     |
-- | change_date   | date    |
-- +---------------+---------+
-- (product_id, change_date) is the primary key of this table.
-- Each row of this table indicates that the price of some product was changed to a new price at some date.
 

-- Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

-- The query result format is in the following example:

-- Products table:
-- +------------+-----------+-------------+
-- | product_id | new_price | change_date |
-- +------------+-----------+-------------+
-- | 1          | 20        | 2019-08-14  |
-- | 2          | 50        | 2019-08-14  |
-- | 1          | 30        | 2019-08-15  |
-- | 1          | 35        | 2019-08-16  |
-- | 2          | 65        | 2019-08-17  |
-- | 3          | 20        | 2019-08-18  |
-- +------------+-----------+-------------+

-- Result table:
-- +------------+-------+
-- | product_id | price |
-- +------------+-------+
-- | 2          | 50    |
-- | 1          | 35    |
-- | 3          | 10    |
-- +------------+-------+

Table Creation Script:
create table products(product_id int,new_price int,change_date date);

insert into products(product_id,new_price,change_date)
values(1,20,'2019-08-14')

insert into products(product_id,new_price,change_date)
values(2,50,'2019-08-14')

insert into products(product_id,new_price,change_date)
values(1,30,'2019-08-15')

insert into products(product_id,new_price,change_date)
values(1,35,'2019-08-16')

insert into products(product_id,new_price,change_date)
values(2,65,'2019-08-17')

insert into products(product_id,new_price,change_date)
values(3,20,'2019-08-18')

Solution:
with product_rank as ( select product_id,new_price from (select product_id,new_price ,
rank() over(partition by product_id order by change_date desc) as rnk 
from products
where change_date<='2019-08-16')qry where rnk=1),
distinct_products as (select distinct product_id from products)
select 
dp.product_id,coalesce(new_price,10) as price
from product_rank pr right join distinct_products dp
on pr.product_id=dp.product_id
order by new_price desc

--use dp.product_id instead of pr.product_id as pr.product_id is null
--Filter the latest price in common table expression instead of main query. If we filter in the main query we will lose the product_id:3

Alternate solution(Without Using Window Function):

with product_rank as (select p2.product_id,p2.change_date,p2.new_price from 
(select product_id,max(change_date) as max_date from products 
where change_date<='2019-08-16' group by product_id) p1 join products p2 on p1.max_date=p2.change_date and p1.product_id=p2.product_id),
distinct_products as (select distinct product_id from products)

select 
dp.product_id,coalesce(new_price,10) as price
from product_rank pr right join distinct_products dp
on pr.product_id=dp.product_id
order by new_price desc


--if we use max() over window function ,for every window we get max date and it is difficult to get price for max date
--We have use group by product_id,get the max date ...for that max_date,get the price with self join.. 
--when we are doing self join we have to join it by change_date and product_id,then only we get exact records




