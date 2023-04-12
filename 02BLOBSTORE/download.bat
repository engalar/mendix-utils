@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

set "base_url=https://cdn.mendix.com/"
set "output_dir=mendix/"

for /f "tokens=*" %%a in (listing.txt) do (
    set "relative_path=%%a"
    set "url=!base_url!!relative_path!"
    set "output_file=!output_dir!!relative_path!"
    if not exist "!output_file!" (
        echo Downloading !url! to !output_file!
        md "!output_file!\.." >nul 2>&1
        powershell -command "& {Invoke-WebRequest !url! -OutFile !output_file!}"
    ) else (
        echo !output_file! already exists, skipping download
    )
)