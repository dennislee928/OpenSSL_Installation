# OpenSSL MinGW 建置步驟

## 步驟 1：在 MSYS2 中安裝必要工具

1. **開啟 MSYS2 MSYS 終端機**
   - 從開始選單找到 "MSYS2 MSYS"（不是 MinGW 終端機）
   - 或執行：`C:\msys64\msys2_shell.cmd -msys`

2. **更新套件資料庫**（如果還沒完成）：
   ```bash
   pacman -Syu
   ```
   - 如果提示關閉終端機，請關閉所有 MSYS2 終端機
   - 重新開啟 MSYS2 MSYS 終端機
   - 再次執行 `pacman -Syu`（可能需要執行兩次）

3. **安裝必要工具**：
   ```bash
   pacman -S make mingw-w64-x86_64-gcc perl
   ```
   - 當提示時，輸入 `Y` 確認安裝

## 步驟 2：驗證工具安裝

在 MSYS2 MSYS 終端機中執行：

```bash
# 檢查 make
make --version

# 檢查 gcc（應該在 /mingw64/bin/gcc）
/mingw64/bin/gcc --version

# 檢查 perl
perl --version
```

## 步驟 3：配置 OpenSSL

1. **進入 OpenSSL 源碼目錄**：
   ```bash
   cd /c/Users/dennis.lee/Downloads/openssl-3.6.0/openssl-3.6.0
   ```

2. **清理之前的配置**（如果有的話）：
   ```bash
   rm -f makefile
   ```

3. **配置 OpenSSL（64 位元）**：
   ```bash
   ./Configure mingw64
   ```

   您應該會看到類似以下的輸出：
   ```
   Configuring OpenSSL version 3.6.0 for target mingw64
   ...
   OpenSSL has been successfully configured
   ```

## 步驟 4：編譯 OpenSSL

```bash
make
```

這可能需要 10-30 分鐘，請耐心等待。

## 步驟 5：執行測試（建議）

```bash
make test
```

這會執行 OpenSSL 的測試套件，確保建置正確。

## 步驟 6：安裝 OpenSSL

**注意**：安裝需要管理員權限。

```bash
make install
```

預設安裝位置：
- 執行檔：`/usr/local/bin/openssl.exe`
- 函式庫：`/usr/local/lib/`
- 標頭檔：`/usr/local/include/openssl/`

## 疑難排解

### 問題：找不到 gcc

**解決方案**：
```bash
# 檢查 gcc 是否安裝
pacman -Q mingw-w64-x86_64-gcc

# 如果未安裝，執行
pacman -S mingw-w64-x86_64-gcc

# 確保 PATH 包含 /mingw64/bin
export PATH="/mingw64/bin:$PATH"
```

### 問題：Configure 失敗

**解決方案**：
- 確保在 MSYS2 MSYS shell 中執行（不是 PowerShell）
- 確保已安裝所有必要工具
- 檢查 Perl 版本：`perl --version`（需要 >= 5.10.0）

### 問題：make 失敗

**解決方案**：
- 檢查錯誤訊息
- 確保使用正確的編譯器：`which gcc` 應該顯示 `/mingw64/bin/gcc`
- 檢查磁碟空間是否足夠

## 快速參考

完整的建置命令序列：

```bash
# 1. 更新並安裝工具
pacman -Syu
pacman -S make mingw-w64-x86_64-gcc perl

# 2. 進入源碼目錄
cd /c/Users/dennis.lee/Downloads/openssl-3.6.0/openssl-3.6.0

# 3. 配置
./Configure mingw64

# 4. 編譯
make

# 5. 測試
make test

# 6. 安裝
make install
```
