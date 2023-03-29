#!/usr/bin/python
import psycopg2
import sys
import os.path
import time
import random
from datetime import datetime

conn = psycopg2.connect(
    host="localhost",
    database="test",
    user="postgres",
    password="ask123")

nNetPerfSize = 4000000
#nNetPerfSize = 500000

cur = conn.cursor()

def seedNetPerf():
    command = "drop table if exists netperf"
    cur.execute(command)
    command = "drop table if exists netperf2"
    cur.execute(command)

    create_statement = """\
create unlogged table netperf (
    id int,
    col_0 varchar (150),
    col_1 varchar (150),
    col_2 varchar (150),
    col_3 varchar (150),
    col_4 varchar (150),
    col_5 varchar (150),
    col_6 varchar (150),
    col_7 varchar (150),
    col_8 varchar (150),
    col_9 varchar (150),
    station int,
    memotest text,
    locked boolean
);
"""
    cur.execute(create_statement)

    create_statement = """\
create index idx_netperf_id on netperf(id);
    """
    cur.execute(create_statement)

    insert_statement = """\
insert into netperf (id)
select g.id
from generate_series(1, {nSize}) as g (id);
""".format(nSize = nNetPerfSize)
    cur.execute(insert_statement)

    create_statement = """\
create unlogged table netperf2 (
    id serial primary key,
    master boolean,
    dstart date,
    tstart time,
    tend time,
    elapsed int,
    fail int,
    locks int,
    avg int,
    ttl_locks int,
    avg_locks int,
    stations int,
    completed int
);
"""
    cur.execute(create_statement)
    conn.commit()

def waitForMaster(lMaster):
    if lMaster:
        input("press Enter to start all tests")
        f = open("netperf.start", "w")
        f.close()
    else:
        print("waiting for master to start")
        while not os.path.exists("netperf.start"):
            time.sleep(1)

def seconds():
    now = datetime.now()
    seconds_since_midnight = (now - now.replace(hour=0, minute=0, second=0, microsecond=0)).total_seconds()
    return int(seconds_since_midnight)

def mainTest():
    lMaster = False
    if len(sys.argv) > 1:
        lMaster = True
    if lMaster:
        seedNetPerf()
        command = "insert into netperf2 (master, dstart, tstart) values (true, current_date, current_time) returning id"
        cur.execute(command)
        nNetperf2Id = cur.fetchone()[0]
    waitForMaster(lMaster)
    
    nStart = seconds()
    command = ""
    if not lMaster:
        command = "insert into netperf2 (master, dstart, tstart) values (false, current_date, current_time) returning id"
        cur.execute(command)
        nNetperf2Id = cur.fetchone()[0]

    nFail = 0
    y = 0
    nId = 1
    nLocks = 0
    
    for x in range(1, 200):
        #print(x)
        nLower = (nNetPerfSize / 200) * (x - 1)
        nUpper = nNetPerfSize / 200 * x
        print("a", " ", x, " ", nLower, " ", nUpper)
        lFail = False
        
        if y==0:
            command = "insert into netperf (id) values (NULL)"
            cur.execute(command)
            y = 1
        else:
            lLocked = False
            while not lLocked:
                nId = random.randint(nLower, nUpper)
                #print(nId, nStart)
                # set locked to true and return old value
                command = """\
update netperf n1
set locked = true
from (select id, locked from netperf where id = {id} for update) n2
where n1.id = n2.id
returning n2.locked;
""".format(id=nId)
                try:
                    #print(command)
                    cur.execute(command)
                    conn.commit()
                    aTemp = cur.fetchone()
                    #print(aTemp)
                    lLocked = aTemp[0]
                    if not lLocked:
                        nLocks += 1
                except:
                    print("error:", sys.exc_info()[0])
                    lFail = True
                    break
            y = 0

        print("b ", nLocks)
        if lFail:
            print("F")
            nFail += 1
            time.sleep(1)

        print("c")
        conn.commit()

        print("d")
        command = f"update netperf set id = id where id = {nId}"
        cur.execute(command)

        print("e")
        conn.commit()

        print("f")
        command = f"update netperf set station = {nNetperf2Id} where id = {nId}"
        cur.execute(command)

        print("g")
        print("h")
        cTemp = f"Start{nId}|"+(datetime.now().strftime("%H:%M:%S")*(x+10))+"END"
        command = f"update netperf set memotest = '{cTemp}' where id = {nId}"
        
        print("i")
        conn.commit()

        print("j")
        print("k")
        nId = random.randint(1, nStart + x)
        command = f"select id from netperf where id={nId}"
        print("l") # end for x in range(1,200)
        #if x > 10:
        #    break

    nElapsed = seconds() - nStart
    command = """\
update netperf2
set tend = current_time,
    elapsed = {nElapsed},
    fail = {nFail},
    locks = {nLocks}
where id={nId}
""".format(nElapsed = nElapsed, nFail = nFail, nId = nNetperf2Id, nLocks = nLocks)
    cur.execute(command)
    print(f" Ended {nElapsed}")
    if nFail > 0:
        print(f"FAILED APPENDS {nFail}")
    conn.commit()

    if lMaster:
        time.sleep(1)
        os.remove("netperf.start")
        input("Master complete, press Enter to calculate summary")
        summary(nNetperf2Id)
        input("press Enter to exit test")



def summary(nNetperf2Id):
    command = "select count(id) from netperf2"
    cur.execute(command)
    nCount = cur.fetchone()[0]

    command = "select count(id) from netperf2 where elapsed>0"
    cur.execute(command)
    nComplete = cur.fetchone()[0]

    command = "select sum(elapsed) from netperf2"
    cur.execute(command)
    nTotal = cur.fetchone()[0]

    command = "select sum(locks) from netperf2"
    cur.execute(command)
    nLocks = cur.fetchone()[0]

    command = "select avg(locks) from netperf2"
    print(command)
    cur.execute(command)
    nAvgLocks = cur.fetchone()[0]
    print(nLocks)
    
    nAverage = nTotal / nComplete
    print(f"Average:{nAverage}, Count:{nCount}, Complete:{nComplete}, avg locks: {nAvgLocks}, total locks: {nLocks}")

    command = """\
update netperf2
set avg = {nAvg},
    stations = {nCount},
    completed = {nComplete},
    ttl_locks = {nLocks},
    avg_locks = {nAvgL}
where id={nId}
""".format(nAvg=nAverage, nCount=nCount, nComplete=nComplete, nId=nNetperf2Id, nLocks=nLocks, nAvgL = nAvgLocks)
    print(command)
    cur.execute(command)
    conn.commit()


mainTest()
    