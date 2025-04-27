import mysql.connector

from config import DB_USER, DB_PASSWORD, DB_NAME

cnx = mysql.connector.connect(
    user=DB_USER,
    password=DB_PASSWORD,
    host="127.0.0.1",
    database=DB_NAME,
)

cursor = cnx.cursor()


# test query

cursor.execute(
    "SELECT customer_id, first_name, last_name, contact_number FROM Customer;"
)
rows = cursor.fetchall()

# Print out each customer record
for customer_id, first_name, last_name, contact_number in rows:
    print(f"{customer_id}: {first_name} {last_name} — {contact_number}")


# get the products that are low in stock for each store and join it with vendor so that we know which vendor to order from
carries_vendor_query = """
SELECT
  c.store_id,
  vp.vendor_id,
  c.upc           AS product_id,
  (c.max_quantity - c.quantity) AS reorder_qty
FROM Carries AS c
JOIN Vendor_Product AS vp
  ON c.upc = vp.product_id
WHERE c.quantity <= c.min_quantity;
"""

cursor.execute(carries_vendor_query)
rows = cursor.fetchall()
# Print out each product record
product_orders = {}
for store_id, vendor_id, product_id, reorder_quantity in rows:
    key = (store_id, vendor_id)
    if key not in product_orders:
        product_orders[key] = []
    product_orders[key].append((product_id, reorder_quantity))


insert_vendor_order_sql = """
INSERT INTO Vendor_Order
  (vendor_id, store_id, fulfilled)
VALUES
  (%s, %s, FALSE);
"""
# … same logic for fetching lastrowid, inserting lines, and committing …


for (store_id, vendor_id), items in product_orders.items():
    [item_id, reorder_quantity] = items[0]
