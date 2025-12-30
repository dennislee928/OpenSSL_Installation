# 快速 MinGW 建置方案

## 當前狀態

✅ **已具備：**
- GCC (MinGW-W64 x86_64) - 來自 Strawberry Perl
- Perl (v5.42.0) - Strawberry Perl
- NASM (v3.01)

❌ **缺少：**
- make

## 解決方案選項

### 選項 1：安裝 MSYS2（推薦）

這是最可靠的方法，符合 OpenSSL 官方文件建議。

1. **下載並安裝 MSYS2**：
   - 網址：https://www.msys2.org/
   - 執行安裝程式，安裝到 `C:\msys64`

2. **開啟 MSYS2 MSYS 終端機**（不是 MinGW 終端機）

3. **更新並安裝工具**：
   ```bash
   pacman -Syu
   # 如果提示關閉終端機，關閉後重新開啟再執行一次
   pacman -Syu
   
   pacman -S make mingw-w64-x86_64-gcc perl
   ```

4. **在 MSYS2 中建置**：
   ```bash
   cd /c/Users/dennis.lee/Downloads/openssl-3.6.0/openssl-3.6.0
   ./Configure mingw64
   make
   make test
   make install
   ```

### 選項 2：下載獨立的 make

如果您不想安裝整個 MSYS2，可以只下載 make：

1. **下載 make for Windows**：
   - 從 MSYS2 套件下載：https://packages.msys2.org/package/make
   - 或使用 Chocolatey：`choco install make`
   - 或從其他來源下載預編譯版本

2. **將 make 加入 PATH**

3. **使用現有工具建置**：
   ```powershell
   # 清理之前的 Visual Studio 配置
   Remove-Item makefile -ErrorAction SilentlyContinue
   
   # 配置（使用 mingw64）
   perl Configure mingw64
   
   # 編譯
   make
   
   # 測試
   make test
   
   # 安裝
   make install
   ```

### 選項 3：使用 Chocolatey 安裝 make

如果您已安裝 Chocolatey：

```powershell
# 以管理員權限執行
choco install make
```

然後重新開啟 PowerShell 並執行建置。

## 注意事項

⚠️ **重要**：根據 OpenSSL 文件，建議使用 MSYS2 的 MinGW 編譯器，而不是 Strawberry Perl 的 gcc。雖然 Strawberry Perl 的 gcc 可能可以工作，但可能會有相容性問題。

## 推薦流程

1. **安裝 MSYS2**（最可靠）
2. **在 MSYS2 中安裝必要工具**
3. **在 MSYS2 MSYS 終端機中執行建置**

這樣可以確保使用正確的工具鏈，避免相容性問題。
