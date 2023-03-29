@echo off
python e:\db_test\service_stress_test.py
if [%1]==[] goto :DONE
if %1=="exit" (exit)
:DONE
exit