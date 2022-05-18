-- Question 85
-- Table: Project

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | project_id  | int     |
-- | employee_id | int     |
-- +-------------+---------+
-- (project_id, employee_id) is the primary key of this table.
-- employee_id is a foreign key to Employee table.
-- Table: Employee

-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | employee_id      | int     |
-- | name             | varchar |
-- | experience_years | int     |
-- +------------------+---------+
-- employee_id is the primary key of this table.
 

-- Write an SQL query that reports the most experienced employees in each project. 
-- In case of a tie, report all employees with the maximum number of experience years.

-- The query result format is in the following example:

-- Project table:
-- +-------------+-------------+
-- | project_id  | employee_id |
-- +-------------+-------------+
-- | 1           | 1           |
-- | 1           | 2           |
-- | 1           | 3           |
-- | 2           | 1           |
-- | 2           | 4           |
-- +-------------+-------------+

-- Employee table:
-- +-------------+--------+------------------+
-- | employee_id | name   | experience_years |
-- +-------------+--------+------------------+
-- | 1           | Khaled | 3                |
-- | 2           | Ali    | 2                |
-- | 3           | John   | 3                |
-- | 4           | Doe    | 2                |
-- +-------------+--------+------------------+

-- Result table:
-- +-------------+---------------+
-- | project_id  | employee_id   |
-- +-------------+---------------+
-- | 1           | 1             |
-- | 1           | 3             |
-- | 2           | 1             |
-- +-------------+---------------+
-- Both employees with id 1 and 3 have the 
-- most experience among the employees of the first project. For the second project, the employee with id 1 has the most experience.

Insertion Script:

create table projects
(project_id int,
employee_id int)

insert into project (project_id,employee_id)
values(1,1)

insert into project (project_id,employee_id)
values(1,2)

insert into project (project_id,employee_id)
values(1,3)

insert into project (project_id,employee_id)
values(2,1)

insert into project (project_id,employee_id)
values(2,4)




create table employee(employee_id int,
name varchar(50),
experience_years int)

insert into employee(employee_id,name,experience_years)
values(1,'Khaled',3)

insert into employee(employee_id,name,experience_years)
values(2,'Ali',2)

insert into employee(employee_id,name,experience_years)
values(3,'John',3)

insert into employee(employee_id,name,experience_years)
values(4,'Doe',2)

Query:
select project_id,employee_id from (select project_id,p.employee_id,rank() over(partition by project_id 
order by experience_years desc) as rnk from project p join employee e
on p.employee_id=e.employee_id) qry where qry.rnk=1





