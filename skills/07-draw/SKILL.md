---
name: opencode-draw
description: 使用 OpenAI GPT Image 2 產生圖片。使用者說「畫圖」「生圖」「畫一張」時載入。
---

# OpenCode 生圖技能

使用本 Skill 同目錄的 `draw.py` 產生 PNG。

## 代理工具隔離規則

- 本 Skill 只使用 `~/.config/opencode/skills/opencode-draw/` 內的檔案。
- 不得搜尋、載入、複製、修改或改用 `~/.codex/skills/codex-draw`，也不得以其他代理工具的生圖 Skill 取代本 Skill。
- 若同目錄缺少 `draw.py`，立即停止並回報安裝不完整；從 `opencode-lazy-packs` 重新同步 `opencode-draw`，不得刪除或簡化本 Skill。

## 前置檢查

1. 確認同目錄的 `draw.py` 存在。
2. 確認 `uv --version` 可用。
3. 確認環境變數 `OPENAI_API_KEY` 已存在，或使用者家目錄的 `.openai.env` 含有該變數。
4. 不可把金鑰內容輸出到終端、對話或回報中；只能回報「已設定／未設定」。

## 執行

先確認本 Skill 的實際目錄，再執行同目錄的 `draw.py`：

```powershell
uv run --with openai python "$HOME/.config/opencode/skills/opencode-draw/draw.py" "<完整提示詞>" --name <簡短名稱> --quality low
```

預設輸出規則：

- 當前專案有 `slides/`：輸出至 `slides/generated/`
- 其他情況：輸出至 `generated/`
- 若使用者指定位置：傳入 `--output-dir <目錄>`

## 品質選擇

- 預設 `low`
- 使用者要求較高細節或 low 明顯不足時用 `medium`
- 印刷或密集文字才用 `high`

## 完成回報

只回報模型、品質、尺寸與實際輸出檔案完整路徑，不回報或顯示 API key。
