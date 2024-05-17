# Create Database 
create database walmart_sales;

# Use Database 
use walmart_sales;

# Create Table 
create table sales 
(
invoice_id varchar(30) primary key,           # Invoice of the sales made
branch varchar(10) not null,                  # Branch at which sales were made 
city varchar(30) not null,                    # The location of the branch 
customer_type varchar(30) not null,           # The type of customer 
gender varchar(10) not null,                  # Gender of the customer making purchase 
product_line varchar(100) not null,           # Product line of the product sold 
unit_price decimal(10,2) not null,            # The price of each product 
quantity int not null,                        # The amount of the product sold 
tax float(6,4) not null,                      # The amount of the tax on the purchase 
total decimal(12,2) not null,                 # # The total cost of the purchase
date date not null,                           # The date on which the purchase was made
time time not null,                           # The time at which the purchase was made
payment_method  varchar(15) not null,         # The total amount paid
cogs decimal(10,2) not null,                  # Cost of the goods sold 
gross_margin float(11,9) not null,            # Gross margin percentage 
gross_income decimal(12,4) not null,          # Gross income 
rating float(2.1) not null                    # Rating 
);

# The sales table is created but its empty right now we will only get the columns name.
select * from sales;

# Now we need to import data into the sales table from the option [ Table import data wizard ].
# The data is imported from CSV file successfully 
Select * from sales;

# Add a column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. This will help us to answer the question on which part of day most sales are made.
# Run a query first to get the correct output.
 select time,
( case 
when time between '00:00:00'and '12:00:00' then 'Morning'
when time between '12:01:00'and '16:00:00' then 'Afternoon'
else 'Evening'
end ) as time_of_date
from sales;

# Add a column as time_of_day 
alter table sales 
add column time_of_day varchar(20);

# Update the values into the time_of_day column 
update sales 
set time_of_day = (
case 
when time between '00:00:00'and '12:00:00' then 'Morning'
when time between '12:01:00'and '16:00:00' then 'Afternoon'
else 'Evening'
end
);

# The time_of_day column is updated in the sales table.
select * from sales;

# In which part of the day we are having highest sales. 
select time_of_day , count(*) as counts from sales
group by time_of_day 
order by counts desc ;

# Add a new column named day_name that contain the extracted day of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.  
# Running query to see the output
select weekday(date) from sales;

# Adding a new column in the sales table called week_day
alter table sales 
add column week_day varchar(5);

# Assigning values in the column according to the day 
update sales 
set week_day = weekday(date);

# Converting the sequence into the weekdays 
update sales 
set week_day = (
case 
when week_day = '0' then 'Mon'
when week_day = '1' then 'Tue'
when week_day = '2' then 'Wed'
when week_day = '3' then 'Thu'
when week_day = '4' then 'Fri'
when week_day = '5' then 'Sat'
when week_day = '6' then 'Sun'
end
);

# In which weekday we are having highest sales
select week_day, count(*) as counts from sales
group by week_day  
order by counts desc ;


# # Add a new column called month_name that contained the month from the date. This will help answer the question on which month the sales are higher.  
# Running query to see the output
select monthname(date) as month_names from sales;

# Adding a new column in the sales table called month_name
alter table sales 
add column month_name varchar(20);

# Assigning values in the column according to the month 
update sales
set month_name = monthname(date);

# In which month we are having highest sales
select * from sales;

#_____________________________________

# Now we will perform EDA on the data.

# Q1. How many unique cities does the data have ?
select distinct city from sales;

# Q2. How many branches we have in each city ?
select distinct branch from sales
order by branch asc;

# Q3. How many product lines we have in the data ?
select count( distinct product_line) as 'Number of Product_line' from sales;

# Q4. What is the common payment method ?
select payment_method, count(*) as Counts from sales
group by payment_method
order by Counts desc 
limit 1;

# Q5. which are the top 3 most selling product line ?
select product_line , count(*) as Counts from sales
group by product_line 
order by Counts desc
limit 3 ;

# Q6. What is the total revenue by months ?
select month_name , sum(total) as Revenue from sales 
group by month_name 
order by Revenue desc;

# Q7. What month had the largest COGS ?
select month_name, count(cogs) as COGS from sales
group by month_name 
order by COGS desc;

# Q8. Which product line had the highest revenue ?
select product_line, sum(total) as Revenue from sales
group by product_line 
order by Revenue desc;

# Q9. Which city had the highest revenue ?
select city, sum(total) as Revenue from sales
group by city 
order by Revenue desc;

# Q10. Which product line had the largest TAX ?
select product_line , sum(tax) as TAX from sales
group by product_line
order by TAX desc
limit 3;

# Q11. Fetch each product line and add a column category and showing 'Good', 'Bad'. Good  if it's greater than average sales.
select product_line,total, 
(case
when total > (select avg(total) from sales) then 'Good'
else 'Bad'
end) as Category
from sales;
 
# Q12. Which branch sold more products than average product sold ?
select branch , avg(quantity) as AVG_product_sold from sales
group by branch 
having AVG_product_sold >= (select avg(quantity)from sales);

# Q13. What is the most common product line by gender ?
select product_line , gender , count(*) as Count from sales
group by product_line, gender
order by product_line,Count desc;

# Q14. What is the average rating of all product line ?
select round(avg(rating),2) as Avg_Rating from sales;
