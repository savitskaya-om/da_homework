select name, class from ships 
where launched>1920

select name, class from ships 
where launched between 1920 and 1942 

select class, count(name) as q from ships
group by class

