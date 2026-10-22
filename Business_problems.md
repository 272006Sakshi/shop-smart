1. Show all delivered orders, sorted from newest to oldest.
2. List all products in the `Accessories` category priced above ₹1,000.
3. Count how many orders exist for each `order_status`.
4. Calculate the total quantity sold for each product. Include the product name.
5. Calculate total revenue from delivered orders.
6. Calculate delivered revenue by product category, highest first.
7. Count distinct customers who placed at least one delivered order.
8. For each order, calculate its total order value. Show only delivered orders, highest value first.
9. Classify each order as `Completed` if delivered, `In Progress` if shipped or processing, and `Not Completed` otherwise. Return order ID, status, and classification.
10. For each customer, show their name, city, and number of delivered orders. Include customers with zero delivered orders.
11. Find the top 3 products by delivered revenue.
12. Find customers who have placed more than one delivered order.
13. Calculate average delivered order value. Count each order once.
14. Find each city's delivered revenue, highest first.
15. Show products that have no delivered sales.
    
### CTEs

16. Use a CTE to calculate delivered revenue per order, then return orders worth more than ₹5,000.
17. Use a CTE to calculate monthly delivered revenue.
18. Use a CTE to calculate revenue per product, then rank products within each category using `DENSE_RANK()` or `ROW_NUMBER()`.
19. Use a CTE to calculate each customer's delivered order count, then label customers as `Repeat` (2+ delivered orders) or `One-time/No delivered orders`.

    
20. What percentage of all customers have at least one delivered order?
21. Which delivered orders contain more than one distinct product?
22. Compare delivered revenue with revenue from all order statuses. Explain why the two figures differ.
23. Find the second-highest product by delivered revenue without hardcoding the product name.
