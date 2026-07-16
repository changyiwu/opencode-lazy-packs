---
name: shutdown
description: 安全結束專案工作並同步。使用者說「收工」「結束工作」「整理並同步」時載入。
---

# 收工同步

1. 讀取 AGENTS.md 與本專案收工規則。
2. 檢查本次 diff、未追蹤檔案、測試結果與敏感資料；API key、憑證或私人設定不得提交。
3. 摘要預計提交的檔案與 commit 訊息。若使用者已明確說「收工」，依專案規則完成 commit 與 push；若使用者限制不推送則遵守。
4. 預設分支使用 `main`，推送到 `origin/main`。不得在未知分支或未知 remote 上猜測。
5. 若 AGENTS.md 連結 Obsidian 專案駕駛艙，更新本次成果、驗證與下一步。
6. 只有專案明確使用 chezmoi 時才處理 chezmoi；不得自行新增或修改未授權的 dotfiles 流程。
7. 回報 commit、push、駕駛艙、未提交檔案與任何跳過項目。
