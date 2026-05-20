# OpenCode 懶人包 #09：連接 Gemini（3.5 Flash / Pro）

> 版本：v0.1
> 更新日期：2026-05-20

---

## 這個懶人包會幫你做什麼？

把 OpenCode 接上 Google Gemini，讓你可以用 **Gemini 3.5 Flash**（百萬 context、多模態、最便宜的旗艦級模型）作為日常 coding 與教材處理引擎：

- 安裝 `opencode-gemini-auth` plugin（OAuth 走訂閱配額）
- 或設定 API Key（按 token 計費，100% 合規）
- 配置 `gemini-3.5-flash` 與 `gemini-3-pro-preview` 雙模型
- 啟用 thinking 推理等級
- 驗證能正常呼叫並使用多模態（圖／音／影）

---

## 為什麼選 Gemini 3.5 Flash？

| 優勢 | 數據 |
|---|---|
| Context Window | **1M tokens**（整本 PDF 塞得下）|
| 多模態 | 文字／圖片／**音訊／影片** 全吃 |
| 圖片理解 | MMMU-Pro **84%（業界第一）** |
| Thinking | 4 級可調（minimal/low/medium/high）|
| 速度 | 比競爭對手快 **4×** |
| 價格 | Input $1.5 / Output $9 / **Cached $0.15** per 1M tokens |
| 對比 | 比 GPT-5.5（$5/$30）便宜 **3 倍**，比 Claude Opus 4.7（$5/$25）便宜 **3 倍** |

特別適合：
- 把整本課本 PDF 一次塞進去做教材分析
- 影片講座 → 切時間軸＋摘要
- 拍照批改作業
- 批次處理 Obsidian 筆記

---

## 先備條件

- [ ] 已完成 [#00 環境建置](00-環境建置.md)（裝好 OpenCode）
- [ ] 有 Google 帳號
- [ ] 二選一：
  - **A 路線**：有 Google AI 訂閱（AI Pro $20 / Ultra $100）→ 走 OAuth
  - **B 路線**：沒訂閱也行 → 走 API Key（按量付費）

---

## 請 OpenCode 幫我執行以下步驟

> 把這份檔案的內容貼給 OpenCode，它會自動執行。
> ⚠️ 請先告訴 OpenCode 你要走 **A 路線（OAuth）** 還是 **B 路線（API Key）**。

---

## 🅰️ A 路線：OAuth + 訂閱配額（推薦給有訂閱的人）

### 步驟 A-1：建立 / 編輯 OpenCode 設定檔

設定檔路徑：`~/.config/opencode/opencode.json`
（Windows 對應：`C:\Users\<你的帳號>\.config\opencode\opencode.json`）

如果資料夾不存在先建立：
```bash
mkdir -p ~/.config/opencode
```

寫入或合併以下內容到 `opencode.json`：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-gemini-auth@latest"]
}
```

> 💡 如果檔案已經有其他設定（例如 Firebase MCP），請**合併**而不是覆蓋。

---

### 步驟 A-2：第一次啟動讓 plugin 自動安裝

```bash
opencode
```

第一次跑時 plugin 會自動下載。看到 OpenCode 主畫面後按 `Ctrl+C` 退出。

---

### 步驟 A-3：OAuth 登入 Google

```bash
opencode auth login
```

依序操作：
1. Provider 選 **Google**
2. 認證方式選 **OAuth with Google (Gemini CLI)**
3. 瀏覽器自動彈出 → 用你的 Google 帳號登入 → 允許
4. 回到終端機應該看到 `✓ Authenticated`

---

### 步驟 A-4（選用）：設定 Workspace / Cloud Project ID

如果用的是學校或 Workspace 帳號，需要指定 GCP project：

```bash
export OPENCODE_GEMINI_PROJECT_ID="your-gcp-project-id"
```

或寫入 `opencode.json`：
```json
{
  "provider": {
    "google": {
      "options": {
        "projectId": "your-gcp-project-id"
      }
    }
  }
}
```

---

### ⚠️ A 路線風險告知

Google 官方聲明：**透過第三方軟體使用 Gemini CLI OAuth 違反政策**，可能觸發濫用偵測。
個人輕度使用通常沒事，但若擔心 → 改走 B 路線。

---

## 🅱️ B 路線：API Key（100% 合規，按量付費）

### 步驟 B-1：取得 API Key

1. 開 https://aistudio.google.com/
2. 用 Google 帳號登入
3. 點 **Get API Key** → **Create API Key in new project**
4. 複製 Key

建議存到家目錄安全位置：
```bash
echo "你的key" > ~/.gemini_api_key
chmod 600 ~/.gemini_api_key
```

Windows PowerShell 設環境變數：
```powershell
[Environment]::SetEnvironmentVariable("GEMINI_API_KEY", "你的key", "User")
```

---

### 步驟 B-2：寫入 OpenCode 設定檔

`~/.config/opencode/opencode.json`：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "google": {
      "apiKey": "{env:GEMINI_API_KEY}"
    }
  }
}
```

> 💡 用 `{env:GEMINI_API_KEY}` 從環境變數讀，避免 Key 寫死在檔案裡被推上 Git。

---

## 🎯 共用步驟：完整推薦配置（A/B 路線都適用）

把這份完整設定合併進 `~/.config/opencode/opencode.json`：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-gemini-auth@latest"],
  "model": "google/gemini-3.5-flash",
  "provider": {
    "google": {
      "whitelist": [
        "gemini-3.5-flash",
        "gemini-3-pro-preview"
      ],
      "models": {
        "gemini-3.5-flash": {
          "options": {
            "thinkingConfig": { "thinkingLevel": "medium" }
          }
        },
        "gemini-3-pro-preview": {
          "options": {
            "thinkingConfig": { "thinkingLevel": "high" }
          }
        }
      }
    }
  }
}
```

這份額外做了：
- **預設模型** = Gemini 3.5 Flash（每次不用選）
- **只顯示兩個你會用的模型**（清掉雜訊）
- **Flash 預設 medium thinking**（中等深度推理）
- **Pro 預設 high thinking**（最深推理）

> ⚠️ 走 B 路線的話請拿掉 `plugin` 那一行，並加上 `provider.google.apiKey`。

---

## 驗證步驟

### 1. 看模型清單
重啟 `opencode`，按 `Tab` 或輸入 `/models`，應該只看到 `gemini-3.5-flash` 與 `gemini-3-pro-preview`。

### 2. 測試文字
```
> 用繁中介紹你自己，並告訴我你是哪個模型
```

### 3. 測試多模態（圖片）
拖一張圖片到 OpenCode 視窗，問：
```
> 這張圖在說什麼？
```

### 4. 看配額（A 路線專用）
```
/gquota
```

### 5. 開 debug log（出問題時）
```bash
OPENCODE_GEMINI_DEBUG=1 opencode
# 會在當前資料夾產生 gemini-debug-<timestamp>.log
```

---

## 任務分配建議

| 任務類型 | 模型 | thinkingLevel |
|---|---|---|
| 簡單翻譯、檔名整理 | `gemini-3.5-flash` | `low` |
| 一般寫程式、文件整理 | `gemini-3.5-flash` | `medium` |
| 大量 PDF / 影片 / 音訊分析 | `gemini-3.5-flash`（1M context）| `medium` |
| 複雜架構設計、debug | `gemini-3-pro-preview` | `high` |
| 數學證明、邏輯推理 | `gemini-3-pro-preview` | `high` |

切換模型：在 opencode 內按 `Ctrl+M` 或輸入 `/model`。

---

## 完成回報格式

```md
## Gemini 連接完成

- 路線：A（OAuth）/ B（API Key）
- Plugin 安裝：成功 / 失敗
- 登入帳號：xxx@xxx.com
- 可用模型：gemini-3.5-flash, gemini-3-pro-preview
- 文字測試：✅
- 多模態測試：✅
- 預設模型：gemini-3.5-flash
- 預設 thinking：medium
```

---

## 常見問題

| 問題 | 解法 |
|------|------|
| Plugin 沒裝起來 | `rm -rf ~/.cache/opencode/node_modules/opencode-gemini-auth` 後重啟 opencode |
| 瀏覽器沒自動開（OAuth）| 終端機會印 URL，手動複製貼到瀏覽器 |
| `opencode` 找不到 google provider | 確認 `opencode.json` JSON 格式正確（用 https://jsonlint.com/ 驗證） |
| 用 Workspace 帳號報 quota 錯誤 | 設定 `OPENCODE_GEMINI_PROJECT_ID` 環境變數 |
| API Key 路線報 401 | 確認 `GEMINI_API_KEY` 環境變數已生效（`echo $env:GEMINI_API_KEY`） |
| 不想暴露 Key 在設定檔 | 用 `{env:GEMINI_API_KEY}` 從環境變數讀 |
| 想看每次請求細節 | `OPENCODE_GEMINI_DEBUG=1 opencode` |

---

## 費用速查（2026/5）

| 項目 | 標準區 | 非全球區 |
|---|---|---|
| Input | $1.50 / 1M tokens | $1.65 / 1M |
| Output | $9.00 / 1M tokens | $9.90 / 1M |
| Cached Input | **$0.15 / 1M tokens** | — |
| 免費 quota | AI Studio 個人測試額度 | — |

**訂閱方案參考**：
- AI Pro $20/月（最划算的起點）
- AI Ultra $100/月（5× 配額 + 可用 Spark）
- AI Ultra $200/月（20× 配額，從 $250 降）

---

## 相關連結

- [opencode-gemini-auth plugin（GitHub）](https://github.com/jenslys/opencode-gemini-auth)
- [opencode-antigravity-auth（用 Antigravity 配額）](https://github.com/NoeFabris/opencode-antigravity-auth)
- [Google AI Studio（拿 API Key）](https://aistudio.google.com/)
- [Gemini API 官方文件](https://ai.google.dev/gemini-api/docs/)
- [Gemini 3.5 Flash Model Card](https://deepmind.google/models/model-cards/gemini-3-5-flash/)

---

## 更新紀錄

| 日期 | 版本 | 更新內容 |
|------|------|---------|
| 2026-05-20 | v0.1 | 初版：A 路線（OAuth）+ B 路線（API Key）雙方案 |
