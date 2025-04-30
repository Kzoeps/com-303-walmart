from datetime import datetime, timedelta
import mysql.connector
from config import DB_USER, DB_PASSWORD, DB_NAME

def get_db_connection():
    return mysql.connector.connect(
        host="127.0.0.1",
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
    )

# SQLs
insert_online_order_sql = """
insert into online_orders
(order_id, web_id, customer_id, order_date, status, shipping_method, tracking_number, estimated_delivery, actual_delivery)
values
(%s, %s, %s, %s, 'Pending', %s, %s, %s, null);
"""

insert_order_line_item_sql = """
insert into order_line_item
(order_id, product_id, quantity, unit_price, shipping_cost, discount_code)
values
(%s, %s, %s, %s, 0, null);
"""

insert_shipping_sql = """
insert into shipping
(shipping_id, order_id, carrier, service_level, tracking_number, ship_date, delivery_status)
values
(%s, %s, %s, %s, %s, %s, 'Pending');
"""

def make_online_order(order_id, web_id, customer_id, shipping_method, purchased_items):
    cnx = get_db_connection()
    cursor = cnx.cursor()

    try:
        # Tracking + estimated delivery
        tracking_number = f"TRK-{order_id}-{datetime.now().strftime('%Y%m%d')}"
        estimated_delivery = datetime.now().date() + timedelta(days=5)

        # Insert order
        cursor.execute(insert_online_order_sql, (
            order_id, web_id, customer_id, datetime.now(),
            shipping_method, tracking_number, estimated_delivery
        ))

        # Insert items
        for product_id, quantity, unit_price in purchased_items:
            cursor.execute(insert_order_line_item_sql, (
                order_id, product_id, quantity, unit_price
            ))

        # Insert shipping info (hardcoded shipping_id for now)
        shipping_id = 4000 + order_id  # just a dummy logic to create unique shipping_id
        ship_date = datetime.now().date()
        carrier = "UPS"
        service_level = shipping_method

        cursor.execute(insert_shipping_sql, (
            shipping_id, order_id, carrier, service_level, tracking_number, ship_date
        ))

        cnx.commit()
        print(f" Online order {order_id} created successfully.")

    except Exception as e:
        cnx.rollback()
        print(" Failed to create online order:", e)

    finally:
        cursor.close()
        cnx.close()

