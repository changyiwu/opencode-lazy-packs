---
name: opencode-notebooklm
description: 連接 NotebookLM，讓 OpenCode 讀寫 Google NotebookLM 筆記本。說「連接 NotebookLM」「裝 NotebookLM」時載入。
---

# 連接 NotebookLM（OpenCode 版）

## 步驟

### 1. 安裝
```bash
uv tool install notebooklm-mcp-cli
# 或 pip install notebooklm-mcp-cli
nlm --version
```

### 2. 登入
```bash
nlm login
```
（瀏覽器會開啟 Google 登入頁面）

驗證：
```bash
nlm doctor
```

### 3. 找到執行檔路徑
- Windows: `where.exe nlm`
- macOS/Linux: `which nlm`

> ⚠️ 路徑陷阱：不要用 `.local\bin\notebooklm-mcp.EXE`（已損壞的獨立 exe），要用 pip/uv 安裝的路徑（如 `Python3xx\Scripts\notebooklm-mcp.exe`）。

### 4. 寫入 opencode.json
編輯 `~/.config/opencode/opencode.json`，在 `mcp` 區塊加入：
```json
"notebooklm": {
  "type": "local",
  "command": ["<nlm完整路徑>", "--transport", "stdio"],
  "enabled": true
}
```

### 5. 驗證
重啟 OpenCode，問：「請列出我所有的 NotebookLM 筆記本。」

回報格式：nlm 版本、登入狀態（nlm doctor）、MCP 設定、筆記本讀取測試結果。
