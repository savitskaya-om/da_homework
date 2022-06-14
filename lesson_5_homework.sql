--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- ������������ �����: ������� view (pages_all_products), � ������� ����� ������������ �������� ���� ��������� (�� ����� ���� ��������� �� ����� ��������). �����: ��� ������ �� laptop, ����� ��������, ������ ���� �������

sample:
1 1
2 1
1 2
2 2
1 3
2 3


select code, model, speed, ram, hd, price, screen,page_num,
row_number () over (partition by page_num) as row_num
from (
SELECT *, 
      CASE WHEN num % 2 = 0 THEN num/2 ELSE num/2 + 1 END AS page_num
      FROM (
      SELECT *, ROW_NUMBER() OVER(ORDER BY price DESC) AS num
      FROM Laptop
) X
)y


--task2 (lesson5)
-- ������������ �����: ������� view (distribution_by_type), � ������ �������� ����� ���������� ����������� ���� ������� �� ���� ����������. �����: �������������, ���, ������� (%)
create view distribution_by_type as
select distinct maker, type, 
max_rn/sum(max_rn) over (partition by maker) as "perc"
from 
(
select distinct maker, type, 
max(rn) over (partition by type, maker) as "max_rn"
from 
(
select *,
row_number () over (partition by type, maker) as rn
from product 
order by maker, type
)x
)y
order by maker, type;


--task3 (lesson5)
-- ������������ �����: ������� �� ���� ����������� view ������ - �������� ���������. ������ https://plotly.com/python/histograms/
request = """
select  concat (maker, '_', type) as "maker_type", perc from distribution_by_type
"""
df = pd.read_sql_query (request, conn)
fig = px.pie(values=df.perc, names=df.maker_type)
fig.show()

--task4 (lesson5)
-- �������: ������� ����� ������� ships (ships_two_words), �� �������� ������� ������ �������� �� ���� ����
create table ships_two_words as
select * from ships s where name like '% %';

select * from ships_two_words

--task5 (lesson5)
-- �������: ������� ������ ��������, � ������� class ����������� (IS NULL) � �������� ���������� � ����� "S"

select * from ships 
where name like 'S%'
and class is NULL

--task6 (lesson5)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'C' � ��� ����� ������� (����� ������� �������). ������� model

with printer_upd as 
(
select *, t0.model as "pr_model",
avg(price) over (partition by t0.maker order by t1.price) as avg_pr,
row_number() over (partition by t0.maker order by t1.price desc) as rn
from product t0 
join printer t1 on t0.model = t1.model
)

select pr_model from printer_upd
where maker = 'A' and price >
( select avg_pr from printer_upd
where maker = 'C')
union all
select pr_model from printer_upd where rn<=3 and maker = 'A'