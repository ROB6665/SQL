# _____AWESOME CHOCOLATES DATASETS____

select * from geo;
select* from people;
select * from products;
select * from sales;

show tables;
# show all all the tables in the database.

desc table sales;
# Gives a description about the specific table.

select * from sales;
# show you all the data of sales table.

select SaleDate, Amount, customers from sales;
# show you specific columns data from sales table. 

select SaleDate, Amount, Boxes, Amount / Boxes as Amount_per_box from sales;
# this query will return all three columns data including with a new column as amount_per_box which we extracted by calculation.

select * from Sales where Amount > 10000;
# this query will return all the data where amount is more than 1000.

select * from Sales where Amount > 20000 order by Amount desc;
# this query will return all the data by sorting it where amount is more than 20000 in descending order.

select * from  Sales where Geoid = 'g1' order by PID, Amount desc; 
# this query will retur all the data where geoid = 'g1' and sort the PID with amount in descending order.

select * from  Sales where Amount >= 10000 and Saledate > '2022-01-01 00:00:00'; 
# this query will return all the data where amount is more than 10000 and date is greater or equals to '2022-01-01'.

select Saledate, Amount, year(Saledate) as Year from sales where Amount >10000 and year(Saledate) between 2020 and 2022;
# this query will return all the data of saledate, amount where amount is more than 10000 and years are between 2022 to2024.

select * from Sales where boxes >=0 and boxes <= 50;
select * from Sales where boxes between 0 and  50;
# both these queries will return the same output where boxes sales is between 0 to 50.

select Saledate, Amount, Boxes, weekday(saledate) as Week_Day  from sales where weekday(saledate) = 1;
# this query will return all the data where sales were happened on ( 1st day on week) = Monday. 

select * from people; 
# this query will return all the data from the people table.

select * from people where team in ('Delish','Jucies');
# this query will return all the data where teams are 'Delish' or 'Jucies'.

select * from people where salesperson like 'B%';                                # it can be [ Starts with =  B%,    Contains =  %B%,      Ends with =  %B ]
# this query will return all the data where salesperson name starts  from B.

select saledate, amount,
 case 
 when amount <1000 then 'under 1k'
 when amount <5000 then 'under 5k'
 when amount <10000 then 'under 10k'
 else 'expensive'
 end as amount_category
 from sales ;
# this query will return all the data with a new column as amount_category where you can see categories of amount.

select s.SaleDate, s.Amount, p.Salesperson, p.SPID from sales as s 
join people as p on p.SPID = s.SPID;
# this query will return a output where you can see columns from two or more different tables together.

select s.SaleDate, s.Amount, pr.Product 
from sales as s 
left join products as pr on pr.pid = s.pid;
# this query will return columns from different tables and return the values which are presents in left column or matching with right tables.

select s.SaleDate, s.Amount, p.Salesperson, p.SPID, pr.product, p.team 
from sales as s 
join people as p on p.SPID = s.SPID
join products as pr on pr.pid = s.pid;
# this query will return you specific columns from the multiple tables by performing joins.

select s.SaleDate, s.Amount, p.Salesperson, p.SPID, pr.product, p.team 
from sales as s 
join people as p on p.SPID = s.SPID
join products as pr on pr.pid = s.pid
where s.Amount < 500 and p.team = 'Delish';
# this query will return you given columns from the multiple tables with specific condition.

select s.SaleDate, s.Amount, p.Salesperson, p.SPID, pr.product, p.team, g.geo
from sales as s 
join people as p on p.SPID = s.SPID
join products as pr on pr.pid = s.pid
join geo as g on g.geoid = s.geoid 
where s.Amount < 500 and p.team = 'Delish'
and g.geo in ('New Zealand', 'India')
order by Amount desc;
# this query we joins multiple tables together with specific condition.

select geoID, sum(Amount), avg(Amount), sum(boxes)
from sales 
group by geoID;
# this query will makes a group of GeoID and returns the calculation

select g.geo, sum(Amount), avg(Amount), sum(boxes)
from sales as s 
join geo as g on s.geoID = g.geoID 
group by g.geo;
# this query will makes a group of Geo and returns the calculation

select pr.category, p.team, sum(boxes), sum(amount)
from sales as s 
join people as p on p.SPID = s.SPID
join products as pr on pr.pid = s.pid
where p.team = ''
group by pr.category , p.team 
order by pr.category, p.team;
# this query will return category vise total boxes sold and the total amount of the boxes where team is blank = ''.

select pr.product, sum(s.amount) 
from sales as s 
join products as pr on pr.pid = s.pid 
group by pr.product 
order by sum(s.amount) desc
limit 10;
# this query will return top 10 most selling product with the total sales amount.