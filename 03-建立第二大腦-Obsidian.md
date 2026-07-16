# OpenCode 懶人包 #03：建立第二大腦 Obsidian

> 版本：v0.3
> 更新日期：2026-07-17

## 這個懶人包會幫你做什麼？

找到主要 Obsidian vault，使用 `@bitbonsai/mcpvault` 連接 OpenCode，並驗證讀寫。

## 步驟一：確認 vault

先詢問使用者主要 vault 的完整路徑。只有在使用者不知道時才搜尋含 `.obsidian` 的資料夾，並限制搜尋範圍，避免從整顆磁碟遞迴掃描。

Windows PowerShell 範例：

```powershell
Get-ChildItem -LiteralPath "$HOME/OneDrive" -Directory -Recurse -Force -ErrorAction SilentlyContinue |
  Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName ".obsidian") }
```

使用者必須確認找到的是主要 vault。

## 步驟二：設定 MCP

不需要全域安裝 mcpvault。編輯 `~/.config/opencode/opencode.json`，安全合併：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "obsidian": {
      "type": "local",
      "command": ["npx", "-y", "@bitbonsai/mcpvault@latest", "<VAULT_PATH>"],
      "enabled": true
    }
  }
}
```

Windows JSON 路徑中的反斜線必須寫成 `\\`。不得覆蓋既有 MCP 或 permission 設定。

## 步驟三：驗證

```bash
opencode mcp list
```

重新開啟 OpenCode，先列出 vault 根目錄，再於使用者同意後建立一則測試筆記。測試完成後詢問是否刪除。

## 安全提醒

- MCPVault 能讀寫整個指定 vault，只能連接使用者確認的路徑。
- 大量修改或刪除筆記前必須先列出範圍並取得確認。
- 不把 Local REST API key 寫入教學、Git 或對話回報。

## 完成回報格式

```md
## Obsidian 連接完成

- Vault：完整路徑
- MCP：已連線 / 失敗
- 讀取測試：成功 / 失敗
- 寫入測試：成功 / 未執行
- 測試筆記：未建立 / 保留 / 已依指示刪除
```

## 更新紀錄

| 日期 | 版本 | 更新內容 |
|------|------|---------|
| 2026-07-17 | v0.3 | 改用免全域安裝的 npx -y @latest、補 MCP 驗證與測試筆記清理確認 |
| 2026-05-25 | v0.2 | 補充 CLI-Anything 進階方案 |
| 2026-05-19 | v0.1 | 初版 |
