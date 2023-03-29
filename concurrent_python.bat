@echo off
set param=%1
IF "%param%"=="" (SET param=10)
echo %param%

for /l %%x in (1, 1, %param%) do (
   echo %%x
   rem e:
   rem cd \livedata
   start "" python_test.bat exit
)