-- Question 92
-- Table: Traffic

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | activity      | enum    |
-- | activity_date | date    |
-- +---------------+---------+
-- There is no primary key for this table, it may have duplicate rows.
-- The activity column is an ENUM type of ('login', 'logout', 'jobs', 'groups', 'homepage').
 

-- Write an SQL query that reports for every date within at most 90 days from today, 
-- the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

-- The query result format is in the following example:

-- Traffic table:
-- +---------+----------+---------------+
-- | user_id | activity | activity_date |
-- +---------+----------+---------------+
-- | 1       | login    | 2019-05-01    |
-- | 1       | homepage | 2019-05-01    |
-- | 1       | logout   | 2019-05-01    |
-- | 2       | login    | 2019-06-21    |
-- | 2       | logout   | 2019-06-21    |
-- | 3       | login    | 2019-01-01    |
-- | 3       | jobs     | 2019-01-01    |
-- | 3       | logout   | 2019-01-01    |
-- | 4       | login    | 2019-06-21    |
-- | 4       | groups   | 2019-06-21    |
-- | 4       | logout   | 2019-06-21    |
-- | 5       | login    | 2019-03-01    |
-- | 5       | logout   | 2019-03-01    |
-- | 5       | login    | 2019-06-21    |
-- | 5       | logout   | 2019-06-21    |
-- +---------+----------+---------------+

-- Result table:
-- +------------+-------------+
-- | login_date | user_count  |
-- +------------+-------------+
-- | 2019-05-01 | 1           |
-- | 2019-06-21 | 2           |
-- +------------+-------------+
-- Note that we only care about dates with non zero user count.
-- The user with id 5 first logged in on 2019-03-01 so he's not counted on 2019-06-21.


Query:
create table Traffic(user_id int,activity varchar(100),activity_date date)
insert into Traffic(user_id,activity,activity_date)
values(1,'login','2019-05-01')

insert into Traffic(user_id,activity,activity_date)
values(1,'homepage','2019-05-01')

insert into Traffic(user_id,activity,activity_date)
values(1,'logout','2019-05-01')

insert into Traffic(user_id,activity,activity_date)
values(2,'login','2019-06-21')

insert into Traffic(user_id,activity,activity_date)
values(2,'logout','2019-06-21')

insert into Traffic(user_id,activity,activity_date)
values(3,'login','2019-01-01')

insert into Traffic(user_id,activity,activity_date)
values(3,'jobs','2019-01-01')

insert into Traffic(user_id,activity,activity_date)
values(3,'logout','2019-01-01')

insert into Traffic(user_id,activity,activity_date)
values(4,'login','2019-06-21')

insert into Traffic(user_id,activity,activity_date)
values(4,'groups','2019-06-21')

insert into Traffic(user_id,activity,activity_date)
values(4,'logout','2019-06-21')

insert into Traffic(user_id,activity,activity_date)
values(5,'login','2019-03-01')

insert into Traffic(user_id,activity,activity_date)
values(5,'logout','2019-03-01')

insert into Traffic(user_id,activity,activity_date)
values(5,'login','2019-06-21')

insert into Traffic(user_id,activity,activity_date)
values(5,'logout','2019-06-21')

Solution:
select  activity_date as login_date,count(distinct user_id) as user_count
from Traffic 
where DATEDIFF(DAY,activity_date,'2019-06-30')<=90
and activity='login'
and user_id not in(select distinct user_id from Traffic 
where DATEDIFF(DAY,activity_date,'2019-06-30')>90
and activity='login')
group by activity_date

Alternate Solution(Best):
select qry.first_login_date as login_date,count(distinct qry.user_id) as user_count from
(select user_id,min(activity_date) as first_login_date from Traffic 
where activity='login'
group by user_id) qry
where DATEDIFF(DAY,qry.first_login_date,'2019-06-30')<=90
group by qry.first_login_date
order by user_count
