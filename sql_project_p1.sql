CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

select * from retail_sales

select count(*) from retail_sales

--check for null values for all  columns
--Data Cleaning

select * from retail_sales
where transactions_id is null

select * from retail_sales
where sale_date is null

select * from retail_sales
where sale_time is null

select * from retail_sales
where customer_id is null

select * from retail_sales
where gender is null

select * from retail_sales
where age is null

select * from retail_sales
where category is null

select * from retail_sales
where quantity is null

select * from retail_sales
where price_per_unit is null

select * from retail_sales
where cogs is null

select * from retail_sales
where total_sale is null

--we can show all where any single column is null also by using this

select * from retail_sales
where 
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

--we can delete this rows

delete from retail_sales
where
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

--How many Sales we have
select count(*) as total_sales from retail_sales

--How many customers we have
select count(distinct customer_id) as total_customers from retail_sales

--how many category we have
select count(distinct category) from retail_sales;
select distinct category from retail_sales

--data analysis and buisness key problems

--1) write a sql query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales 
where sale_date = '2022-11-05'

--2) write a sql query to retrieve all tranactions where the category is clothing and the quantity sold is more than 10 in nov-2022

select * from retail_sales where
sale_date between '2022-11-01' and '2022-11-30'
and category = 'Clothing' and quantity > 3
--another way
select * from retail_sales where
to_char(sale_date, 'YYYY-MM')='2022-11'
and category = 'Clothing' and quantity > 3

--3)write a sql query to calculate the total sales for each category
select category,sum(total_sale) from retail_sales 
group by category

--4) write a sql query to find the avg age of customers who purchased the item from the beauty category
select round(avg(age)::numeric,2) from retail_sales where category='Beauty'

--5) write a sql query to find all the tranactions where total sale is greater than 1000
select * from retail_sales where total_sale>1000

--6) write a sql query to find the total number of transactions made by each gender in each category
select gender,category,count(*) from retail_sales
group by gender,category

--7) write a sql query to find the avg sale for each month and find out best selling month in each year
select to_char(sale_date,'YYYY-MM') as m_y,round(avg(total_sale)::numeric,2) 
from retail_sales group by m_y order by m_y

--we can also do this by
select extract(year from sale_date) as year,
extract(month from sale_date) as month,
round(avg(total_sale)::numeric,2) 
from retail_sales group by year,month
order by year,month

--for the best month just order the avg sale in des
select extract(year from sale_date) as year,
extract(month from sale_date) as month,
round(avg(total_sale)::numeric,2) as avg_sales 
from retail_sales group by year,month
order by year,avg_sales desc

--this is not possible with the first approach in first we can only order by avg_sale
--but we want only the frist row for 2022 and first row for 2023

--one method is we can use offset and other is rank so using rank
select * from
(select extract(year from sale_date) as year,
extract(month from sale_date) as month,
round(avg(total_sale)::numeric,2) as avg_sales,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank --cant use the alias one in this 
from retail_sales group by year,month)
where rank=1

--8)write a sql query to find top 5 customers based on the highest total sales
select customer_id,sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5

--9)write a sql query to find the number of unique customers who purchased items for each category
select customer_id from retail_sales 
group by customer_id having count(category)=3

--10)write a sql query to create each shift and number of orders(example morning <12 afternoon between 12 and 17,evening >17)
with hourly_sale as
(select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	End as shift
from retail_sales
)

select shift,count(*) as total_orders
from hourly_sale group by shift



