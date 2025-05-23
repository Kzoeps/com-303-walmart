-- Most Sold Items 
SELECT
    p.item_name,
    SUM(tli.quantity) AS total_units_sold
FROM
    Transaction_Line_Item tli
    JOIN Product p ON tli.product_id = p.upc
GROUP BY
    p.item_name
ORDER BY
    total_units_sold DESC
LIMIT
    10;

-- List of Customers and their transactions and total amounts for all transactions 
SELECT
    c.first_name,
    c.last_name,
    COUNT(th.transaction_id) AS num_transactions,
    SUM(th.total_amount) AS total_spent
FROM
    Customer c
    JOIN Transaction_Header th ON c.customer_id = th.customer_id
GROUP BY
    c.customer_id;

-- Total revenue by Store
SELECT
    s.store_name,
    SUM(th.total_amount) AS revenue
FROM
    Transaction_Header th
    JOIN Store s ON th.store_id = s.store_id
GROUP BY
    s.store_name
ORDER BY
    revenue DESC;

-- Customer Purchase History 
SELECT
    c.customer_id,
    CONCAT (c.first_name, ' ', c.last_name) AS customer_name,
    th.transaction_id,
    th.datetime,
    p.item_name,
    tli.quantity,
    tli.unit_price,
    tli.line_total
FROM
    Customer c
    JOIN Transaction_Header th ON c.customer_id = th.customer_id
    JOIN Transaction_Line_Item tli ON th.transaction_id = tli.transaction_id
    JOIN Product p ON tli.product_id = p.upc
ORDER BY
    c.customer_id,
    th.datetime DESC;

-- Products below the minimum inventory threshold 
SELECT
    c.store_id,
    s.store_name,
    c.upc AS product_id,
    p.item_name,
    c.quantity,
    c.min_quantity
FROM
    Carries c
    JOIN Product p ON c.upc = p.upc
    JOIN Store s ON c.store_id = s.store_id
WHERE
    c.quantity < c.min_quantity
ORDER BY
    c.store_id,
    c.upc;