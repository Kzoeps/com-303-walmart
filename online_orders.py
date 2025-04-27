import mysql.connector
from config import DB_USER, DB_PASSWORD, DB_NAME
from datetime import datetime

# db connection stuff

def get_db_connection():
    return mysql.connector.connect(
        host="127.0.0.1",
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
    )

# sql to make a new online order
insert_online_order_sql = """
insert into online_orders
(order_id, web_id, customer_id, order_date, status, shipping_method, tracking_number, estimated_delivery, actual_delivery)
values
(%s, %s, %s, %s, 'Pending', %s, %s, %s, null);
"""
# sql to add each product the customer bought online
insert_order_line_item_sql = """
insert into order_line_item
(order_id, product_id, quantity, unit_price, shipping_cost, discount_code)
values
(%s, %s, %s, %s, 0, null);
"""

# sql to add shipping details (optional but good to have)
insert_shipping_sql = """
insert into shipping
(shipping_id, order_id, carrier, service_level, tracking_number, ship_date, delivery_status)
values
(%s, %s, %s, %s, %s, %s, 'Pending');
"""

# function to create an online order
def make_online_order(order_id, web_id, customer_id, shipping_method, purchased_items):
    cnx = get_db_connection()
    cursor = cnx.cursor()

    try:
        # insert the main online order
        estimated_delivery = datetime.now().date()
        estimated_delivery = estimated_delivery.replace(day=estimated_delivery.day + 5)  # fake 5 day shipping
        
		# make a basic tracking number without fancy formatting
		today = datetime.now().date()
		tracking_number = "TRK-" + str(order_id) + "-" + str(today)
	

		# Inserting into online_orders
        cursor.execute(insert_online_order_sql, (
            order_id, web_id, customer_id, datetime.now(), shipping_method, tracking_number, estimated_delivery
        ))

        # insert each item the customer ordered
        for product_id, quantity, unit_price in purchased_items:
            cursor.execute(insert_order_line_item_sql, (
                order_id, product_id, quantity, unit_price
            ))

        

    cnx.commit()
    print("Online orders created")
    except:
        cnx.rollback()
        print("Something went wrong - Failed to create online order")


cursor.close()
cnx.close()


