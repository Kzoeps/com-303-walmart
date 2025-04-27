import mysql.connector
from config import DB_USER, DB_PASSWORD, DB_NAME

# 1) connect & cursor
cnx = mysql.connector.connect(
    user=DB_USER,
    password=DB_PASSWORD,
    host="127.0.0.1",
    database=DB_NAME,
)
cursor = cnx.cursor()


# 2) fetch low-stock items + vendor
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

# 3) group into { (store_id,vendor_id): [(prod,qty), …], … }
product_orders = {}
for store_id, vendor_id, product_id, reorder_qty in rows:
    key = (store_id, vendor_id)
    product_orders.setdefault(key, []).append((product_id, reorder_qty))

# 4) prepare our DML
insert_vendor_order_sql = """
INSERT INTO Vendor_Order
  (vendor_id, store_id, fulfilled)
VALUES
  (%s, %s, FALSE);
"""

insert_order_line_sql = """
INSERT INTO Order_Line
  (order_id, product_id, unit_cost, quantity)
SELECT
  %s,               -- new order_id
  vp.product_id,
  vp.quoted_cost,   -- snapshot cost
  %s                -- reorder quantity
FROM Vendor_Product vp
WHERE
  vp.vendor_id = %s
  AND vp.product_id = %s;
"""

# 5) execute headers + lines
try:
    for (store_id, vendor_id), items in product_orders.items():
        # a) insert PO header
        cursor.execute(insert_vendor_order_sql, (vendor_id, store_id))
        order_id = cursor.lastrowid
        print(
            f"✅ Created Vendor_Order {order_id} (store {store_id}, vendor {vendor_id})"
        )

        # b) insert each line
        for product_id, qty in items:
            cursor.execute(
                insert_order_line_sql, (order_id, qty, vendor_id, product_id)
            )
            print(f"   • Line for product {product_id}, qty {qty}")

    # 6) final commit
    cnx.commit()
    print("✔ All orders and lines created successfully.")

except mysql.connector.Error as err:
    cnx.rollback()
    print("❌ Transaction rolled back:", err)

finally:
    cursor.close()
    cnx.close()
