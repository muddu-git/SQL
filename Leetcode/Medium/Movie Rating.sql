-- Question 59
-- Table: Movies

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | movie_id      | int     |
-- | title         | varchar |
-- +---------------+---------+
-- movie_id is the primary key for this table.
-- title is the name of the movie.
-- Table: Users

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | name          | varchar |
-- +---------------+---------+
-- user_id is the primary key for this table.
-- Table: Movie_Rating

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | movie_id      | int     |
-- | user_id       | int     |
-- | rating        | int     |
-- | created_at    | date    |
-- +---------------+---------+
-- (movie_id, user_id) is the primary key for this table.
-- This table contains the rating of a movie by a user in their review.
-- created_at is the user's review date. 
 

-- Write the following SQL query:

-- Find the name of the user who has rated the greatest number of the movies.
-- In case of a tie, return lexicographically smaller user name.

-- Find the movie name with the highest average rating in February 2020.
-- In case of a tie, return lexicographically smaller movie name.

-- Query is returned in 2 rows, the query result format is in the folowing example:

-- Movies table:
-- +-------------+--------------+
-- | movie_id    |  title       |
-- +-------------+--------------+
-- | 1           | Avengers     |
-- | 2           | Frozen 2     |
-- | 3           | Joker        |
-- +-------------+--------------+

-- Users table:
-- +-------------+--------------+
-- | user_id     |  name        |
-- +-------------+--------------+
-- | 1           | Daniel       |
-- | 2           | Monica       |
-- | 3           | Maria        |
-- | 4           | James        |
-- +-------------+--------------+

-- Movie_Rating table:
-- +-------------+--------------+--------------+-------------+
-- | movie_id    | user_id      | rating       | created_at  |
-- +-------------+--------------+--------------+-------------+
-- | 1           | 1            | 3            | 2020-01-12  |
-- | 1           | 2            | 4            | 2020-02-11  |
-- | 1           | 3            | 2            | 2020-02-12  |
-- | 1           | 4            | 1            | 2020-01-01  |
-- | 2           | 1            | 5            | 2020-02-17  | 
-- | 2           | 2            | 2            | 2020-02-01  | 
-- | 2           | 3            | 2            | 2020-03-01  |
-- | 3           | 1            | 3            | 2020-02-22  | 
-- | 3           | 2            | 4            | 2020-02-25  | 
-- +-------------+--------------+--------------+-------------+

-- Result table:
-- +--------------+
-- | results      |
-- +--------------+
-- | Daniel       |
-- | Frozen 2     |
-- +--------------+

-- Daniel and Maria have rated 3 movies ("Avengers", "Frozen 2" and "Joker") but Daniel is smaller lexicographically.
-- Frozen 2 and Joker have a rating average of 3.5 in February but Frozen 2 is smaller lexicographically.

Table Creation Script:
create table movies(movie_id int,title varchar(100))

insert into  movies(movie_id,title)
values(1,'Avengers')

insert into  movies(movie_id,title)
values(2,'Frozen 2')

insert into  movies(movie_id,title)
values(3,'Joker')

Create table users(user_id int,name varchar(100))
insert into users values(1,'Daniel')
insert into users values(2,'Monica')
insert into users values(3,'Maria')
insert into users values(4,'James')

create table movie_rating(movie_id int,user_id int,rating int,created_at date)
insert into movie_rating(movie_id,user_id,rating,created_at)
values(1,1,3,'2020-01-12')

insert into movie_rating(movie_id,user_id,rating,created_at)
values(1,2,4,'2020-02-11')

insert into movie_rating(movie_id,user_id,rating,created_at)
values(1,3,2,'2020-02-12')

insert into movie_rating(movie_id,user_id,rating,created_at)
values(1,4,1,'2020-01-01')

insert into movie_rating(movie_id,user_id,rating,created_at)
values(2,1,5,'2020-02-17')

insert into movie_rating(movie_id,user_id,rating,created_at)
values(2,2,2,'2020-02-01')

insert into movie_rating(movie_id,user_id,rating,created_at)
values(2,3,2,'2020-03-01')

insert into movie_rating(movie_id,user_id,rating,created_at)
values(3,1,3,'2020-02-22')

insert into movie_rating(movie_id,user_id,rating,created_at)
values(3,2,4,'2020-02-25')

Solution:
select * from (select top 1 u.name as results
from movie_rating mr join users u
on mr.user_id=u.user_id
group by u.name
order by count(distinct movie_id) desc,u.name) qry1
union 
select * from (select top 1 m.title as results
from movie_rating mr join movies m
on mr.movie_id=m.movie_id
where year(mr.created_at)=2020 and month(mr.created_at)=2
group by m.title
order by avg(cast(mr.rating as float)) desc,m.title) qry2

Solution(using window Function):
with movie_count as
(select user_id,count(distinct movie_id) cnt from movie_rating group by user_id),
movie_users as
(select u.name,mc.cnt from movie_count mc join users u on mc.user_id=u.user_id),
rank_movies as
(select mu.name,rank() over(order by mu.cnt desc,mu.name) as rnk from movie_users mu),
movie_ratings as
(select m.title,avg(cast(rating as float)) as average from movie_rating mr join movies m
on mr.movie_id=m.movie_id where year(created_at)=2020 and month(created_at)=2 group by m.title),
ratings_rank as
(select mr.title,rank() over(order by average desc,title) as rnk from movie_ratings mr)
select rm.name as results from rank_movies rm where  rm.rnk=1
union
select title as results from ratings_rank where rnk=1

--cast the column to float whenever we have to apply 'avg'
