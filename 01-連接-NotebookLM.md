# OpenCode 懶人包 #01：連接 NotebookLM

> 版本：v0.2
> 更新日期：2026-06-12

> 📌 **本懶人包可獨立執行**：會自動檢查並安裝所需工具。

---

## 這個懶人包會幫你做什麼？

讓 OpenCode 能夠操作 Google NotebookLM：
- 建立 notebook、上傳資料來源
- 產生教學簡報（Slide Deck）、資訊圖表（Infographic）
- 產生音訊概覽、影片概覽、心智圖、測驗等
- 所有成品自動下載到電腦裡的指定資料夾

---

## 原理說明

```
OpenCode ←(MCP 協定)→ nlm（翻譯官）←(Google 登入)→ NotebookLM
```

`nlm` 是 stdio MCP server，OpenCode 透過 MCP 協定呼叫它，它再模擬瀏覽器操作 NotebookLM。因為 NotebookLM 沒有官方 API，`nlm` 扮演「翻譯官」的角色。

---

## 先備條件

- [ ] Node.js 18+ 已安裝
- [ ] OpenCode 已安裝
- [ ] 有 Google 帳號
- [ ] 電腦有網路連線

---

## 安裝方式二選一

`notebooklm-mcp-cli` 支援兩種安裝方式：

**方式 A：uv（獨立環境，推薦）**
```bash
uv tool install notebooklm-mcp-cli
```

**方式 B：pip（全域安裝）**
```bash
pip install notebooklm-mcp-cli
```

---

## 請 OpenCode 幫我執行以下步驟

> ⚠️ 把這份檔案的內容貼給 OpenCode，它會自動執行。遇到需要手動操作的地方會暫停指示你。

---

### 步驟零：環境檢查

1. **確認作業系統**：Windows / macOS / Linux
2. **確認網路連線正常**
3. **檢查 uv 或 pip 是否可用**：`uv --version` 或 `pip --version`，如果都沒裝，步驟一會補裝 uv
4. **檢查 Node.js**：`node --version`（需 18+）

---

### 步驟一：安裝 uv（如果沒裝）

**Windows（PowerShell）**：
```bash
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**macOS / Linux**：
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

確認：`uv --version`

---

### 步驟二：安裝 NotebookLM MCP CLI

```bash
uv tool install notebooklm-mcp-cli
# 或
pip install notebooklm-mcp-cli
```

確認：
```bash
nlm --version
```

> `nlm: command not found` → 重開終端機；仍失敗代表 uv/pip 工具路徑沒進 PATH。

---

### 步驟三：登入 Google 帳號

```bash
nlm login
```

> 🖐️ 瀏覽器會開啟 Google 登入頁面，選擇你的 Google 帳號完成授權。

登入後驗證：
```bash
nlm doctor
```

> 如果顯示未認證，重新執行 `nlm login`。

---

### 步驟四：設定 MCP 連接

找到 nlm 的完整路徑：

**Windows**：`where.exe nlm`

**macOS / Linux**：`which nlm`

記錄這個路徑。接著編輯 `~/.config/opencode/opencode.json`，在 `mcp` 區塊加入：

```json
"notebooklm": {
  "type": "local",
  "command": ["<nlm完整路徑>", "--transport", "stdio"],
  "enabled": true
}
```

> ⚠️ **重要：路徑陷阱！**
> 電腦上可能同時存在兩個 `notebooklm-mcp.exe`：
> - ✅ **正確**：pip/uv 安裝的，位於 `Python3xx\Scripts\notebooklm-mcp.exe`（或 uv 的 bin 目錄）
> - ❌ **錯誤**：獨立的 `.local\bin\notebooklm-mcp.EXE`，此為 PyInstaller 打包的獨立執行檔，**已損壞**，會報 `ModuleNotFoundError: No module named 'notebooklm_tools'`
>
> 請務必使用 pip 或 uv 安裝的路徑。如果不確定，用以下指令查詢：
> ```bash
> pip show notebooklm-mcp-cli -f | grep notebooklm-mcp
> # 或
> where notebooklm-mcp.exe   (Windows)
> which notebooklm-mcp       (macOS/Linux)
> ```

---

### 步驟五：建立本地資料夾

在文件資料夾下建立以下目錄結構：

```
Documents/
  └── NotebookLM/
      ├── slides/          ← 簡報（Slide Deck）
      ├── infographics/    ← 資訊圖表
      ├── audio/           ← 音訊概覽
      ├── video/           ← 影片概覽
      ├── docs/            ← 報告文件
      ├── sheets/          ← 試算表
      ├── mindmaps/        ← 心智圖
      └── quizzes/         ← 測驗與閃卡
```

> 建立完成後，告知使用者資料夾的完整路徑。

---

### 步驟六：重啟並驗證連接

> 🖐️ 完全關閉 OpenCode，然後重新開啟。

驗證方式：對 OpenCode 說「請列出我所有的 NotebookLM 筆記本」。能成功列出（即使是空的）代表連接成功。

---

### 步驟七：功能測試

1. 建立一個名為「測試筆記本」的 notebook
2. 確認建立成功
3. 刪除這個測試筆記本
4. ✅ 「全部完成！OpenCode 已成功連接 NotebookLM。」

---

## 完成回報格式

```md
## NotebookLM 連接完成

- nlm 版本：xxx
- uv / pip：已安裝
- 登入狀態（nlm doctor）：成功 / 失敗
- MCP 設定：已寫入 ~/.config/opencode/opencode.json
- 筆記本讀取測試：成功 / 失敗
- 本地資料夾：已建立 / 未建立
```

---

## 如果安裝失敗，如何重來

對 OpenCode 說：「上次 NotebookLM 懶人包執行失敗了，幫我清除設定，重新跑一次。」

復原步驟：
1. 從 `opencode.json` 的 `mcp` 區塊移除 `notebooklm` 項目
2. 移除 nlm：`uv tool uninstall notebooklm-mcp-cli`（或 `pip uninstall notebooklm-mcp-cli`）
3. 清除登入：`nlm logout`（或刪除 `~\.notebooklm-mcp-cli\` 目錄）
4. 從步驟零重新開始

---

## 常見問題

| 問題 | 解法 |
|------|------|
| `nlm: command not found` | 重開終端機；確認 uv/pip 安裝路徑已加入 PATH |
| `uv: command not found` | Windows 需重開 PowerShell；macOS/Linux 需 `source ~/.bashrc` 或 `source ~/.zshrc` |
| 登入後 `nlm doctor` 顯示未認證 | 重新執行 `nlm login`，確認瀏覽器登入成功 |
| 瀏覽器沒有自動開啟 | 手動開 https://notebooklm.google.com/ 確認已登入，或嘗試 `nlm login --manual` |
| OpenCode 看不到 NotebookLM 工具 | 檢查 `opencode.json` 中 `mcp.notebooklm.command` 路徑是否指向正確的 pip/uv 版本（見步驟四路徑陷阱）|
| `ModuleNotFoundError: No module named 'notebooklm_tools'` | ❌ 你用的是 `.local\bin\` 中損壞的獨立 exe！改用 pip/uv 安裝的版本 |
| opencode.json 格式錯誤 | JSON 最後一項不能有逗號；確認 `mcp` 在頂層，不要巢狀到其他項目裡 |
| Windows 上指令格式錯誤 | 使用 PowerShell，不要用 CMD |
| `nlm list` 在 Windows 顯示亂碼 | 設定 `$env:PYTHONIOENCODING = "utf-8"`，這是已知的 cp950 編碼問題，不影響功能 |

---

## 更新紀錄

| 日期 | 版本 | 更新內容 |
|------|------|---------|
| 2026-06-12 | v0.2 | 改用 `uv tool install` 為主、補 `nlm doctor`、路徑陷阱警告、本地資料夾、功能測試、復原流程 |
| 2026-05-19 | v0.1 | 初版 |
