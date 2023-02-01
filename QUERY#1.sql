WITH breakfast_metrics AS (
  SELECT 
    city, 
    AVG(amount) AS breakfast_basket, 
    COUNT(DISTINCT user_id) AS num_breakfast_users, 
    COUNT(order_id) AS num_breakfast_orders 
  FROM 
    `vasilis-efood2022.main_assessment.orders`
  WHERE 
    cuisine = 'Breakfast' 
  GROUP BY 
    city 
), 
total_metrics AS (
  SELECT 
    city, 
    AVG(amount) AS total_basket, 
    COUNT(DISTINCT user_id) AS num_total_users, 
    COUNT(order_id) AS num_total_orders 
  FROM 
    `vasilis-efood2022.main_assessment.orders` 
  GROUP BY 
    city
)
SELECT 
  b.city, 
  b.breakfast_basket, 
  t.total_basket, 
  SUM(b.num_breakfast_orders) / SUM(b.num_breakfast_users) AS breakfast_frequency, 
  SUM(t.num_total_orders) / SUM(t.num_total_users) AS total_frequency,
  --CASE WHEN (b.num_breakfast_orders  > 3) THEN  b.num_breakfast_orders ELSE 0 END/b.num_breakfast_users AS breakfast_users3freq_percentage,
  --CASE WHEN (t.num_total_orders  > 3) THEN  t.num_total_orders ELSE 0 END/t.num_total_users AS total_users3freq_percentage
  --SUM(CASE WHEN b.num_breakfast_orders > 3 THEN 1 END) / COUNT(DISTINCT b.num_breakfast_users) AS breakfast_users3freq_percentage, 
  --SUM(CASE WHEN t.num_total_orders > 3 THEN 1 END) / COUNT(DISTINCT t.num_total_users) AS total_users3freq_percentage
 
  SUM(CASE WHEN b.num_breakfast_orders / b.num_breakfast_users > 3 THEN 1 ELSE 0 END)/COUNT(DISTINCT b.num_breakfast_users) AS breakfast_users3freq_percentage, 
  SUM(CASE WHEN t.num_total_orders / t.num_total_users > 3 THEN 1 ELSE 0 END)/COUNT(DISTINCT t.num_total_users) AS total_users3freq_percentage 
FROM 
  breakfast_metrics b 
  JOIN total_metrics t 
  ON b.city = t.city 
WHERE 
  t.num_total_orders > 1000 
GROUP BY 
  b.city, 
  b.breakfast_basket, 
  t.total_basket
ORDER BY 
  SUM(b.num_breakfast_orders) DESC 
LIMIT 
  5;
