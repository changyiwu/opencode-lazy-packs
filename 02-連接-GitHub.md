# OpenCode 懶人包 #02：連接 GitHub

> 版本：v0.2
> 更新日期：2026-07-17

## 這個懶人包會幫你做什麼？

- 安裝或檢查 Git、GitHub CLI
- 登入 GitHub CLI
- 設定 Git 使用者資訊
- 在使用者確認後建立私人測試 repo，驗證 commit 與 push

## 步驟一：檢查並補裝工具

```bash
git --version
gh --version
```

若缺少，先取得使用者確認。

### Windows PowerShell

```powershell
winget install --id Git.Git --accept-source-agreements --accept-package-agreements
winget install --id GitHub.cli --accept-source-agreements --accept-package-agreements
```

### macOS

```bash
brew install git gh
```

### Ubuntu / Debian

依 Git 與 GitHub CLI 官方套件庫說明安裝，不使用未經確認的第三方安裝腳本。

## 步驟二：登入 GitHub CLI

```bash
gh auth status
```

若尚未登入，由使用者在互動式終端執行：

```bash
gh auth login --web --git-protocol https
```

## 步驟三：設定 Git 身分

```bash
git config --global user.name
git config --global user.email
```

若缺少，先向使用者取得正確姓名與 email，再設定；不可自行猜測。

## 步驟四：可選的 push 測試

先詢問是否建立私人測試 repo。使用者同意後，在明確的暫存目錄建立測試，不要混入現有專案。

```bash
git init -b main
git add README.md
git commit -m "建立 OpenCode GitHub 測試"
gh repo create opencode-github-test --private --source=. --push
```

完成後詢問要保留或刪除。未獲確認不得刪除本機資料夾或遠端 repo。

## 完成回報格式

```md
## GitHub 連接完成

- Git：版本 / 已補裝
- GitHub CLI：版本 / 已補裝
- gh 登入：帳號 / 失敗
- Git 身分：已設定 / 待設定
- commit / push 測試：成功 / 未執行
- 測試 repo：未建立 / 保留 / 已依指示刪除
```

## 更新紀錄

| 日期 | 版本 | 更新內容 |
|------|------|---------|
| 2026-07-17 | v0.2 | #02 改為負責 Git/gh 安裝、main 初始化與逐步刪除確認 |
| 2026-05-19 | v0.1 | 初版 |
