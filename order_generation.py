import random
from datetime import datetime
from record_sale import record_sale
import mysql.connector
from config import DB_USER, DB_PASSWORD, DB_NAME


def get_db_connection():
    return mysql.connector.connect(
        host="127.0.0.1",
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
    )


# Pull usable data from DB
def fetch_data():
    cnx = get_db_connection()
    cursor = cnx.cursor()

    cursor.execute(
        "SELECT customer_id, first_name, last_name, contact_number, store_id FROM Customer"
    )
    customers = cursor.fetchall()

    cursor.execute(
        """
        SELECT c.store_id, c.upc, c.price
        FROM Carries c
        JOIN Product p ON c.upc = p.upc
    """
    )
    product_info = cursor.fetchall()

    cursor.close()
    cnx.close()
    return customers, product_info


def generate_orders(num_orders=10, base_transaction_id=9010):
    customers, product_info = fetch_data()
    grouped_products = {}
    for store_id, upc, price in product_info:
        grouped_products.setdefault(store_id, []).append((upc, price))

    for i in range(num_orders):
        customer = random.choice(customers)
        customer_id, fname, lname, phone, store_id = customer

        terminal_id = random.randint(1, 5)
        employee_id = random.randint(100, 999)
        payment_id = base_transaction_id + i
        transaction_id = base_transaction_id + i
        payment_method = random.choice(["cash", "card"])

        possible_products = grouped_products.get(store_id)
        if not possible_products:
            continue

        product_sample = random.sample(possible_products, k=random.randint(1, 3))
        items = []
        total_amount = 0
        for pid, price in product_sample:
            qty = random.randint(1, 3)
            total_amount += qty * price
            items.append((pid, qty, price))

        customer_info = (customer_id, fname, lname, phone)

        record_sale(
            transaction_id=transaction_id,
            customer_info=customer_info,
            employee_id=employee_id,
            store_id=store_id,
            terminal_id=terminal_id,
            payment_info=(payment_id, payment_method, round(total_amount, 2)),
            purchased_items=items,
        )


# Generate 10 test orders
generate_orders(100)
