# opencode-lazy-packs（專案藍圖）

> 本檔為跨 Agent 通用的專案藍圖（AGENTS.md 開放標準）。任何 Agent 的每個 session 都應先讀本檔＋`handoff.md`。

## 專案簡介

OpenCode 專用的懶人包倉庫。與 `claude-code-lazy-packs/`、`codex-lazy-packs/`、`antigravity-lazy-pack/` 平行：同一套教學流程，分別給不同 AI 編碼代理使用。

三者的關鍵差異：

| 項目 | opencode | claude-code | codex |
|------|----------|-------------|-------|
| 設定檔 | `opencode.json` | `settings.json` | `config.toml` |
| 專案檔 | `AGENTS.md` | `CLAUDE.md` | `AGENTS.md` |
| MCP | 編輯 JSON | `claude mcp add` | `codex mcp add` |
| Skills dir | `~/.config/opencode/skills/` | `~/.claude/skills/` | `~/.codex/skills/` |

## 關鍵時程

<!-- 目前無固定時程 -->

## 目標與路線圖

- [x] 階段一：教學章節與 Skills 成形
- [x] 階段二：移除第二大腦設定指南與 `opencode-second-brain` Skill，Firebase／瀏覽器／生圖／全部安裝重編為 #04～#07
- [x] 階段三：發布驗證通過，repo 現有 8 個 `opencode-*` Skills；隔離安裝測試成功
- [ ] 階段四：執行 `skills/07-install-all/install-opencode-skills.ps1` 同步 OpenCode 全域 Skills
- [ ] 階段五：移除全域舊副本 `opencode-second-brain`，驗證全域目錄只有預期的 8 個 Skills 且無舊編號副本

## 資料夾結構

```
opencode-lazy-packs/
├─ INSTALL.md             # 懶人包入口說明（根目錄不可放 SKILL.md，否則 npx 只發現一個 Skill）
├─ README.md
├─ 00-環境建置.md
├─ 01-連接-NotebookLM.md
├─ 02-連接-GitHub.md
├─ 03-建立第二大腦-Obsidian.md
├─ 04-連接-Firebase.md
├─ 05-安裝瀏覽器控制.md
├─ 06-生圖.md
├─ skills/                # 一鍵安裝用子技能
├─ scripts/               # 輔助腳本（draw.py、validate-lazy-pack.ps1）
├─ generated/             # 本機測試輸出（gitignore）
├─ examples/              # 精選展示輸出
├─ agents.md              # 本檔：專案藍圖
├─ handoff.md             # 交接檔（每次收工必更新）
├─ .agents/  .gitignore
└─ LICENSE
```

## 同步層級（本專案初始化至第 3 層級）

| 層級 | 平台 | 位置 | 讀取時機 |
|------|------|------|---------|
| L1 | 本地（GDrive） | `agents.md`＋`handoff.md` | 每個 session |
| L2 | GitHub | origin：https://github.com/changyiwu/opencode-lazy-packs （公開）／upstream：`mathruffian-dot/opencode-lazy-packs` | 指定時 |
| L3 | Obsidian | `opencode-lazy-packs/專案工作流程.md` | 有需要時 |

## 工作約定

- 任何 Agent、任何電腦：**開工先讀 `handoff.md`，收工必更新 `handoff.md`**
- 修改共用檔案前先讀最新內容，避免覆蓋其他 Agent 的變更
- 所有回應與文件使用繁體中文
- 使用者說「更新 OpenCode 懶人包」→ 只動本資料夾；說「三邊都更新」→ 三個資料夾都改
- 修改主流程時三邊都要更新；**不要**把 Claude Code 或 Codex 版直接複製過來
- 預設分支 `main`，推送到 `origin/main`；`upstream` 只用來追蹤原始專案
- 修改教學或 Skills 後執行：`powershell -ExecutionPolicy Bypass -File scripts/validate-lazy-pack.ps1`
- `generated/` 僅放本機測試輸出；需要保留的展示圖移到 `examples/`
- **不要**把 Skills 安裝到 `~/.agents/skills/` 當作 OpenCode 的完成位置
- `opencode-draw` 必須使用自身的 `draw.py`，不得借用 Codex 版本
- 安裝器若偵測到已退役的 `opencode-second-brain` 會停止；取得刪除確認後清理，再重新同步

## 安全邊界

- Commit 前檢查敏感資訊（API key 等），特別確認 `.openai.env` 是否被 git 追蹤
- 不提交 `.env`、token、密碼、憑證或個人本機代理設定

## 最近進度

- 2026-07-22：移除第二大腦設定指南與對應 Skill，將 Firebase、瀏覽器、生圖與全部安裝重編為 #04～#07；專案工作筆記改為 `opencode-lazy-packs/專案工作流程.md`，8-Skill 驗證已通過。
- 2026-07-22：移除內建工作流程 Skill，將生圖與全部安裝 Skill 重編為 #07、#08，並同步安裝器與驗證規則；發布驗證已通過。
- 2026-07-24：專案藍圖改用標準範本格式（補上路線圖 checklist 與同步層級表，原「同步對照表」併入）。
