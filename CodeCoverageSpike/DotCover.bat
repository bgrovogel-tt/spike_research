@echo off

call :log "In DotCover.bat"

REM Run tests with coverage using DotCover
call :log "Running dotCover tool..."

REM This was changed so for now we are only running the coverage with filters
if "%filter%"=="" (
    call :log "Running coverage with no filters..."
    REM can do it this way...
    "%DOTCOVER_EXE%" cover /TargetExecutable="%VSTEST_EXE%" /TargetArguments="%TESTASSEMBLY%" /Output=%OUTPUT_DIR%\AppCoverageReport.html /ReportType=HTML
) else (
    call :log "Running coverage with filters..."
    "%DOTCOVER_EXE%" cover /TargetExecutable="%VSTEST_EXE%" /TargetArguments="%TESTASSEMBLY%" /Output="%OUTPUT_DIR%"\AppCoverageReport.html /Filters="%FILTER%" /ReportType=HTML
    "%DOTCOVER_EXE%" cover /TargetExecutable="%VSTEST_EXE%" /TargetArguments="%TESTASSEMBLY%" /Output="%OUTPUT_DIR%"\CoverageXML\coverage_"%DATE_TIME%".xml /ReportType=DetailedXML --Filters="%FILTER%"
)

REM EXAMPLES:
REM "%DOTCOVER_EXE%" cover /TargetExecutable="%vstest%" /TargetArguments="%TESTASSEMBLY%" /Output=%OUTPUT_DIR%\AppCoverageReport.html /Filters="-:module=testhost.net472;-:module=LoadInSiteSearchResultSetUnitTests" /ReportType=HTML

REM NOTES:
REM ("%DOTCOVER_EXE%" cover /TargetExecutable="%vstest%" /TargetArguments="%TESTASSEMBLY%" /Output=AppCoverageReport.html /ReportType=HTML)
REM This command uses the cover command of DotCover, which is designed specifically for capturing code coverage during the execution of another program (specified by /TargetExecutable).
REM The /TargetExecutable option specifies the path to the executable to be covered, which is typically a test runner such as vstest.
REM The /TargetArguments option allows you to specify additional arguments to pass to the target executable.
REM The /Output option specifies the path where DotCover will save the coverage results.
REM The /ReportType option sets the type of coverage report to be generated.
REM /Filters=+:Assembly;...: Specifies the filters to include specific namespaces in the coverage analysis. Each namespace is preceded by + to include it. The namespaces are separated by semicolons ;.
REM ...............................................
REM ("%DOTCOVER_EXE%" dotnet --output=C:\TylerDev\CODECOVERAGE\CoverageReport\DotCoverResults\AppCoverageReport.html --reportType=HTML -- test "%TESTASSEMBLY%")
REM This command uses the dotnet command-line interface to execute tests and generate coverage reports.
REM The dotnet command is a general-purpose tool for managing .NET projects and running .NET Core CLI commands.
REM The --output option specifies the path where DotCover will save the coverage report.
REM The --reportType option sets the type of coverage report to be generated.
REM --filters=+:Assembly;...: Specifies the filters to include specific namespaces in the coverage analysis. Each namespace is preceded by + to include it. The namespaces are separated by semicolons ;.

call :log "Exiting out of DotCover.bat"

exit /b

REM Function to log messages
:log
set "logDateTime=%date% %time%"
echo [%logDateTime%] %*
echo [%logDateTime%] %* >> "%CODECOVERAGE_LOG%"
exit /b