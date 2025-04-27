import mysql.connector
from config import DB_HOST, DB_USER, DB_PASSWORD, DB_NAME


def execute_sql_file(cursor, filepath):
    """
    Reads a .sql file and splits on ';' to execute each statement.
    """
    with open(filepath, "r") as f:
        sql = f.read()
    statements = sql.split(";")
    for stmt in statements:
        stmt = stmt.strip()
        if stmt:
            cursor.execute(stmt + ";")


def main():
    # Connect to the database
    cnx = mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
    )
    cursor = cnx.cursor()
    try:
        print("Applying schema...")
        execute_sql_file(cursor, "schema.sql")
        print("Schema applied successfully.")

        print("Seeding data...")
        execute_sql_file(cursor, "seed.sql")
        print("Seed data applied successfully.")

        cnx.commit()
        print("All changes committed.")

    except mysql.connector.Error as err:
        print("❌ Error occurred:", err)
        cnx.rollback()
        print("Rolled back changes.")

    finally:
        cursor.close()
        cnx.close()


if __name__ == "__main__":
    main()
