-- Question 90
-- Table: Sales

-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | sale_id     | int   |
-- | product_id  | int   |
-- | year        | int   |
-- | quantity    | int   |
-- | price       | int   |
-- +-------------+-------+
-- sale_id is the primary key of this table.
-- product_id is a foreign key to Product table.
-- Note that the price is per unit.
-- Table: Product

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | product_id   | int     |
-- | product_name | varchar |
-- +--------------+---------+
-- product_id is the primary key of this table.
 

-- Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.

-- The query result format is in the following example:

-- Sales table:
-- +---------+------------+------+----------+-------+
-- | sale_id | product_id | year | quantity | price |
-- +---------+------------+------+----------+-------+ 
-- | 1       | 100        | 2008 | 10       | 5000  |
-- | 2       | 100        | 2009 | 12       | 5000  |
-- | 7       | 200        | 2011 | 15       | 9000  |
-- +---------+------------+------+----------+-------+

-- Product table:
-- +------------+--------------+
-- | product_id | product_name |
-- +------------+--------------+
-- | 100        | Nokia        |
-- | 200        | Apple        |
-- | 300        | Samsung      |
-- +------------+--------------+

-- Result table:
-- +------------+------------+----------+-------+
-- | product_id | first_year | quantity | price |
-- +------------+------------+----------+-------+ 
-- | 100        | 2008       | 10       | 5000  |
-- | 200        | 2011       | 15       | 9000  |
-- +------------+------------+----------+-------+

Table Creation Script:
SET QUOTED_IDENTIFIER ON;
GO
create table product_sales(sale_id int,product_id int,"year" int,quantity int,price int)

insert into product_sales(sale_id,product_id,"year",quantity,price)
values(1,100,2008,10,5000)
insert into product_sales(sale_id,product_id,"year",quantity,price)
values(2,100,2009,12,5000)
insert into product_sales(sale_id,product_id,"year",quantity,price)
values(7,200,2011,15,9000)


create table product(product_id int,product_name varchar(50))
insert into product(product_id,product_name)
values(100,2008,10,5000)
insert into product(product_id,product_name)
values(200,2011,15,9000)


Solution:
SET QUOTED_IDENTIFIER ON;

select product_id,first_year,quantity,price from (select product_id,
"year" as first_year,
quantity,
price,
rank() over(partition by product_id order by "year") as rnk
from product_sales) qry where qry.rnk=1


-- year is reserved keyword...In order to make it as identifier/Column,add double quotes to year and include Quoted_identifier setting
--execute individual statements in table creation script
