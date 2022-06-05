-- Question 50
-- Write a SQL query to get the nth highest salary from the Employee table.

-- +----+--------+
-- | Id | Salary |
-- +----+--------+
-- | 1  | 100    |
-- | 2  | 200    |
-- | 3  | 300    |
-- +----+--------+
-- For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.

-- +------------------------+
-- | getNthHighestSalary(2) |
-- +------------------------+
-- | 200                    |
-- +------------------------+

Table Insertion Script:
create table employee_sal(Id int,Salary int)
insert into employee_sal(Id,Salary)
values(1,100)
insert into employee_sal(Id,Salary)
values(2,200)
insert into employee_sal(Id,Salary)
values(3,300)


Solution:
create function getNthHighestSalary(@N int) returns INT
as
begin
RETURN(select distinct qry.Salary   from (select Id,Salary,DENSE_RANK() over(order by Salary desc) rnk
from employee_sal) qry 
where qry.rnk=@N);
end

select dbo.getNthHighestSalary(3) as [getNthHighestSalary(3)]


ALTER function getNthHighestSalary(@N int) returns INT
as
begin
RETURN(select DISTINCT Salary from employee_sal as e1
where @N-1=(select count(distinct salary) from employee_sal as e2 where e2.salary> e1.salary));
end

select dbo.getNthHighestSalary(3) as [getNthHighestSalary(3)]




