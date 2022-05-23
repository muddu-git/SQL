-- Question 64
-- Table: Books

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | book_id        | int     |
-- | name           | varchar |
-- | available_from | date    |
-- +----------------+---------+
-- book_id is the primary key of this table.
-- Table: Orders

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | order_id       | int     |
-- | book_id        | int     |
-- | quantity       | int     |
-- | dispatch_date  | date    |
-- +----------------+---------+
-- order_id is the primary key of this table.
-- book_id is a foreign key to the Books table.
 

-- Write an SQL query that reports the books that have sold less than 10 copies in the last year, excluding books that have been available for less than 1 month from today. Assume today is 2019-06-23.

-- The query result format is in the following example:

-- Books table:
-- +---------+--------------------+----------------+
-- | book_id | name               | available_from |
-- +---------+--------------------+----------------+
-- | 1       | "Kalila And Demna" | 2010-01-01     |
-- | 2       | "28 Letters"       | 2012-05-12     |
-- | 3       | "The Hobbit"       | 2019-06-10     |
-- | 4       | "13 Reasons Why"   | 2019-06-01     |
-- | 5       | "The Hunger Games" | 2008-09-21     |
-- +---------+--------------------+----------------+

-- Orders table:
-- +----------+---------+----------+---------------+
-- | order_id | book_id | quantity | dispatch_date |
-- +----------+---------+----------+---------------+
-- | 1        | 1       | 2        | 2018-07-26    |
-- | 2        | 1       | 1        | 2018-11-05    |
-- | 3        | 3       | 8        | 2019-06-11    |
-- | 4        | 4       | 6        | 2019-06-05    |
-- | 5        | 4       | 5        | 2019-06-20    |
-- | 6        | 5       | 9        | 2009-02-02    |
-- | 7        | 5       | 8        | 2010-04-13    |
-- +----------+---------+----------+---------------+

-- Result table:
-- +-----------+--------------------+
-- | book_id   | name               |
-- +-----------+--------------------+
-- | 1         | "Kalila And Demna" |
-- | 2         | "28 Letters"       |
-- | 5         | "The Hunger Games" |
-- +-----------+--------------------+

Table Creation Script:
create table books(book_id int,name varchar(100),available_from date)
insert into books(book_id,name,available_from)
values(1,'Kalila And Demna','2010-01-01')

insert into books(book_id,name,available_from)
values(2,'28 Letters','2012-05-12')

insert into books(book_id,name,available_from)
values(3,'The Hobbit','2019-06-10')

insert into books(book_id,name,available_from)
values(4,'13 Reasons Why','2019-06-01')

insert into books(book_id,name,available_from)
values(5,'The Hunger Games','2008-09-21')

create table book_orders(order_id int,book_id int,quantity int,dispatch_date date)

insert into book_orders (order_id,book_id,quantity,dispatch_date)
values(1,1,2,'2018-07-26')

insert into book_orders (order_id,book_id,quantity,dispatch_date)
values(2,1,1,'2018-11-05')

insert into book_orders (order_id,book_id,quantity,dispatch_date)
values(3,3,8,'2019-06-11')

insert into book_orders (order_id,book_id,quantity,dispatch_date)
values(4,4,6,'2019-06-05')

insert into book_orders (order_id,book_id,quantity,dispatch_date)
values(5,4,5,'2019-06-20')

insert into book_orders (order_id,book_id,quantity,dispatch_date)
values(6,5,9,'2009-02-02')

insert into book_orders (order_id,book_id,quantity,dispatch_date)
values(7,5,8,'2010-04-13')


Query:

with book as 
(select * from books
where available_from < dateadd(month,-1,'2019-06-23')),
orders as
(select * from book_orders
where dispatch_date>dateadd(year,-1,'2019-06-23'))

select b.book_id,b.name from 
book b join orders o on b.book_id=o.order_id
group by b.book_id,b.name
having sum(quantity)<10

--dateadd is for adding or subtract months,years,days from date
--cassume current date='2019-06-23'
--cte alias should be different from table alias
--filter the individual tables and join them which is part of optimization


