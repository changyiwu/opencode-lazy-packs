---
name: opencode-obsidian
description: 連接 Obsidian，讓 OpenCode 讀寫第二大腦筆記。說「連接 Obsidian」「設定 Obsidian vault」時載入。
---

# 連接 Obsidian

透過 `@bitbonsai/mcpvault` 讓 OpenCode 讀寫 Obsidian vault。

## 步驟

### 1. 找到 Obsidian vault 路徑
搜尋含 `.obsidian` 子資料夾的目錄：
```powershell
Get-ChildItem -Path "$env:USERPROFILE\OneDrive" -Recurse -Directory |
  Where-Object { Test-Path (Join-Path $_.FullName ".obsidian") }
```
確認使用者這是主要 vault。

### 2. 寫入 opencode.json
```json
"obsidian": {
  "type": "local",
  "command": ["npx", "-y", "@bitbonsai/mcpvault@latest", "<VAULT_PATH>"],
  "enabled": true
}
```

### 3. 驗證
執行 `opencode mcp list`。重啟 OpenCode 後：「列出 Obsidian vault 根目錄」→ 再建立測試筆記。測試完成後詢問使用者是否刪除，不可自行刪除。

### 進階：CLI-Anything Obsidian CLI
若需全文檢索、metadata 操作等進階功能：
1. 在 Obsidian 安裝 Local REST API plugin
2. `pip install cli-anything-hub`
3. 執行 `cli-hub search obsidian`，確認目前 registry 後再決定是否安裝

回報格式：vault 路徑、MCP 連線狀態、讀取/寫入測試結果、測試筆記處理方式。
