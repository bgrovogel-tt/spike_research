@echo off

call :log "Running Filters.bat"

call :log "DLL name: %DLLNAME%"

REM TODO: Add filters here

set "FILTER=-:module=testhost.net472;-:module=%DLLNAME%"

call :log "Filter: %FILTER%"
call :log "Exiting out of CodeCoverage.bat"

exit /b

REM Function to log messages
:log
set "logDateTime=%date% %time%"
echo [%logDateTime%] %*
echo [%logDateTime%] %* >> "%CODECOVERAGE_LOG%"
exit /b