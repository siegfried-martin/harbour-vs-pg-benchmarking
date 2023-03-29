#!/usr/bin/python
import random
#import dbf
import psycopg2
import time
from datetime import datetime
from dbfread import DBF


table = DBF('e:/livedata/database/vendor.dbf', load=True)
for record in table:
    print(record)
print(table.records[0])
exit()

# def populateAccountsDbfFromSql():
#     # table = dbf.Table('accounts.dbf', 'user_id N(7, 0); username C(50); password C(50); email M; created_on D; last_login N(13, 0)')
#     dbf_table = dbf.Table('accounts.dbf')
#     dbf_table.open(dbf.READ_WRITE)

#     conn = psycopg2.connect(
#         host="localhost",
#         database="test",
#         user="postgres",
#         password="ask123")

#     cur = conn.cursor()

#     command = "select * from accounts"
#     cur.execute(command)
#     row = cur.fetchone()
#     count = 0
#     timekeep = time.time()
#     print("started", timekeep, time.time() - timekeep)
#     while row:
#         count += 1
#         #if count < 3:
#         # row = cur.fetchone()
#         #    continue
#         if count % 1000 == 0:
#             print("copying record", count, time.time(), time.time() - timekeep)
#         dt = row[4]
#         dbf_dt = dbf.Date(dt.year, dt.month, dt.day)
#         dbf_row = (row[0], row[1], row[2], row[3], dbf_dt)
#         #print(dbf_row)
#         dbf_table.append(dbf_row)
#         row = cur.fetchone()

# populateAccountsDbfFromSql()
# exit()


# table = dbf.Table('temptable', 'name C(30); age N(3,0); birth D')
# table = dbf.Table('temptable.dbf')
# table.open(dbf.READ_WRITE)
# for datum in (
#         ('John Doe', 31, dbf.Date(1979, 9,13)),
#         ('Ethan Furman', 102, dbf.Date(1909, 4, 1)),
#         ('Jane Smith', 57, dbf.Date(1954, 7, 2)),
#         ('John Adams', 44, dbf.Date(1967, 1, 9)),
#     ):
#     table.append(datum)
# exit()


# table = dbf.Table("e:/livedata/database/CHKCLR.DBF")
# table.open(dbf.READ_WRITE)
# table.goto(559)
# while not table.eof:
#     record = table.current_record
#     print(record['amount'])
#     table.skip()
