---
name: project-init
description: 初始化或安全補齊新專案。使用者說「初始化專案」「建立新專案」時載入。
---

# 專案初始化

1. 先檢查目標資料夾是否已有檔案、Git、AGENTS.md、README 與 `.gitignore`，不得覆蓋既有內容。
2. 補齊專案簡介、資料夾結構、驗證命令、敏感資訊規則與必要的 AGENTS.md。
3. 若尚未使用 Git，初始化 `main` 分支並建立初始提交。
4. 只有使用者確認後才建立 GitHub repo；個人 fork 使用 `origin`，來源專案使用 `upstream`。
5. 只有使用者確認後才建立或更新 Obsidian 專案駕駛艙。
6. 驗證 Git 狀態、remote、預設分支與文件連結，回報所有寫入與跳過項目。
