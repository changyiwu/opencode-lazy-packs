# AGENTS.md — opencode-lazy-packs

## 專案簡介

OpenCode 專用的懶人包倉庫，對應 repo **mathruffian-dot/opencode-lazy-packs**。
與 `claude-code-lazy-packs/`、`codex-lazy-packs/` 平行：同一套教學流程，分別給三個 AI 編碼代理使用。

## 主要差異

| 項目 | opencode | claude-code | codex |
|------|----------|-------------|-------|
| 設定檔 | `opencode.json` | `settings.json` | `config.toml` |
| 專案檔 | `AGENTS.md` | `CLAUDE.md` | `AGENTS.md` |
| MCP | 編輯 JSON | `claude mcp add` | `codex mcp add` |
| Skills dir | `~/.config/opencode/skills/` | `~/.claude/skills/` | `~/.codex/skills/` |

## 資料夾結構

```
opencode-lazy-packs/
├── skills/          # 一鍵安裝用子技能
├── scripts/         # 輔助腳本（draw.py）
├── generated/       # 本機測試輸出（gitignore）
├── examples/        # 精選展示輸出
├── 00-*.md ~ 07-*.md  # 教學流程文件
├── AGENTS.md        # 本檔案
├── INSTALL.md       # 懶人包入口說明（根目錄不可放 SKILL.md，否則 npx 只發現一個 Skill）
├── README.md
├── LICENSE
└── .gitignore
```

## Obsidian 關聯資料

- Obsidian vault：`C:\Users\chang\我的雲端硬碟\2ndbrain`
- 每日筆記：`每日筆記/<日期>.md`
- 創作庫：`創作庫/`
- 專案駕駛艙：`opencode-lazy-packs-專案駕駛艙.md`
- 敏感資料注意：檢查 `.openai.env` 是否被 git 追蹤
- 知識庫：`知識庫/`

## 同步對照表

| 平台 | 位置 |
|------|------|
| Obsidian 閱讀版 | `opencode-lazy-packs-專案駕駛艙.md` |
| GitHub (origin) | `changyiwu/opencode-lazy-packs` |
| GitHub (upstream) | `mathruffian-dot/opencode-lazy-packs` |
| 本機路徑 | `C:\Users\chang\我的雲端硬碟\agents\opencode-lazy-packs` |

## 工作流程提醒

- 使用者說「更新 OpenCode 懶人包」→ 只動本資料夾
- 使用者說「三邊都更新」→ 三個資料夾都改
- 修改主流程時三邊都要更新
- **不要**把 Claude Code 或 Codex 版直接複製過來
- Commit 前檢查敏感資訊（API key 等）
- 預設分支為 `main`，推送到 `origin/main`
- `origin` 指向 `changyiwu/opencode-lazy-packs`，`upstream` 指向 `mathruffian-dot/opencode-lazy-packs`
- 修改教學或 Skills 後執行：`powershell -ExecutionPolicy Bypass -File scripts/validate-lazy-pack.ps1`
- `generated/` 僅放本機測試輸出；需要保留的展示圖移到 `examples/`

## 最近進度

- 2026-07-22：移除內建工作流程 Skill，將生圖與全部安裝 Skill 重編為 #07、#08，並同步安裝器與驗證規則；發布驗證已通過。
