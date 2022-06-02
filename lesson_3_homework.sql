--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. 
Вывести: класс и число потопленных кораблей.

select class, count (t1.ship) as quantity
from ships t0
join outcomes t1 on t0.name = t1.ship 
where result = 'sunk'
group by class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. 
Вывести: класс, год.

with head_ship as
(select class, launched as "year"
from ships 
where class = name),
min_launched as
(select class, min (launched) as "year"
from ships 
group by class)

select distinct t0.class,
case when t2."year" is not null 
then t2."year"
else t1."year"
end as "year"
from ships t0
full outer join min_launched t1 on t0.class = t1.class
full outer join head_ship t2 on t0.class = t2.class


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, 
вывести имя класса и число потопленных кораблей.

select class, count (ship) from outcomes t0
join ships t1 on t0.ship =t1."name" 
where result = 'sunk'
and t1.class in 
(select class from (
select class, count(name) as q from ships 
group by class) t
where q>=3)
group by t1.class

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения 
(учесть корабли из таблицы Outcomes).

select t0.name, x."max_numGuns"
from ships t0
join (
select displacement, class, max (numGuns) as "max_numGuns"
from classes
group by displacement, class
)x on t0."class" =x."class" 

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM 
и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
with x as (
select model, speed, ram from pc
where ram = (select min(ram) from pc)
)

select maker, model
from product 
where type = 'Printer'
and model in (
select model from x
where speed = (select max(speed) from x)
)