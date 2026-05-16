# Global Development Configuration

## Environment

- **Operating system**: ArchLinux
- **User terminal**: Kitty
- **Environment constraint**: Python is managed through uv

## Permissions

- You have permission to read any file without asking for confirmation

## Coding Principles (Core Philosophy)

### 1. Think First, Then Code

- State assumptions clearly. When there are multiple interpretations, list the options instead of silently choosing one.
- If there is a simpler approach, point it out proactively. If something is genuinely unclear, **stop and ask** instead of guessing.
- If the requirement is unclear → explain what is unclear, then ask.

### 2. Prefer Simplicity

- Implement only what was requested; do not write speculative code.
- Do not abstract code that is used only once. Avoid flexibility for “maybe someday”.
- If 200 lines can be solved in 50 lines, rewrite it.

### 3. Surgical Changes

- Change only what is necessary. Do not “clean up” unrelated code along the way.
- Preserve the existing code style, even if you would write it differently.
- Remove orphan code introduced by your changes, such as unused imports or variables. For pre-existing dead code, mention it but do not delete it.

### 4. Goal-Driven Execution

Turn tasks into verifiable goals:

- “Fix a bug” → “Write a test that reproduces it, then make it pass”
- “Refactor X” → “Ensure tests pass before and after the refactor”

## Command Execution Strategy

### AI May Execute Automatically (✅ Allowed)

- **File operations**: use dedicated tools (`read`, `write`, `edit`, `bash`)
- **Git read-only operations**: `git status/log/diff/branch/show/blame`
- **GitHub operations**: `gh pr/issue/repo/search`, etc.
- **Type checks**: `npx tsc --noEmit`, `npx vue-tsc --noEmit`

### Commands to Provide for the User to Run

Commands that require administrator privileges, interactive operation, or long-running processes → provide a shell code block for the user to run manually.

### Absolutely Forbidden

- Interactive commands, such as text editors or interactive installers
- System administration commands that require administrator privileges
- Dangerous commands, such as `rm`, `kill`, etc.

## Core Workflow

### Normal Features

Plan → Code → `/code-review` → `/security-review` when sensitive data is involved

### Complex Features / Architectural Changes

Use `/planning-with-files` to generate a plan → user confirmation → phased implementation → comprehensive review

## Working Principles

- Prefer reading the project-level `AGENT.md` first
- Prefer editing existing files over creating new files

## Error Handling

- **Tool failure**: analyze the cause → try an alternative → explain to the user after 3 consecutive failures
- **Build/test failure**: fix incrementally, one error at a time, and verify after each fix
