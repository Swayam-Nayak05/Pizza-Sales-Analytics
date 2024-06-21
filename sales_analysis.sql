 -- Retrieve total number of orders placed
 Select COUNT(order_id) as total_orders from orders;
 
 -- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;
    
-- Identify the highest-priced pizza.
Select pizza_types.name, pizzas.price from
pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc 
LIMIT 1;

-- Identify the most common pizza size ordered.
Select pizzas.size , count(order_details.order_details_id) as ordered
from order_details JOIN pizzas
on order_details.pizza_id = pizzas.pizza_id
Group by pizzas.size
Order by ordered desc
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.

 Select pizza_types.name, sum(order_details.quantity) as total_count
 from pizza_types join pizzas 
 on pizza_types.pizza_type_id=pizzas.pizza_type_id
 join order_details
 on order_details.pizza_id = pizzas.pizza_id
 group by pizza_types.name
 order by total_count desc
 LIMIT 5;
 
-- Join the necessary tables to find the total quantity of each pizza category ordered.
Select pizza_types.category , sum(order_details.quantity) as count
from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
Group by pizza_types.category
order by count desc;

-- Determine the distribution of orders by hour of the day.
Select hour(order_time) as hour, count(order_id) as order_count from orders
group by hour
order by hour;

-- find the category-wise distribution of pizzas.
Select category, count(name) from pizza_types
group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
Select avg(count_order) from 
(Select orders.order_date, sum(order_details.quantity) as count_order
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity; 

 -- Determine the top 3 most ordered pizza types based on revenue.
Select pizza_types.name , SUM(order_details.quantity*pizzas.price) as revenue from
pizza_types JOIN pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
on pizzas.pizza_id= order_details.pizza_id
group by pizza_types.name 
order by revenue desc
LIMIT 3;


-- 
