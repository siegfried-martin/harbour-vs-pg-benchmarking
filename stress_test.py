import psycopg2
import time
import random
import sys
from datetime import datetime

import os
import os.path
from os import path

from subprocess import Popen

conn = psycopg2.connect(
    host="localhost",
    database="test",
    user="postgres",
    password="ask123")

cur = conn.cursor()

cStartFile = "start.test"

def seconds():
    now = datetime.now()
    seconds_since_midnight = (now - now.replace(hour=0, minute=0, second=0, microsecond=0)).total_seconds()
    return seconds_since_midnight

print(len(sys.argv), sys.argv)

if len(sys.argv) < 2:
    print("usage: stress_test.py [num_instances]")

def stresTestMaster():
    nCount = int(sys.argv[1])
    if nCount < 1:
        print("usage: stress_test.py [num_instances]")
        exit()
    if path.exists(cStartFile):
        os.remove(cStartFile)

    createStressDbs()

    proc = Popen('test.bat '+str(nCount), shell=True,
             stdin=None, stdout=None, stderr=None, close_fds=True)

    #for nInstance in range(1, nCount):
    #    print("starting", nInstance)
        #os.system('cmd /k start "" python stress_test.py child '+str(nInstance)+' && exit')
        #os.system('cmd /k python stress_test.py child '+str(nInstance))
        #proc = Popen('python stress_test.py child '+str(nInstance), shell=True,
        #    stdin=None, stdout=None, stderr=None, close_fds=True)
        
    #    time.sleep(1)
    time.sleep(nCount + 2)
    f = open(cStartFile, "w")
    f.close()

    time.sleep(2)

    lAllComplete = False
    while not lAllComplete:
        command = "select count(*) from stress_test where elapsed is null"
        cur.execute(command)
        #print(command)
        row = cur.fetchone()
        #print(row)
        lAllComplete = (row[0] == 0)
        if not lAllComplete:
            time.sleep(1)
    
    aggregateResults()
    os.remove(cStartFile)
    
    
def createStressDbs():
    command = "drop table if exists stress_test"
    cur.execute(command)

    command = """\
create table stress_test (
    instance int,
    seed int,
    start_seconds real,
    end_seconds real,
    elapsed real
)
"""
    #print(command)
    cur.execute(command)
    conn.commit()

def aggregateResults():
    command = "select count(elapsed), avg(elapsed) from stress_test"
    cur.execute(command)
    row = cur.fetchone()
    print("count", row[0])
    print("average", row[1])

def stressTestChild(nInstance):
    nSubIterations = 10
    nSeconds = seconds()
    nSeed = nInstance * nSeconds * 100 + nInstance
    
    random.seed(nSeed)
    command = f"insert into stress_test (instance, seed) values ({nInstance}, {nSeed})"
    cur.execute(command)
    conn.commit()

    print("waiting on master")
    while not path.exists(cStartFile):
        time.sleep(0.1)
    nSeconds = seconds()
    for i in range(1, nSubIterations):
        nTemp = random.randint(0, 2)
        #nTemp = 0
        if nTemp == 0:
            filterTest()
        elif nTemp == 1:
            try:
                seekTest()
            except Exception as e:
                print(e)
                time.sleep(5)
        elif nTemp ==2:
            writeTest()
        
    nTemp = seconds()
    nTemp2 = nTemp - nSeconds
    #input("hit enter when you are happy")
    command = """\
update stress_test
set start_seconds = {nSeconds},
    end_seconds = {nTemp},
    elapsed = {nTemp2}
where instance = {nInstance}
""".format(nTemp=nTemp, nInstance=nInstance, nSeconds=nSeconds, nTemp2=nTemp2)
    #print(command)
    #time.sleep(10)
    cur.execute(command)
    conn.commit()

def filterTest():
    print("starting filter test")
    aVendors = []
    command = "select recno from vendor where lockout != true and pullvend = 1418"
    cur.execute(command)
    row = cur.fetchone()
    while row:
        aVendors.append(row[0])
        row = cur.fetchone()
    
    for i in range(1, 10):
        nVendor = aVendors[random.randint(0, len(aVendors) - 1)]
        command = """\
select service.type_id, result.modif_by
from service, result
where service.result_id = result.recno
    and service.invoice_id is null
    and service.vendor_id = {nVendor}
    and (service.owner = 18 or service.owner = 21)
    and (service.result_id is null or result.open)
    and service.dprtmnt_id != 6
""".format(nVendor = nVendor)
        #if i==1:
        #    print(command)
        #    time.sleep(20)
        #print(command)
        cur.execute(command)
        nTemp = 0
        row = cur.fetchone()
        while row:
            nTemp+=row[0]+row[1]
            row = cur.fetchone()

def seekTest():
    print("starting seek test")
    command = "select max(search_id) from service"
    cur.execute(command)
    nMaxSearch = cur.fetchone()[0]
    command = "select max(id_) from service"
    cur.execute(command)
    nMaxId = cur.fetchone()[0]

    for i in range(1, 10):
        counter = 0
        for j in range(1, 500):
            nTemp = 0
            nSkip = random.randint(1,3)
            #nSeek = random.randint(nMaxId - int(nMaxId / 10), nMaxId)
            counter = counter + nSkip
            nSeek = nMaxId - counter
            command = f"select type_id from service where id_ = {nSeek}"
            cur.execute(command)
            row = cur.fetchone()
            if row and row[0]:
                nTemp+=row[0]
            #nSeek = random.randint(nMaxSearch - int(nMaxSearch / 10), nMaxSearch)
            counter = counter + nSkip
            nSeek = nMaxSearch - counter
            command = f"select type_id from service where search_id = {nSeek} limit 1"
            cur.execute(command)
            row = cur.fetchone()
            if row and row[0]:
                nTemp+=row[0]
            #nSeek = random.randint(nMaxId - int(nMaxId / 10), nMaxId)
            counter = counter + nSkip
            nSeek = nMaxId - counter
            command = f"select type_id from service where id_ = {nSeek}"
            cur.execute(command)
            row = cur.fetchone()
            if row and row[0]:
                nTemp+=row[0]

def writeTest():
    print("starting write test")
    aRollBack = []
    for i in range(1, 20):
        nOffset = random.randint(1, 100000)
        command = """\
select id_, type_id, invoice_id, batch_id, rbatch_id, ask_notes, extra
from service
order by id_
limit 1 offset {nOffset}
""".format(nOffset = nOffset)
        cur.execute(command)
        row = cur.fetchone()
        nId = row[0]
        hRollBack = {
            "id_": nId or 0,
            "type_id": row[1] or 0,
            "invoice_id": row[2] or 0,
            "batch_id": row[3] or 0,
            "rbatch_id": row[4] or 0,
            "ask_notes": row[5],
            "extra": row[6]
        }
        if hRollBack["ask_notes"]:
            hRollBack["ask_notes"] = hRollBack["ask_notes"].replace("'", "''")
        if hRollBack["extra"]:
            hRollBack["extra"] = hRollBack["extra"].replace("'", "''")
        aRollBack.append(hRollBack)
        nType_id = random.randint(1, 300000)
        nInvoice_id = random.randint(1, 300000)
        nBatch_id = random.randint(1, 300000)
        nRbatch_id = random.randint(1, 300000)
        cAsk_notes = "abcd" * 100
        cExtra = "abcd" * 100
        command = """\
update service
set type_id = {1},
    invoice_id = {2},
    batch_id = {3},
    rbatch_id = {4},
    ask_notes = '{5}',
    extra = '{6}'
where id_ = {0}
""".format(nId, nType_id, nInvoice_id, nBatch_id, nRbatch_id, cAsk_notes, cExtra)
        cur.execute(command)
        conn.commit()

    for hRollBack in aRollBack:
        nId = hRollBack['id_']
        nType_id = hRollBack['type_id']
        nInvoice_id = hRollBack['invoice_id']
        nBatch_id = hRollBack['batch_id']
        nRbatch_id = hRollBack['rbatch_id']
        cAsk_notes = hRollBack['ask_notes']
        cExtra = hRollBack['extra']
        command = """\
update service
set type_id = {1},
    invoice_id = {2},
    batch_id = {3},
    rbatch_id = {4},
    ask_notes = '{5}',
    extra = '{6}'
where id_ = {0}
""".format(nId, nType_id, nInvoice_id, nBatch_id, nRbatch_id, cAsk_notes, cExtra)
        cur.execute(command)
        conn.commit()






if sys.argv[1].upper() == "CHILD":
    stressTestChild(int(sys.argv[2]))
else:
    stresTestMaster()