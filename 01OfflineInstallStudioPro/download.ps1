$mendix_version="10.13.1.42744"



# 设置编码为 UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 设置当前脚本目录为工作目录
cd -LiteralPath $PSScriptRoot

# 设置 CDN 基础 URL
$CDN_BASE_URL = "https://artifacts.rnd.mendix.com"

# 确保 Dependencies 目录存在
$dependenciesDir = Join-Path $PSScriptRoot "Dependencies"
if (-not (Test-Path -Path $dependenciesDir)) {
  New-Item -ItemType Directory -Path $dependenciesDir | Out-Null
}

# 定义下载文件的函数
function Ensure-File {
  param (
    [string]$url,
    [string]$outputPath
  )

  if (-not (Test-Path -Path $outputPath)) {
    Write-Host "下载文件 $url 到 $outputPath"
        (New-Object System.Net.WebClient).DownloadFile($url, $outputPath)
  }
  else {
    Write-Host "已经存在 $outputPath"
  }
}



function downloadJDK {
  param (
    [int]$version
  )

  $url = "https://mirrors.ustc.edu.cn/adoptium/releases/temurin${version}-binaries/LatestRelease/"
  $base_filename = "OpenJDK${version}U-jdk_x64_windows_hotspot_"
  $pageContent = Invoke-WebRequest -Uri $url -UseBasicParsing
  $regex = [regex]::new("href\s*=\s*""($base_filename[^\s""]*\.msi)""")
  $matches = $regex.Matches($pageContent.Content)

  foreach ($match in $matches) {
    $downloadLink = $match.Groups[1].Value
    Ensure-File $url$downloadLink "$dependenciesDir/adoptiumjdk_${version}_x64.msi"
  }
}

downloadJDK 11
downloadJDK 17
downloadJDK 21


# 下载所需文件
Ensure-File "https://download.visualstudio.microsoft.com/download/pr/bb581716-4cca-466e-9857-512e2371734b/5fe261422a7305171866fd7812d0976f/windowsdesktop-runtime-8.0.7-win-x64.exe" "$dependenciesDir/windowsdesktop-runtime-8.0-x64.exe"
Ensure-File "https://aka.ms/vs/16/release/vc_redist.x64.exe" "$dependenciesDir/vcredist2019_x64.exe"
Ensure-File "https://appdev-mx-cdn.s3.amazonaws.com/native-builders/latest.exe" "$dependenciesDir/mendix_native_mobile_builder.exe"
Ensure-File "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe" "$dependenciesDir/git_for_windows_installer.exe"
Ensure-File "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/4ce14d46-50c8-43d4-8c49-d13652b01e50/MicrosoftEdgeWebView2RuntimeInstallerX64.exe" "$dependenciesDir/MicrosoftEdgeWebview2Setup.exe"
Ensure-File "https://mirrors.cloud.tencent.com/gradle/gradle-8.5-bin.zip" "$dependenciesDir/gradle-8.5-bin.zip"
Ensure-File "$CDN_BASE_URL/modelers/Mendix-${mendix_version}-Setup.exe" "$PSScriptRoot/Mendix-${mendix_version}-Setup.exe"
