---
name: commit
description: Generate a Conventional Commits message and create a git commit
---

Follow this workflow to create a git commit.

## 1. Analyze Changes

Run `git diff --cached` to analyze staged changes. If there are no staged changes, run `git status` first and show the user the list of changed files for confirmation.

## 2. Generate the Commit Message

Generate the message strictly according to the Conventional Commits specification:

```
<type>[optional scope]: <subject>

[optional body]
```

**Supported types**:

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `refactor`: Code changes that neither fix a bug nor add a feature
- `chore`: Build, dependency, tooling, or other maintenance changes
- `style`: Formatting changes that do not affect behavior, such as whitespace or semicolons
- `test`: Adding or updating tests
- `perf`: Performance improvements

**Rules**:

- `scope` is optional. When used, wrap it in parentheses to indicate the affected area, such as a module or component name. The user may specify it via the `$1` argument.
- Write `subject` in English, in the imperative mood, with no trailing period, and keep it under 50 characters.
- `body` is optional. When useful, write it in English and briefly explain what changed, why it changed, and the affected scope.

## 3. Confirm and Execute

After generating the message, show the complete command and ask the user to confirm. Use one `-m` for the subject only, or two `-m` arguments when a body is included:

```bash
git commit -m "feat(scope): subject"
git commit -m "feat(scope): subject" -m "Body text"
```

Only run `git commit` after confirmation. Do not commit automatically.
