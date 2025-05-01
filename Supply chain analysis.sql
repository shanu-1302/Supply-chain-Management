create database supply_chain;
# Created a supply chain database

# Loaded the excel file into the database
select * from supply_chain_data;

# Identifying the revenue for each product type
select `Product type`,
		sum(`Revenue generated`) as TotalRevenue, 
		round(Sum(`Revenue generated`)*100/(SELECT sum(`Revenue generated`) from supply_chain_data),1) as Revenue_percentage
from supply_chain_data
group by `Product type`
order by TotalRevenue desc;
### Insight: Skincare leads revenue generation, contributing 41.8% of total revenue.

## Identifying the top cities by revenue
select location,
		round(sum(`Revenue generated`),2) as Totalsum
from supply_chain_data
group by location
order by Totalsum desc;
##Insights: Highest Revenue is from Mumbai Location

# Identifying the total number of orders from each location
select location,
		sum(`Order quantities`) as Totalquantity,
        sum(`Order quantities`)*100/(select sum(`Order quantities`) from supply_chain_data) as percentage
from supply_chain_data
group by location
order by Totalquantity desc;
## Insights: Highest number of orders is from Kolkata and chennai with 24% and 22%.

# Identifying the total no of orders from each product type
select `Product type`,
		sum(`Order quantities`) as Totalquantity,
        sum(`Order quantities`)*100/(select sum(`Order quantities`) from supply_chain_data) as percentage
from supply_chain_data
group by `Product type`
order by Totalquantity desc;
## Skincare product type are getting more orders

select sku,
		`product type`,
        sum(`Number of products sold`) as ttl_units_sold
from supply_chain_data
group by sku, `product type`
order by ttl_units_sold desc
limit 10;
## Insights: SKU 10 is the best selling product by quantity

SELECT SKU, 
    sum(`Number of products sold`) as quantity, 
    sum(`Revenue generated`) as totalrevenue, 
    ROUND(sum(`Revenue generated`) /sum( `Number of products sold`), 2) AS ActualPerUnitPrice
FROM supply_chain_data
GROUP BY SKU
ORDER BY ActualPerUnitPrice desc
LIMIT 10;
## Insights: Premium Product is SKU2 -generate the more revenue perunitsold


# Identifying the manufacturing cost for each product type
select `Product type`, round(sum(`Manufacturing costs`),2) as Ttl_manfacturing_cost
from supply_chain_data
group by `Product type`
order by Ttl_manfacturing_cost desc;
## Insight: The skincare product type incurs the highest manufacturing cost, indicating a need for cost optimization or premium pricing strategies in this category.

# Profit Margin Analysis by Product Type
select `Product type`, 
		round(sum(`revenue generated`),2) as ttl_revenue,
		round(sum(costs),2) as Ttt_cost,
		round(sum(`revenue generated`)-sum(costs),2) as profit,
        round((sum(`revenue generated`)-sum(costs))*100/sum(`revenue generated`),2) as profitmargin
from supply_chain_data
group by `Product type`
order by profitmargin desc;
## Insights: Profit Analysis-cosmetic leads profitability


## Revenue Contribution by Transportstion Mode
SELECT 
    `Transportation modes`,
    ROUND(SUM(`Revenue generated`),2) AS TotalRevenue,
    ROUND(SUM(`Revenue generated`) * 100.0 / 
          (SELECT SUM(`Revenue generated`) FROM supply_chain_data), 2) AS Revenue_Percentage
FROM supply_chain_data
GROUP BY `Transportation modes`
ORDER BY TotalRevenue DESC;
## Insights: Highest Revenue is getting through Railway Transportation mode which contributes 28.5%

## Average Lead time for each product type
SELECT `product type`,
	round(avg(`lead times`),0) AS AvgLeadTime
FROM supply_chain_data
GROUP BY `product type`
ORDER BY Avgleadtime desc;
## Insights: Skincare products are slower to deliver while cosmetics deliver faster

### Low Performing Products
SELECT SKU,
	`product type`,
    Availability,
    `stock levels`,
    `Number of products sold`
FROM supply_chain_data
WHERE `Number of products sold`<10
ORDER BY  `stock levels` DESC;
## SKU 2 is the low selling product and Availabitiy is high
## As it the premium product which need to do promotions

SELECT SKU, `Product type`, Availability
FROM supply_chain_data
WHERE Availability < 20
ORDER BY Availability ASC;
## Insight: Low Availabitity products that are risk at out of stock

SELECT SKU,
	`Product type`,
	`Lead times`,
    Availability,
    `Stock levels`
FROM supply_chain_data
where `Lead times`>10 and Availability <10 and `Stock levels`<40
ORDER BY `Lead times` desc, Availability ASC;
## Insights: SKU 43 product might cause supply chain distruption due to dealy in delivery and low availability

## AVG SHIPPING TIME FOR EACH PRODUCT TYPE

SELECT `product type`,
	ROUND(avg(`shipping times`),0) as avgshiptime
FROM supply_chain_data
GROUP BY `product type`
ORDER BY avgshiptime DESC;
## Insights: Cosmetics having more shipping time compare to haircare and skincare product type which may impact customer satisfaction


select `shipping carriers`,
	ROUND(sum(`shipping costs`),2) as ttl_ship_cost,
	avg(`shipping times`) as avg_ship_time
FROM supply_chain_data
GROUP BY `shipping carriers`
ORDER BY ttl_ship_cost DESC;
## Insights: Carrier B Shipping cost is higher becoz they deliver the products faster

SELECT 
	`supplier name`,
	Location,
    avg(`lead time`) as avg_lead_time
FROM supply_chain_data
GROUP BY `Product type`,`supplier name`, Location
ORDER BY `Supplier name` asc,avg_lead_time desc;
    ## Average lead times differ by supplier and location, helping identify delays and improve procurement planning.

SELECT Location,
	sum(`Production Volumes`) as total_prod_vol,
    round(sum(`Production Volumes`)*100/(select sum(`Production Volumes`) from supply_chain_data),2) as Percentage
FROM supply_chain_data
GROUP BY Location
ORDER BY total_prod_vol DESC;
## Insights: Kolkata accounts for the highest production share at 27%, highlighting its key role in the overall supply chain network.

SELECT `Transportation modes`,
	COUNT(*) AS totalshippings,
    avg(`shipping times`) as avg_ship_time,
	ROUND(SUM(`shipping costs`),2) as ttl_ship_cost
FROM supply_chain_data
GROUP BY `Transportation modes`
ORDER BY ttl_ship_cost DESC;
## Road transport is the most used and fastest mode but also the most expensive,
## while Sea is the cheapest but slowest, highlighting a clear trade-off between cost and delivery speed.

SELECT `Supplier name`,
	ROUND(SUM(`Manufacturing costs`),2) as ttl_manufacturing_cost
FROM supply_chain_data
GROUP BY `Supplier name`
ORDER  BY ttl_manufacturing_cost desc;
## Supplier 1 has the highest total manufacturing cost, while supplier 3 has the lowest

SELECT 
    `Supplier name`,
    `Product type`,
    SUM(`Order quantities`) AS total_orders,
    RANK() OVER (PARTITION BY `Supplier name` ORDER BY SUM(`Order quantities`) DESC) AS rank_in_product
FROM supply_chain_data
GROUP BY `Supplier name`, `Product type`
ORDER BY `Supplier name`, rank_in_product;
## identifies and ranks the most ordered product types for each supplier, helping reveal demand patterns and top-performing products per supplier.

SELECT 
	`Inspection results`,
    ROUND(SUM(`Defect rates`),2) AS Defect_rates_sum,
    ROUND(SUM(`Defect rates`)*100/( SELECT SUM(`Defect rates`) FROM supply_chain_data),2) AS Percentage,
    ROUND(AVG(`Defect rates`),2) AS Avg_Defect_rate
FROM supply_chain_data
group by `Inspection results`
ORDER BY Defect_rates_sum desc;
## Most defects are coming from failed and pending inspections, signaling a need for immediate quality control improvements and faster resolution of pending checks.
    
SELECT 
	`Transportation modes`,
    count(*) AS Frequency
FROM supply_chain_data
GROUP BY `Transportation modes`
ORDER BY Frequency desc;
## This data shows that Road transport is the most frequently used mode (29 times), followed closely by Rail (28) and Air (26), while Sea transport is the least used

SELECT 
	`Transportation modes`,
    ROUND(SUM(`lead times`),2) as TTL_lead_time,
    ROUND(SUM(costs),2) as TTL_cost
FROM supply_chain_data
GROUP BY `Transportation modes`
ORDER BY TTL_cost DESC;
##  Road transport has the highest total cost and lead time, making it the most resource-heavy, while sea transport is the most time- and cost-efficient.

SELECT 
	routes,
   ROUND(SUM(`lead times`),2) as TTL_lead_time,
    ROUND(SUM(costs),2) as TTL_cost
FROM supply_chain_data
GROUP BY routes
ORDER BY TTL_cost DESC; 
## Route B has the highest total lead time and cost, followed by Route A, while Route C is the most efficient with the lowest time and cost.

SELECT routes,
		count(*) as freq
from supply_chain_data
group by routes
order by freq desc;
## Route A is the most frequently used, followed by Route B, while Route C is the least utilized, suggesting it's either less preferred or serves fewer shipments.

SELECT `product type`,
	round(avg(`defect rates`),2) as avg_def_rate
FROM supply_chain_data
GROUP BY `Product type`
ORDER BY avg_def_rate desc;
## Haircare has the most defects, followed by skincare, while cosmetics have the least.
## Focus on improving quality checks and production processes for haircare products to reduce defect rates.

SELECT `Inspection Results`,
	ROUND(SUM(`Manufacturing costs`),2) as ttl_manf_cost,
    ROUND(SUM(`Manufacturing costs`)*100/(SELECT SUM(`Manufacturing costs`) FROM SUPPLY_CHAIN_DATA),2) AS Percent
FROM supply_chain_data
GROUP BY `Inspection Results`
ORDER BY Percent desc;
## Failed inspections account for the highest manufacturing cost (39.78%), followed by pending 37.77%)
## Reduce failures and pending inspections to cut manufacturing costs and improve efficiency
## Improve quality control early in the manufacturing process so fewer items fail or stay pending

SELECT 
  `Product type`,
  ROUND(SUM(`Manufacturing costs`)/NULLIF(SUM(`Defect rates`), 0), 2) AS cost_per_defect
FROM supply_chain_data
GROUP BY `Product type`
ORDER BY cost_per_defect ASC;
## Although cosmetics have the lowest defect rate, their cost per defect is highest. Consider optimizing cosmetic production to improve cost-effectiveness.

SELECT 
  `Supplier name`,
  ROUND(AVG(`Defect rates`), 2) AS avg_defect_rate
FROM supply_chain_data
GROUP BY `Supplier name`
ORDER BY avg_defect_rate DESC;
##  Supplier 5 has the highest defect rate and may need process reviews or stricter quality checks
## Supplier 1 shows the best quality with the lowest defect rate 

SELECT 
  routes,
  COUNT(*) AS frequency,
  ROUND(SUM(costs), 2) AS total_cost,
  ROUND(SUM(costs)/COUNT(*), 2) AS cost_per_shipment
FROM supply_chain_data
GROUP BY routes
ORDER BY cost_per_shipment DESC;
 ## Consider investigating Route B for potential inefficiencies

SELECT 
  ROUND(`lead times`, 0) AS rounded_lead_time,
  ROUND(AVG(`Defect rates`), 2) AS avg_defect_rate
FROM supply_chain_data
GROUP BY rounded_lead_time
ORDER BY rounded_lead_time;
## Highest Defect rates was observed in day 11 and day 30,these days may indicate quality issues or production surges that led to more defects.
## Lowest Defect rates was observed in day 15 and day 25, these may represent optimal operating days or successful quality control.








