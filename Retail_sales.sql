CREATE DATABASE sql_project_p2;

use sql_project_p2;

Create table Retail_sales(
transactions_id	int,
sale_date	date,
sale_time	time,
customer_id int,
gender varchar(50),	
age	int,
category varchar(50),
quantiy Int,
price_per_unit float,
cogs float,	
total_sale float
);
SELECT * FROM sql_project_p2.retail_sales;

-- How many sales we have?
select count(*) as total_sale from retail_sales;  -- 1987

-- How many unique customer we ahve?
select count(DISTINCT customer_id) as total_customer from retail_sales;  -- 155

-- Distint Categories we have?
select DISTINCT category from retail_sales;  -- Clothing,Beauty,Electronics

/*Data Analysis & Business Key Problems & Answers

My Analysis & Findings
Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022
Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
*/

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05.
select * from retail_sales WHERE sale_date = '2022-11-05';  -- 11 sales

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022
select * from retail_sales WHERE category = 'Clothing' and quantiy > 2 and year(sale_date)=2022 and month(sale_date)=11;  -- 29 transaction

-- Q.3 Write a SQL query to calculate the total sales for each category.
SELECT category,SUM(total_sale) as net_sale, COUNT(*) as total_orders FROM retail_sales GROUP BY category;

/*Clothing	309995	698
Beauty	286790	611
Electronics	311445	678 */

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT avg(age) as avg_age FROM retail_sales where category = 'Beauty';  -- 40.4157

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales where total_sale > 1000;  -- 306 Transaction

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender,count(transactions_id) as total_transaction from retail_sales GROUP BY gender;  -- male 975,femail 1012

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
       year,
       month,
    avg_sale
FROM ( SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as ranks
FROM retail_sales
GROUP BY 1, 2) as t1
WHERE ranks = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id,sum(total_sale) as total_sales FROM retail_sales GROUP BY customer_id ORDER BY total_sales DESC LIMIT 5;
    
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,COUNT(DISTINCT customer_id) as un_customer FROM retail_sales GROUP BY 1;    
  
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
ORDER BY total_orders DESC;

-- End of problem.
    






 



