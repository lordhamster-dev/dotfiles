---
name: plan-task
description: Plan complex tasks and write structured plan documents to the project's plans/ directory. Use this skill whenever the user asks to plan a task, create a plan, design a solution, make a plan, analyze a requirement before implementation, or says "先规划一下", "先出个方案", "帮我设计", "分析一下怎么做". Also trigger proactively when the user describes a large, ambiguous, or multi-step task that would benefit from upfront planning before any code is written. This skill operates in planning-only mode — it reads code, runs verification commands, and produces plan documents, but MUST NOT write or modify any production code or configuration files.
---

# Plan Task

Plan complex tasks and produce structured plan documents in the project's `plans/` directory.

## Core rule: planning-only mode

When this skill is active, you are in **planning-only mode**:

- ✅ Read project files, run verification commands (tests, lints, type checks), execute analysis scripts
- ✅ Create or update files inside `plans/`
- ❌ Do NOT write, edit, or delete any production code, configuration files, or any file outside `plans/`
- ❌ Do NOT create commits or branches
- ❌ Do NOT install dependencies or make system changes

If the user asks you to implement the plan, say: "The plan is complete. To begin implementation, ask me to switch out of planning mode — for example, say 'start implementing' or manually load a different skill."

## Workflow

### 1. Understand the task

- Ask clarifying questions if the goal, scope, or constraints are unclear.
- Confirm the target outcome with the user before writing.

### 2. Explore the project

- Read relevant source files, tests, configuration, and any existing documentation.
- Run verification commands to understand the current state (e.g., `cargo test`, `go test ./...`, `npm test`, `rg` for patterns, `git log` for recent changes).
- Inventory affected files, dependencies, and interfaces.

### 3. Write the plan

- Create `plans/` at the project root if it does not exist.
- Name the file `plans/YYYY-MM-DD-{task-slug}.md`. Use today's date. Convert the task name to lowercase kebab-case for the slug.
- Use the template in [assets/template.md](assets/template.md).
- Fill every section concretely. Do not leave "TBD" entries — if something is unknown, state that it is unknown and propose how to resolve it.
- Each step under **分步方案** must include:
  - **操作**: specific actions (files to touch, commands to run)
  - **产出**: what artifact results from this step
  - **验证**: how to confirm the step succeeded

### 4. Present and iterate

- Show the plan to the user.
- Ask if any adjustments are needed.
- Once confirmed, the plan is ready for implementation.

## Plan quality checklist

Before presenting the plan, confirm:

- [ ] The overview matches the user's stated goal.
- [ ] Every target outcome has at least one corresponding step.
- [ ] Each step is ordered correctly — no step depends on a later step's output.
- [ ] Verification methods are concrete and executable (commands, expected outputs, manual checks).
- [ ] Risks cover real failure modes, not generic placeholders.
- [ ] The plan does not assume the existence of code that has not yet been written (within this plan).
