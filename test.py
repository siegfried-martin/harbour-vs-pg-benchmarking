import psycopg2
import trax
import random

def main():
	trax.trax("start")
	for j in range(0, 100):
		aTemp = [None]*100000
		for i in range(0, 100000):
			aTemp[i] = random.randint(0, 100000)
		aTemp.sort()
	trax.trax("end")
main()
exit()



trax.trax("start")

conn = psycopg2.connect(
    host="localhost",
    database="test",
    user="postgres",
    password="ask123")

cur = conn.cursor()

command = """\
select service.id_, vendor.name, result.result
from client, search, service, vendor, result
where client.code = 'ASK0003'
	and search.client_id = client.recno
	and service.search_id = search.id_
	and service.vendor_id = vendor.recno
	and service.result_id = result.recno
order by service.id_;
"""

cur.execute(command)
row = cur.fetchone()
while row:
	trax.trax(row[0], row[1], row[2])
	row = cur.fetchone()

trax.trax("end")