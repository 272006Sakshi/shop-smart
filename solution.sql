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
