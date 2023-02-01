/*This query creates a temporary table user_orders to store the total number of orders 
for each user in each city. 
The next temporary table, top_users, is created 
by sorting the user_orders table by the number of orders. 
The ranked_users table is created to rank the top_users table. 
Finally, the query selects the percentage of orders contributed by the top 10 users in each city. */
WITH user_orders AS (
  SELECT 
    city, 
    user_id, 
    count(*) as num_orders
  FROM `vasilis-efood2022.main_assessment.orders`
  GROUP BY city, user_id
),
top_users AS (
  SELECT 
    city, 
    user_id, 
    num_orders
  FROM user_orders
  ORDER BY city, num_orders DESC
),
ranked_users AS (
  SELECT 
    city, 
    user_id, 
    num_orders,
    row_number() OVER (PARTITION BY city ORDER BY num_orders DESC) as rank
  FROM top_users
)
SELECT city, 
       sum(num_orders) / 
         (SELECT sum(num_orders) 
          FROM user_orders 
          WHERE city = ranked_users.city) * 100 as percentage
FROM ranked_users
WHERE rank <= 10
GROUP BY city
ORDER BY percentage DESC;
