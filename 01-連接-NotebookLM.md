# OpenCode 懶人包 #01：連接 NotebookLM

> 版本：v0.4
> 更新日期：2026-07-17

## 這個懶人包會幫你做什麼？

安裝 `notebooklm-mcp-cli`，登入 NotebookLM，並把真正的 `notebooklm-mcp` server 連接到 OpenCode。

> 這是使用 NotebookLM 內部 API 的社群工具，不是 Google 官方 API；個人或實驗用途應了解其介面可能變動。

## 執行原則

- 安裝、登入、修改 OpenCode 設定前逐步說明
- 瀏覽器登入必須由使用者完成
- 建立測試 notebook 後，刪除前再次詢問

## 步驟一：安裝

優先使用 uv：

```bash
uv tool install notebooklm-mcp-cli
```

已安裝時可更新：

```bash
uv tool upgrade notebooklm-mcp-cli
```

確認兩個不同用途的執行檔都存在：

```bash
nlm --version
nlm doctor
```

- Windows：`where.exe nlm`、`where.exe notebooklm-mcp`
- macOS/Linux：`which nlm`、`which notebooklm-mcp`

## 步驟二：登入

```bash
nlm login
nlm login --check
nlm doctor
```

## 步驟三：設定 OpenCode

優先使用套件提供的自動設定：

```bash
nlm setup add opencode
```

不要執行 `nlm skill install opencode`。該指令會額外建立 `~/.config/opencode/skills/nlm-skill/`；NotebookLM MCP 已由 `nlm setup add opencode` 提供，不需要再安裝這個額外 Skill。

若自動設定失敗，再編輯 `~/.config/opencode/opencode.json`，將 MCP server 指向 `notebooklm-mcp`，不是 `nlm`：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "notebooklm": {
      "type": "local",
      "command": ["<notebooklm-mcp完整路徑>"],
      "enabled": true
    }
  }
}
```

合併既有 JSON，不得覆蓋其他設定。

## 步驟四：驗證

```bash
opencode mcp list
```

重新開啟 OpenCode，要求「列出我的 NotebookLM 筆記本」。功能測試若要建立臨時 notebook，完成後詢問使用者是否刪除。

## 復原

```bash
nlm setup remove opencode
nlm skill uninstall opencode  # 只有先前曾安裝 nlm-skill 時才需要
uv tool uninstall notebooklm-mcp-cli
```

登入資料位於 `~/.notebooklm-mcp-cli/`；是否刪除必須由使用者確認。

## 完成回報格式

```md
## NotebookLM 連接完成

- 套件版本：xxx
- 登入狀態：成功 / 失敗
- MCP server：notebooklm-mcp
- OpenCode MCP：已連線 / 失敗
- 讀取測試：成功 / 未執行
- 測試 notebook：未建立 / 保留 / 已依指示刪除
```

## 更新紀錄

| 日期 | 版本 | 更新內容 |
|------|------|---------|
| 2026-07-17 | v0.4 | OpenCode 僅設定 NotebookLM MCP，不再額外安裝 nlm-skill |
| 2026-07-17 | v0.3 | 改用 notebooklm-mcp、nlm setup/skill 的 OpenCode 支援，移除過時 EXE 與指令說明 |
| 2026-06-12 | v0.2 | 改用 uv tool、補 doctor 與復原流程 |
| 2026-05-19 | v0.1 | 初版 |
