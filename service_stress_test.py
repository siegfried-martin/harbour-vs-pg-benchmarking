import random
import psycopg2
import time
import trax


def stress_subtest1(db_conn):
    aTemp1 = []
    cur = db_conn.cursor()
    for i in range(0, 100):
        service_id = random.randrange(4000000, 9000000)
        command = "select service_id, tpteam, vendor_id, page_range, details, parameters "
        command += f"from service where service_id={service_id}"
        cur.execute(command)
        row = cur.fetchone()
        #trax.trax(row[0])
        aTemp1.append(row)
        aNew = []
        aNew.append(random.randrange(0, 10))
        aNew.append(random.randrange(0, 10000))
        aNew.append(trax.get_random_string(random.randrange(1, 20)))
        aNew.append(trax.get_random_string(random.randrange(1, 100)))
        aNew.append(trax.get_random_string(random.randrange(1, 100)))
        
        command = "update service set (tpteam, vendor_id, page_range, details, parameters)=\n"
        command += f"({aNew[0]}, {aNew[1]}, '{aNew[2]}', '{aNew[3]}', '{aNew[4]}')\n"
        command += f"where service_id={service_id}"
        #trax.trax(command)
        cur.execute(command)
        db_conn.commit()
    for row in aTemp1:
        command = "update service set (tpteam, vendor_id, page_range, details, parameters)=\n"
        command += f"({row[1]}, {row[2]}, '{row[3]}', '{row[4]}', '{row[5]}')\n"
        command += f"where service_id={row[0]}"
        #trax.trax(command)
        cur.execute(command)
        db_conn.commit()

def stress_subtest2(db_conn):
    cur = db_conn.cursor()
    aVendors = [
      1051,
      1804,
      2281,
      2888,
      3657,
      3794,
      3833,
      4683,
      4814,
      4910,
      5087,
      5218,
      5371,
      5372,
      6948,
      7877,
      7879,
      7916,
      9917,
      11806,
      11867,
      11868,
      11951
    ]
    k = 0
    for i in range(0, 100):
        nVendor = aVendors[random.randrange(0, len(aVendors))]
        j = 0
        command = "select service_id, type_id from service\n"
        command += f"where vendor_id={nVendor} and result_id=0"
        #trax.trax(command)
        cur.execute(command)
        row = cur.fetchone()
        while row:
            j += row[1]
            #trax.trax(row, j)
            row = cur.fetchone()
        k+=j
        #trax.trax(j, k)
    #trax.trax(k)



conn = psycopg2.connect(
    host="localhost",
    database="test",
    user="postgres",
    password="ask123")

trax.trax("begin")
#stress_subtest2(conn)
#trax.trax("end")
#exit()

for i in range(0, 5):
    if random.randrange(1, 3) == 1:
        trax.trax("running subtest 1")
        stress_subtest1(conn)
        trax.trax("done with subtest 1")
    else:
        trax.trax("running subtest 2")
        stress_subtest2(conn)
        trax.trax("done with subtest 2")
trax.trax("end")