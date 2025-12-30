# 如何將 Perl 和 NASM 加入 PATH 環境變數

## 方法 1：使用自動化腳本（推薦）

### 步驟 1：以管理員權限執行 PowerShell

1. 按 `Win + X`，選擇「Windows PowerShell (系統管理員)」或「終端機 (系統管理員)」
2. 或搜尋「PowerShell」，右鍵點選「以系統管理員身分執行」

### 步驟 2：執行腳本

```powershell
cd C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0
.\add-to-path.ps1
```

**只修改使用者 PATH（不需要管理員）：**
```powershell
.\add-to-path.ps1 -UserPath
```

**修改系統 PATH（需要管理員）：**
```powershell
.\add-to-path.ps1 -SystemPath
```

### 步驟 3：重新開啟終端機

關閉並重新開啟 PowerShell 或命令提示字元，讓 PATH 變更生效。

---

## 方法 2：透過 Windows 設定（圖形界面）

### 步驟 1：開啟環境變數設定

1. 按 `Win + R`，輸入 `sysdm.cpl`，按 Enter
2. 點選「進階」標籤
3. 點選「環境變數」按鈕

或

1. 按 `Win + X`，選擇「系統」
2. 點選「進階系統設定」
3. 點選「環境變數」按鈕

### 步驟 2：編輯 PATH 變數

**修改使用者 PATH（推薦）：**
- 在上方的「使用者變數」區域
- 找到並選取「Path」
- 點選「編輯」

**修改系統 PATH（需要管理員權限）：**
- 在下方的「系統變數」區域
- 找到並選取「Path」
- 點選「編輯」

### 步驟 3：新增路徑

點選「新增」，然後分別加入以下路徑：

**Perl（根據您的安裝位置選擇）：**
- `C:\Strawberry\perl\bin` （如果使用 Strawberry Perl）
- 或 `C:\Perl\bin` （如果使用其他 Perl 發行版）

**NASM：**
- `C:\Program Files\NASM` （64 位元系統）
- 或 `C:\Program Files (x86)\NASM` （32 位元系統）

### 步驟 4：確認並套用

1. 點選「確定」關閉所有對話框
2. 重新開啟所有終端機視窗

---

## 方法 3：使用 PowerShell 命令（臨時）

這只會影響目前的 PowerShell 會話，關閉後會失效：

```powershell
$env:Path += ";C:\Strawberry\perl\bin;C:\Program Files\NASM"
```

---

## 方法 4：使用 PowerShell 命令（永久）

### 修改使用者 PATH（不需要管理員）

```powershell
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$userPath += ";C:\Strawberry\perl\bin;C:\Program Files\NASM"
[Environment]::SetEnvironmentVariable("Path", $userPath, "User")
```

### 修改系統 PATH（需要管理員權限）

```powershell
# 以管理員權限執行
$systemPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$systemPath += ";C:\Strawberry\perl\bin;C:\Program Files\NASM"
[Environment]::SetEnvironmentVariable("Path", $systemPath, "Machine")
```

---

## 驗證 PATH 是否設定成功

重新開啟終端機後，執行以下命令驗證：

```powershell
# 檢查 Perl
perl --version

# 檢查 NASM
nasm --version

# 查看 PATH 中是否包含這些路徑
$env:PATH -split ';' | Where-Object { $_ -like '*perl*' -or $_ -like '*nasm*' }
```

---

## 常見問題

### Q: 為什麼修改後還是找不到命令？

A: 您需要**重新開啟終端機**才能讓 PATH 變更生效。環境變數是在程式啟動時載入的。

### Q: 使用者 PATH 和系統 PATH 有什麼差別？

A: 
- **使用者 PATH**：只影響目前登入的使用者，不需要管理員權限
- **系統 PATH**：影響所有使用者，需要管理員權限

建議使用**使用者 PATH**，除非您需要讓所有使用者都能使用這些工具。

### Q: 如何確認路徑是否正確？

A: 確認以下檔案存在：
- `C:\Strawberry\perl\bin\perl.exe` （Perl）
- `C:\Program Files\NASM\nasm.exe` （NASM）

如果檔案不存在，請先安裝對應的軟體。

---

## 目前找到的安裝位置

根據檢查，您的系統中：
- ✅ **Perl**: `C:\Strawberry\perl\bin` （已找到）
- ❌ **NASM**: 尚未安裝

請先從 https://www.nasm.us/ 下載並安裝 NASM，然後再執行 PATH 設定。
