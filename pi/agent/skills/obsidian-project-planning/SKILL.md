---
name: obsidian-project-planning
description: Plan and track software development work through an Obsidian project note instead of local planning files. Use this skill when the user asks to plan a development task with Obsidian notes, maintain project progress in Obsidian, sync completed/unfinished features, or when AGENTS.md mentions an Obsidian project note and tells the agent to load this skill.
---

# Obsidian Project Planning

Use an Obsidian note as the persistent development plan for the current project. This is a simpler alternative to multi-file planning: one project note stores goals, completed features, unfinished work, decisions, discoveries, and session progress.

## When to use

Use this skill for development tasks that need persistent planning or progress tracking, especially when the user mentions:

- Obsidian project notes
- project planning in Obsidian
- completed and unfinished features
- keeping a project note updated
- recording the note path in `AGENTS.md`
- `AGENTS.md` already contains an Obsidian project note path or says to load this skill

Skip it for trivial one-shot edits unless the user explicitly wants the project note updated.

## Dependencies and related skills

- Prefer the `obsidian` CLI when available and Obsidian is running.
- Whenever using or troubleshooting the `obsidian` CLI, load and follow the `obsidian-cli` skill.
- If using Obsidian-specific markdown, also follow the `obsidian-markdown` skill.
- If the `obsidian` CLI is unavailable, ask the user for the vault path and edit the markdown note directly with normal file tools.

## Core workflow

### 1. Identify project and note name

1. Determine the project root from the current working directory.
2. Use the project directory basename as the default project name.
3. The default Obsidian note title is exactly the project name.
4. When creating a new project note, place it under the vault-relative `1-Projects/` directory by default, e.g. `1-Projects/<project-name>.md`.
5. If the user gives a specific note name or path, use that instead.

### 2. Locate the project note

Try, in order:

1. Read `AGENTS.md` in the project root and look for an existing Obsidian project note path.
2. Use `obsidian read file="<project-name>"` to find a note by title.
3. Use `obsidian search query="<project-name>" limit=10` and choose an exact or obviously matching project note.
4. If direct vault access is being used, search the vault for `<project-name>.md`.

Do not silently choose an ambiguous note. If multiple likely notes exist, ask the user which one to use.

### 3. Create the note only with user consent

If no matching note exists:

1. Tell the user that no project note was found.
2. Propose the note path as `1-Projects/<project-name>.md` and include the vault target if known.
3. Ask for consent before creating it.
4. After consent, create the note in `1-Projects/` using this template:

```markdown
---
title: <project-name>
status: active
---

## Purpose

- <brief project purpose or user goal>

## Completed Features

- [x] <completed item> ✅ <YYYY-MM-DD>

## Unfinished Features

- [ ] <planned or in-progress item>

## Decisions

| Date | Decision | Rationale |
| ---- | -------- | --------- |

## Discoveries

- <important findings, constraints, bugs, commands, or file locations>

## Session Log

### <YYYY-MM-DD>

- Started project planning note.
```

Keep the template compact. Fill unknown sections with useful placeholders rather than inventing facts.

### 4. Record the note path in AGENTS.md

After the note is located or created, ensure the project root has an `AGENTS.md` entry so future agents can find it immediately.

If `AGENTS.md` does not exist, create it with a minimal entry:

```markdown
## Obsidian Project Note

- Project note: `<vault-relative-or-known-path>`
- When working on planning, feature development, task continuation, or progress tracking, load and follow the `obsidian-project-planning` skill.
- Use this note to track completed features, unfinished features in priority order, decisions, discoveries, and session progress.
```

If `AGENTS.md` exists, add or update only the `## Obsidian Project Note` section. Ensure that section explicitly tells future agents to load and follow the `obsidian-project-planning` skill when planning, continuing development tasks, or updating progress, and to load the `obsidian-cli` skill whenever they use the Obsidian CLI. Do not rewrite unrelated project instructions.

Prefer a vault-relative path when known, especially the default `1-Projects/<project-name>.md` for newly created notes. If only the note title is known, record `[[<note-title>]]` and note that it was resolved by Obsidian.

### 5. Read before planning or acting

Before making a development plan or resuming work:

1. Read the project note.
2. Read `AGENTS.md` for project instructions.
3. Summarize the current goal, completed features, and unfinished features in their planned order.
4. Only then propose or execute a task plan.

### 6. Keep the note updated in real time

Update the project note whenever any of these occur:

- A feature is completed: move/check it under `Completed Features` using Obsidian Tasks completion format: `- [x] Feature text ✅ YYYY-MM-DD`.
- A new requirement appears: add it under `Unfinished Features` in the intended execution order.
- Priorities change: reorder `Unfinished Features` so the next work appears first.
- A decision is made: add a row under `Decisions` with date, decision, and rationale.
- A meaningful discovery is made: add it under `Discoveries`.
- A phase finishes, tests run, or an error occurs: add a short `Session Log` entry.

For long-running tasks, update at least after each phase and before ending the response.

### 7. Output format to the user

When starting, report:

- Project name
- Obsidian note found/created
- Whether `AGENTS.md` was updated
- Current completed/unfinished summary
- Ordered unfinished features

When finishing a task, report:

- Code/files changed
- Tests or checks run
- Project note updates made
- Remaining unfinished features in order

## Editing rules

- Make surgical updates; preserve user-written note content.
- Do not delete completed history unless the user asks.
- Prefer checklist items for features. Treat `Unfinished Features` as the ordered queue of next work; reorder it when priorities change.
- Do not create a separate `Next Actions` section; put actionable future work under `Unfinished Features`.
- When marking features complete, use Obsidian Tasks completion format with date: `- [x] Feature text ✅ YYYY-MM-DD`.
- Use Obsidian wikilinks for related notes when useful.
- Do not create or modify a note in the wrong vault. Ask if vault identity is unclear.
- Do not store secrets, tokens, private credentials, or sensitive logs in the project note.

## Recovery and ambiguity

If the note path in `AGENTS.md` is stale:

1. Try to locate the note by title through Obsidian search.
2. If found, update `AGENTS.md` with the correct path.
3. If not found, ask whether to create a new note or use a different note.

If Obsidian is not running or the CLI fails:

1. Explain the failure briefly.
2. Ask for the vault path if direct file editing is acceptable.
3. Otherwise continue the code task and clearly state that project-note sync is pending.
