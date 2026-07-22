---
name: opencode-browser
description: 安裝瀏覽器控制工具（Playwright MCP + open-computer-use）。說「裝瀏覽器控制」「瀏覽器自動化」時載入。
---

# 瀏覽器控制

讓 OpenCode 控制瀏覽器和桌面應用。

登入、送出表單、購買、刪除或發布前必須取得使用者確認。

## 步驟

### 1. Playwright MCP
在 `~/.config/opencode/opencode.json` 加入：
```json
"playwright": {
  "type": "local",
  "command": ["npx", "-y", "@playwright/mcp"],
  "enabled": true
}
```

### 2. open-computer-use
```bash
npm install -g open-computer-use
```
先嘗試官方安裝命令：

```bash
open-computer-use install-opencode-mcp
```

若自動設定失敗，再手動加入 opencode.json：

加入 opencode.json：
```json
"open-computer-use": {
  "type": "local",
  "command": ["open-computer-use", "mcp"],
  "enabled": true
}
```

### 3. 驗證
- 先執行 `opencode mcp list`
- Playwright: 「開啟 https://example.com 並告訴我標題」
- open-computer-use: 使用者確認後「截圖我的桌面」

### 輕量替代：CLI-Anything Browser CLI
若只需簡單網頁操作（不需完整自動化），先查詢目前 registry：
```bash
pip install cli-anything-hub
cli-hub search browser
```

回報格式：Playwright 狀態、open-computer-use 狀態、兩個工具的啟動測試結果。
