 -- 1) Retrieving total number of orders placed
 Select COUNT(order_id) as total_orders from orders;



 -- 2) Calculating the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;



-- 3) Identifying the highest-priced pizza.
Select pizza_types.name, pizzas.price from
pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc 
LIMIT 1;



-- 4) Identifying the most common pizza size ordered.
Select pizzas.size , count(order_details.order_details_id) as ordered
from order_details JOIN pizzas
on order_details.pizza_id = pizzas.pizza_id
Group by pizzas.size
Order by ordered desc
LIMIT 1;



-- 5) The top 5 most ordered pizza types along with their quantities.
 Select pizza_types.name, sum(order_details.quantity) as total_count
 from pizza_types join pizzas 
 on pizza_types.pizza_type_id=pizzas.pizza_type_id
 join order_details
 on order_details.pizza_id = pizzas.pizza_id
 group by pizza_types.name
 order by total_count desc
 LIMIT 5;



-- 6) Finding the total quantity of each pizza category ordered.
Select pizza_types.category , sum(order_details.quantity) as count
from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
Group by pizza_types.category
order by count desc;



-- 7) Distribution of orders by hour of the day.
Select hour(order_time) as hour, count(order_id) as order_count from orders
group by hour
order by hour;



-- 8) Category-wise distribution of pizzas.
Select category, count(name) from pizza_types
group by category;



-- 9) Grouping the orders by date and calculating the average number of pizzas ordered per day.
Select avg(count_order) from 
(Select orders.order_date, sum(order_details.quantity) as count_order
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity; 



 -- 9) The top 3 most ordered pizza types based on revenue.
Select pizza_types.name , SUM(order_details.quantity*pizzas.price) as revenue from
pizza_types JOIN pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
on pizzas.pizza_id= order_details.pizza_id
group by pizza_types.name 
order by revenue desc
LIMIT 3;


-- 10) Percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
  ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
            ROUND(SUM(order_details.quantity * pizzas.price),
                        2) AS total_sales
        FROM
            order_details
                JOIN
            pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;



-- 11) Analyzing the cumulative revenue generated over time.
Select order_date, sum(revenue) over (order by order_date) as cumm_revenue
from 
(Select orders.order_date ,sum(order_details.quantity* pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on order_details.order_id=orders.order_id
group by orders.order_date) as sales; 



-- 12) The top 3 most ordered pizza types based on revenue for each pizza category.
Select name,revenue from 
(Select category,name,revenue,
rank() over (partition by category order by revenue desc) as rn from
(Select pizza_types.category , pizza_types.name, sum(order_details.quantity* pizzas.price) as revenue
from pizza_types JOIN pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
on pizzas.pizza_id= order_details.pizza_id
group by pizza_types.category, pizza_types.name) as sales) as sales_1
where rn<=3;
