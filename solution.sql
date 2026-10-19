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
SELECT p.product_name, SUM(oi.quantity*p.unit_price) AS revenue
FROM products AS p
JOIN order_items AS oi ON p.product_id = oi.product_id
JOIN orders AS o ON oi.order_id = o.order_id
WHERE o.order_status='Delivered'
GROUP BY  p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 3;

-- ques 12. Find customers who have placed more than one delivered order.
SELECT c.customer_id, c.customer_name, 
    COUNT(o.order_id) AS delivered_order FROM customers AS c
JOIN orders AS o
ON c.customer_id=o.customer_id 
WHERE o.order_status='Delivered'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.customer_id)>1
ORDER BY delivered_order DESC;
