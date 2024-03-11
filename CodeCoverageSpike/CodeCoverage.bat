@echo off
cls

setlocal enabledelayedexpansion

REM Configuration
set "SCRIPT_DIR=C:\TylerDev\Scripts"
set "OUTPUT_DIR=%SCRIPT_DIR%\CodeCoverage"
set "CODECOVERAGE_LOG=%OUTPUT_DIR%\CodeCoverageLogs.txt"
set "VSTEST_EXE=%PROGRAMFILES%\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe"
set "DOTCOVER_EXE=%USERPROFILE%\.dotnet\tools\.store\jetbrains.dotcover.commandlinetools\2023.3.0\jetbrains.dotcover.commandlinetools\2023.3.0\tools\dotCover.exe"
set "REPORTGENERATOR_EXE=%USERPROFILE%\.dotnet\tools\reportgenerator.exe"
set "DOTCOVER_TOOL_INSTALL_CMD=dotnet tool install --global JetBrains.dotCover.CommandLineTools --version 2023.3.0"
set "REPORTGENERATOR_TOOL_INSTALL_CMD=dotnet tool install --global dotnet-reportgenerator-globaltool"
set "DATE_TIME=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%"

REM Main script logic
:main
call :initializeEnvironment

call :log "Running CodeCoverage.bat"

echo.
call :log "Searching for .dll files in the current directory and its subdirectories:"
echo -------------------------------------------------------------------------

REM Initialize a counter to track the number of .dll files found
set count=0

REM Initialize a variable to store the last directory encountered
set "lastdir="

REM Loop through all .dll files recursively in the current directory and its subdirectories
for /r %%F in (*.dll) do (

    REM Extract the directory path of the current .dll file
    set "dir=%%~dpF"
    
    REM Check if the current directory is different from the last one encountered
    if "!dir!" neq "!lastdir!" (
    
        REM If it's not the first directory encountered, print a newline for better formatting
        if not "!lastdir!"=="" echo(
        
        REM Print the current directory path (with the current directory replaced with '.')
        REM This will display the relative path from the current directory
        echo !dir:%CD%\=!
        
        REM Update the last directory variable to the current directory
        set "lastdir=!dir!"
    )
    
    REM Increment the counter for each .dll file found
    set /a count+=1
    
    REM Display the count number, followed by the name of the current .dll file (without the directory)
    echo    !count!. %%~nxF
)

echo -------------------------------------------------------------------------

set /p selection=Enter the number of the file you want to select: 

set fileIndex=0
for /r %%F in (*.dll) do (
    set /a fileIndex+=1
    if !fileIndex! equ %selection% (
        set SELECTEDFILE=%%F
        for %%I in (%%F) do set "DLLNAME=%%~nI"
        goto :found
    )
)

call :log "Invalid selection. Exiting script."
goto :end

:found
call :log "You selected: %SELECTEDFILE%"

set TESTASSEMBLY=%SELECTEDFILE%

REM Check existence of executables
call :checkExecutable "%VSTEST_EXE%"
call :checkOrInstallExecutable "DotCover CLI" "%DOTCOVER_EXE%" "%DOTCOVER_TOOL_INSTALL_CMD%"
call :checkOrInstallExecutable "ReportGenerator global tool" "%REPORTGENERATOR_EXE%" "%REPORTGENERATOR_TOOL_INSTALL_CMD%"

REM Call other necessary scripts
call Filters.bat
call DotCover.bat
call ReportGenerator.bat

call :log "Exiting out of CodeCoverage.bat"

REM S3?
REM call SendToS3.bat

:end
endlocal
exit /b 0

REM Function to initialize environment
:initializeEnvironment
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"
type nul > "%CODECOVERAGE_LOG%"
call :log "Environment initialized."
exit /b

REM Function to log messages
:log
set "logDateTime=%date% %time%"
echo [%logDateTime%] %*
echo [%logDateTime%] %* >> "%CODECOVERAGE_LOG%"
exit /b

REM Function to check if an executable exists
:checkExecutable
if not exist "%~1" (
    call :log "Error: %~1 not found."
    echo "Check CodeCoverageLogs.txt for more details."
    exit /b 1
)
exit /b

REM Function to check or install an executable
:checkOrInstallExecutable
if not exist "%~2" (
    call :log "%~1 not found. Installing %~1..."
    %3
    if errorlevel 1 (
        call :log "Error installing %~1."
        echo "Check CodeCoverageLogs.txt for more details."
        exit /b 1
    ) else (
        call :log "%~1 installed successfully."
    )
)
exit /b