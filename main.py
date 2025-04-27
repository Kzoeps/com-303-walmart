import mysql.connector
from config import DB_USER, DB_PASSWORD, DB_NAME

TEST_QUERY = """
SELECT * FROM Customer 
"""


def get_db_connection():
    """Establishes and returns a new database connection."""
    return mysql.connector.connect(
        user=DB_USER,
        password=DB_PASSWORD,
        host="127.0.0.1",
        database=DB_NAME,
    )


cnx = get_db_connection()
cursor = cnx.cursor()
cursor.execute(TEST_QUERY)
rows = cursor.fetchall()

# print all rows
for row in rows:
    print(row)
