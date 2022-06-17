--task1  (lesson6, �������������)
-- SQL: �������� ������� � �������������� ������� (10000 �����, 3 �������, ��� ���� int) � ��������� �� ���������� ������� �� 0 �� 1 000 000. ��������� EXPLAIN �������� � �������� ������� ��������.
explain 
create table random_data as
with tmp(x1, x2, x3) as (
    select cast(random()*10^6 as int) as x1, cast(random()*10^6 as int) as x2, cast(random()*10^6 as int) as x3
	from generate_series(1, 10000)
)
select * from tmp;

--task3  (lesson6)
--������������ �����: ������� ����� ������ �������� (��, ��-�������� ��� ��������), �������� ����� ������� ����. �������: model

with all_products as (
select code, model, price from pc
union all
select code, model, price from printer
union all
select  code, model, price from laptop  
)
select model from all_products 
where price = (select max(price) from all_products)


--task5  (lesson6)
-- ������������ �����: ������� ������� all_products_with_index_task5 ��� ����������� ���� ������ �� ����� code (union all) � ������� ���� (flag) �� ���� > ������������ �� ��������. ����� �������� ��������� (����� ������� �������) �� ������ ��������� �������� � ������� ����������� ���� (price_index). �� ����� price_index ������� ������

create table all_products_with_index_task5 as 
 select product.model, maker, price, type, 
 case  
 when price > (select max(price) from printer) then 1 
 else 0 
 end flag,
row_number() over(partition by type order by price) as price_index
 from  
 (select code, model, price 
 from pc  
 union all 
 select code, model, price 
 from laptop l  
 union all 
 select code, model, price 
 from printer) all_products 
 join product  
 on all_products.model = product.model; 


 create index price_idx on all_products_with_index_task5 (price_index);
