---
name: opencode-env-setup
description: 安裝 OpenCode 開發環境（Node.js, OpenCode, uv）。說「建置環境」「安裝開發環境」時載入。
---

# OpenCode 環境建置

檢查並補裝缺失的開發工具，支援 Windows / macOS / Linux。

## 步驟

### 1. 檢查環境
確認作業系統，然後檢查各工具版本：
```bash
node --version; opencode --version; uv --version
```

### 2. 補裝缺少的工具

| 工具 | Windows | macOS | Linux |
|------|---------|-------|-------|
| Node.js | `winget install --id OpenJS.NodeJS --accept-source-agreements` | `brew install node` | `curl -fsSL https://deb.nodesource.com/setup_20.x \| sudo -E bash - && sudo apt install -y nodejs` |
| OpenCode | `npm install -g opencode-ai` | 同左 | 同左 |
| uv | `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 \| iex"` | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | 同左 |

### 3. 最終驗證
```bash
node --version && opencode --version && uv --version
```

回報格式：已安裝 / 已補裝清單 + 版本號。
