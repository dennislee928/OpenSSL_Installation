# OpenSSL Windows 安裝指南

## 當前狀態檢查

✅ **已找到：**
- Visual Studio 2019 Build Tools（位於：`C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools`）

❌ **需要安裝：**
1. **Perl**（建議使用 Strawberry Perl）
2. **NASM**（Netwide Assembler）

## 安裝步驟

### 步驟 1：安裝 Perl

1. 下載 Strawberry Perl：
   - 網址：https://strawberryperl.com/
   - 選擇 Windows 64-bit 版本下載

2. 執行安裝程式，安裝時確保勾選「Add Perl to PATH environment variable」

3. 驗證安裝：
   ```powershell
   perl --version
   ```

### 步驟 2：安裝 NASM

1. 下載 NASM：
   - 網址：https://www.nasm.us/pub/nasm/releasebuilds/
   - 選擇最新版本的 Windows 安裝程式（例如：nasm-2.xx-installer-x64.exe）

2. 執行安裝程式，安裝到預設位置（通常是 `C:\Program Files\NASM`）

3. 將 NASM 加入 PATH：
   - 開啟「系統環境變數」設定
   - 編輯 PATH 變數
   - 新增：`C:\Program Files\NASM`

4. 驗證安裝：
   ```powershell
   nasm --version
   ```

### 步驟 3：安裝 OpenSSL

在安裝完 Perl 和 NASM 後，請重新開啟 PowerShell（以系統管理員權限），然後執行以下命令：

```powershell
# 1. 進入 OpenSSL 源碼目錄
cd C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0

# 2. 設置 Visual Studio 環境
& "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64

# 3. 配置 OpenSSL（64位元版本）
perl Configure VC-WIN64A

# 4. 編譯 OpenSSL
nmake

# 5. 執行測試（建議）
nmake test

# 6. 安裝 OpenSSL（需要管理員權限）
nmake install
```

## 預設安裝位置

- **64位元：** `C:\Program Files\OpenSSL`
- **32位元：** `C:\Program Files (x86)\OpenSSL`

## 安裝到自訂位置

如果您想安裝到其他位置（例如避免覆蓋系統版本）：

```powershell
perl Configure VC-WIN64A --prefix=C:\OpenSSL --openssldir=C:\OpenSSL\ssl
nmake
nmake test
nmake install
```

## 注意事項

1. **系統管理員權限**：安裝到預設位置需要管理員權限
2. **PATH 環境變數**：安裝後可能需要將 OpenSSL 的 bin 目錄加入 PATH
3. **系統版本**：如果系統已安裝 OpenSSL，建議安裝到不同位置
