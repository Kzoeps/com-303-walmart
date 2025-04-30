import mysql.connector
from config import DB_USER, DB_PASSWORD, DB_NAME
from vendor_invoice_generation import process_invoice  # Invoice generation routine

# ─── SQL CONSTANTS ─────────────────────────────────────────────────────────────
VIEW_VENDOR_ORDERS_SQL = """
SELECT vo.order_id,
       vo.created_at,
       vo.fulfilled,
       v.vendor_id,
       v.contact_person,
       s.store_id,
       s.store_name,
       COUNT(ol.order_line_id)        AS line_count,
       SUM(ol.quantity * ol.unit_cost) AS order_cost
  FROM Vendor_Order vo
  JOIN Vendor        v  ON vo.vendor_id = v.vendor_id
  JOIN Store         s  ON vo.store_id  = s.store_id
  JOIN Order_Line    ol ON vo.order_id  = ol.order_id
GROUP BY vo.order_id, v.vendor_id, s.store_id
ORDER BY vo.created_at DESC;
"""

CARRIES_VENDOR_QUERY = """
SELECT
  c.store_id,
  vp.vendor_id,
  c.upc AS product_id,
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
  %s, -- new order_id
  vp.product_id,
  vp.quoted_cost,
  %s  -- reorder quantity
FROM Vendor_Product vp
WHERE
  vp.vendor_id = %s
  AND vp.product_id = %s;
"""

FETCH_STORE_SQL = """
SELECT store_id
  FROM Vendor_Order
 WHERE order_id = %s;
"""

FETCH_ORDER_LINES_SQL = """
SELECT product_id, quantity
  FROM Order_Line
 WHERE order_id = %s;
"""

MARK_ORDER_FULFILLED_SQL = """
UPDATE Vendor_Order
   SET fulfilled = TRUE
 WHERE order_id = %s
   AND fulfilled = FALSE;
"""

UPDATE_CARRIES_INVENTORY_SQL = """
UPDATE Carries
   SET quantity = quantity + %s
 WHERE store_id = %s
   AND upc = %s;
"""


# ─── DB CONNECTION ─────────────────────────────────────────────────────────────


def get_db_connection():
    """Establishes and returns a new database connection."""
    return mysql.connector.connect(
        host="127.0.0.1",
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
    )


# ─── REORDER PROCESSING ────────────────────────────────────────────────────────


def fetch_low_stock_items(cursor):
    cursor.execute(CARRIES_VENDOR_QUERY)
    return cursor.fetchall()


def group_product_orders(rows):
    orders = {}
    for store_id, vendor_id, product_id, reorder_qty in rows:
        orders.setdefault((store_id, vendor_id), []).append((product_id, reorder_qty))
    return orders


def create_vendor_order(cursor, vendor_id, store_id):
    cursor.execute(INSERT_VENDOR_ORDER_SQL, (vendor_id, store_id))
    return cursor.lastrowid


def create_order_line(cursor, order_id, vendor_id, product_id, quantity):
    cursor.execute(INSERT_ORDER_LINE_SQL, (order_id, quantity, vendor_id, product_id))


def process_reorders():
    cnx = get_db_connection()
    cursor = cnx.cursor()
    try:
        rows = fetch_low_stock_items(cursor)
        product_orders = group_product_orders(rows)

        if not product_orders:
            print("✅ No low-stock items to reorder.")
            return

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


# VIEW VENDOR ORDERS ------------------------


def view_vendor_orders():
    cnx = get_db_connection()
    cursor = cnx.cursor()
    try:
        cursor.execute(VIEW_VENDOR_ORDERS_SQL)
        rows = cursor.fetchall()
        if not rows:
            print("ℹ️  No vendor orders found.")
            return

        print("\n🗒  Current Vendor Orders")
        print("--------------------------------------------------------------")
        for (
            order_id,
            created_at,
            fulfilled,
            vendor_id,
            contact_person,
            store_id,
            store_name,
            line_count,
            order_cost,
        ) in rows:
            status = "✅ Fulfilled" if fulfilled else "⏳ Open"
            print(
                f"Order {order_id:<4} | {created_at:%Y-%m-%d} | "
                f"Vendor {vendor_id} ({contact_person}) -> "
                f"Store {store_id} ({store_name}) | "
                f"{line_count} lines | ${order_cost:,.2f} | {status}"
            )
    except mysql.connector.Error as err:
        print("❌ Unable to fetch vendor orders:", err)
    finally:
        cursor.close()
        cnx.close()


# ─── FULFILLMENT & INVENTORY BUMP ───────────────────────────────────────────────


def bump_inventory(cursor, order_id):
    cursor.execute(FETCH_STORE_SQL, (order_id,))
    row = cursor.fetchone()
    if not row:
        print(f"⚠️ Order {order_id} not found. No inventory to bump.")
        return
    store_id = row[0]
    print(f"📦 Bumping inventory for Order {order_id} at Store {store_id}...")

    cursor.execute(FETCH_ORDER_LINES_SQL, (order_id,))
    for product_id, quantity in cursor.fetchall():
        cursor.execute(UPDATE_CARRIES_INVENTORY_SQL, (quantity, store_id, product_id))
        print(f"   🔄 Product {product_id}: +{quantity} units")


def fulfill_order(order_id):
    print(f"🚚 Starting fulfillment for Order {order_id}...")
    cnx = get_db_connection()
    cursor = cnx.cursor()
    try:
        cursor.execute(MARK_ORDER_FULFILLED_SQL, (order_id,))
        if cursor.rowcount == 0:
            print(f"⚠️ Order {order_id} already fulfilled or invalid—skipping bump.")
            cnx.commit()
            return

        print(f"Order {order_id} marked as fulfilled.")
        bump_inventory(cursor, order_id)
        cnx.commit()
        print(f"✅ Fulfillment complete for Order {order_id}.")
    except Exception as e:
        cnx.rollback()
        print(f"❌ Failure fulfilling Order {order_id}: {e}")
        raise
    finally:
        cursor.close()
        cnx.close()


def main():
    print("Select an action:")
    print("  1) Reorder low-stock items")
    print("  2) Fulfill an order")
    print("  3) Generate an invoice for an order")
    print("  4) View vendor orders")  # <-- new choice
    choice = input("Enter 1, 2, 3 or 4: ").strip()

    if choice == "1":
        process_reorders()
    elif choice == "2":
        oid = input("Enter the Order ID to fulfill: ").strip()
        if oid.isdigit():
            fulfill_order(int(oid))
        else:
            print("❌ Invalid Order ID.")
    elif choice == "3":
        oid = input("Enter the Order ID to invoice: ").strip()
        if oid.isdigit():
            process_invoice(int(oid))
        else:
            print("❌ Invalid Order ID.")
    elif choice == "4":
        view_vendor_orders()
    else:
        print("❌ Invalid choice. Please run again and enter 1, 2, 3 or 4.")


if __name__ == "__main__":
    main()
