#!/usr/bin/python
import csv
import os
import psycopg2
import sys

def getHeaderData(cvsReader):
    data = []
    headerRow = csvReader.__next__()
    for field in headerRow:
        items = field.split("|")
        dataItem = {
            "name":items[0],
            "type":items[1],
            "length":int(items[2]),
            "decimal":int(items[3])
        }
        if dataItem['name']=="FREEZE":
            dataItem['name'] = "_FREEZE"
        elif dataItem['name']=="FROM":
            dataItem['name'] = "_FROM"
        elif dataItem['name']=="TO":
            dataItem['name'] = "_TO"
        elif dataItem['name']=="PRIMARY":
            dataItem['name'] = "_PRIMARY"
        elif dataItem['name']=="REFERENCES":
            dataItem['name'] = "_REFERENCES"
        data.append(dataItem)
    return data

def createStringFromHeaderItem(item):
    retStr = item['name']
    dataType = item['type']
    sqlType = ""
    if dataType == "C":
        if item['length'] <= 20:
            sqlType = f"CHAR ({item['length']})"
        else:
            sqlType = f"VARCHAR ({item['length']})"
    elif dataType=="M":
        sqlType = "TEXT"
    elif dataType == "I":
        sqlType = "INT"
    elif dataType == "N":
        if item['length'] == 13 and item['decimal']==0:
            sqlType = "TIMESTAMP"
        elif item['decimal'] > 0:
            sqlType = "FLOAT4"
        else:
            sqlType = "INT"
    elif dataType == "L":
        sqlType = "BOOL"
    elif dataType == "D":
        sqlType = "DATE"
    else:
        sqlType = "TEXT"
    
    retStr+=f" {sqlType}"
    if item['name'].upper()=="RECNO" or item['name'].upper()=="ID_":
        retStr+=" PRIMARY KEY"
    return retStr


def header2createStatement(headerData, tableName):
    #idField = tableName+"_id"
    query = f"CREATE TABLE {tableName} ("
    #query += f"\n   {idField} SERIAL PRIMARY KEY"
    first = True
    for item in headerData:
        if first:
            first = False
        else:
            query+=","
        query += f"\n   {createStringFromHeaderItem(item)}"
    query += "\n);"
    return query

def getInsertPrefix(headerData, tableName):
    ret_str = f"INSERT INTO {tableName} ("
    first = True
    for i, item in enumerate(headerData):
        #if i>49:
        #    continue
        if first:
            first = False
        else:
            ret_str+=", "
        if (i + 1) % 10 == 0:
            ret_str+="\n"
        ret_str+=item["name"]
    ret_str+=")\nvalues\n"
    return ret_str

def insertValues(csvReader, headerData, tableName, conn):
    insert_statement = ""
    prefix = getInsertPrefix(headerData, tableName)
    cur = conn.cursor()
    i = 0
    for row in csvReader:
        #print(row)
        #print(i)
        i += 1
        if i % 50 == 1:
            if i > 1:
                if i % 5000 == 1:
                    print(i)
                insert_statement+=";"
                #print(insert_statement)
                #print(i)
                try:
                    cur.execute(insert_statement)
                except Exception as e:
                    print(e)
                # print(insert_statement)
                #cSqlFile = "insert2.sql"
                #if os.path.exists(cSqlFile):
                #    os.remove(cSqlFile)
                #f = open(cSqlFile, "x")
                #f.write(insert_statement)
                #break # TODO: remove this to run whole file
            insert_statement = prefix
        else:
            insert_statement+=",\n"
        insert_statement+="("
        first = True
        for j, item in enumerate(row):
            #if j>49:
            #    continue

            if first:
                first = False
            else:
                insert_statement+=", "    
            if headerData[j]["type"] in ("C", "M") and item!="null":
                insert_statement+="'"+item+"'"
            elif item == "" or item.startswith("'0000"):
                insert_statement+="null"
            else:
                insert_statement+=item
        insert_statement+=")"
    if i % 50 != 1: # run remainder
        insert_statement+=";"
        cur.execute(insert_statement)
    conn.commit()


def makeCreateStatement(headerData, table):
    createStatement = header2createStatement(headerData, table)
    cSqlFile = "sql/create_"+table+".sql"
    if os.path.exists(cSqlFile):
        os.remove(cSqlFile)
    f = open(cSqlFile, "x")
    f.write(createStatement)

aTables = ["service", "search", "sc_pin"]

for table in aTables:
    with open(table+'.csv', newline='',  errors='ignore') as csvfile:
        csvReader = csv.reader(csvfile)
        headerData = getHeaderData(csvReader)
        #print(csv.field_size_limit())
        csv.field_size_limit(100000000)
        #csv.field_size_limit(sys.maxsize)

        #makeCreateStatement(headerData, table)
        #continue

        conn = psycopg2.connect(
            host="localhost",
            database="test",
            user="postgres",
            password="ask123")
        insertValues(csvReader, headerData, table, conn)



