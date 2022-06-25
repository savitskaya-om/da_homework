--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select case when grade<8 then NULL else name end as name, t1. grade, marks 
from Students t0 left join Grades t1 on t0.marks between t1.min_mark and t1.max_mark order by grade desc, name asc;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem
select doctor,professor,singer,actor from 
(select * from 
(select Name, occupation, (ROW_NUMBER() OVER (PARTITION BY occupation ORDER BY name)) as row_num 
from occupations order by name asc) 
pivot 
( min(name) for occupation in ('Doctor' as doctor,'Professor' as professor,'Singer' as singer,'Actor' as actor)) order by row_num)t;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct city from station where city not like 'A%' and city not like 'E%' AND city not like 'I%' and city not like 'O%' and city not like 'U%';

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem
select distinct city from station where city not like '%a' and city not like '%e' AND city not like '%i' and city not like '%o' and city not like '%u' ;

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem
select distinct city from station where (city not like '%a' and city not like '%e' AND city not like '%i' and city not like '%o' and city not like '%u') or (city not like 'A%' and city not like 'E%' AND city not like 'I%' and city not like 'O%' and city not like 'U%');

--task6  (lesson9)
-- oracle:https://www.hackerrank.com/challenges/weather-observation-station-12/problem
select distinct city from station where (city not like '%a' and city not like '%e' AND city not like '%i' and city not like '%o' and city not like '%u') and (city not like 'A%' and city not like 'E%' AND city not like 'I%' and city not like 'O%' and city not like 'U%');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select name from Employee where months < 10 and salary > 2000 order by employee_id asc;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select case when grade<8 then NULL else name end as name, t1. grade, marks 
from Students t0 left join Grades t1 on t0.marks between t1.min_mark and t1.max_mark order by grade desc, name asc;
