import psycopg2
import time
import random
import sys

conn = psycopg2.connect(
    host="localhost",
    database="test",
    user="postgres",
    password="ask123")

cur = conn.cursor()

cStartFile = "start.test"