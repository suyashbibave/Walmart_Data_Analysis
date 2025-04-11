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
#Identify the busiest day for each branch based on the number of transactions
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

#Calculate the total quantity of items sold per payment method
SELECT 
    payment_method,
    SUM(quantity) AS no_qty_sold
FROM walmart
GROUP BY payment_method;

#Determine the average, minimum, and maximum rating of categories for each city
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM walmart
GROUP BY city, category;

#Calculate the total profit for each category
SELECT 
    category,
    SUM(unit_price * quantity * profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;

#Categorize sales into Morning, Afternoon, and Evening shifts
SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;

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