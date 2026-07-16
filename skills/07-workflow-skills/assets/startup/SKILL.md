---
name: startup
description: 安全接續既有專案。使用者說「開工」「開始工作」「上次做到哪」時載入。
---

# 開工同步

1. 讀取目前專案適用的 `AGENTS.md`。
2. 檢查 `git status --short --branch`、目前分支、remote 與最近提交。
3. 若 AGENTS.md 記錄 Obsidian 專案駕駛艙，讀取駕駛艙中的目前狀態與下一步。
4. 可安全 fetch 時比較 `main` 與 `origin/main`；fetch 失敗則回報，不自行改動。
5. 給出已完成、未提交變更、風險與建議下一步。

開工流程預設只讀，不修改檔案、不切分支、不 pull、不 commit、不 push。
