@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"
set port=8000
set root=%cd%

echo Starting web server on http://localhost:%port%
echo Serving files from %root%

python -m http.server %port%
