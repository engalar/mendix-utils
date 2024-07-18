@echo off
chcp 65001
SETLOCAL
cd /d "%~dp0"
set CDN_BASE_URL=https://artifacts.rnd.mendix.com

if not exist ./Dependencies (
  mkdir Dependencies
)

@REM dotnet
CALL :ensure_file https://download.visualstudio.microsoft.com/download/pr/bb581716-4cca-466e-9857-512e2371734b/5fe261422a7305171866fd7812d0976f/windowsdesktop-runtime-8.0.7-win-x64.exe , ./Dependencies/windowsdesktop-runtime-8.0-x64.exe

@REM jdk
CALL :ensure_file https://mirrors.ustc.edu.cn/adoptium/releases/temurin21-binaries/jdk-21.0.3%2B9/OpenJDK21U-jdk_x64_windows_hotspot_21.0.3_9.msi , ./Dependencies/adoptiumjdk_21_x64.msi

@REM vc
CALL :ensure_file https://aka.ms/vs/16/release/vc_redist.x64.exe , ./Dependencies/vcredist2019_x64.exe

@REM native_build
CALL :ensure_file https://appdev-mx-cdn.s3.amazonaws.com/native-builders/latest.exe , ./Dependencies/mendix_native_mobile_builder.exe

@REM git
CALL :ensure_file https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe , ./Dependencies/git_for_windows_installer.exe

@REM WebView2
CALL :ensure_file https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/4ce14d46-50c8-43d4-8c49-d13652b01e50/MicrosoftEdgeWebView2RuntimeInstallerX64.exe , ./Dependencies/MicrosoftEdgeWebview2Setup.exe

@REM gradle
CALL :ensure_file https://mirrors.cloud.tencent.com/gradle/gradle-8.5-bin.zip , ./Dependencies/gradle-8.5-bin.zip


CALL :ensure_file %CDN_BASE_URL%/modelers/Mendix-10.12.1.39914-Setup.exe , ./Mendix-10.12.1.39914-Setup.exe


EXIT /B %ERRORLEVEL%

:ensure_file
if not exist %~2 (
  echo 下载文件 %~1 到 %~2
  powershell -Command "(New-Object Net.WebClient).DownloadFile('%~1', '%~2')"
) else (
  echo 已经存在 %~2
)
EXIT /B 0