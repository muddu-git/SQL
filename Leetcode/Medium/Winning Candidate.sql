-- Question 88
-- Table: Candidate

-- +-----+---------+
-- | id  | Name    |
-- +-----+---------+
-- | 1   | A       |
-- | 2   | B       |
-- | 3   | C       |
-- | 4   | D       |
-- | 5   | E       |
-- +-----+---------+  
-- Table: Vote

-- +-----+--------------+
-- | id  | CandidateId  |
-- +-----+--------------+
-- | 1   |     2        |
-- | 2   |     4        |
-- | 3   |     3        |
-- | 4   |     2        |
-- | 5   |     5        |
-- +-----+--------------+
-- id is the auto-increment primary key,
-- CandidateId is the id appeared in Candidate table.
-- Write a sql to find the name of the winning candidate, the above example will return the winner B.

-- +------+
-- | Name |
-- +------+
-- | B    |
-- +------+
-- Notes:

-- You may assume there is no tie, in other words there will be only one winning candidate


Table Creation Script:
create table candidate(id int,name varchar(50))
insert into candidate(id,name)
values(1,'A')

insert into candidate(id,name)
values(2,'B')

insert into candidate(id,name)
values(3,'C')

insert into candidate(id,name)
values(4,'D')

insert into candidate(id,name)
values(5,'E')

create table vote(id int,CandidateId int)
insert into vote(id,CandidateId)
values(1,2)

insert into vote(id,CandidateId)
values(2,4)

insert into vote(id,CandidateId)
values(3,3)

insert into vote(id,CandidateId)
values(4,2)

insert into vote(id,CandidateId)
values(5,5)


Query(without Window Function):
select Name from Candidate where id in 
(select top(1) maxnumber from
(select CandidateId,count(*) maxnumber  from vote group by CandidateId ) 
qry)

-- cannot use order by in inner query
-- limit clause is not there in mssql

Query(With Window Function):
select Name from Candidate where id in 
(select CandidateId from ( select CandidateId,
rank() over(order by cnt desc) as rnk 
from 
(select CandidateId,count(*) cnt  from vote group by CandidateId ) 
qry) qry1 where rnk=1)

Query(using with clause):

with qry 
as
(select CandidateId,count(*) cnt  from vote group by CandidateId),
qry1 as
(select CandidateId,rank() over(order by cnt desc) as rnk from qry)

select Name from Candidate where id in (select CandidateId from qry1 where rnk=1)
