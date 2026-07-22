# OpenCode 懶人包 #04：連接 Firebase

> 版本：v0.2
> 更新日期：2026-07-17

## 這個懶人包會幫你做什麼？

安裝 Firebase CLI、登入帳號，並連接 Firebase 官方 MCP server。連接 MCP 本身不會自動初始化或修改專案。

## 步驟一：安裝與登入

```bash
npm install -g firebase-tools
firebase --version
firebase login
firebase projects:list
```

登入需要使用者完成瀏覽器操作。

## 步驟二：確認使用範圍

先詢問：

- 要連接哪一個本機專案目錄？
- 是否已有 `firebase.json`？
- 只需要哪些功能，例如 auth、firestore、storage？

如果只是列出 Firebase 專案，可以不指定 `--dir`。如果要操作特定 app，應使用絕對路徑限制目錄。

## 步驟三：設定 OpenCode MCP

可先使用 `opencode mcp add` 的互動式流程。手動設定範例：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "firebase": {
      "type": "local",
      "command": [
        "npx", "-y", "firebase-tools@latest", "mcp",
        "--dir", "<專案絕對路徑>",
        "--only", "auth,firestore,storage"
      ],
      "enabled": true
    }
  }
}
```

依使用者需求移除不需要的 `--dir` 或調整 `--only`，並安全合併既有 JSON。

## 步驟四：驗證

```bash
opencode mcp list
```

重新開啟 OpenCode，先要求列出 Firebase 專案。不要把 CRUD、部署或 `firebase init` 當成連線測試。

## 初始化是另一個動作

只有使用者明確要求，而且已確認工作目錄、Firebase 專案與服務清單時，才執行 `firebase init` 或 MCP 的初始化工具。重新初始化既有功能可能覆寫設定，必須先檢查 diff。

## 完成回報格式

```md
## Firebase 連接完成

- firebase-tools：版本
- 登入：成功 / 失敗
- MCP：已連線 / 失敗
- 專案目錄：未指定 / 完整路徑
- 功能限制：全部 / auth,firestore,...
- 初始化：未執行 / 已另行確認
```

## 更新紀錄

| 日期 | 版本 | 更新內容 |
|------|------|---------|
| 2026-07-17 | v0.2 | 拆開 MCP 連線與 firebase init，補 --dir、--only 與安全確認 |
| 2026-05-19 | v0.1 | 初版 |
