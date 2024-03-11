REM Description: This batch file is used to send the coverage file to Amazon S3
REM aws is AWS CLI tool
REM s3 interact with Amazon S3
REM cp copy files to Amazon S3

set FILE_PATH="%OUTPUT_DIR%"\CoverageXML\coverage_"%DATE_TIME%"
set BUCKET_NAME=bucket
set DESTINATION_PATH=coverage_"%DATE_TIME%"

REM Upload file to S3 bucket
aws s3 cp "%FILE_PATH%" s3://%BUCKET_NAME%/%DESTINATION_PATH%

REM Check if the upload was successful
if %errorlevel% equ 0 (
  call :log File uploaded successfully
) else (
  call :log Error uploading file
)

REM Function to log messages
:log
set "logDateTime=%date% %time%"
echo [%logDateTime%] %*
echo [%logDateTime%] %* >> "%CODECOVERAGE_LOG%"
exit /b