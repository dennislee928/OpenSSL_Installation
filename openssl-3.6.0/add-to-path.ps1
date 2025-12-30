# Add Perl and NASM to PATH environment variable
# Run as Administrator to modify system PATH, or use -UserPath for user PATH only

param(
    [switch]$UserPath = $false,
    [switch]$SystemPath = $false
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PATH Environment Variable Setup Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check admin privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Determine target PATH scope
if (-not $UserPath -and -not $SystemPath) {
    if ($isAdmin) {
        $targetPath = "Machine"
        Write-Host "Running as Administrator, will modify System PATH" -ForegroundColor Yellow
    } else {
        $targetPath = "User"
        Write-Host "Not running as Administrator, will modify User PATH" -ForegroundColor Yellow
    }
} elseif ($SystemPath) {
    if (-not $isAdmin) {
        Write-Host "Error: Administrator privileges required to modify System PATH" -ForegroundColor Red
        Write-Host "Please run as Administrator or use -UserPath parameter" -ForegroundColor Yellow
        exit 1
    }
    $targetPath = "Machine"
} else {
    $targetPath = "User"
}

# Paths to add
$pathsToAdd = @()

# Check and add Perl
$perlPaths = @(
    "C:\Strawberry\perl\bin",
    "C:\Perl\bin",
    "C:\Program Files\Perl\bin",
    "C:\Program Files (x86)\Perl\bin",
    "C:\Program Files\Strawberry\perl\bin"
)

foreach ($path in $perlPaths) {
    if (Test-Path "$path\perl.exe") {
        $pathsToAdd += $path
        Write-Host "Found Perl: $path" -ForegroundColor Green
        break
    }
}

# Check and add NASM
$nasmPaths = @(
    "C:\Program Files\NASM",
    "C:\Program Files (x86)\NASM",
    "C:\NASM"
)

$nasmFound = $false
foreach ($path in $nasmPaths) {
    if (Test-Path "$path\nasm.exe") {
        $pathsToAdd += $path
        Write-Host "Found NASM: $path" -ForegroundColor Green
        $nasmFound = $true
        break
    }
}

if (-not $nasmFound) {
    Write-Host "NASM not found, will add default path: C:\Program Files\NASM" -ForegroundColor Yellow
    $pathsToAdd += "C:\Program Files\NASM"
}

if ($pathsToAdd.Count -eq 0) {
    Write-Host "No paths found to add" -ForegroundColor Red
    exit 1
}

# Get current PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", $targetPath)

# Check and add paths
$modified = $false
foreach ($path in $pathsToAdd) {
    if ($currentPath -notlike "*$path*") {
        $currentPath += ";$path"
        Write-Host "Adding: $path" -ForegroundColor Yellow
        $modified = $true
    } else {
        Write-Host "Already in PATH: $path" -ForegroundColor Gray
    }
}

if ($modified) {
    # Update PATH
    [Environment]::SetEnvironmentVariable("Path", $currentPath, $targetPath)
    
    # Update current session PATH
    $env:Path = [Environment]::GetEnvironmentVariable("Path", $targetPath) + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
    
    Write-Host ""
    Write-Host "PATH updated successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Note: Please restart PowerShell or Command Prompt for PATH changes to take effect" -ForegroundColor Yellow
    Write-Host "Or run this command to reload environment variables:" -ForegroundColor Yellow
    Write-Host "  `$env:Path = [System.Environment]::GetEnvironmentVariable('Path','$targetPath') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')" -ForegroundColor Gray
} else {
    Write-Host ""
    Write-Host "All paths are already in PATH" -ForegroundColor Green
}

Write-Host ""
Write-Host "Verifying installation:" -ForegroundColor Cyan
try {
    $perlVer = & perl --version 2>&1 | Select-Object -First 1
    Write-Host "  Perl: $perlVer" -ForegroundColor Green
} catch {
    Write-Host "  Perl: Not found (please restart terminal)" -ForegroundColor Yellow
}

try {
    $nasmVer = & nasm --version 2>&1 | Select-Object -First 1
    Write-Host "  NASM: $nasmVer" -ForegroundColor Green
} catch {
    Write-Host "  NASM: Not found (please restart terminal or install NASM)" -ForegroundColor Yellow
}
