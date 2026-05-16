---
name: skill-creator
description: Create, improve, or debug Agent Skills for Pi and other Agent Skills-compatible harnesses. Use this skill whenever the user asks to make a new skill, turn a workflow into a reusable skill, install or adapt a Claude/Codex/Agent Skill, improve skill triggering, write SKILL.md frontmatter, add skill resources/scripts/evals, or troubleshoot why a skill is not loading or not triggering.
compatibility: Pi coding agent with filesystem tools. Follows the Agent Skills standard and Pi skill discovery rules.
---

# Skill Creator

Use this skill to create practical, Pi-compatible Agent Skills. The goal is not to generate a generic prompt file; it is to capture a reusable workflow that future agents can discover, load, and follow with minimal ambiguity.

## Default workflow

1. **Clarify intent**
   - What capability should the skill add?
   - When should it trigger?
   - What inputs, files, tools, or dependencies does it need?
   - What should the output look like?
   - Should this be a global skill or project skill?

2. **Inspect existing context**
   - Read relevant existing skills for local style.
   - Read project docs, runbooks, scripts, or examples that encode the actual workflow.
   - If adapting another skill, read it and preserve ideas, not unlicensed text.

3. **Draft the skill**
   - Create a directory whose name exactly matches the `name` frontmatter.
   - Write `SKILL.md` with concise frontmatter and focused instructions.
   - Add bundled resources only when they reduce future context or make execution deterministic.

4. **Check it**
   - Validate frontmatter rules.
   - Make sure relative links point to real bundled files.
   - Confirm instructions are actionable in Pi with available tools.

5. **Test or simulate usage**
   - For objective workflows, create 2-3 realistic eval prompts.
   - For subjective workflows, do a qualitative review against likely user prompts.
   - Improve the description if the skill may under-trigger or over-trigger.

If the user asks for a simple skill and gives enough information, create it directly. If important details are missing, ask only the smallest set of questions needed before writing files.

## Pi skill locations

Ask where to install when unclear:

- Global user skill: `~/.pi/agent/skills/<skill-name>/SKILL.md`
- Alternative global skill: `~/.agents/skills/<skill-name>/SKILL.md`
- Project skill: `.pi/skills/<skill-name>/SKILL.md`
- Alternative project skill: `.agents/skills/<skill-name>/SKILL.md`

Default to `~/.pi/agent/skills/` when the user says “for me”, “globally”, or asks to install a reusable personal skill. Default to `.pi/skills/` when the workflow is clearly project-specific.

Pi also discovers skills from package skill directories and paths configured in settings. If Pi-specific behavior is uncertain, read:

`/home/lordhamster/.nvm/versions/node/v22.22.0/lib/node_modules/@earendil-works/pi-coding-agent/docs/skills.md`

## Required structure

A standard skill is a directory with a required `SKILL.md`:

```text
skill-name/
├── SKILL.md
├── scripts/      # optional deterministic helpers
├── references/   # optional long docs loaded only when needed
└── assets/       # optional templates, examples, images, etc.
```

Keep `SKILL.md` useful when loaded by itself. Put long reference material in `references/` and link to it from the body.

## Frontmatter rules

Every `SKILL.md` starts with YAML frontmatter:

```markdown
---
name: skill-name
description: What this skill does and when to use it. Be specific.
---
```

Rules:

- `name` is required.
- `name` must match the parent directory.
- `name` uses lowercase letters, digits, and hyphens only.
- `name` must not start/end with a hyphen or contain consecutive hyphens.
- `description` is required, non-empty, and under 1024 characters.
- Optional fields include `license`, `compatibility`, `metadata`, `allowed-tools`, and `disable-model-invocation`.

Use a `compatibility` field only when it adds real value, such as required CLIs, network access, or a target harness.

## Writing the description

The description is the primary trigger. Write it as an instruction to the agent, not just a label.

Good description pattern:

```yaml
description: Build and debug Foo deployments. Use this skill whenever the user mentions Foo deploys, Foo config, release failures, staging promotion, or production rollback, even if they do not explicitly ask for a Foo deployment guide.
```

Checklist:

- Say what the skill does.
- Say when to use it.
- Include user phrases and adjacent contexts that should trigger it.
- Be specific enough to avoid false positives.
- Be “pushy” enough to prevent under-triggering.
- Stay concise.

Avoid descriptions like “Helps with Foo.” They do not tell the model when to load the skill.

## Writing the body

Use clear operational instructions. Prefer:

- Ordered workflows
- Decision points with defaults
- Concrete file paths and commands
- Input/output formats
- Known pitfalls and recovery steps
- Links to bundled references when needed

Avoid:

- Generic advice such as “follow best practices” without specifics
- Large copied docs in `SKILL.md`
- Over-abstracted frameworks for one-off tasks
- Instructions that contradict Pi’s available tools or user permissions
- Hidden or surprising behavior

A good skill explains enough “why” that the model can adapt, but not so much that it wastes context.

## Capturing a workflow into a skill

When the user says “turn this into a skill”, extract reusable details from the conversation before asking questions:

- Tools and commands that worked
- Sequence of steps
- Corrections from the user
- Project conventions
- Required inputs and expected outputs
- Edge cases discovered during the task
- Things that should not be repeated

Then ask the user to confirm the extracted workflow before creating the final skill if the skill will encode strong preferences or non-obvious behavior.

## Bundled resources

Use bundled resources when they make the skill smaller or more reliable:

- `scripts/` for deterministic/repetitive tasks.
- `references/` for long docs, APIs, policies, examples, or troubleshooting matrices.
- `assets/` for templates or files copied into outputs.
- `evals/` for test prompts and fixtures.

Reference bundled files with relative paths from the skill directory:

```markdown
Read [references/api.md](references/api.md) when working with the API surface.
```

If a script has dependencies, document setup and invocation. In this environment, prefer `uv`/`uvx` for Python tooling when possible.

## Evals and testing

Not every skill needs formal evals. Use evals when success is observable: file transformations, code generation, extraction, formatting, migrations, reports, and repeatable tool workflows.

Create `evals/evals.json` for objective skills:

```json
{
  "skill_name": "skill-name",
  "evals": [
    {
      "id": 1,
      "prompt": "A realistic user request goes here",
      "expected_output": "Human-readable description of success",
      "files": []
    }
  ]
}
```

Start with 2-3 realistic prompts. Include varied phrasing and at least one edge case. Add assertions only when they can be checked objectively.

For Pi, if no automated eval runner is available, do a manual comparison:

1. Run the task with the skill loaded, or invoke `/skill:<name>`.
2. Run a comparable baseline without the skill, if practical.
3. Compare final outputs and execution traces.
4. Revise `SKILL.md` based on misses, confusion, or wasted steps.

## Validation checklist

Before reporting completion, check:

- The directory name matches frontmatter `name`.
- The name follows Agent Skills naming rules.
- The description is present and under 1024 characters.
- `SKILL.md` has YAML frontmatter followed by Markdown.
- Links to bundled files exist.
- The skill does not depend on unavailable tools without saying so.
- The skill avoids malware, credential exfiltration, stealth, or surprising system changes.
- The skill is scoped tightly enough to avoid loading for unrelated tasks.
- The skill is broad enough to trigger for natural user wording.

Useful shell checks:

```bash
# Inspect created files
find ~/.pi/agent/skills/skill-name -maxdepth 3 -type f -print

# Check frontmatter quickly
python - <<'PY'
from pathlib import Path
p = Path('SKILL.md')
text = p.read_text()
assert text.startswith('---\n')
front = text.split('---', 2)[1]
print(front)
PY
```

Adjust paths for project skills.

## Improving an existing skill

When improving a skill:

1. Read the existing `SKILL.md` completely.
2. Identify the failure mode:
   - Not discovered: wrong location or missing/invalid frontmatter.
   - Not triggered: weak or too narrow description.
   - Mis-triggered: over-broad description.
   - Loaded but ineffective: body too vague, too long, contradictory, or missing concrete steps.
   - Tool failure: missing dependencies or unclear script interface.
3. Make the smallest edit that addresses the problem.
4. Re-check the validation checklist.

Do not rewrite the whole skill unless the structure itself is the problem.

## Security and licensing

- Do not create skills that facilitate credential theft, unauthorized access, stealth, persistence, or data exfiltration.
- Do not hide surprising behavior in a skill or bundled script.
- Prefer original wording when adapting public skills unless the source license clearly permits copying.
- If a source has no explicit license, use it as a design reference only and say so.

## Reporting back

After creating or editing a skill, report:

- Path created/changed
- What the skill triggers on
- Any bundled resources added
- How to use it, usually `/skill:<name>` or natural language
- Any limitations or follow-up testing needed
