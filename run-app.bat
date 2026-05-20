@echo off
REM Run this file from the project root to start the Bus Management System.
REM Requirements: Java JDK installed, Maven installed, and MySQL configured as expected by the application.

REM Change directory to the directory containing this script.
cd /d "%~dp0"

echo Starting Bus Management System...

rem Start the embedded container in a new window so this script can continue.
start "BMS Server" cmd /k "mvn cargo:run"

echo Waiting for application to become available (checking about.jsp)...

rem Poll the local about.jsp until it returns HTTP 200 (or timeout after 60s).
powershell -Command "for ($i=0;$i -lt 60;$i++) { try { $r=Invoke-WebRequest -UseBasicParsing -Uri 'http://localhost:8082/BusManagementSystem/about.jsp' -TimeoutSec 2; if ($r.StatusCode -eq 200) { exit 0 } } catch {}; Start-Sleep -Seconds 1 }; exit 1"

if %ERRORLEVEL% EQU 0 (
	echo Application started; opening browser.
	start "" "http://localhost:8082/BusManagementSystem/about.jsp"
) else (
	echo Application did not respond within timeout; opening page anyway.
	start "" "http://localhost:8082/BusManagementSystem/about.jsp"
)

echo.
echo To stop the server, close the "BMS Server" window.
pause >nul
