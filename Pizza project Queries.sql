# Retrieve the total number of orders placed.
select count(order_id) from orders;

# Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(quantity * price), 2) AS Total_revenue
FROM
    order_details O
        JOIN
    pizzas p USING (pizza_id);
    
# Identify the highest-priced pizza.
  Select name, price from pizzas join pizza_types
 using (pizza_type_id)  order by price desc limit 1;
 
 # Identify the most common pizza size ordered.
 Select size, count(order_details_id)as order_count from pizzas p join order_details 
 using (pizza_id) group by size order by order_count desc;
 
 # List the top 5 most ordered pizza types along with their quantities.
Select name, sum(quantity) from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id 
group by name
order by sum(quantity) desc limit 5;

# Join the necessary tables to find the total quantity of each pizza category ordered.
Select category,sum(quantity) as quantity from pizza_types join pizzas
on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by category
order by quantity;
----------------------------------------------------------------------------
Select category,count(quantity) as quantity from pizza_types join pizzas
on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by category
order by quantity;

# Determine the distribution of orders by hour of the day.
Select hour(order_time), count(order_id) as order_count from orders
group by hour(order_time);

# Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name) as count from pizza_types
group by category;
-----------------------------------------------------------------------------------
Select category,count(Order_id) as order_count from pizza_types join pizzas
on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by category;

# Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0)as Avg_pizza_ordered from
(Select Order_date, sum(quantity) as quantity from order_details join orders
on orders.order_id=order_details.Order_id
group by Order_date) as order_quantity;

# Determine the top 3 most ordered pizza types based on revenue.
select name, round((sum(price*quantity))) as Revenue from pizzas join pizza_types
on pizzas.pizza_type_id=pizza_types.pizza_type_id 
join order_details on order_details.pizza_id=pizzas.pizza_id
group by name
order by revenue desc limit 3;

#  Calculate the percentage contribution of each pizza type to total revenue.
select name, round(sum(price*quantity) / (Select round(sum(price*quantity),0)  
from pizzas join order_details on order_details.pizza_id=pizzas.pizza_id)*100,2) as Revenue
from pizzas join pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id 
join order_details on order_details.pizza_id=pizzas.pizza_id
group by name
order by revenue desc;

# Analyze the cumulative revenue generated over time.
select order_date,round(sum(revenue)over( order by order_date),2) as cum_revenue from
(select order_date, round(sum(price*quantity),2) as revenue from orders join order_details 
on orders.order_id=order_details.Order_id join pizzas on pizzas.pizza_id=order_details.pizza_id
group by order_date) as Sales;

# Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, category, revenue from
 (select name, category, revenue,rank() over(partition by category order by revenue desc)as Rnk from
 (Select name, category, round(sum(price*quantity),2) as revenue
 from pizzas join order_details on pizzas.pizza_id=order_details.pizza_id
 join pizza_types on pizza_types.pizza_type_id=pizzas.pizza_type_id
 group by name, category)as a)as b
 where Rnk<=3;
 
