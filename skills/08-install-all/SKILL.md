---
name: opencode-install-all
description: 將 OpenCode 懶人包 00-08 以 opencode-* 名稱全部安裝至 ~/.config/opencode/skills，不在 ~/.agents 留副本，再逐項執行 00-07。
---

# 全域安裝並保留全部 Skills

「全部安裝」包含兩個階段，不能只做其中一個：

1. **長駐安裝**：將 repo 中 00～08 對應的 9 個 Skills 以 `opencode-*` 名稱安裝到 OpenCode 全域 Skills 目錄。
2. **功能設定**：再依序載入並執行 00～07，完成工具、MCP 與生圖設定。

## 第一階段：直接安裝到 OpenCode 專用目錄

若目前位於完整的 `opencode-lazy-packs` clone，且 repo root 下有 `skills/00-env-setup` 到 `skills/08-install-all`，先比較既有目標；取得覆寫同意後直接執行：

```powershell
powershell -ExecutionPolicy Bypass -File "skills/08-install-all/install-opencode-skills.ps1" -SourceRoot "skills" -Force
```

這條路徑會把編號來源資料夾映射為 `opencode-*` 目標名稱，直接複製到 `~/.config/opencode/skills/`，不會建立 `~/.agents/skills/`。

只有無法從完整 repo 執行時，才暫用 skills CLI 取得 9 個來源 Skills；`--global` 與 `--agent opencode` 不得省略：

```bash
npx skills add mathruffian-dot/opencode-lazy-packs --skill '*' --agent opencode --global --copy --yes
```

skills CLI 會暫存在 `~/.agents/skills/`。安裝後立即執行其中的同步腳本；腳本驗證 OpenCode 目標後，會自動刪除本懶人包在 `.agents` 的新舊名稱副本：

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME/.agents/skills/opencode-install-all/install-opencode-skills.ps1" -Force
```

不要改成無參數的 `npx skills add`，也不要把 `.agents` 當成完成位置。最終以下 9 個 Skills 都必須實際存在於 `~/.config/opencode/skills/`，且資料夾名稱與 frontmatter `name` 相同：

```text
opencode-env-setup
opencode-notebooklm
opencode-github
opencode-obsidian
opencode-second-brain
opencode-firebase
opencode-browser
opencode-draw
opencode-install-all
```

同步後確認 `~/.agents/skills/` 不含本懶人包的新舊名稱副本；若它因此變空，腳本應移除空的 `skills` 與 `.agents` 目錄。缺少任何目標或仍留下任何本懶人包暫存來源，都不得回報「全部安裝完成」。

## 第二階段：逐項執行 00–07

確認 9 個 `opencode-*` Skills 已全部長駐後，依序載入並執行：

1. **opencode-env-setup** — 安裝 Node.js LTS、OpenCode、uv，設定模型登入
2. **opencode-notebooklm** — 連接 NotebookLM MCP
3. **opencode-github** — 安裝 Git / GitHub CLI 並登入
4. **opencode-obsidian** — 連接 Obsidian MCPVault
5. **opencode-second-brain** — 建立第二大腦三層結構
6. **opencode-firebase** — 連接 Firebase MCP
7. **opencode-browser** — 安裝 Playwright + open-computer-use
8. **opencode-draw** — 安裝 OpenCode 生圖 Skill

先列出 00–07，逐項詢問使用者是否執行。涉及登入、建立遠端 repo、修改既有專案或寫入外部目錄時仍須另外取得確認。已安裝且驗證正常的外部工具可以跳過執行，但不得因此刪除或漏裝對應的 `opencode-*` Skill。

`opencode-draw` 本身就是長駐生圖 Skill，不得只留下舊版 `draw` 或 `07-draw`。

## 完成標準

- 9 個 `opencode-*` Skills：全部實際存在於 `~/.config/opencode/skills/`，且 frontmatter 名稱與目錄相同。
- `~/.agents/skills/`：不含本懶人包的新舊名稱副本；若沒有其他內容則目錄不存在。
- `nlm-skill`：不得安裝；NotebookLM 只設定 MCP。
- `opencode-draw`：`SKILL.md` 與同目錄 `draw.py` 都必須存在；不得搜尋或改用 `~/.codex/skills/codex-draw`。
- 00–07：逐項回報成功、已驗證而跳過、使用者略過或失敗。
- 最終預期為 9 個相關 Skills；只要缺少 `opencode-*` Skill、仍留舊編號副本或多出 `nlm-skill`，就不能標示為完整安裝。

同步腳本不刪除 OpenCode 全域目錄中的舊編號 Skills。若偵測到舊副本，先回報並另行取得清理同意。

> 💡 也可用 `npx skills add` 個別安裝：
> ```bash
> npx skills add mathruffian-dot/opencode-lazy-packs --skill opencode-notebooklm --agent opencode --global --copy --yes
> ```
