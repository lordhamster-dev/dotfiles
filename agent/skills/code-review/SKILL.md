---
name: code-review
description: Review code changes for correctness, maintainability, integration risk, tests, dependencies, and security-relevant regressions. Use this skill whenever the user asks for a code review, PR review, diff review, commit review, staged/working-tree review, or asks "review this", "check my changes", "look over this branch", or "before I merge". Produces evidence-cited findings with verification and concrete fixes.
compatibility: Pi coding agent with git, bash, read, and optional GitHub CLI for PR metadata.
---

# Code Review

Use this skill to review changed code like a careful human reviewer: establish the exact diff, understand surrounding code, find actionable defects, verify every claim, and report only evidence-backed findings.

This is a Pi-compatible single-agent workflow inspired by a public multi-agent code-review skill. Read [references/source-review.md](references/source-review.md) when adapting this skill or explaining its provenance.

## Defaults

- Install/use globally for personal code review workflows.
- If the user gives no scope, review the current branch against the default branch.
- If there are uncommitted changes and no explicit scope, mention them and ask whether to review branch diff, working tree, staged changes, or all pending changes.
- Prefer a chat report unless the user asks for an artifact; if writing an artifact, use `thoughts/shared/reviews/YYYY-MM-DD_HH-MM-SS_<scope>.md` and [templates/review.md](templates/review.md).
- Security-only audits should use the `security-review` skill instead; this skill still checks security-relevant regressions in the reviewed diff.

## Scope Resolution

Determine what to review before analyzing code.

Supported scopes:

- `working` / `unstaged`: `git diff`
- `staged`: `git diff --cached`
- `commit` or no argument with a clean tree on a detached/single-commit request: `git show --stat --patch -U30 HEAD`
- `<hash>`: `git show --stat --patch -U30 <hash>`
- `<base>..<tip>`: `git diff --stat <base>..<tip>` and `git diff -U30 <base>..<tip>`
- PR number or URL: use `gh pr view` for metadata, then diff against the PR base branch
- default branch review: detect default branch with `git symbolic-ref --quiet --short refs/remotes/origin/HEAD | sed 's@^origin/@@'`; fallback to `main`, then `master`

Create a temporary review patch when useful:

```bash
git diff -U30 <base>...HEAD > .git/pi-code-review.diff
```

Use `-U30` when possible so findings include function-level context. If the patch is too large, use `-U10`; do not rely on `-U0` for semantic review.

Stop and ask the user if the requested scope is ambiguous or resolves to no changed files.

## Review Workflow

### 1. Inventory the change

Gather:

- changed files and diff stats
- commit messages or PR title/body when available
- language/framework signals from manifests and existing project conventions
- tests added/changed
- dependency manifest or lockfile changes
- generated files, snapshots, vendored files, and binary assets to de-prioritize

Useful commands:

```bash
git status --short
git diff --name-status <scope>
git diff --stat <scope>
git log --oneline --decorate -20
```

For PRs, if `gh` is authenticated:

```bash
gh pr view <pr> --json number,title,body,baseRefName,headRefName,author,commits,files,reviews
```

### 2. Build a mental map

For each changed production file, identify:

- responsibility and public API surface
- entry points and callers (`rg`, `git grep`, imports, routes, registrations)
- outbound dependencies (database, filesystem, network, subprocess, framework APIs)
- nearby peer implementations or established patterns
- data model, schema, enum, route, or protocol contracts touched by the diff

Read full files when patch context is insufficient. Read tests after production code so you can judge coverage against actual risk.

### 3. Review by lenses

Apply these lenses to the diff and surrounding code. Report only issues caused or exposed by the reviewed change.

#### Correctness and logic

Check validation, condition order, null/undefined handling, error paths, async/await, return values, state transitions, off-by-one boundaries, idempotency, and rollback/cleanup behavior.

#### Integration and contracts

Check whether callers, routes, schemas, serializers, migrations, config, dependency injection, event handlers, CLI flags, and generated types still agree. For enums/discriminators/statuses, verify every registry/switch/map/query filter that must know about new or renamed values.

#### Pattern consistency

Compare new code to nearby peers. Flag meaningful divergence in guards, events, persistence fields, teardown, logging, authorization, or test setup. Do not flag style-only differences unless they create maintenance risk.

#### Tests and verification

For each behavior-bearing change, verify there is an appropriate test or explain why existing tests cover it. Focus on edge cases, regression cases, error paths, and cross-layer contract changes.

#### Dependencies and build configuration

For manifest/lockfile changes, list added/removed/bumped packages, peer/dev/optional dependency changes, license changes if visible, and obvious version conflicts. Use ecosystem-native audit commands only if they are already available and non-interactive.

#### Security-relevant regressions

Look for new or changed user-controlled data flows into dangerous sinks: command execution, dynamic code/deserialization, raw queries, explicit-trust HTML/markup rendering, filesystem paths, outbound URLs, secrets, or privileged operations missing authorization/validation. Prefer false negatives over speculative security findings; require a concrete source-to-sink or boundary-change trace.

#### Performance and reliability

Check newly introduced hot-path allocations, N+1 queries, unbounded loops, cache invalidation, retries without idempotency, concurrency races, resource leaks, and timeout/fallback behavior.

### 4. Find cross-file interactions

After per-file review, look for emergent issues across files:

- one layer accepts a state/value another layer rejects
- data is written but never read, indexed, migrated, or cleaned up
- event producers and consumers disagree
- a retry/replay path can duplicate non-idempotent work
- a public API changes without caller/test/doc updates
- a new peer member misses an invariant shared by existing peers

### 5. Verify every finding

Before reporting, re-read each cited location in the actual file state.

A finding must include:

- exact `file:line`
- a short verbatim code quote
- why the changed code creates the issue
- impact/blast radius
- concrete fix direction

Drop findings when:

- the cited line does not exist or is not part of the reviewed change/context
- an upstream guard, framework behavior, or existing caller contract makes the claim false
- the issue is purely speculative without a plausible failure path
- it is a pre-existing unrelated problem not affected by this diff

Demote findings when the risk is real but narrower than first stated.

### 6. Report

Order findings by severity, then by likely reviewer actionability.

Severity:

- 🔴 Critical — likely merge blocker: data loss, security exploit, broken core flow, irreversible migration/rollback issue, or broad production outage risk
- 🟡 Important — should fix before/soon after merge: real bug, contract drift, missing important tests, moderate security/reliability risk
- 🔵 Suggestion — useful improvement: maintainability, narrow edge case, low-risk consistency issue
- 💭 Discussion — unclear product/design tradeoff or question that needs author intent

If no issues are found, say so clearly and summarize what was reviewed.

Use this compact chat format unless writing an artifact:

```markdown
## Code Review Summary

Scope: <scope>
Files reviewed: <N>
Status: <approved | needs_changes | requesting_changes>

### Findings

#### 🔴 Critical
- **Q1 — <headline>**
  - Evidence: `path/file.ext:42` — `<verbatim line>`
  - Why: <mechanism>
  - Fix: <specific action>

#### 🟡 Important
...

#### 🔵 Suggestions
...

#### 💭 Discussion
...

### Checks performed
- Diff/context reviewed: <yes/no>
- Tests reviewed: <yes/no + paths>
- Dependencies reviewed: <yes/no/not applicable>
- Security-sensitive sinks checked: <yes/no/not applicable>
- Verification pass: <verified/dropped/demoted counts>
```

## Artifact Mode

When the user asks to save a review, create `thoughts/shared/reviews/` if needed and write one Markdown file using [templates/review.md](templates/review.md). Do not overwrite prior reviews; use a timestamped filename.

## GitHub PR Notes

When reviewing a PR and `gh` is available:

1. Read PR metadata and changed files with `gh pr view`.
2. Do not post PR comments unless the user explicitly asks.
3. If asked to post, summarize findings first and ask for confirmation before `gh pr review` or `gh pr comment`.

## Quality Bar

- Prefer fewer, better findings over broad commentary.
- Keep findings tied to changed code.
- Do not include praise unless it helps orient the review.
- Do not rewrite code unless the user asks for fixes.
- Preserve repository conventions when suggesting fixes.
