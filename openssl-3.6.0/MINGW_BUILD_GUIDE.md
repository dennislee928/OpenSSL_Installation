# 使用 MinGW 建置 OpenSSL 指南

## 步驟 1：安裝 MSYS2

1. 下載 MSYS2：
   - 網址：https://www.msys2.org/
   - 下載並執行安裝程式（例如：`msys2-x86_64-*.exe`）
   - 安裝到預設位置：`C:\msys64`

2. 安裝完成後，開啟 **MSYS2 MSYS** 終端機（不是 MinGW 終端機）

## 步驟 2：更新 MSYS2 套件

在 MSYS2 MSYS 終端機中執行：

```bash
pacman -Syu
```

如果提示關閉終端機，請關閉後重新開啟，然後再次執行：

```bash
pacman -Syu
```

## 步驟 3：安裝必要的工具

在 MSYS2 MSYS 終端機中執行：

```bash
# 安裝 make
pacman -S make

# 安裝 MinGW 64 位元編譯器（用於 64 位元 OpenSSL）
pacman -S mingw-w64-x86_64-gcc

# 安裝 MinGW 32 位元編譯器（可選，如果只需要 64 位元可跳過）
# pacman -S mingw-w64-i686-gcc

# 確保 Perl 已安裝（MSYS2 通常已包含）
pacman -S perl
```

## 步驟 4：建置 OpenSSL

### 方法 A：在 MSYS2 MSYS 終端機中建置

1. 開啟 **MSYS2 MSYS** 終端機

2. 進入 OpenSSL 源碼目錄：
   ```bash
   cd /c/Users/dennis.lee/Downloads/openssl-3.6.0/openssl-3.6.0
   ```

3. 配置 OpenSSL（64 位元）：
   ```bash
   ./Configure mingw64
   ```

   或配置 OpenSSL（32 位元）：
   ```bash
   ./Configure mingw
   ```

4. 編譯：
   ```bash
   make
   ```

5. 執行測試（建議）：
   ```bash
   make test
   ```

6. 安裝（需要管理員權限）：
   ```bash
   make install
   ```

### 方法 B：使用 PowerShell 腳本（自動化）

執行 `build-openssl-mingw.ps1` 腳本（見下方）

## 重要注意事項

1. **必須使用 MSYS2 的 MinGW 編譯器**：
   - 使用 `mingw-w64-x86_64-gcc`（64 位元）
   - 不要使用 MSYS2 自帶的 gcc
   - 不要使用 Strawberry Perl 的 gcc

2. **PATH 設定**：
   - 在 MSYS2 shell 中，MinGW 編譯器應該自動在 PATH 中
   - 如果找不到，檢查：`which gcc` 應該顯示 `/mingw64/bin/gcc`（64 位元）

3. **建置結果**：
   - 建置出的 OpenSSL 是**原生 Windows 二進位檔**
   - **不依賴** MSYS2 執行
   - 可以在任何 Windows 系統上執行

## 驗證安裝

建置完成後，檢查產生的檔案：

```bash
ls -la apps/openssl.exe
ls -la libcrypto*.a
ls -la libssl*.a
```

## 疑難排解

### 問題：找不到 gcc

**解決方案**：
```bash
# 檢查 gcc 是否在 PATH 中
which gcc

# 如果不在，手動加入 PATH
export PATH="/mingw64/bin:$PATH"
```

### 問題：Configure 失敗

**解決方案**：
- 確保在 MSYS2 MSYS shell 中執行（不是 PowerShell）
- 確保已安裝所有必要套件
- 檢查 Perl 版本：`perl --version`（需要 >= 5.10.0）

### 問題：make 失敗

**解決方案**：
- 確保使用正確的編譯器：`gcc --version` 應該顯示 MinGW
- 檢查是否有足夠的磁碟空間
- 查看錯誤訊息，可能需要安裝額外的開發套件
