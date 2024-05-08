-- Intermediate:

use pizza;

select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

-- Q1. Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category as Category, Sum(ord.quantity) as Ordered from order_details as ord
join pizzas as pz 
on pz.pizza_id = ord.pizza_id
join pizza_types as pt 
on pz.pizza_type_id = pt.pizza_type_id
group by Category 
order by Ordered desc;

-- Q2. Determine the distribution of orders by hour of the day.
select hour(ord.time) as Hours, count(order_id) as QTY from orders as ord
group by Hours
order by QTY desc; 

-- Q3. Find the category-wise distribution of pizzas.
select pt.category as Category , count(name) as QTY 
from pizza_types as pt
group by Category;

-- Q4. Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(QYT),0) as Average_Pizza_Ordered_Per_Day from
(
select ord.date as Date, sum(ordt.quantity) as QYT 
from order_details as ordt
join orders as ord 
on ordt.order_id = ord.order_id
group by Date
) as Sub_Query;

-- Q5. Determine the top 3 most ordered pizza types based on revenue.
select pt.name as Name ,
round(sum(pz.price * ordt.quantity),0) as Revenue 
from order_details as ordt
join orders as ord on ordt.order_id = ord.order_id
join pizzas as pz on pz.pizza_id = ordt.pizza_id
join pizza_types as pt on pt.pizza_type_id = pz.pizza_type_id
group by Name 
order by Revenue desc
limit 3;