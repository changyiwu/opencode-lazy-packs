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
├── generated/       # 測試輸出
├── 00-*.md ~ 08-*.md  # 教學流程文件
├── AGENTS.md        # 本檔案
├── SKILL.md         # 懶人包入口技能
├── README.md
├── LICENSE
└── .gitignore
```

## Obsidian 關聯資料

- Obsidian vault：`C:\Users\chang\我的雲端硬碟\2ndbrain`
- 每日筆記：`每日筆記/<日期>.md`
- 創作庫：`創作庫/opencode-lazy-packs/`
- 知識庫：`知識庫/`

## 同步對照表

| 平台 | 位置 |
|------|------|
| Obsidian 閱讀版 | `2ndbrain/創作庫/opencode-lazy-packs/` |
| GitHub (origin) | `changyiwu/opencode-lazy-packs` |
| GitHub (upstream) | `mathruffian-dot/opencode-lazy-packs` |
| 本機路徑 | `C:\Users\chang\我的雲端硬碟\agents\opencode-lazy-packs` |

## 工作流程提醒

- 使用者說「更新 OpenCode 懶人包」→ 只動本資料夾
- 使用者說「三邊都更新」→ 三個資料夾都改
- 修改主流程時三邊都要更新
- **不要**把 Claude Code 或 Codex 版直接複製過來
- Commit 前檢查敏感資訊（API key 等）
