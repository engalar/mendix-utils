@echo off
chcp 65001
SETLOCAL
cd /d "%~dp0"
set CDN_BASE_URL=https://artifacts.rnd.mendix.com


@REM begin version ==========================================================================
setlocal enabledelayedexpansion

del listing.txt
CALL :ensure_file https://cdn.mendix.com/listing.txt , listing.txt

set count=0
for /f "tokens=1,2 delims=-" %%a in (listing.txt) do (
    if "%%a" == "runtime/mendix" (
      set /a count+=1
      set var[!count!]=%%b
    )
)

echo.
echo 请选择一个你想要安装的Studio Pro版本号?
echo [162] 9.9.2.35886
echo 例如你输入162表示安装9.9.2.35886
echo.
for /l %%x in (1,1,!count!) do (
    echo [%%x] !var[%%x]:~0,-7!
)
echo.
set /p chose=?
echo.
set folder=!var[%chose%]:~0,-7!
echo 你选择安装 !folder!
@REM end version ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

if not exist ./Dependencies (
  mkdir Dependencies
)
@REM adoptiumjdk_11_x64.msi – for versions 9.14.0 and above
@REM adoptopenjdk_11_x64.msi – for versions 9.13.x and below
CALL :ensure_file https://cdn.mendix.com/installer/AdoptOpenJDK/OpenJDK11U-jdk_x64_windows_hotspot_11.0.3_7.msi , ./Dependencies/adoptopenjdk_11_x64.msi
CALL :ensure_file %CDN_BASE_URL%/native-builders/latest.exe , ./Dependencies/mendix_native_mobile_builder.exe
CALL :ensure_file https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe , ./Dependencies/credist2010_x64.exe
CALL :ensure_file https://aka.ms/vs/16/release/vc_redist.x64.exe , ./Dependencies/credist2019_x64.exe
CALL :ensure_file https://download.visualstudio.microsoft.com/download/pr/5681bdf9-0a48-45ac-b7bf-21b7b61657aa/bbdc43bc7bf0d15b97c1a98ae2e82ec0/windowsdesktop-runtime-6.0.5-win-x64.exe , ./Dependencies/windowsdesktop-runtime-6.0-x64.exe
CALL :ensure_file %CDN_BASE_URL%/modelers/Mendix-%folder%-Setup.exe , ./Mendix-%folder%-Setup.exe


EXIT /B %ERRORLEVEL%

:ensure_file
if not exist %~2 (
  echo 下载文件 %~1 到 %~2
  powershell -Command "(New-Object Net.WebClient).DownloadFile('%~1', '%~2')"
) else (
  echo 已经存在 %~2
)
EXIT /B 0