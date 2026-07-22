---
name: opencode-firebase
description: 連接 Firebase，讓 OpenCode 管理 Firestore / Hosting / Auth。說「連接 Firebase」「設定 Firebase」時載入。
---

# 連接 Firebase

透過 `firebase-tools` 讓 OpenCode 管理 Firebase 專案。

## 步驟

### 1. 安裝 Firebase CLI
```bash
npm install -g firebase-tools
firebase --version
```

### 2. 登入
```bash
firebase login
```

### 3. 確認專案目錄

連接 MCP 不需要先執行 `firebase init`。若使用者之後要初始化 Firebase 服務，必須先確認目標專案目錄與服務清單，再另外取得同意。

### 4. 寫入 opencode.json
```json
"firebase": {
  "type": "local",
  "command": ["npx", "-y", "firebase-tools@latest", "mcp", "--dir", "<專案絕對路徑>"],
  "enabled": true
}
```

### 5. 驗證
先執行 `opencode mcp list`，再重啟 OpenCode 後說：「請列出我的 Firebase 專案。」如果只使用部分服務，可在 MCP command 加上 `--only auth,firestore,storage` 限縮工具。

回報格式：firebase-tools 版本、登入狀態、專案數量、MCP 寫入狀態、工具測試結果。
