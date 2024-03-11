@echo off

call :log "Running ReportGenerator.bat"

REM Configuration
set "REPORTOUTPUTPATH=C:\TylerDev\Scripts\CodeCoverage\ReportGenerator"

REM Generate HTML report using ReportGenerator
call :log "Generating HTML report..."
"%REPORTGENERATOR_EXE%" -reports:"%OUTPUT_DIR%"\CoverageXML\coverage_"%DATE_TIME%".xml -targetdir:"%REPORTOUTPUTPATH%" -reporttypes:Html_Dark -title:Defendant Access 

call :log Coverage report generated at: %REPORTOUTPUTPATH%
call :log Exiting out of ReportGenerator.bat

exit /b

REM Function to log messages
:log
set "logDateTime=%date% %time%"
echo [%logDateTime%] %*
echo [%logDateTime%] %* >> "%CODECOVERAGE_LOG%"
exit /b

REM ReportGenerator Usage
REM https://reportgenerator.io/usage
REM $(UserProfile)\.nuget\packages\reportgenerator\5.2.2\tools\net47\ReportGenerator.exe
REM-reports:
REM-targetdir:
REM-reporttypes:
REM-sourcedirs:
REM-historydir:
REM-plugins:
REM-assemblyfilters:
REM-classfilters:
REM-filefilters:
REM-verbosity:
REM-title:
REM-tag:
REM-license: