Select gender, SUM(purchase_amount) as revenue
from customer_behavior.customer
group by gender;

Select customer_id, purchase_amount from customer_behavior.customer where discount_applied = 'Yes'
and purchase_amount >= (Select AVG(purchase_amount) from customer_behavior.customer);

Select item_purchased, ROUND(avg(review_rating),2) as "AVG Product Rating" from customer_behavior.customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

Select DISTINCT shipping_type from customer_behavior.customer;

Select shipping_type, ROUND(avg(purchase_amount),2) from customer_behavior.customer
where shipping_type in ('Standard', 'Express')
group by shipping_type;

Select subscription_status, COUNT(customer_id) as total_customers,
ROUND(Avg(purchase_amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
from customer group by subscription_status
order by total_revenue, avg_spend desc;

Select item_purchased,
ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*) * 100, 2) as discount_rate 
from customer
group by item_purchased
order by discount_rate desc
limit 5;

with customer_type as (
Select customer_id, previous_purchases,
CASE WHEN previous_purchases = 1 THEN 'NEW'
	 WHEN previous_purchases BETWEEN 2 AND 10 THEN 'RETURNING'
     ELSE 'LOYAL'
     END AS customer_segment
from customer
)
Select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment;

with item_counts as(
Select item_purchased, category,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category, item_purchased
)
Select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;

Select subscription_status,
COUNT(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;

Select age_group, SUM(purchase_amount) as revenue_contribution
from customer
group by age_group
order by revenue_contribution desc;