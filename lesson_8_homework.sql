--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/
select t.name as Employee, t.salary, d.name as department
from
(select e.*, dense_rank() over (partition by departmentId order by salary desc) as rn
from Employee e)t
join Department d on t.departmentId=d.id
where rn<=3;

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
select member_name, status, amount*unit_price as costs
from FamilyMembers t0
left join Payments t1 on t0.member_id = t1.family_member
where year(date)=2005

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
select name from (
select name, count(name) as count from Passenger group by name)t
where count>1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count from (
select first_name, count(first_name) as count from Student group by first_name)t
where first_name = 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
select count(*) as count from (
select distinct classroom
from Schedule
where date = '2019-09-02')t

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count from (
select first_name, count(first_name) as count from Student group by first_name)t
where first_name = 'Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
select CEILING(avg(age))-1 as age from (
select datediff(current_date, birthday)/365 as age
from FamilyMembers)t

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
select type as good_type_name, sum(costs) as costs from(
select type, t0.amount*t0.unit_price as costs
from Payments t0
left join Goods t1 on t0.good=t1.good_id
where year(t0.date)=2005)t
group by type

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
select min(ceiling(age)-1) as year from(
select datediff(current_date, birthday)/365 as age from Student)t

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
select max(ceiling(age)-1) as max_year from (
select datediff(current_date, birthday)/365 as age
from Student t0
left join Student_in_class t1 on t0.id=t1.student
where t1.class = 10)
t

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
select status, member_name, 
amount*unit_price as costs
from FamilyMembers t0
left join Payments t1 on t0.member_id = t1.family_member
left join Goods t2 on t1.good = t2.good_id
left join GoodTypes t3 on t2.type = t3.good_type_id
where t3.good_type_name = 'entertainment'

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
with t AS 
(select company as id, 
count(company) as count from Trip
group by company)

delete from company where id in (
select id from t 
where count = (select min(count) from t))

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
with t as 
(select classroom, count(classroom) as count
from Schedule
group by classroom)

select classroom from t 
where count = (select max(count) from t)  

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
select last_name from Teacher t0
left join Schedule t1 on t0.id = t1.teacher
left join Subject t2 on t1.subject = t2.id
where t2.name = 'Physical Culture'
order by last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
select * from (select concat(last_name,'.',left(first_name,1),'.', left(middle_name,1),'.') as name from Student)t order by name