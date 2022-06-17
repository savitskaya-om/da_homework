--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.
explain 
create table random_data as
with tmp(x1, x2, x3) as (
    select cast(random()*10^6 as int) as x1, cast(random()*10^6 as int) as x2, cast(random()*10^6 as int) as x3
	from generate_series(1, 10000)
)
select * from tmp;

--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

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
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) и сделать флаг (flag) по цене > максимальной по принтеру. Также добавить нумерацию (через оконные функции) по каждой категории продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс

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
