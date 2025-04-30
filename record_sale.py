import mysql.connector
from config import DB_USER, DB_PASSWORD, DB_NAME
from datetime import datetime
import traceback  # <-- added to show full error messages
from decimal import Decimal


# db connection stuff here
def get_db_connection():
    return mysql.connector.connect(
        host="127.0.0.1",
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
    )

# sql for checking if customer is already in the db
check_customer_sql = """
select customer_id from customer where customer_id = %s;
"""

# sql for adding new customer if needed
insert_customer_sql = """
insert into customer
(customer_id, first_name, last_name, contact_number, address_id, is_registered, store_id)
values
(%s, %s, %s, %s, null, true, %s);
"""

# sql for putting payment into db
insert_payment_sql = """
insert into payment
(payment_id, payment_method, amount, payment_date, card_hash, approval_code, is_split_payment)
values
(%s, %s, %s, %s, null, null, false);
"""

# sql to add the transaction header (basic sale info)
insert_transaction_sql = """
insert into transaction_header
(transaction_id, store_id, terminal_id, datetime, employee_id, customer_id, payment_id, payment_type, total_amount, tax_amount, loyalty_points_earned)
values
(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
"""

# sql to add each product line the customer bought
insert_line_item_sql = """
insert into transaction_line_item
(line_id, transaction_id, product_id, quantity, unit_price, discount_amount, line_total)
values
(%s, %s, %s, %s, %s, 0, %s);
"""

# function that checks if customer exists, or adds them
def check_or_create_customer(cursor, customer_id, first_name, last_name, contact_number, store_id):
    cursor.execute(check_customer_sql, (customer_id,))
    if not cursor.fetchone():
        cursor.execute(insert_customer_sql, (customer_id, first_name, last_name, contact_number, store_id))

# function to calculate correct tax based on products and state
def calculate_real_tax(cursor, store_id, purchased_items):
    total_tax = 0
    cursor.execute("""
        select a.state_name
        from store s
        join address a on s.store_id = a.address_id
        where s.store_id = %s;
    """, (store_id,))

    result = cursor.fetchone()

    if not result:
        raise ValueError("store not found or no address linked.")

    state_code = result[0]

    for product_id, quantity, unit_price in purchased_items:
        cursor.execute("""
            select tax_category_id from product where upc = %s;
        """, (product_id,))
        product_row = cursor.fetchone()
        if not product_row:
            continue
        tax_category_id = product_row[0]

        cursor.execute("""
            select rate from state_tax_rate
            where state_code = %s and tax_category_id = %s and is_active = true;
        """, (state_code, tax_category_id))
        rate_row = cursor.fetchone()

        if rate_row:
            tax_rate = rate_row[0]
            item_tax = Decimal(str(unit_price)) * quantity * tax_rate

            total_tax += item_tax

    return round(total_tax, 2)

# function that does the main recording of a sale
def record_sale(transaction_id, customer_info, employee_id, store_id, terminal_id, payment_info, purchased_items):
    cnx = get_db_connection()
    cursor = cnx.cursor()
    try:
        customer_id, first_name, last_name, contact_number = customer_info
        check_or_create_customer(cursor, customer_id, first_name, last_name, contact_number, store_id)

        payment_id, payment_method, amount = payment_info
        cursor.execute(insert_payment_sql, (payment_id, payment_method, amount, datetime.now()))

        total_amount = sum(qty * unit_price for _, qty, unit_price in purchased_items)
        tax_amount = calculate_real_tax(cursor, store_id, purchased_items)
        loyalty_points = int(total_amount // 1)

        cursor.execute(insert_transaction_sql, (
            transaction_id, store_id, terminal_id, datetime.now(),
            employee_id, customer_id, payment_id, payment_method,
            total_amount, tax_amount, loyalty_points
        ))

        line_id = 1
        for product_id, quantity, unit_price in purchased_items:
            line_total = quantity * unit_price
            cursor.execute(insert_line_item_sql, (
                line_id, transaction_id, product_id, quantity, unit_price, line_total
            ))
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


