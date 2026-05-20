@echo off
REM Run this file from the project root to start the Bus Management System.
REM Requirements: Java JDK installed, Maven installed, and MySQL configured as expected by the application.

REM Change directory to the directory containing this script.
cd /d "%~dp0"

echo Starting Bus Management System...

mvn cargo:run

echo.
echo If the application stops, press any key to close this window.
pause >nul
