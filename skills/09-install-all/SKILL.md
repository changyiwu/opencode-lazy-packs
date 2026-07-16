---
name: 09-install-all
description: 將 OpenCode 懶人包 00-09 全部保留在全域 Skills，再逐項執行 00-08。說「全部安裝」「裝完所有懶人包」時載入。
---

# 全域安裝並保留全部 Skills

「全部安裝」包含兩個階段，不能只做其中一個：

1. **長駐安裝**：先把 `00-env-setup` 到 `09-install-all` 共 10 個編號 Skills 全部安裝到 OpenCode 支援的全域 Skills 目錄。
2. **功能設定**：再依序載入並執行 00–08，完成工具、MCP、工作流程與生圖設定。

## 第一階段：強制全域安裝 00–09

先決定來源：

- 若目前位於完整的 `opencode-lazy-packs` clone，且 repo root 下有 `skills/00-env-setup` 到 `skills/09-install-all`，使用 repo root 的完整路徑。
- 否則使用 `mathruffian-dot/opencode-lazy-packs`。

一次安裝全部 10 個 Skills；`--global` 與 `--agent opencode` 不得省略：

```bash
npx skills add <來源> --skill '*' --agent opencode --global --copy --yes
```

不要改成無參數的 `npx skills add <來源>`；那會預設安裝到目前專案的 `.agents/skills/`，不是使用者的全域目錄。

安裝後執行：

```bash
npx skills ls --global --agent opencode
```

`npx skills` 可能先將共用副本保存在 `~/.agents/skills/`。本懶人包的固定規則是：再將 10 個編號 Skills 全部同步到 OpenCode 專用的 `~/.config/opencode/skills/`，讓使用者能在單一位置找到完整內容。

Windows PowerShell 使用隨附的同步腳本。若目標已有不同內容，先比較並取得覆寫同意；取得同意後才加上 `-Force`：

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME/.agents/skills/09-install-all/install-opencode-skills.ps1" -Force
```

若從完整 clone 執行，也可改用 repo 內的腳本：

```powershell
powershell -ExecutionPolicy Bypass -File "skills/09-install-all/install-opencode-skills.ps1" -Force
```

`~/.agents/skills/` 中由 CLI 管理的來源副本可以保留，不要自行刪除。最終以下 10 個編號 Skills 都必須實際存在於 `~/.config/opencode/skills/`，且檔案可讀取：

```text
00-env-setup
01-notebooklm
02-github
03-obsidian
04-second-brain
05-firebase
06-browser
07-workflow-skills
08-draw
09-install-all
```

若缺少任何一個，不得回報「全部安裝完成」。先用相同的 `--agent opencode --global --copy --yes` 參數補裝來源，再重新執行同步腳本並驗證目標目錄。

## 第二階段：逐項執行 00–08

確認 10 個編號 Skills 已全部長駐後，依序載入並執行：

1. **00-env-setup** — 安裝 Node.js LTS、OpenCode、uv，設定模型登入
2. **01-notebooklm** — 連接 NotebookLM MCP
3. **02-github** — 安裝 Git / GitHub CLI 並登入
4. **03-obsidian** — 連接 Obsidian MCPVault
5. **04-second-brain** — 建立第二大腦三層結構
6. **05-firebase** — 連接 Firebase MCP
7. **06-browser** — 安裝 Playwright + open-computer-use
8. **07-workflow-skills** — 安裝 startup/shutdown/project-init
9. **08-draw** — 安裝 draw 生圖技能

先列出 00–08，逐項詢問使用者是否執行。涉及登入、建立遠端 repo、修改既有專案或寫入外部目錄時仍須另外取得確認。已安裝且驗證正常的外部工具可以跳過執行，但不得因此刪除或漏裝對應的編號 Skill。

執行 `07-workflow-skills` 後，另外確認 `startup`、`shutdown`、`project-init` 三個長駐 Skills 存在。`08-draw` 本身就是長駐生圖 Skill，不得只留下舊版 `draw` 而漏掉 `08-draw`。

## 完成標準

- 10 個編號 Skills：全部實際存在於 `~/.config/opencode/skills/`。
- 3 個工作流程 Skills：`startup`、`shutdown`、`project-init` 全部存在。
- 00–08：逐項回報成功、已驗證而跳過、使用者略過或失敗。
- 即使外部工具都可用，只要缺少任一編號 Skill，就不能標示為完整安裝。

> 💡 也可用 `npx skills add` 個別安裝：
> ```bash
> npx skills add mathruffian-dot/opencode-lazy-packs --skill 01-notebooklm --agent opencode --global --copy --yes
> ```
