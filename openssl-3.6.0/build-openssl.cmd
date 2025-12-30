@echo off
REM OpenSSL Windows Build Script
REM This script sets up Visual Studio environment and builds OpenSSL

echo ========================================
echo OpenSSL Windows Build Script
echo ========================================
echo.

REM Setup Visual Studio environment
echo [1/4] Setting up Visual Studio environment...
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
if errorlevel 1 (
    echo ERROR: Failed to setup Visual Studio environment
    exit /b 1
)
echo OK: Visual Studio environment ready
echo.

REM Check if Configure was already run
if not exist "makefile" (
    echo [2/4] Configuring OpenSSL...
    perl Configure VC-WIN64A
    if errorlevel 1 (
        echo ERROR: Configure failed
        exit /b 1
    )
    echo OK: Configuration complete
    echo.
) else (
    echo [2/4] Configuration already done, skipping...
    echo.
)

REM Build OpenSSL
echo [3/4] Building OpenSSL (this may take 10-30 minutes)...
echo Please be patient...
nmake
if errorlevel 1 (
    echo ERROR: Build failed
    exit /b 1
)
echo OK: Build complete
echo.

REM Test (optional)
echo [4/4] Running tests...
nmake test
if errorlevel 1 (
    echo WARNING: Some tests failed, but continuing...
) else (
    echo OK: All tests passed
)
echo.

echo ========================================
echo Build completed successfully!
echo ========================================
echo.
echo To install OpenSSL, run as Administrator:
echo   nmake install
echo.
