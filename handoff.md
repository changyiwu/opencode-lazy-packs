# 交接檔（handoff.md）

## ⏯️ 目前做到哪

已移除 repo 內建工作流程 Skill，將生圖與全部安裝 Skill 重新編為 #07、#08，並同步 README、INSTALL、安裝器與驗證器。

## 🚦 目前狀態

- `scripts/validate-lazy-pack.ps1` 已通過，預期為 9 個 `opencode-*` Skills。
- `.playwright-mcp/` 是本機工具輸出，已加入 ignore，不納入版本控制。

## ➡️ 下一步

1. 執行 `skills/08-install-all/install-opencode-skills.ps1`，同步 OpenCode 全域 Skills。
2. 驗證全域目錄只有預期的 9 個相關 Skills，且沒有舊編號副本。

## ⚠️ 注意事項

- 不要把 Skills 安裝到 `~/.agents/skills/` 當作 OpenCode 的完成位置。
- `opencode-draw` 必須使用自身的 `draw.py`，不得借用 Codex 版本。

## 🕐 最後更新

- 時間：2026-07-22 14:29
- 更新者：Codex @ PC-YI-FY
- Git push：✅ 已推（主要提交 `60f8c6f`）
