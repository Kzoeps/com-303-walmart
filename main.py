import mysql.connector
from config import DB_USER, DB_PASSWORD, DB_NAME

# SQL Queries
CARRIES_VENDOR_QUERY = """
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

INSERT_VENDOR_ORDER_SQL = """
INSERT INTO Vendor_Order
  (vendor_id, store_id, fulfilled)
VALUES
  (%s, %s, FALSE);
"""

INSERT_ORDER_LINE_SQL = """
INSERT INTO Order_Line
  (order_id, product_id, unit_cost, quantity)
SELECT
  %s,               -- new order_id
  vp.product_id,
  vp.quoted_cost,
  %s                -- reorder quantity
FROM Vendor_Product vp
WHERE
  vp.vendor_id = %s
  AND vp.product_id = %s;
"""


def get_db_connection():
    """Establishes and returns a new database connection."""
    return mysql.connector.connect(
        user=DB_USER,
        password=DB_PASSWORD,
        host="127.0.0.1",
        database=DB_NAME,
    )


def fetch_low_stock_items(cursor):
    """Fetches all low-stock items along with their vendors."""
    cursor.execute(CARRIES_VENDOR_QUERY)
    return cursor.fetchall()


def group_product_orders(rows):
    """Groups rows into a mapping of (store_id, vendor_id) to list of (product_id, qty)."""
    orders = {}
    for store_id, vendor_id, product_id, reorder_qty in rows:
        orders.setdefault((store_id, vendor_id), []).append((product_id, reorder_qty))
    return orders


def create_vendor_order(cursor, vendor_id, store_id):
    """Inserts a Vendor_Order header and returns the new order_id."""
    cursor.execute(INSERT_VENDOR_ORDER_SQL, (vendor_id, store_id))
    return cursor.lastrowid


def create_order_line(cursor, order_id, vendor_id, product_id, quantity):
    """Inserts a line item into Order_Line for the given order."""
    cursor.execute(INSERT_ORDER_LINE_SQL, (order_id, quantity, vendor_id, product_id))


def process_reorders():
    """Main orchestration: fetches low-stock items, creates orders and lines in a transaction."""
    cnx = get_db_connection()
    cursor = cnx.cursor()
    try:
        rows = fetch_low_stock_items(cursor)
        product_orders = group_product_orders(rows)

        for (store_id, vendor_id), items in product_orders.items():
            order_id = create_vendor_order(cursor, vendor_id, store_id)
            print(
                f"✅ Created Vendor_Order {order_id} (store {store_id}, vendor {vendor_id})"
            )
            for product_id, qty in items:
                create_order_line(cursor, order_id, vendor_id, product_id, qty)
                print(f"   • Line for product {product_id}, qty {qty}")

        cnx.commit()
        print("✔ All orders and lines created successfully.")
    except mysql.connector.Error as err:
        cnx.rollback()
        print("❌ Transaction rolled back:", err)
    finally:
        cursor.close()
        cnx.close()


if __name__ == "__main__":
    process_reorders()
