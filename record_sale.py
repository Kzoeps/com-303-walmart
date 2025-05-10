import mysql.connector
from config import DB_USER, DB_PASSWORD, DB_NAME
from datetime import datetime
import traceback
from decimal import Decimal


def get_db_connection():
    return mysql.connector.connect(
        host="127.0.0.1",
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
    )


# SQL queries
check_customer_sql = """
SELECT customer_id FROM Customer WHERE customer_id = %s;
"""

insert_customer_sql = """
INSERT INTO Customer
(customer_id, first_name, last_name, contact_number, address_id, is_registered, store_id)
VALUES (%s, %s, %s, %s, NULL, TRUE, %s);
"""

insert_payment_sql = """
INSERT INTO Payment
(payment_id, payment_method, amount, payment_date, card_hash, approval_code, is_split_payment)
VALUES (%s, %s, %s, %s, NULL, NULL, FALSE);
"""

insert_transaction_sql = """
INSERT INTO Transaction_Header
(transaction_id, store_id, terminal_id, datetime, employee_id, customer_id, payment_id, payment_type, total_amount, tax_amount, loyalty_points_earned)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
"""

insert_line_item_sql = """
INSERT INTO Transaction_Line_Item
(line_id, transaction_id, product_id, quantity, unit_price, discount_amount, line_total)
VALUES (%s, %s, %s, %s, %s, 0, %s);
"""


def check_or_create_customer(
    cursor, customer_id, first_name, last_name, contact_number, store_id
):
    cursor.execute(check_customer_sql, (customer_id,))
    if not cursor.fetchone():
        cursor.execute(
            insert_customer_sql,
            (customer_id, first_name, last_name, contact_number, store_id),
        )


def calculate_real_tax(cursor, store_id, purchased_items):
    total_tax = 0
    cursor.execute(
        """
        SELECT a.state_name
        FROM Store s
        JOIN Address a ON s.store_id = a.address_id
        WHERE s.store_id = %s;
    """,
        (store_id,),
    )

    result = cursor.fetchone()
    if not result:
        raise ValueError("Store not found or no address linked.")

    state_code = result[0]

    for product_id, quantity, unit_price in purchased_items:
        cursor.execute(
            "SELECT tax_category_id FROM Product WHERE upc = %s;", (product_id,)
        )
        product_row = cursor.fetchone()
        if not product_row:
            continue
        tax_category_id = product_row[0]

        cursor.execute(
            """
            SELECT rate FROM State_Tax_Rate
            WHERE state_code = %s AND tax_category_id = %s AND is_active = TRUE;
        """,
            (state_code, tax_category_id),
        )
        rate_row = cursor.fetchone()

        if rate_row:
            tax_rate = rate_row[0]
            item_tax = Decimal(str(unit_price)) * quantity * tax_rate
            total_tax += item_tax

    return round(total_tax, 2)


def record_sale(
    transaction_id,
    customer_info,
    employee_id,
    store_id,
    terminal_id,
    payment_info,
    purchased_items,
):
    cnx = get_db_connection()
    cursor = cnx.cursor()

    try:
        customer_id, first_name, last_name, contact_number = customer_info
        check_or_create_customer(
            cursor, customer_id, first_name, last_name, contact_number, store_id
        )

        payment_id, payment_method, amount = payment_info
        cursor.execute(
            insert_payment_sql, (payment_id, payment_method, amount, datetime.now())
        )

        total_amount = sum(qty * unit_price for _, qty, unit_price in purchased_items)
        tax_amount = calculate_real_tax(cursor, store_id, purchased_items)
        loyalty_points = int(total_amount // 1)

        cursor.execute(
            insert_transaction_sql,
            (
                transaction_id,
                store_id,
                terminal_id,
                datetime.now(),
                employee_id,
                customer_id,
                payment_id,
                payment_method,
                total_amount,
                tax_amount,
                loyalty_points,
            ),
        )

        cursor.execute("SELECT COALESCE(MAX(line_id), 0) FROM Transaction_Line_Item")
        line_id = cursor.fetchone()[0] + 1

        for product_id, quantity, unit_price in purchased_items:
            line_total = quantity * unit_price
            cursor.execute(
                insert_line_item_sql,
                (line_id, transaction_id, product_id, quantity, unit_price, line_total),
            )
            line_id += 1

        cnx.commit()
        print(" Sale recorded for Transaction", transaction_id)

    except Exception as e:
        cnx.rollback()
        print(" Something went wrong:", e)
        traceback.print_exc()

    finally:
        cursor.close()
        cnx.close()
