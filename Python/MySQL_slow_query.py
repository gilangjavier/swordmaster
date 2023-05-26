# Install = pip install pymysql
import pymysql
import time

# Configure database
db_config = {
    'host': 'localhost',
    'user': 'your_user',
    'password': 'your_password',
    'db': 'your_database'
}

# Koneksi ke database
try:
    connection = pymysql.connect(**db_config)
except Exception as e:
    print(f"Error connecting to database: {e}")
    exit()

def check_slow_queries():
    with connection.cursor() as cursor:
        # Menjalankan query untuk mendapatkan semua query yang berjalan lebih dari 5 menit
        try:
            cursor.execute("SHOW FULL PROCESSLIST")
        except Exception as e:
            print(f"Error executing query: {e}")
            return

        queries = cursor.fetchall()

        for query in queries:
            id, user, host, db, command, time, state, info = query

            # Jika query berjalan lebih dari 5 menit
            if int(time) > 5*60:
                log_entry = (f"Slow query detected:\n"
                             f"ID: {id}\n"
                             f"User: {user}\n"
                             f"Host: {host}\n"
                             f"DB: {db}\n"
                             f"Command: {command}\n"
                             f"Time: {time}\n"
                             f"State: {state}\n"
                             f"Query: {info}\n\n")
                with open('slow-query.log', 'a') as file:
                    file.write(log_entry)

check_slow_queries()

# Menutup koneksi
connection.close()