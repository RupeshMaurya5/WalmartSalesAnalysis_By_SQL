select * from sales;
-- --------------------------------------------------------------------------------------------------------

-- ------------------------------------- Feature Engineering ----------------------------------------------

-- time_of_day

SELECT time,
    (CASE
        WHEN time between '00:00:00' and '12:00:00' THEN 'Morning'
        WHEN time between '12:01:00' and '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM sales;

alter table sales add column time_of_day varchar(20);

update sales
	set time_of_day = (
	CASE
        WHEN time between '00:00:00' and '12:00:00' THEN 'Morning'
        WHEN time between '12:01:00' and '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
	);
-- day_name

select date, to_char(date, 'Day') from sales;

alter table sales add column day_name varchar(10)

update sales
set day_name = (to_char(date, 'Day'));

-- month_name

select date, to_char(date, 'Month') from sales;

alter table sales add column month_name varchar(10)

update sales
set month_name = (to_char(date, 'Month'));

-- ---------------------------------------------------------------------------------------------------
-- --------------------------------------- Generic -------------------------------------------------------------
-- How many unique cities does the data have?
select distinct city from sales;

-- In which city is each branch?
select distinct branch, city from sales
order by branch asc;

-- ----------------------------------------------------------------------------------------------------
-- -------------------------------- Product -----------------------------------------------------------

-- How many unique product lines does the data have?
select distinct(product_line) from sales;

-- What is the most common payment method?
select  payment_method, count(payment_method) from sales
group by payment_method
order by count desc;

-- What is the most selling product line?
select  product_line, count(product_line) from sales
group by product_line
order by count desc;

-- What is the total revenue by month?
select month_name as month, sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?
select month_name as month, sum(cogs) as cogs from sales
group by month_name
order by cogs desc;

-- What product line had the largest revenue?
select product_line, sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- What is the city with the largest revenue?
select city, sum(total) as total_revenue
from sales
group by city
order by total_revenue desc;

-- What product line had the largest VAT?
select product_line, avg(vat) as avg_vat
from sales
group by product_line
order by avg_vat desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM sales
GROUP BY product_line;

-- Which branch sold more products than average product sold?
select branch, sum(quantity) as qty 
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?
select gender, product_line, count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- What is the average rating of each product line?
select product_line, round(avg(rating), 2) as avg_rating
from sales
group by product_line
order by avg_rating desc;
-- ------------------------------------------------------------------------------------------------------
-- ------------------------------------ Sales ----------------------------------------------------------- 

-- Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(*) AS total_sales 
FROM sales
WHERE TRIM(day_name) = 'Monday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
select customer_type, sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;
	
-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, round(avg(vat), 2) as avg_vat from sales
	group by city
	order by avg_vat desc;

-- Which customer type pays the most in VAT?
select customer_type, round(avg(vat), 2) as avg_vat
from sales
group by customer_type
order by avg_vat desc;

-- -------------------------------------------------------------------------------------------------
-- ------------------------------------------ Customer -----------------------------------------------

-- How many unique customer types does the data have?
select distinct(customer_type) from sales;

-- How many unique payment methods does the data have?
select distinct(payment_method) from sales;

-- What is the most common customer type?
select customer_type, count(*) from sales
group by customer_type;

-- Which customer type buys the most?
select customer_type, count(*) as cust_cnt
from sales
group by customer_type;

-- What is the gender of most of the customers?
select gender, count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- What is the gender distribution per branch?
select gender, count(*) as gender_cnt
from sales
where branch = 'B'
group by gender
order by gender_cnt desc;

-- Which time of the day do customers give most ratings?
select time_of_day, avg(rating) as avg_rat
from sales
group by time_of_day
order by avg_rat desc;

-- Which time of the day do customers give most ratings per branch?
select time_of_day, avg(rating) as avg_rat
from sales
where branch = 'B'
group by time_of_day
order by avg_rat desc;

-- Which day fo the week has the best avg ratings?
select day_name, avg(rating) as avg_rat
from sales
group by day_name
order by avg_rat desc;

-- Which day of the week has the best average ratings per branch?
select day_name, avg(rating) as avg_rat
from sales
where branch = 'A'
group by day_name
order by avg_rat desc;
