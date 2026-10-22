-- review tables
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

-- Ques 1. Show all delivered orders, sorted from newest to oldest.
SELECT * FROM orders
WHERE order_status = 'Delivered'
ORDER BY order_date DESC;

--Ques 2. List all products in the Accessories category priced above ₹1,000.
SELECT product_name, category, unit_price FROM products
WHERE category='Accessories' AND unit_price>1000;

--Ques 3. Count how many orders exist for each order_status.
SELECT COUNT(order_id) AS order_count, order_status 
FROM orders
GROUP BY order_status;

-- ques 4. Calculate the total quantity sold for each product. Include the product name.
SELECT
    p.product_name,
    COALESCE(SUM(oi.quantity), 0) AS total_quantity
FROM products AS p
LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity DESC;

-- ques 5. Calculate total revenue from delivered orders. Revenue is quantity multiplied by unit_price.
SELECT
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered';

-- ques 6. Calculate delivered revenue by product category, highest first.
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items AS oi
JOIN products AS p
    ON oi.product_id = p.product_id
JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY total_revenue DESC;

-- ques 7. Count distinct customers who placed at least one delivered order.
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
WHERE order_status = 'Delivered';

-- ques 8. For each order, calculate its total order value. Show only delivered orders, highest value first.
SELECT
    oi.order_id,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items AS oi
JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY oi.order_id
ORDER BY revenue DESC;

-- Ques 9. Classify each order as `Completed` if delivered, `In Progress` if shipped or processing, and `Not Completed` otherwise. Return order ID, status, and classification.
SELECT order_id,
    order_status,
    CASE
        WHEN order_status = 'Delivered' THEN 'Completed'
        WHEN order_status IN ('Shipped', 'Processing') THEN 'In Progress'
        ELSE 'Not Completed'
    END AS classification
FROM orders;

-- ques 10. Show every customer's name and city, along with their number of delivered orders—including customers who have zero delivered orders.
SELECT
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS delivered_orders
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY delivered_orders DESC;

-- ques 11. Find the top 3 products by delivered revenue.
SELECT p.product_name, 
    SUM(oi.quantity*p.unit_price) AS revenue
FROM products AS p
JOIN order_items AS oi 
    ON p.product_id = oi.product_id
JOIN orders AS o 
    ON oi.order_id = o.order_id
WHERE o.order_status='Delivered'
GROUP BY  p.product_id, p.product_name 
ORDER BY revenue DESC
LIMIT 3;

-- ques 12. Find customers who have placed more than one delivered order.
SELECT c.customer_id, c.customer_name, 
    COUNT(o.order_id) AS delivered_order 
FROM customers AS c
JOIN orders AS o 
    ON c.customer_id=o.customer_id 
WHERE o.order_status='Delivered'
GROUP BY c.customer_id, c.customer_name 
    HAVING COUNT(o.customer_id)>1
ORDER BY delivered_order DESC;

-- ques 13. Calculate average delivered order value. Count each order once.
SELECT ROUND(AVG(order_value),2) AS average_order_value
FROM (
    SELECT
        oi.order_id,
        SUM(oi.quantity * oi.unit_price) AS order_value
    FROM order_items AS oi
    JOIN orders AS o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY oi.order_id
) AS order_totals;


-- ques 14. Find each city's delivered revenue, highest first.

SELECT c.city, SUM(oi.quantity*oi.unit_price) AS revenue
FROM customers AS c
join orders AS o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON oi.order_id=o.order_id
WHERE o.order_status='Delivered'
GROUP BY c.city
ORDER BY revenue DESC;

-- Ques 15. Show products that have no delivered sales.
SELECT p.product_name
FROM products AS p
LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
LEFT JOIN orders AS o
    ON oi.order_id = o.order_id
    AND o.order_status = 'Delivered'
WHERE o.order_id IS NULL;


-- CTE
-- ques 16. Use a CTE to calculate delivered revenue per order, then return orders worth more than ₹5,000.
with delivered_order_revenue AS(
    SELECT oi.order_id, SUM(oi.quantity*oi.unit_price) AS revenue
	FROM order_items AS oi
	JOIN orders AS o 
	ON oi.order_id = o.order_id
	WHERE o.order_status='Delivered'
	GROUP BY oi.order_id
) 
SELECT order_id FROM delivered_order_revenue
WHERE revenue>5000

-- Ques 17. Use a CTE to calculate monthly delivered revenue.
SELECT
    DATE_TRUNC('month', o.order_date) AS revenue_month,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items AS oi
JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY revenue_month ASC;

-- ques 18. Use a CTE to calculate revenue per product, then rank products within each category using `DENSE_RANK()` or `ROW_NUMBER()`.
WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products AS p
    JOIN order_items AS oi
        ON p.product_id = oi.product_id
    JOIN orders AS o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.product_id, p.product_name, p.category
)
SELECT
    product_name,
    category,
    revenue,
    ROW_NUMBER() OVER (
        PARTITION BY category
        ORDER BY revenue DESC
    ) AS product_rank
FROM product_revenue
ORDER BY category, product_rank;

-- ques 19. Use a CTE to calculate each customer's delivered order count, then label customers as `Repeat` (2+ delivered orders) or `One-time/No delivered orders`.
WITH delivered_order AS (
    SELECT
        customer_id,
        COUNT(*) AS delivered_count
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(d.delivered_count, 0) AS delivered_count,
    CASE
        WHEN COALESCE(d.delivered_count, 0) >= 2 THEN 'Repeat'
		WHEN COALESCE(d.delivered_count, 0) = 1 THEN 'One-time'
        ELSE 'No delivered orders'
    END AS customer_type
FROM customers AS c
LEFT JOIN delivered_order AS d
    ON c.customer_id = d.customer_id
ORDER BY delivered_count DESC;


-- 20. What percentage of all customers have at least one delivered order?
SELECT
    COUNT(DISTINCT o.customer_id) * 100.0
    / COUNT(c.customer_id) AS percentage
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered';

-- 21. Which delivered orders contain more than one distinct product?

SELECT DISTINCT oi.order_id
FROM order_items AS oi 
JOIN orders AS o
ON o.order_id=oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY oi.order_id
HAVING COUNT(DISTINCT oi.product_id) > 1;

-- 22. Compare delivered revenue with revenue from all order statuses. Explain why the two figures differ.
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM customers;
SELECT * FROM order_items;

--delivered revenue
SELECT SUM(oi.quantity*oi.unit_price) AS delivered_revenue
FROM order_items AS oi
JOIN orders AS o 
ON oi.order_id=o.order_id
WHERE order_status='Delivered'

--revenue from all order statuses
SELECT SUM(oi.quantity*oi.unit_price) AS revenue
FROM order_items AS oi
JOIN orders AS o 
ON oi.order_id=o.order_id

-- The first query counts revenue only from Delivered orders, whereas the second includes Delivered, Cancelled, Shipped, Returned, and Processing orders.
-- Therefore, the second figure will generally be higher because it includes orders that aren't completed sales. The exact difference depends on the data.

-- 23. Find the second-highest product by delivered revenue without hardcoding the product name.
SELECT p.product_name, p.product_id, SUM(oi.quantity*oi.unit_price) AS delivered_revenue
FROM order_items AS oi
JOIN orders AS o 
ON oi.order_id=o.order_id
JOIN products AS p
ON oi.product_id=p.product_id
WHERE order_status='Delivered'
GROUP BY p.product_name, p.product_id
ORDER BY delivered_revenue DESC
LIMIT 1
OFFSET 1;

