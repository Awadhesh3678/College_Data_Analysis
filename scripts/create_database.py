import pymysql
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from config.config import HOST, USER, PASSWORD, DATABASE
from config.logger import log


def create_database():
    conn = None
    cursor = None
    try:
        conn = pymysql.connect(
            host=HOST,
            user=USER,
            password=PASSWORD
        )
        cursor = conn.cursor()
        cursor.execute(f"CREATE DATABASE IF NOT EXISTS {DATABASE}")
        log(f"Database '{DATABASE}' created or already exists.")

    except pymysql.Error as err:
        log(f"ERROR creating database: {err}")
        raise

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


if __name__ == "__main__":
    create_database()