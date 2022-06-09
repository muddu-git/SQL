-- Question 83
-- Table: Transactions

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | country       | varchar |
-- | state         | enum    |
-- | amount        | int     |
-- | trans_date    | date    |
-- +---------------+---------+
-- id is the primary key of this table.
-- The table has information about incoming transactions.
-- The state column is an enum of type ["approved", "declined"].
 

-- Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

-- The query result format is in the following example:

-- Transactions table:
-- +------+---------+----------+--------+------------+
-- | id   | country | state    | amount | trans_date |
-- +------+---------+----------+--------+------------+
-- | 121  | US      | approved | 1000   | 2018-12-18 |
-- | 122  | US      | declined | 2000   | 2018-12-19 |
-- | 123  | US      | approved | 2000   | 2019-01-01 |
-- | 124  | DE      | approved | 2000   | 2019-01-07 |
-- +------+---------+----------+--------+------------+

-- Result table:
-- +----------+---------+-------------+----------------+--------------------+-----------------------+
-- | month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
-- +----------+---------+-------------+----------------+--------------------+-----------------------+
-- | 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
-- | 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
-- | 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
-- +----------+---------+-------------+----------------+--------------------+-----------------------+


Table Creation Script:
create table transactions(id int, country varchar(100),state varchar(100),amount int,trans_date date)

insert into  transactions(id,country,state,amount,trans_date)
values(121,'US','approved',1000,'2018-12-18')

insert into  transactions(id,country,state,amount,trans_date)
values(122,'US','declined',2000,'2018-12-19')

insert into  transactions(id,country,state,amount,trans_date)
values(123,'US','approved',2000,'2019-01-01')

insert into  transactions(id,country,state,amount,trans_date)
values(124,'DE','approved',2000,'2019-01-07')

Solution:
select t1.month as month,t1.country,t1.trans_count,t2.approved_count,t1.trans_total_amount,t2.approved_total_amount from
(select format(trans_date,'yyyy-MM') as month, country,count(distinct id) as trans_count,sum(amount) as trans_total_amount
from transactions
group by format(trans_date,'yyyy-MM'),country) t1 join
(select format(trans_date,'yyyy-MM') as month, country,count(distinct id) as approved_count,sum(amount) as approved_total_amount
from transactions 
where state='approved'
group by format(trans_date,'yyyy-MM'),country) t2
on t1.month=t2.month and t1.country=t2.country
order by country desc

--group by should not be applied on column alias
--order by can be applied on column alias

