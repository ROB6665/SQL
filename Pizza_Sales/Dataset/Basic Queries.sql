select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

-- BASIC:
-- Q1. Retrieve the total number of orders placed.
SELECT COUNT(*) AS 'Total Orders' FROM orders;

-- Q2. Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(ord.quantity * pz.price), 2) AS 'Total Revenue' 
FROM order_details AS ord
JOIN pizzas AS pz 
ON ord.pizza_id = pz.pizza_id;
    
-- Q3. Identify the highest-priced pizza.
# Method 1:
SELECT * FROM pizzas
WHERE price = (SELECT MAX(price) FROM pizzas);

# Method 2:
select pzt.name as Name , pz.size as Size , pz.price as Price 
from pizza_types as pzt
join pizzas as pz 
on pzt.pizza_type_id = pz.pizza_type_id
order by price desc 
limit 1;

-- Q4. Identify the most popular pizza size ordered.
select pz.size as Size , Sum(ord.quantity) as QTY 
from order_details as ord
join pizzas as pz 
on ord.pizza_id = pz.pizza_id
group by Size
order by QTY desc
limit 1;

-- Q5. List the top 5 most ordered pizza types along with their quantities.
select pzt.name as 'Top 5 Pizzas' , sum(ord.quantity) as QTY 
from order_details as ord 
join pizzas as pz
on ord.pizza_id = pz.pizza_id
join pizza_types as pzt
on pzt.pizza_type_id = pz.pizza_type_id
group by pzt.name
order by QTY desc
limit 5;