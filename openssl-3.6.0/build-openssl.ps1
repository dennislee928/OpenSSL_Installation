# OpenSSL Windows 自動化建置腳本
# 使用前請確保已安裝：
# 1. Perl (建議 Strawberry Perl)
# 2. NASM (Netwide Assembler)
# 3. Visual Studio Build Tools

param(
    [string]$Architecture = "x64",
    [string]$Prefix = "",
    [string]$OpenSSLDir = "",
    [switch]$SkipTest = $false,
    [switch]$NoMakedepend = $false
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "OpenSSL Windows 自動化建置腳本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 檢查必要工具
Write-Host "[1/6] 檢查必要工具..." -ForegroundColor Yellow

# 檢查 Perl
try {
    $perlVersion = & perl --version 2>&1 | Select-Object -First 1
    Write-Host "  ✓ Perl 已安裝: $perlVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Perl 未安裝或不在 PATH 中" -ForegroundColor Red
    Write-Host "    請從 https://strawberryperl.com/ 下載並安裝 Perl" -ForegroundColor Red
    exit 1
}

# 檢查 NASM
try {
    $nasmVersion = & nasm --version 2>&1 | Select-Object -First 1
    Write-Host "  ✓ NASM 已安裝: $nasmVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ NASM 未安裝或不在 PATH 中" -ForegroundColor Red
    Write-Host "    請從 https://www.nasm.us/ 下載並安裝 NASM" -ForegroundColor Red
    exit 1
}

# 檢查 Visual Studio
$vcvarsPath = $null
$vsPaths = @(
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvarsall.bat",
    "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat",
    "C:\Program Files\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat",
    "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat"
)

foreach ($path in $vsPaths) {
    if (Test-Path $path) {
        $vcvarsPath = $path
        Write-Host "  ✓ Visual Studio 已找到: $path" -ForegroundColor Green
        break
    }
}

if (-not $vcvarsPath) {
    Write-Host "  ✗ 找不到 Visual Studio vcvarsall.bat" -ForegroundColor Red
    Write-Host "    請確保已安裝 Visual Studio Build Tools" -ForegroundColor Red
    exit 1
}

# 設置 Visual Studio 環境
Write-Host ""
Write-Host "[2/6] 設置 Visual Studio 環境..." -ForegroundColor Yellow
& cmd /c "`"$vcvarsPath`" $Architecture >nul 2>&1 && set" | ForEach-Object {
    if ($_ -match "^([^=]+)=(.*)$") {
        [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
    }
}
Write-Host "  ✓ 環境變數已設置" -ForegroundColor Green

# 檢查編譯器
try {
    $clVersion = & cl 2>&1 | Select-Object -First 1
    Write-Host "  ✓ 編譯器可用: $clVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ 無法找到編譯器 (cl.exe)" -ForegroundColor Red
    exit 1
}

# 進入源碼目錄
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir
Write-Host ""
Write-Host "[3/6] 配置 OpenSSL..." -ForegroundColor Yellow

# 構建 Configure 命令
$configureArgs = @()
if ($Architecture -eq "x64") {
    $configureArgs += "VC-WIN64A"
} elseif ($Architecture -eq "x86") {
    $configureArgs += "VC-WIN32"
} else {
    $configureArgs += "VC-WIN64A"  # 預設使用 64 位元
}

if ($NoMakedepend) {
    $configureArgs += "no-makedepend"
}

if ($Prefix) {
    $configureArgs += "--prefix=$Prefix"
}

if ($OpenSSLDir) {
    $configureArgs += "--openssldir=$OpenSSLDir"
}

$configureCmd = "perl Configure " + ($configureArgs -join " ")
Write-Host "  執行: $configureCmd" -ForegroundColor Gray

& perl Configure $configureArgs
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ✗ Configure 失敗" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ Configure 完成" -ForegroundColor Green

# 編譯
Write-Host ""
Write-Host "[4/6] 編譯 OpenSSL（這可能需要一些時間）..." -ForegroundColor Yellow
& nmake
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ✗ 編譯失敗" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ 編譯完成" -ForegroundColor Green

# 測試
if (-not $SkipTest) {
    Write-Host ""
    Write-Host "[5/6] 執行測試..." -ForegroundColor Yellow
    & nmake test
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ⚠ 測試失敗，但繼續安裝..." -ForegroundColor Yellow
    } else {
        Write-Host "  ✓ 測試通過" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "[5/6] 跳過測試..." -ForegroundColor Yellow
}

# 安裝
Write-Host ""
Write-Host "[6/6] 安裝 OpenSSL..." -ForegroundColor Yellow
Write-Host "  注意：安裝到預設位置需要管理員權限" -ForegroundColor Gray

# 檢查管理員權限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "  ⚠ 未以管理員權限執行，安裝可能會失敗" -ForegroundColor Yellow
    Write-Host "  建議：以管理員權限重新執行此腳本" -ForegroundColor Yellow
}

& nmake install
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ✗ 安裝失敗" -ForegroundColor Red
    Write-Host "  提示：請以管理員權限執行此腳本" -ForegroundColor Yellow
    exit 1
}
Write-Host "  ✓ 安裝完成" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "OpenSSL 安裝完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "預設安裝位置：" -ForegroundColor Yellow
if ($Architecture -eq "x64") {
    Write-Host "  C:\Program Files\OpenSSL" -ForegroundColor White
} else {
    Write-Host "  C:\Program Files (x86)\OpenSSL" -ForegroundColor White
}
Write-Host ""
