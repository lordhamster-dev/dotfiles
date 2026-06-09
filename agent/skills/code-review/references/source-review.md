# Source Review and Adaptation Notes

## Search performed

The skill was created after searching GitHub with the authenticated `gh` CLI for existing code-review Agent Skills and templates, including queries such as:

- `code review skill agent`
- `code-review SKILL.md`
- `name: code-review SKILL.md`
- `claim-verifier code-review SKILL.md`

## Best reference found

The most complete public Agent Skill-style reference found was:

- Repository: `juicesharp/rpiv-mono`
- Path: `packages/rpiv-pi/skills/code-review/SKILL.md`
- Template: `packages/rpiv-pi/skills/code-review/templates/review.md`
- URL: <https://github.com/juicesharp/rpiv-mono/tree/main/packages/rpiv-pi/skills/code-review>
- License: MIT, per repository license metadata from GitHub

## Ideas borrowed conceptually

This Pi skill uses original wording but preserves several design ideas from that reference because they are useful for robust code review:

- review an explicit git scope rather than the whole repository by default
- use high-context diffs (`-U30`, fallback `-U10`) so findings are grounded in surrounding code
- separate lenses for quality, security, dependencies, integration, tests, and cross-file interactions
- compare new code against peer implementations and established local patterns
- require every finding to cite `file:line` plus a verbatim code quote
- run a verification pass that drops or demotes ungrounded findings before reporting
- use severity buckets and stable finding IDs
- optionally write timestamped review artifacts under `thoughts/shared/reviews/`

## Deliberate Pi adaptation

The referenced skill assumes a multi-agent runtime with specialized agents and advisor tools. This local skill is intentionally single-agent and Pi-compatible:

- no dependency on unavailable `Agent`, `advisor`, or custom subagent types
- uses Pi's normal filesystem tools plus `bash`, `git`, `rg`, and optional `gh`
- does not automatically post GitHub comments
- defaults to concise chat output unless an artifact is requested

## Licensing note

Because the source is MIT-licensed, it is acceptable to adapt ideas. The local `SKILL.md` is not a verbatim copy; it is a compact workflow rewritten for this Pi environment.
