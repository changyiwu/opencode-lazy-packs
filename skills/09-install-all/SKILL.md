---
name: 09-install-all
description: 一次安裝所有 OpenCode 懶人包技能（00-08 全部）。說「全部安裝」「裝完所有懶人包」時載入。
---

# 一次安裝全部技能

依序載入並執行所有 9 個懶人包技能：

1. **00-env-setup** — 安裝 Node.js LTS、OpenCode、uv，設定模型登入
2. **01-notebooklm** — 連接 NotebookLM MCP
3. **02-github** — 安裝 Git / GitHub CLI 並登入
4. **03-obsidian** — 連接 Obsidian MCPVault
5. **04-second-brain** — 建立第二大腦三層結構
6. **05-firebase** — 連接 Firebase MCP
7. **06-browser** — 安裝 Playwright + open-computer-use
8. **07-workflow-skills** — 安裝 startup/shutdown/project-init
9. **08-draw** — 安裝 draw 生圖技能

## 執行方式

先列出 00–08，逐項詢問使用者是否執行。使用者確認後，依序安裝到 OpenCode：

```bash
npx skills add mathruffian-dot/opencode-lazy-packs --skill <skill名稱> --agent opencode --global --copy --yes
```

每裝好一個就載入並依該 Skill 指示執行；涉及登入、建立遠端 repo、修改既有專案或寫入外部目錄時仍須另外取得確認。跳過已安裝且驗證正常的工具。
最終回報總表：9 項各別的成功/失敗/已跳過狀態。

> 💡 也可用 `npx skills add` 個別安裝：
> ```bash
> npx skills add mathruffian-dot/opencode-lazy-packs --skill 01-notebooklm --agent opencode --global --copy --yes
> ```
