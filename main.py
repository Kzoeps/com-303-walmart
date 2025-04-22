import mysql.connector

from config import DB_USER, DB_PASSWORD, DB_NAME

cnx = mysql.connector.connect(
    user=DB_USER,
    password=DB_PASSWORD,
    host="127.0.0.1",
    database=DB_NAME,)

cursor = cnx.cursor()


# test query

cursor.execute("SELECT customer_id, first_name, last_name, contact_number FROM Customer;")
rows = cursor.fetchall()

# Print out each customer record
for customer_id, first_name, last_name, contact_number in rows:
    print(f"{customer_id}: {first_name} {last_name} — {contact_number}")