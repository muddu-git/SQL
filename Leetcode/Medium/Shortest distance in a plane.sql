-- Question 89
-- Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.
 

-- Write a query to find the shortest distance between these points rounded to 2 decimals.
 

-- | x  | y  |
-- |----|----|
-- | -1 | -1 |
-- | 0  | 0  |
-- | -1 | -2 |
 

-- The shortest distance is 1.00 from point (-1,-1) to (-1,2). So the output should be:
 

-- | shortest |
-- |----------|
-- | 1.00     |
 

-- Note: The longest distance among all the points are less than 10000.


Table Creation Script:

create table point_2d(x int,y int)

insert into point_2d(x,y)
values(-1,-1)

insert into point_2d(x,y)
values(0,0)


insert into point_2d(x,y)
values(-1,-2)

Solution:
select cast(min(qry.shortest) as decimal(10,2)) as shortest from 
(select sqrt(power((t2.x-t1.x),2)+power((t2.y-t1.y),2)) as shortest   
from point_2d t1 join point_2d t2
on t1.x!=t2.x or t1.y!=t2.y) qry

--use 'cast' instead of 'round'
--use 'or' instead of 'and'


t1.x- t1.y t2.x t2.y  or_condition      and_condition 
-1	  -1	  -1	-1       no              no
0	     0	-1	-1         yes             yes
-1	  -2	-1	-1         0 or 1=yes      0 and 1=no   
-1	  -1	 0	 0         yes             yes
0	     0	 0	 0         no              no
-1	  -2	 0	 0         yes             yes
-1	  -1	-1	-2         0 or 1=yes      0 and 1=no
0	     0	-1	-2         yes             yes
-1	  -2	-1	-2         no              no



or condition output:
0	0	-1	-1
-1	-2	-1	-1
-1	-1	0	0
-1	-2	0	0
-1	-1	-1	-2
0	0	-1	-2

and condition output:
0	0	-1	-1
-1	-1	0	0
-1	-2	0	0
0	0	-1	-2


--we need to select should not select the rows where point in table 1 not equal to point in table 2
t1.x- t1.y t2.x t2.y
-1	   -1	   -1	-1



