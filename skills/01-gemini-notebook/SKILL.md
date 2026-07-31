---
name: opencode-gemini-notebook
description: 連接 Gemini Notebook（原 NotebookLM），讓 OpenCode 讀寫 Google Gemini Notebook 筆記本。說「連接 Gemini Notebook」「裝 Gemini Notebook」「連接 NotebookLM」時載入。
---

# 連接 Gemini Notebook（OpenCode 版）

Google 已將產品與社群 GitHub 專案改名為 Gemini Notebook，但目前 PyPI 套件、CLI 與 MCP 執行檔仍沿用 `notebooklm-mcp-cli`、`nlm`、`notebooklm-mcp`。不要把下列技術名稱改成尚未發布的名稱；此工具使用內部 API，並非 Google 官方 API。

## 步驟

### 1. 安裝
```bash
uv tool install notebooklm-mcp-cli
# 或 pip install notebooklm-mcp-cli
uv tool upgrade notebooklm-mcp-cli
nlm --version
```

新安裝或更新時使用可取得的最新版，且版本不得低於 0.9.3，以支援 `notebook.google.com` 與 `notebook.cloud.google.com`。

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

### 4. 驗證
執行 `opencode mcp list`，確認 Gemini Notebook 已連線，再重啟 OpenCode 並問：「請列出我所有的 Gemini Notebook 筆記本。」

回報格式：nlm 版本、登入狀態（nlm doctor）、MCP 設定、筆記本讀取測試結果。
