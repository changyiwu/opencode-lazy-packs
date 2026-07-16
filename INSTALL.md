# OpenCode 懶人包安裝入口

## 可用項目

| 編號 | Skill | 說明 | 前置需求 |
|------|-------|------|---------|
| 00 | `00-env-setup` | Node.js LTS、OpenCode、uv、模型登入 | 無 |
| 01 | `01-notebooklm` | NotebookLM MCP | #00 |
| 02 | `02-github` | Git、GitHub CLI 與登入 | 無 |
| 03 | `03-obsidian` | Obsidian MCPVault | Node.js、vault |
| 04 | `04-second-brain` | 第二大腦三層結構 | #03 |
| 05 | `05-firebase` | Firebase MCP | Node.js |
| 06 | `06-browser` | Playwright 與桌面控制 | Node.js |
| 07 | `07-workflow-skills` | startup、shutdown、project-init | Git；Obsidian 選用 |
| 08 | `08-draw` | GPT Image 2 生圖 | uv、OpenAI API key |
| 09 | `09-install-all` | 逐項安裝 00–08 | 無 |

## 執行方式

1. 先列出上表，讓使用者選擇。
2. 即使使用者選「全部」，也要逐項說明並確認；不可把一次確認擴張成登入、建立遠端資源或刪除測試資料的授權。
3. 對每個選取的 Skill 執行：

```bash
npx skills add mathruffian-dot/opencode-lazy-packs --skill <skill名稱> --agent opencode --global --copy --yes
```

4. 安裝後載入該 Skill，依內容執行並驗證。
5. 已安裝且驗證正常的項目可以跳過；回報跳過原因。

若 `npx skills` 無法使用，才改為讀取 repo 中對應的 `skills/<名稱>/SKILL.md`，並保留其附屬檔案與 assets；不能只複製摘要。

## 為什麼入口不是 SKILL.md？

根目錄若存在 `SKILL.md`，`npx skills` 會把整個 repo 視為單一 Skill，導致 `skills/00-*` 到 `skills/09-*` 無法被列出。入口因此使用 `INSTALL.md`，真正可安裝的 Skills 全部位於 `skills/`。

## 完成回報

列出每項的：安裝狀態、驗證結果、使用者仍需完成的互動步驟、建立的檔案或遠端資源，以及未執行或跳過的項目。
