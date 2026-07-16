# OpenCode 懶人包安裝入口

## 完整全域安裝

「全部安裝」表示 `00-env-setup` 到 `09-install-all` 共 10 個編號 Skills 都必須保留在 OpenCode 支援的全域目錄，不能只執行設定後留下 `draw`、`startup`、`shutdown`、`project-init`。

在本 repo 根目錄直接同步，不經過 skills CLI 的共用目錄：

```powershell
powershell -ExecutionPolicy Bypass -File "skills/09-install-all/install-opencode-skills.ps1" -SourceRoot "skills" -Force
```

最終必須在 `~/.config/opencode/skills/` 看到 00～09 全部 10 個目錄，且 `~/.agents/skills/` 不得留下本懶人包副本。執行 07 後還應另外看到 `startup`、`shutdown`、`project-init`，完整結果為 13 個相關 Skills。

若沒有完整 repo，才使用 `npx skills` 取得暫存來源；完成同步後，隨附腳本會刪除 `~/.agents/skills/` 中的 00～09，並在目錄變空時一併移除空目錄。

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
| 09 | `09-install-all` | 安裝 00–09 至 OpenCode 專用目錄並清除暫存副本 | 無 |

## 執行方式

1. 先列出上表，讓使用者選擇。
2. 使用者選「全部」時，先用上方同步腳本將 00–09 全部長駐安裝，再逐項說明並確認是否執行 00–08；不可把一次確認擴張成登入、建立遠端資源或刪除測試資料的授權。
3. 使用者只選部分項目時，對每個選取的 Skill 執行：

```bash
npx skills add mathruffian-dot/opencode-lazy-packs --skill <skill名稱> --agent opencode --global --copy --yes
```

4. 安裝後執行同步腳本，確認目標位於 `~/.config/opencode/skills/`，再載入該 Skill，依內容執行並驗證。
5. 已安裝且驗證正常的外部工具可以跳過執行；編號 Skill 本身仍須保留在全域目錄。

若 `npx skills` 無法使用，才改為讀取 repo 中對應的 `skills/<名稱>/SKILL.md`，並保留其附屬檔案與 assets；不能只複製摘要。

## 為什麼入口不是 SKILL.md？

根目錄若存在 `SKILL.md`，`npx skills` 會把整個 repo 視為單一 Skill，導致 `skills/00-*` 到 `skills/09-*` 無法被列出。入口因此使用 `INSTALL.md`，真正可安裝的 Skills 全部位於 `skills/`。

## 完成回報

列出每項的：安裝狀態、驗證結果、使用者仍需完成的互動步驟、建立的檔案或遠端資源，以及未執行或跳過的項目。
