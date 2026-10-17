-- Check If there is a duplicate data
With check_dup as 
(
Select *, Row_number() over (partition by Order_ID) rn
From sales_data
order by Order_ID
)
Select *
From check_dup
where rn >1
;
-- No duplicates

-- Task 1
-- Average net_sale for every Customer Satisfaction in every Channel

Select Channel, Customer_Satisfaction, avg(Net_Sales_INR) avg_net_sale
from sales_data
group by `Channel`, Customer_Satisfaction
Order by Channel
;

-- Task 2 — Most Profitable Product Category
-- Calculate total revenue, total profit, quantity sold, and profit margin for each category.

Select Category, Round(Sum(Net_Sales_INR),2) as total_revenue, sum(quantity) as quantity_sold,
Round(Sum(Profit_INR),2) as total_profit, Round(Round(Sum(Profit_INR),2) / Round(Sum(Net_Sales_INR),2) * 100,2) profit_margin
From sales_data
group by Category
order by total_profit DESC
;

-- Task 3: Regional Sales Analysis
-- Compare average sales across regions and cities.

Select City, Round(Sum(Net_Sales_INR),2) as total_revenue, sum(quantity) as quantity_sold,
Round(Sum(Profit_INR),2) as total_profit, Round(Round(Sum(Profit_INR),2) / Round(Sum(Net_Sales_INR),2) * 100,2) profit_margin
From sales_data
group by City
order by total_profit DESC
;

Select Region, Round(Sum(Net_Sales_INR),2) as total_revenue, sum(quantity) as quantity_sold,
Round(Sum(Profit_INR),2) as total_profit, Round(Round(Sum(Profit_INR),2) / Round(Sum(Net_Sales_INR),2) * 100,2) profit_margin
From sales_data
group by Region
order by total_profit DESC
;

-- Task 4: Product Performance Ranking
-- Rank products within each category based on revenue.
With for_rank as
(
Select Category, Round(Sum(Net_Sales_INR),2) as total_revenue, sum(quantity) as quantity_sold,
Round(Sum(Profit_INR),2) as total_profit, Round(Round(Sum(Profit_INR),2) / Round(Sum(Net_Sales_INR),2) * 100,2) profit_margin
From sales_data
group by Category
order by total_profit DESC
)
Select *,
rank()over(order by total_revenue) as ranking
from for_rank;


-- Task 5: Top 10 Best-Selling Products
-- Rank products by total quantity sold and identify the top 10
With Top_products as
(
Select Subcategory, Sum(quantity) as total_quantity_sold
From sales_data
Group by Subcategory
), Top_products2 as
(
Select *, dense_rank() over(order by total_quantity_sold DESC) rank_per_products
From Top_products
)
Select *
From Top_products2
where rank_per_products < 11
;



Select *
From sales_data;









