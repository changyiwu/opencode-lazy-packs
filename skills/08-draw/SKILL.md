---
name: 08-draw
description: 使用 OpenAI GPT Image 2 產生圖片。使用者說「畫圖」「生圖」「畫一張」時載入。
---

# OpenCode 生圖技能

使用本 Skill 同目錄的 `draw.py` 產生 PNG。不要重新下載或覆蓋其他代理工具的 Skill。

## 前置檢查

1. 確認 `uv --version` 可用。
2. 確認環境變數 `OPENAI_API_KEY` 已存在，或使用者家目錄的 `.openai.env` 含有該變數。
3. 不可把金鑰內容輸出到終端、對話或回報中；只能回報「已設定／未設定」。

## 執行

先確認本 Skill 的實際目錄，再執行同目錄的 `draw.py`。全域安裝的典型命令是：

```bash
uv run --with openai python ~/.config/opencode/skills/08-draw/draw.py "<完整提示詞>" --name <簡短名稱> --quality low
```

Windows PowerShell 可使用：

```powershell
uv run --with openai python "$HOME/.config/opencode/skills/08-draw/draw.py" "<完整提示詞>" --name <簡短名稱> --quality low
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
