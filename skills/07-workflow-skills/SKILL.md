---
name: opencode-workflow-skills
description: 安裝完整的 startup、shutdown、project-init 三個 OpenCode Skills。說「裝工作流程技能」時載入。
---

# 安裝工作流程 Skills

本 Skill 隨附：

```text
assets/startup/SKILL.md
assets/shutdown/SKILL.md
assets/project-init/SKILL.md
```

## 步驟

1. 找到本 Skill 的實際安裝目錄，確認三個 assets 都存在。
2. 檢查 `~/.config/opencode/skills/startup/`、`shutdown/`、`project-init/` 是否已有內容。
3. 若目標已存在，先比較差異並詢問使用者，不得直接覆蓋。
4. 使用目前作業系統的原生檔案工具，將三個完整資料夾複製到 `~/.config/opencode/skills/`。
5. 確認每個目標資料夾都有完整 `SKILL.md`，且 frontmatter name 與目錄相同。

若使用者有自訂 Skill 權限，安全合併：

```json
{
  "permission": {
    "skill": {
      "*": "ask",
      "startup": "allow",
      "shutdown": "allow",
      "project-init": "allow"
    }
  }
}
```

重新開啟 OpenCode 後說「開工」。正確驗證只讀取規則與 Git 狀態，不修改檔案。

回報三個來源、目標、覆蓋或保留決定，以及驗證結果。
