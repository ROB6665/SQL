-- Advanced:

use pizza ; 

select * from orders;
select * from order_details;
select * from pizzas;
select * from pizza_types;

-- Q1. Calculate the percentage contribution of each pizza type to total revenue.
# sub query for calculate total revenue generated
select round(sum(pz.price * ord.quantity),0) as total 
from order_details as ord 
join pizzas as pz 
on pz.pizza_id = ord.pizza_id;

select  pt.category as Category , 
concat(round(sum(pz.price * ordt.quantity) / 
(select sum(pz.price * ordt.quantity) as total from order_details as ordt join pizzas as pz on pz.pizza_id = ordt.pizza_id ) *100,0),'%') as Revenue
from pizza_types as pt
join pizzas as pz on pz.pizza_type_id = pt.pizza_type_id
join order_details as ordt on pz.pizza_id = ordt.pizza_id
group by Category
order by Revenue desc;

-- Q2. Analyze the cumulative revenue generated over time.
select order_date, 
sum(Revenue) over(order by order_date) as Cum_Revenue 
from 
(select ord.date as order_date , 
round(sum(ordt.quantity * pz.price ),0)
as Revenue
from order_details as ordt
join pizzas as pz on pz.pizza_id = ordt.pizza_id
join orders as ord on ord.order_id = ordt.order_id
group by order_date ) 
as Daily_Revenue;

select* from orders;
select* from order_details;
select* from pizzas;
select* from pizza_types;


-- Q3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select Name ,Category ,Revenue from
(select Category , Name , Revenue,
rank() over(partition by category order by revenue desc) as Rnk
from
(select pt.category as category , pt.name as Name, 
round(sum(ordt.quantity * pz.price),0) as Revenue 
from order_details as ordt
join pizzas as pz on pz.pizza_id = ordt.pizza_id
join pizza_types as pt on pt.pizza_type_id = pz.pizza_type_id
group by Category, Name
order by Revenue desc) as Cat_Rev) as Pizzas_Revenue
where Rnk <= 3 ;