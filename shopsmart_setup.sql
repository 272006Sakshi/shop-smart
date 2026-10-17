-- Run the script in pgAdmin Query Tool
-- It creates four tables and inserts a small, fictional dataset.

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    order_status VARCHAR(20) NOT NULL
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL
);

INSERT INTO customers VALUES
(1, 'Aarav Sharma', 'Delhi', '2025-01-10'),
(2, 'Priya Singh', 'Mumbai', '2025-01-15'),
(3, 'Rohan Verma', 'Bengaluru', '2025-02-02'),
(4, 'Ananya Das', 'Kolkata', '2025-02-18'),
(5, 'Kabir Khan', 'Delhi', '2025-03-05'),
(6, 'Meera Iyer', 'Chennai', '2025-03-22'),
(7, 'Ishaan Patel', 'Mumbai', '2025-04-01'),
(8, 'Sara Thomas', 'Hyderabad', '2025-04-14'),
(9, 'Dev Malhotra', 'Pune', '2025-05-09'),
(10, 'Nisha Roy', 'Kolkata', '2025-05-20'),
(11, 'Vikram Joshi', 'Jaipur', '2025-06-11'),
(12, 'Tara Kapoor', 'Delhi', '2025-06-25');

INSERT INTO products VALUES
(101, 'Wireless Mouse', 'Accessories', 799.0),
(102, 'Mechanical Keyboard', 'Accessories', 2499.0),
(103, 'USB-C Hub', 'Accessories', 1599.0),
(104, '27-inch Monitor', 'Electronics', 14999.0),
(105, 'Laptop Stand', 'Accessories', 1299.0),
(106, 'Bluetooth Speaker', 'Electronics', 2999.0),
(107, 'Webcam', 'Electronics', 2199.0),
(108, 'Notebook Set', 'Stationery', 299.0);

INSERT INTO orders VALUES
(1001, 1, '2025-07-01', 'Delivered'),
(1002, 2, '2025-07-03', 'Delivered'),
(1003, 3, '2025-07-05', 'Delivered'),
(1004, 1, '2025-07-18', 'Delivered'),
(1005, 4, '2025-08-02', 'Delivered'),
(1006, 5, '2025-08-04', 'Cancelled'),
(1007, 6, '2025-08-09', 'Delivered'),
(1008, 7, '2025-08-12', 'Shipped'),
(1009, 2, '2025-08-20', 'Delivered'),
(1010, 8, '2025-09-01', 'Delivered'),
(1011, 9, '2025-09-03', 'Returned'),
(1012, 3, '2025-09-10', 'Delivered'),
(1013, 10, '2025-09-12', 'Delivered'),
(1014, 11, '2025-09-19', 'Processing'),
(1015, 12, '2025-10-01', 'Delivered'),
(1016, 4, '2025-10-04', 'Delivered'),
(1017, 5, '2025-10-08', 'Delivered'),
(1018, 1, '2025-10-10', 'Shipped'),
(1019, 7, '2025-10-12', 'Delivered'),
(1020, 2, '2025-10-15', 'Delivered');

INSERT INTO order_items VALUES
(1, 1001, 101, 1, 799),
(2, 1001, 108, 2, 299),
(3, 1002, 104, 1, 14999),
(4, 1003, 102, 1, 2499),
(5, 1003, 103, 1, 1599),
(6, 1004, 106, 1, 2999),
(7, 1005, 107, 2, 2199),
(8, 1006, 104, 1, 14999),
(9, 1007, 105, 1, 1299),
(10, 1007, 108, 3, 299),
(11, 1008, 101, 2, 799),
(12, 1009, 103, 1, 1599),
(13, 1009, 106, 1, 2999),
(14, 1010, 104, 1, 14999),
(15, 1010, 105, 1, 1299),
(16, 1011, 102, 1, 2499),
(17, 1012, 107, 1, 2199),
(18, 1012, 101, 1, 799),
(19, 1013, 108, 5, 299),
(20, 1014, 106, 2, 2999),
(21, 1015, 104, 1, 14999),
(22, 1015, 103, 1, 1599),
(23, 1016, 105, 2, 1299),
(24, 1017, 102, 1, 2499),
(25, 1017, 101, 1, 799),
(26, 1018, 107, 1, 2199),
(27, 1019, 106, 1, 2999),
(28, 1019, 108, 2, 299),
(29, 1020, 104, 1, 14999),
(30, 1020, 103, 1, 1599);


-- expected row counts are customers=12, products=8, orders=20, order_items=30.
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;
