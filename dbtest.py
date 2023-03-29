#!/usr/bin/python
import psycopg2
import time
import random
import string

conn = psycopg2.connect(
    host="localhost",
    database="test",
    user="postgres",
    password="ask123")

cur = conn.cursor()

def get_random_string(length):
    letters = string.ascii_lowercase
    result_str = ''.join(random.choice(letters) for i in range(length))
    return result_str

def getRandInsert():
    username = get_random_string(random.randint(15, 20))
    password = get_random_string(random.randint(15, 20))
    email = get_random_string(random.randint(12, 20))+"@"
    email += get_random_string(random.randint(5, 10))+".com"
    result_str = "('"+username+"','"+password+"','"+email+"', now())"
    #print(result_str)
    return result_str

timekeep = time.time()
print("started", timekeep, time.time() - timekeep)

command = "select service_id from service where vendor_id=4744"
cur.execute(command)
print("queried", timekeep, time.time() - timekeep)
row = cur.fetchone()
while row:
    #print(row[0])
    row = cur.fetchone()
print("done", timekeep, time.time() - timekeep)
exit()




i = 0
while i < 4000:
    i+=1
    command = "insert into accounts (username, password, email, created_on)\nvalues\n"
    command+=getRandInsert()
    cur.execute(command)
    
    if i % 400 == 0:
        print("completed", i, time.time(), time.time() - timekeep)
        conn.commit()
conn.commit()
print("done", time.time(), time.time() - timekeep)
exit()



timekeep = time.time()
print("started", timekeep, time.time() - timekeep)
command = "insert into accounts (username, password, email, created_on)\nvalues\n"
i = 1
while i < 100000:
    i+=1
    command+=getRandInsert()+",\n"
command+=getRandInsert()
#print(command)
print("created command", time.time(), time.time() - timekeep)
cur.execute(command)
print("executed command", time.time(), time.time() - timekeep)
conn.commit()
print("committed", time.time(), time.time() - timekeep)
exit()
    


command = """
        insert into accounts (username, password, email, created_on)
        values
        ('hi mom', 'bestpassword', 'imcool@yay.com', now()),
        ('hi mom2', 'bestpassword2', 'imcool2@yay.com', now())
        """
command = "select * from accounts"
cur.execute(command)
row = cur.fetchone()
while row:
    print(row[1])
    row = cur.fetchone()
print(time.time())
conn.commit()