-- Question 54
-- Table: NPV

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | year          | int     |
-- | npv           | int     |
-- +---------------+---------+
-- (id, year) is the primary key of this table.
-- The table has information about the id and the year of each inventory and the corresponding net present value.
 

-- Table: Queries

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | year          | int     |
-- +---------------+---------+
-- (id, year) is the primary key of this table.
-- The table has information about the id and the year of each inventory query.
 

-- Write an SQL query to find the npv of all each query of queries table.

-- Return the result table in any order.

-- The query result format is in the following example:

-- NPV table:
-- +------+--------+--------+
-- | id   | year   | npv    |
-- +------+--------+--------+
-- | 1    | 2018   | 100    |
-- | 7    | 2020   | 30     |
-- | 13   | 2019   | 40     |
-- | 1    | 2019   | 113    |
-- | 2    | 2008   | 121    |
-- | 3    | 2009   | 12     |
-- | 11   | 2020   | 99     |
-- | 7    | 2019   | 0      |
-- +------+--------+--------+

-- Queries table:
-- +------+--------+
-- | id   | year   |
-- +------+--------+
-- | 1    | 2019   |
-- | 2    | 2008   |
-- | 3    | 2009   |
-- | 7    | 2018   |
-- | 7    | 2019   |
-- | 7    | 2020   |
-- | 13   | 2019   |
-- +------+--------+

-- Result table:
-- +------+--------+--------+
-- | id   | year   | npv    |
-- +------+--------+--------+
-- | 1    | 2019   | 113    |
-- | 2    | 2008   | 121    |
-- | 3    | 2009   | 12     |
-- | 7    | 2018   | 0      |
-- | 7    | 2019   | 0      |
-- | 7    | 2020   | 30     |
-- | 13   | 2019   | 40     |
-- +------+--------+--------+

-- The npv value of (7, 2018) is not present in the NPV table, we consider it 0.
-- The npv values of all other queries can be found in the NPV table.

Table Creation Script:
create table NPV(id int,year int,npv int)
insert into NPV(id,year,npv)
values(1,2018,100)

insert into NPV(id,year,npv)
values(7,2020,30)

insert into NPV(id,year,npv)
values(13,2019,40)

insert into NPV(id,year,npv)
values(1,2019,113)

insert into NPV(id,year,npv)
values(2,2008,121)

insert into NPV(id,year,npv)
values(3,2009,12)

insert into NPV(id,year,npv)
values(11,2020,99)

insert into NPV(id,year,npv)
values(7,2019,0)

create table queries(id int,year int)
insert into queries(id,year)
values(1,2019)

insert into queries(id,year)
values(2,2008)

insert into queries(id,year)
values(3,2009)

insert into queries(id,year)
values(7,2018)

insert into queries(id,year)
values(7,2019)

insert into queries(id,year)
values(7,2020)

insert into queries(id,year)
values(13,2019)


Solution:
-- Solution
select q.id, q.year, coalesce(n.npv,0) as npv
from queries q
left join npv n
on q.id = n.id and q.year=n.year
