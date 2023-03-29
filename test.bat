@echo off
set param=%1
IF "%param%"=="" (SET param=10)
echo %param%

for /l %%x in (1, 1, %param%) do (
   echo %%x
   start "" test2.bat %%x
   timeout 1 > nul
)
exit