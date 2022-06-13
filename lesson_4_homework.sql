--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type
select model, maker, type from product

--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"
select *, 
case when price > (select avg (price) from pc) then 1
else 0
end as flag
from printer 

--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)
select name from ships where class is null

--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����.
select name
from battles 
where date_part('year', "date") not in (select launched from ships)

--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.
select battle
from battles t0 
join outcomes t1 on t0."name" =t1.battle 
join ships t2 on t1.ship = t2."name" 
where t2."class" = 'Kongo'

--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ > 300. �� view ��� �������: model, price, flag
create view all_products_flag_300 as
with all_products as ( 
  select model, price  
  from pc 
    union all   
  select model, price  
  from laptop  
    union all 
  select model, price  
  from printer 
) 
select model, price,
case when price >300 then 1
else 0
end as flag
from all_products;

select * from all_products_flag_300

--task2  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ c������ . �� view ��� �������: model, price, flag

create view all_products_flag_avg_price as
with all_products as ( 
  select model, price  
  from pc 
    union all   
  select model, price  
  from laptop  
    union all 
  select model, price  
  from printer 
) 
select model, price,
case when price > (select avg (price) from all_products) then 1
else 0
end as flag
from all_products;

select * from all_products_flag_avg_price


--task3  (lesson4)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model
with printer_w_price as(
select t0.model, price, maker from printer t0
join product t1 on t0.model = t1.model
)

select model from printer_w_price 
where maker = 'A'
and price > (select avg(price) from printer_w_price where maker in ('D', 'C')) 

--task4 (lesson4)
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

with all_products as ( 
  select model, price  
  from pc 
    union all   
  select model, price  
  from laptop  
    union all 
  select model, price  
  from printer 
),
printer_w_price as(
select t0.model, price, maker from printer t0
join product t1 on t0.model = t1.model
)

select all_products.model
from all_products 
join product  
on all_products.model=product.model 
where maker = 'A'
and price > (select avg(price) from printer_w_price where maker in ('D', 'C') )

--task5 (lesson4)
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)
with all_products as ( 
  select model, price  
  from pc 
    union all   
  select model, price  
  from laptop  
    union all 
  select model, price  
  from printer 
)

select avg (price)
from all_products 
join product  
on all_products.model=product.model 
where maker = 'A'

--task6 (lesson4)
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������. �� view: maker, count
create view count_products_by_makers as
select count (model) as q, maker from product
group by maker 

--task7 (lesson4)
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)
request = """
select * from count_products_by_makers
order by q
"""
df = pd.read_sql_query (request, conn)
fig = px.bar(x=df.maker.to_list(), y =df.q.to_list(), labels = {'x':'maker', 'y':'q'})
fig.show()


--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'
create table printer_updated as
select p.* from printer p
join product p2 on p.model =p2.model 
where p2.maker <> 'D' 

--task9 (lesson4)
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� (�������� printer_updated_with_makers)
create view printer_updated_with_makers as
select t0.*, t1.maker from printer_updated t0
join product t1 on t0.model = t1.model;

select * from printer_updated_with_makers

--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes). �� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)

create view sunk_ships_by_classes as
select count (ship) as "count", 
case when t1."class" is not null then t1."class" 
else '0'
end as "class"
from outcomes t0
join ships t1 on t0.ship =t1."name" 
where t0."result" ='sunk'
group by t1.class;

select * from sunk_ships_by_classes

--task11 (lesson4)
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)
request = """
select * from sunk_ships_by_classes
"""
df = pd.read_sql_query (request, conn)
fig = px.bar(x=df['class'].to_list(), y =df['count'].to_list(), labels = {'x':'class', 'y':'count'})
fig.show()

--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0
create table classes_with_flag as
select *,
case when numguns >=9 then 1
else 0
end as flag
from classes;

select * from classes_with_flag

--task13 (lesson4)
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)
request = """
select country, count(class) from classes 
group by country
order by "count"
"""
df = pd.read_sql_query (request, conn)
fig = px.bar(x=df['country'].to_list(), y =df['count'].to_list(), labels = {'x':'country', 'y':'count'})
fig.show()

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".
select count(name) as "count" 
from ships
where "name" like 'M%' or name like 'O%'

--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.
select count(name) as "count" 
from ships
where "name" like '% %'

--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)
request = """
select launched, count(name) as "count" 
from ships
group by launched 
order by launched
"""
df = pd.read_sql_query (request, conn)
fig = px.bar(x=df['launched'].to_list(), y =df['count'].to_list(), labels = {'x':'year', 'y':'count'})
fig.show()