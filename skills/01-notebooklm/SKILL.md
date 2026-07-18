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

### 3. 自動設定 OpenCode MCP

```bash
nlm setup add opencode
```

不要執行 `nlm skill install opencode`。它會額外建立 `~/.config/opencode/skills/nlm-skill/`，但 MCP 連線不需要這個 Skill。若先前已安裝，可執行 `nlm skill uninstall opencode` 移除。

若自動設定不可用，先找 MCP server 路徑：

- Windows：`where.exe notebooklm-mcp`
- macOS/Linux：`which notebooklm-mcp`

再於 `opencode.json` 的 `mcp` 區塊加入：
```json
"notebooklm": {
  "type": "local",
  "command": ["<notebooklm-mcp完整路徑>"],
  "enabled": true
}
```

### 5. 驗證
執行 `opencode mcp list`，確認 NotebookLM 已連線，再重啟 OpenCode 並問：「請列出我所有的 NotebookLM 筆記本。」

回報格式：nlm 版本、登入狀態（nlm doctor）、MCP 設定、筆記本讀取測試結果。
