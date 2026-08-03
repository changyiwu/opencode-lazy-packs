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
- [x] 階段三：發布驗證通過，repo 曾有 8 個 `opencode-*` Skills；隔離安裝測試成功
- [x] 階段四：NotebookLM 品牌更新為 Gemini Notebook，保留相容的套件／CLI／MCP 技術名稱
- [x] 階段五：執行當時的 `skills/07-install-all/install-opencode-skills.ps1` 同步 OpenCode 全域 Skills
- [x] 階段六：移除全域舊副本 `opencode-notebooklm` 與 `opencode-second-brain`，驗證全域目錄只有預期的 8 個 Skills 且無舊編號副本
- [x] 階段七：移除瀏覽器控制教學與 `opencode-browser` Skill，生圖與全部安裝重編為 #05～#06；repo 改為 7 個 Skills，全域 `opencode-browser` 已移除
- [ ] 階段八：重啟使用 Gemini Notebook MCP 的 Agent 後，重新驗證 `nlm login --check` 與筆記本讀取

## 資料夾結構

```
opencode-lazy-packs/
├─ INSTALL.md             # 懶人包入口說明（根目錄不可放 SKILL.md，否則 npx 只發現一個 Skill）
├─ README.md
├─ 00-環境建置.md
├─ 01-連接-Gemini-Notebook.md
├─ 02-連接-GitHub.md
├─ 03-建立第二大腦-Obsidian.md
├─ 04-連接-Firebase.md
├─ 05-生圖.md
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

## 三個檔案的職責（依「時效性」分家，不是依「詳細程度」）

| 檔案 | 時效 | 寫入方式 | 放什麼 |
|------|------|---------|--------|
| `handoff.md` | **只對下一個 session 有效**，過期即丟 | 每次收工整份重寫 | 做到哪、下一步、**這次**的暫時 workaround |
| `agents.md`（本檔） | **長期有效**，每個 session 都適用 | 只有規則本身變了才改 | 目標、路線圖、常設規則、結構 |
| Obsidian／`git log` | **歷史**：發生過什麼、為什麼 | 只增不刪 | 決策紀錄、踩坑完整版、逐次進度 |

驗收標準：**`handoff.md` 整份刪掉，不應損失任何長期資訊**——會的話代表該升級進本檔卻沒升級。

**本檔不要出現的東西**：❌ `## 最近進度`／逐次工作紀錄、❌ 決策理由與踩坑完整版。2026-08-03 移除了 `## 最近進度`，內容逐條比對後已在 L3 筆記的〈🗓️ 最近更動紀錄〉——**是主動移除，不是遺漏，不要補回來**。踩過的坑只把**結論**收斂成一條祈使句寫進〈工作約定〉，原因留 L3。

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
- 安裝器若偵測到已退役的 `opencode-notebooklm`、`opencode-second-brain` 或 `opencode-browser` 會在複製前停止；取得刪除確認後清理，再重新同步

## 安全邊界

- Commit 前檢查敏感資訊（API key 等），特別確認 `.openai.env` 是否被 git 追蹤
- 不提交 `.env`、token、密碼、憑證或個人本機代理設定
- **`notebooklm-mcp-cli`、`nlm`、`notebooklm-mcp` 仍是上游有效的技術識別**，不可因產品改名而改錯
- **Google Drive 的空目錄可能帶 `ReadOnly` 屬性**：刪除前先確認目錄為空、路徑位於專案內，再清除精確目標的屬性
