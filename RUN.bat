@echo off
REM Bus Management System - One-Click Launcher
REM Simply double-click to start the app

cd /d "%~dp0"

echo.
echo Starting Bus Management System...
echo Please wait 30-60 seconds for the browser to open...
echo.

REM Kill any existing process on port 8081
for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr ":8081.*LISTENING"') do taskkill /PID %%a /F >nul 2>&1

REM Clean old builds
if exist "target" rmdir /s /q target >nul 2>&1

REM Start the server
mvn jetty:run
