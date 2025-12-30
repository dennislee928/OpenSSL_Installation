# OpenSSL MinGW Build Script
# This script helps set up and build OpenSSL using MinGW/MSYS2

param(
    [string]$Architecture = "x64",
    [switch]$SkipTest = $false
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "OpenSSL MinGW Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check for MSYS2
$msys2Paths = @(
    "C:\msys64",
    "C:\msys32"
)

$msys2Path = $null
foreach ($path in $msys2Paths) {
    if (Test-Path $path) {
        $msys2Path = $path
        Write-Host "Found MSYS2: $msys2Path" -ForegroundColor Green
        break
    }
}

if (-not $msys2Path) {
    Write-Host "ERROR: MSYS2 not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install MSYS2 from: https://www.msys2.org/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "After installation, you need to:" -ForegroundColor Yellow
    Write-Host "1. Open MSYS2 MSYS terminal (not MinGW terminal)" -ForegroundColor White
    Write-Host "2. Run: pacman -Syu" -ForegroundColor White
    Write-Host "3. Run: pacman -S make mingw-w64-x86_64-gcc perl" -ForegroundColor White
    Write-Host "4. Then run this script again" -ForegroundColor White
    exit 1
}

# Determine MSYS2 shell path
$msysShell = Join-Path $msys2Path "usr\bin\bash.exe"
if (-not (Test-Path $msysShell)) {
    Write-Host "ERROR: MSYS2 bash not found at: $msysShell" -ForegroundColor Red
    exit 1
}

# Convert Windows path to MSYS2 path
$opensslPath = $PWD.Path -replace '^([A-Z]):', '/$1' -replace '\\', '/'
$opensslPath = $opensslPath.ToLower()

Write-Host "OpenSSL source path: $opensslPath" -ForegroundColor Gray
Write-Host ""

# Check if Configure was already run
$configured = Test-Path "makefile"

if (-not $configured) {
    Write-Host "[1/4] Configuring OpenSSL..." -ForegroundColor Yellow
    
    if ($Architecture -eq "x64") {
        $configureTarget = "mingw64"
    } else {
        $configureTarget = "mingw"
    }
    
    $configureCmd = "cd '$opensslPath' && ./Configure $configureTarget"
    
    Write-Host "  Running: ./Configure $configureTarget" -ForegroundColor Gray
    & $msysShell -c $configureCmd
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ERROR: Configure failed" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "  OK: Configuration complete" -ForegroundColor Green
} else {
    Write-Host "[1/4] Configuration already done, skipping..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[2/4] Building OpenSSL (this may take 10-30 minutes)..." -ForegroundColor Yellow
Write-Host "  Please be patient..." -ForegroundColor Gray

$buildCmd = "cd '$opensslPath' && make"
& $msysShell -c $buildCmd

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: Build failed" -ForegroundColor Red
    exit 1
}

Write-Host "  OK: Build complete" -ForegroundColor Green

if (-not $SkipTest) {
    Write-Host ""
    Write-Host "[3/4] Running tests..." -ForegroundColor Yellow
    
    $testCmd = "cd '$opensslPath' && make test"
    & $msysShell -c $testCmd
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  WARNING: Some tests failed, but continuing..." -ForegroundColor Yellow
    } else {
        Write-Host "  OK: All tests passed" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "[3/4] Skipping tests..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[4/4] Build Summary" -ForegroundColor Yellow

# Check for built files
$builtFiles = @(
    "apps\openssl.exe",
    "libcrypto.a",
    "libssl.a"
)

Write-Host "  Checking built files..." -ForegroundColor Gray
foreach ($file in $builtFiles) {
    if (Test-Path $file) {
        $size = (Get-Item $file).Length / 1MB
        Write-Host "    ✓ $file ($([math]::Round($size, 2)) MB)" -ForegroundColor Green
    } else {
        Write-Host "    ✗ $file (not found)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Build completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To install OpenSSL, run in MSYS2 MSYS terminal:" -ForegroundColor Yellow
Write-Host "  cd '$opensslPath'" -ForegroundColor Gray
Write-Host "  make install" -ForegroundColor Gray
Write-Host ""
Write-Host "Note: Installation requires administrator privileges" -ForegroundColor Yellow
Write-Host ""
