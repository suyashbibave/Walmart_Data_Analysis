show databases;
create database walmart_db;
use walmart_db;
show tables;

select * from walmart;
drop table walmart;
select * from walmart;

#Total No of transaction 
select count(*) from walmart;

#How many payment types we have
select distinct payment_method from walmart;

#how many transaction are there in these payment methods
select 
	payment_method,
    count(*)
from walmart
group by payment_method;

#Total no of stores w have
select count(distinct branch)
from walmart;

#Business problems

#find the diffrenet payment method and no of trans, no of quantity sold
select 
	payment_method,
    count(*),
    sum(quantity) as no_qty_sold
from walmart
group by payment_method;

#identiy the higest rated category in each branch, dislaying the branch, categeory avg rating

select version();

SELECT * 
FROM (
    SELECT
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank_pos
    FROM walmart
    GROUP BY branch, category
) AS ranked_data
WHERE rank_pos = 1;


#General Data Exploration
#1. How many unique branches and cities are there in the dataset?

Select 
	count(distinct branch),
    count(distinct city)
    from walmart;
    
#2. What are the top-selling product categories?
select category, sum(total) as total_sales
from walmart
group by category
order by total_sales desc
limit 10;

#3. What is the distribution of payment methods?
select payment_method,
	count(*) as transaction_count
from walmart
group by payment_method
order by transaction_count desc;

#4. What is the average unit price and total sales per category?
select category, avg(unit_price) as avg_unit_price, sum(total) as total_sales
from walmart
group by category
order by total_sales desc;

#5. What is the total revenue by city and branch?
select branch, city, sum(total) as total_sales
from walmart
group by branch, city
order by total_sales desc;

#6. Which branch has the highest sales and profit margin?

select branch, sum(total) as total_sales, sum(profit_margin) as total_profit_margin
from walmart
group by branch
order by total_sales, total_profit_margin desc;


#7. What is the average order value (AOV) across different branches?
select * from walmart;
select branch, 
	sum(total) as total_sales, 
	count(distinct invoice_id) as total_orders,
    (sum(total) / count(distinct invoice_id)) as avg_order_value
from walmart
group by branch
order by avg_order_value desc;
    
# Customer Behaviour and shopping trends
#1. What is the most common payment method used by customers?
select payment_method,
	count(*)
from walmart
group by payment_method;

#2. What is the average quantity purchased per transaction?
select 
	count(distinct invoice_id) as total_orders,
    sum(quantity) as total_quantity,
    (sum(quantity) / count(distinct invoice_id)) as avg_quantity_per_transaction
from walmart;


#3. Which products contribute the most to total revenue?
select 
	category,
    sum(total) as total_sales
from walmart
group by category
order by total_sales desc;