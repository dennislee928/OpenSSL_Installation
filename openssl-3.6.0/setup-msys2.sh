#!/bin/bash
# MSYS2 Setup Script for OpenSSL Build
# Run this in MSYS2 MSYS terminal

echo "========================================"
echo "MSYS2 Setup for OpenSSL Build"
echo "========================================"
echo ""

# Update package database
echo "[1/3] Updating package database..."
pacman -Syu --noconfirm
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to update packages"
    echo "Please close the terminal and run this script again"
    exit 1
fi
echo "OK: Package database updated"
echo ""

# Install required tools
echo "[2/3] Installing required tools..."
echo "  Installing: make"
pacman -S --noconfirm make
echo "  Installing: mingw-w64-x86_64-gcc (64-bit compiler)"
pacman -S --noconfirm mingw-w64-x86_64-gcc
echo "  Installing: perl"
pacman -S --noconfirm perl
echo "OK: All tools installed"
echo ""

# Verify installations
echo "[3/3] Verifying installations..."
echo ""

# Check make
if command -v make &> /dev/null; then
    echo "  ✓ make: $(make --version | head -n 1)"
else
    echo "  ✗ make: NOT FOUND"
fi

# Check gcc
if command -v /mingw64/bin/gcc &> /dev/null; then
    echo "  ✓ gcc: $(/mingw64/bin/gcc --version | head -n 1)"
else
    echo "  ✗ gcc: NOT FOUND"
fi

# Check perl
if command -v perl &> /dev/null; then
    echo "  ✓ perl: $(perl --version | head -n 1)"
else
    echo "  ✗ perl: NOT FOUND"
fi

echo ""
echo "========================================"
echo "Setup completed!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Navigate to OpenSSL source directory:"
echo "   cd /c/Users/dennis.lee/Downloads/openssl-3.6.0/openssl-3.6.0"
echo ""
echo "2. Configure OpenSSL:"
echo "   ./Configure mingw64"
echo ""
echo "3. Build OpenSSL:"
echo "   make"
echo ""
echo "4. Test (optional):"
echo "   make test"
echo ""
echo "5. Install (requires admin):"
echo "   make install"
echo ""
