import mysql.connector
from decimal import Decimal
from datetime import date, timedelta
from config import DB_USER, DB_PASSWORD, DB_NAME


def get_db_connection():
    """Establishes and returns a new database connection."""
    return mysql.connector.connect(
        host="127.0.0.1", user=DB_USER, password=DB_PASSWORD, database=DB_NAME
    )


def fetch_vendor_order_lines(cursor, order_id):
    """
    Fetches product_id, quantity, and unit_cost for all line items of a given vendor_order.
    """
    cursor.execute(
        """
        SELECT product_id, quantity, unit_cost
          FROM Order_Line
         WHERE order_id = %s;
    """,
        (order_id,),
    )
    return cursor.fetchall()


def create_invoice_header(
    cursor,
    invoice_number,
    due_date,
    payment_status,
    total_amount,
    vendor_id,
):
    """
    Inserts a new Invoice row and returns the generated invoice_id.
    """
    cursor.execute(
        """
        INSERT INTO Invoice
          (invoice_number, due_date, payment_status, total_amount, vendor_id, transaction_id)
        VALUES
          (%s, %s, %s, %s, %s, NULL);
    """,
        (invoice_number, due_date, payment_status, total_amount, vendor_id),
    )
    return cursor.lastrowid


def create_invoice_line(
    cursor, invoice_id, product_id, quantity, unit_price, tax_applied=0
):
    """
    Inserts a single line item into Invoice_Line_Item.
    """
    cursor.execute(
        """
        INSERT INTO Invoice_Line_Item
          (invoice_id, product_id, quantity, unit_price, tax_applied)
        VALUES
          (%s, %s, %s, %s, %s);
    """,
        (invoice_id, product_id, quantity, unit_price, tax_applied),
    )


def link_invoice_to_vendor_order(cursor, order_id, invoice_id):
    """
    Updates the Vendor_Order to mark it fulfilled and link the invoice.
    """
    cursor.execute(
        """
        UPDATE Vendor_Order
           SET invoice_id = %s
         WHERE order_id = %s;
    """,
        (invoice_id, order_id),
    )


def calculate_total_amount(lines: list[tuple[int, int, Decimal]]) -> Decimal:
    """
    Given a list of (product_id, quantity, unit_cost) tuples,
    return the sum of quantity * unit_cost for each line.
    """
    total = Decimal("0")
    for product_id, quantity, unit_cost in lines:
        line_amount = quantity * unit_cost
        total += line_amount
    return total


"""
Notes:
1, Due date of invoice is 30 days from the issue date.
2. We assume that the quoted_cost is the final cost for the item for now. (if more time we can create a place for the vendor to enter the unit cost for each)
3. There is no shipment_date for now rather we have the fulfilled flag and we assume that an employee will mark an order as fulfilled when it physically arrives at the store
"""


def process_invoice(order_id):
    """
    Orchestrates the invoice creation for a given order_id.
    """
    cnx = get_db_connection()
    cursor = cnx.cursor()
    try:
        cursor.execute(
            "SELECT vendor_id FROM Vendor_Order WHERE order_id = %s;", (order_id,)
        )
        vendor_id = cursor.fetchone()[0]

        lines = fetch_vendor_order_lines(cursor, order_id)
        if not lines:
            raise ValueError(f"No line items found for order {order_id}")

        # Compute total amount
        total_amount = calculate_total_amount(lines)
        # Prepare invoice details
        invoice_number = f"PO{order_id}-{date.today().strftime('%Y%m%d')}"

        issue_date = date.today()
        due_date = issue_date + timedelta(days=30)
        payment_status = "UNPAID"

        # Insert invoice header
        invoice_id = create_invoice_header(
            cursor,
            invoice_number,
            due_date,
            payment_status,
            total_amount,
            vendor_id,
        )
        print(f" Created Invoice {invoice_id} for PO {order_id}")

        # Insert invoice lines
        for product_id, qty, cost in lines:
            create_invoice_line(cursor, invoice_id, product_id, qty, cost)
            print(f"   • Line: product {product_id}, qty {qty}, price {cost}")

        # Link invoice to PO
        link_invoice_to_vendor_order(cursor, order_id, invoice_id)
        print(f" Linked Invoice {invoice_id} to PO {order_id}")

        cnx.commit()
        print(" Invoice processing complete.")

    except Exception as e:
        cnx.rollback()
        print(" Failed to process invoice:", e)

    finally:
        cursor.close()
        cnx.close()


# Test function (replace with a valid order_id in your database)
if __name__ == "__main__":
    test_order_id = 1
    process_invoice(test_order_id)
