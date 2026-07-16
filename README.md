# OpenCode 懶人包

一套給 OpenCode 使用者的繁體中文環境、MCP 與工作流程 Skills。每個項目可獨立安裝；涉及軟體安裝、登入、遠端建立或刪除時會逐步詢問。

## 快速開始

### 方式一：請 AI 協助選擇

把以下內容貼給 OpenCode：

```text
這是 OpenCode 懶人包：https://github.com/mathruffian-dot/opencode-lazy-packs
請先讀取 INSTALL.md，列出所有項目，逐項問我要安裝哪些；不要一次執行未確認的安裝或登入。
```

### 方式二：安裝指定 Skill

```bash
npx skills add mathruffian-dot/opencode-lazy-packs --skill <skill名稱> --agent opencode --global --copy --yes
```

`--agent opencode` 可避免安裝到錯誤的代理工具，`--copy` 可降低 Windows 或雲端同步資料夾的連結問題。

### 方式三：閱讀單章教學

下載對應 MD 檔，在目標專案啟動 `opencode`，把內容交給 OpenCode。仍應逐項確認安裝、登入與刪除操作。

## Skills 清單

| Skill | 版本 | 用途 |
|-------|------|------|
| `00-env-setup` | v0.4 | Node.js LTS、OpenCode、uv、模型登入 |
| `01-notebooklm` | v0.3 | NotebookLM CLI、MCP 與官方提供的 OpenCode setup |
| `02-github` | v0.2 | Git、GitHub CLI、登入與選用 push 測試 |
| `03-obsidian` | v0.3 | 使用 MCPVault 連接 Obsidian |
| `04-second-brain` | v0.3 | 建立每日筆記／創作庫／知識庫三層結構 |
| `05-firebase` | v0.2 | Firebase CLI 與限定目錄／功能的 MCP |
| `06-browser` | v0.4 | Playwright MCP 與 open-computer-use |
| `07-workflow-skills` | v0.2 | 安裝 startup、shutdown、project-init 完整 Skills |
| `08-draw` | v0.4 | 使用 GPT Image 2 生圖 |
| `09-install-all` | v0.2 | 逐項確認並安裝 00–08 |

## 對應教學

| 編號 | 文件 |
|------|------|
| 00 | [環境建置](00-環境建置.md) |
| 01 | [連接 NotebookLM](01-連接-NotebookLM.md) |
| 02 | [連接 GitHub](02-連接-GitHub.md) |
| 03 | [建立第二大腦 Obsidian](03-建立第二大腦-Obsidian.md) |
| 04 | [第二大腦設定指南](04-第二大腦設定指南.md) |
| 05 | [連接 Firebase](05-連接-Firebase.md) |
| 06 | [安裝瀏覽器控制](06-安裝瀏覽器控制.md) |
| 07 | [開工／收工／初始化技能](07-開工收工初始化技能.md) |
| 08 | [生圖技能](08-生圖.md) |

## OpenCode 路徑

- 全域設定：`~/.config/opencode/opencode.json`
- 全域 Skills：`~/.config/opencode/skills/<name>/SKILL.md`
- 專案規則：`AGENTS.md`
- MCP 管理：`opencode mcp add`、`opencode mcp list`
- 模型登入：`opencode auth login`、`opencode auth list`

Windows 原生環境可使用；需要最佳相容性時，OpenCode 官方建議使用 WSL。教學已將 PowerShell 與 Bash 分開標示。

## 安全原則

- 不輸出 API key、token 或憑證內容
- `.openai.env`、`.env*`、credentials、secrets 不得進 Git
- 建立或刪除測試 repo、NotebookLM notebook、Obsidian 筆記前先確認
- Firebase 初始化、部署與資料寫入不是 MCP 連線測試
- 瀏覽器或桌面工具在登入、送出、購買、刪除、發布前取得確認

## 維護者驗證

在 Windows PowerShell 執行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-lazy-pack.ps1
```

驗證 Skill 名稱與 frontmatter、Markdown 連結、版本、敏感資訊忽略規則、draw.py 同步與 Python 語法。

## 儲存庫

- 上游：`mathruffian-dot/opencode-lazy-packs`
- 個人 fork：`changyiwu/opencode-lazy-packs`
- 預設分支：`main`

## 授權

MIT License。
