---
name: opencode-env-setup
description: 安裝 OpenCode 開發環境（Node.js, OpenCode, uv）。說「建置環境」「安裝開發環境」時載入。
---

# OpenCode 環境建置

檢查並補裝缺失的開發工具，支援 Windows / macOS / Linux。每次安裝前先說明將執行的命令並取得使用者確認。

## 步驟

### 1. 檢查環境
確認作業系統，然後檢查各工具版本：
```bash
node --version
opencode --version
uv --version
```

### 2. 補裝缺少的工具

| 工具 | Windows | macOS | Linux |
|------|---------|-------|-------|
| Node.js LTS | `winget install --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements` | `brew install node` | 使用發行版套件管理器或 Node.js 官方建議方式安裝目前 LTS |
| OpenCode | `npm install -g opencode-ai` | 同左 | 同左 |
| uv | `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 \| iex"` | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | 同左 |

### 3. 最終驗證
```bash
node --version
opencode --version
uv --version
```

### 4. 設定 OpenCode 模型供應商

檢查 `opencode auth list`。如果沒有可用供應商，請使用者在互動式終端執行：

```bash
opencode auth login
```

回報格式：已安裝 / 已補裝清單、版本號、模型供應商登入狀態。

> Git、GitHub CLI 與 GitHub 登入由 `opencode-github` 負責。
