---
name: 02-github
description: 連接 GitHub，讓 OpenCode 管理 repo、commit、push。說「連接 GitHub」「設定 GitHub」時載入。
---

# 連接 GitHub

透過 GitHub CLI (`gh`) 讓 OpenCode 管理 GitHub。

## 步驟

### 1. 確認並補裝 Git / GitHub CLI
```bash
git --version
gh --version
```

如果缺少，先取得使用者確認，再依作業系統安裝：

- Windows：`winget install --id Git.Git`、`winget install --id GitHub.cli`
- macOS：`brew install git gh`
- Ubuntu/Debian：依 Git 與 GitHub CLI 官方套件庫說明安裝

### 2. 登入 GitHub CLI
```bash
gh auth status
```
若未登入：
```bash
gh auth login --web --git-protocol https
```

### 3. 設定 Git 使用者資訊
檢查並補設：
```bash
git config --global user.name "你的姓名"
git config --global user.email "你的email"
```

### 4. 驗證 commit/push
建立測試 repo → commit → push。確認成功後詢問要保留或刪除；未獲確認不得刪除本機或遠端測試 repo。

回報格式：Git/GitHub CLI 版本、登入狀態、使用者資訊、commit/push 測試結果。
