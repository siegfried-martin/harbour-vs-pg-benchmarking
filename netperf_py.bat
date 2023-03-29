@echo off
set param=%1
IF "%param%"=="" (SET param=5)
echo %param%
start "" python netperf.py master
for /l %%x in (1, 1, %param%) do (
   echo %%x
   start "" python netperf.py
   timeout 1
)