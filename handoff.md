# 交接檔（handoff.md）

## ⏯️ 目前做到哪

已移除第二大腦設定指南與 `opencode-second-brain` Skill，將 Firebase、瀏覽器、生圖與全部安裝重新編為 #04～#07，並同步 README、INSTALL、安裝器與驗證器。專案工作筆記位置已改為 `C:\Users\chang\我的雲端硬碟\2ndbrain\opencode-lazy-packs\專案工作流程.md`。

## 🚦 目前狀態

- `scripts/validate-lazy-pack.ps1` 已通過，repo 現有 8 個 `opencode-*` Skills。
- 隔離安裝測試已成功安裝 8 個 Skills；`draw.py` AST 語法驗證通過。
- 本輪尚未同步 `~/.config/opencode/skills/`，全域舊副本 `opencode-second-brain` 可能仍存在。
- Obsidian MCP 已完成讀取驗證；新的 `專案工作流程.md` 將在本輪 Git 推送完成後補寫詳細收工紀錄。

## ➡️ 下一步

1. 執行 `skills/07-install-all/install-opencode-skills.ps1`，同步 OpenCode 全域 Skills。
2. 確認後移除全域舊副本 `opencode-second-brain`，再驗證全域目錄只有預期的 8 個相關 Skills，且沒有舊編號副本。
3. Git 推送完成後，將本次移除與重編決策補記到 `opencode-lazy-packs/專案工作流程.md`。

## ⚠️ 注意事項

- 不要把 Skills 安裝到 `~/.agents/skills/` 當作 OpenCode 的完成位置。
- `opencode-draw` 必須使用自身的 `draw.py`，不得借用 Codex 版本。
- 安裝器若偵測到已退役的 `opencode-second-brain` 會停止；取得刪除確認後清理，再重新同步。

## 🕐 最後更新

- 時間：2026-07-22 16:12
- 更新者：Codex @ PC-YI-FY
- Git push：⏳ 待推
