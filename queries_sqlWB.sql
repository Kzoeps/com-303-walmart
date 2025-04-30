SELECT 
    p.item_name, 
    SUM(tli.quantity) AS total_units_sold
FROM transaction_line_item tli
JOIN product p ON tli.product_id = p.upc
GROUP BY p.item_name
ORDER BY total_units_sold DESC
LIMIT 10;



SELECT 
    p.item_name, 
    SUM(tli.quantity) AS total_units_sold
FROM transaction_line_item tli
JOIN product p ON tli.product_id = p.upc
GROUP BY p.item_name
ORDER BY total_units_sold DESC
LIMIT 10;




SELECT 
    c.first_name, 
    c.last_name,
    COUNT(th.transaction_id) AS num_transactions,
    SUM(th.total_amount) AS total_spent
FROM customer c
JOIN transaction_header th ON c.customer_id = th.customer_id
GROUP BY c.customer_id;
