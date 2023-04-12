@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"
set root=%cd%

where python >nul 2>&1
if %errorlevel% equ 0 (
    echo Python is installed on this computer.
) else (
    echo Python is not installed on this computer.
)

echo Starting web server on http://localhost:5000
echo Serving files from 5000

python LocalCacheStaticFileServer.py
