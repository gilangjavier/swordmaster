# Install Module first: pip install pymysql psycopg2-binary

import pymysql
import psycopg2
import getpass

def create_conn_psql(host, port, dbname, user, password):
    conn = psycopg2.connect(host=host, port=port, dbname=dbname, user=user, password=password)
    return conn

def create_conn_mysql(host, port, user, password, db):
    conn = pymysql.connect(host=host, port=port, user=user, password=password, db=db)
    return conn

def interactive_migration():
    db_type = input("Enter the database type (mysql/psql/cockroachdb): ")

    host = input("Enter the source database host: ")
    port = int(input("Enter the source database port: "))
    dbname = input("Enter the source database name: ")
    user = input("Enter the source database username: ")
    password = getpass.getpass("Enter the source database password: ")

    if db_type == "mysql":
        src_conn = create_conn_mysql(host, port, user, password, dbname)
    elif db_type in ["psql", "cockroachdb"]:
        src_conn = create_conn_psql(host, port, dbname, user, password)
    else:
        print("Unsupported database type.")
        return

    dest_host = input("Enter the destination database host: ")
    dest_port = int(input("Enter the destination database port: "))
    dest_dbname = input("Enter the destination database name: ")
    dest_user = input("Enter the destination database username: ")
    dest_password = getpass.getpass("Enter the destination database password: ")

    if db_type == "mysql":
        dest_conn = create_conn_mysql(dest_host, dest_port, dest_user, dest_password, dest_dbname)
    elif db_type in ["psql", "cockroachdb"]:
        dest_conn = create_conn_psql(dest_host, dest_port, dest_dbname, dest_user, dest_password)
    else:
        print("Unsupported database type.")
        return

    try:
        with src_conn.cursor() as src_cur, dest_conn.cursor() as dest_cur:
            src_cur.execute("SELECT * FROM my_table")
            rows = src_cur.fetchall()

            for row in rows:
                # This assumes that the destination table has the same structure as the source table
                dest_cur.execute("INSERT INTO my_table VALUES (%s, %s, %s)", row)

            dest_conn.commit()

    except Exception as e:
        print("An error occurred:", e)

    finally:
        src_conn.close()
        dest_conn.close()

if __name__ == "__main__":
    interactive_migration()
