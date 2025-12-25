---
name: git-commit-master
description: 按照 Conventional Commits 规范执行高质量的 git 提交，处理暂存、消息生成及钩子修复。
---

核心逻辑

1. **分析变更**: 使用 `git diff --cached` 深度分析已暂存的代码。
2. **生成消息**: 遵循 `<type>(<scope>): <subject>` 格式。
   - `feat`: 新功能
   - `fix`: 修补 bug
   - `docs`: 文档改变
   - `style`: 代码格式（不影响代码运行的变动）
   - `refactor`: 重构（既不是新增功能，也不是修改 bug 的代码变动）
3. **自愈机制**: 如果提交因 pre-commit 钩子失败且代码被自动格式化，应自动重新 add 并尝试再次提交。
   使用时机

- 当需要将当前更改持久化到版本库时。
- 当用户要求“提交代码”或“保存更改”时。
