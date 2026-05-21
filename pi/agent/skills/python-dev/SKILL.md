---
name: python-dev
description: Guide Python development using the user's preferred stack and conventions. Use this skill whenever writing, reviewing, refactoring, testing, or designing Python code, especially when choosing libraries for logging, terminal output, environment config, notifications, dates/times, HTTP clients, dataframes, CLIs, validation, or tests.
---

# Python Development Guidelines

Use this skill when helping with Python code. It captures the user's preferred package choices and practical conventions. Apply it as guidance, not as a reason to add dependencies unnecessarily.

## Default assumptions

- Prefer simple, explicit Python over over-engineered abstractions.
- Preserve the project's existing style when it conflicts with these preferences.
- Use type hints for public functions, data models, CLI entrypoints, and non-trivial logic.
- Prefer `uv` for dependency management and Python tooling when the environment allows it.
- Do not introduce a preferred package if the task can be solved cleanly with existing project dependencies.

## Preferred package choices

### Logging: `loguru`

Use `loguru` for application logging when the project does not already standardize on `logging`.

Guidelines:

- Import with `from loguru import logger`.
- Use structured, contextual messages rather than `print()`.
- Prefer exception-aware logging:
  ```python
  try:
      ...
  except Exception:
      logger.exception("Failed to process item")
      raise
  ```
- For libraries, avoid surprising global logger configuration unless the project already does it.

### Terminal output: `rich`

Prefer `rich` for human-friendly terminal output, tables, progress bars, tracebacks, panels, and colored CLI messages.

Guidelines:

- Use `rich.print`, `Console`, `Table`, `Progress`, or `Panel` when output readability matters.
- Keep `loguru` for logs and `rich` for user-facing terminal presentation.
- Avoid excessive colors or decorative output in scripts that are likely to be piped or parsed.
- For Typer apps, use Rich for formatted output when it improves clarity.

### Configuration and environment variables: `pydantic-settings`

Prefer `pydantic-settings` for structured application configuration: reading environment variables, loading local `.env` files, parsing types, applying defaults, and validating required settings.

Use `python-dotenv` only for lightweight scripts or projects that simply need to load local `.env` values into `os.environ` without a structured settings model.

Guidelines:

- Import with `from pydantic_settings import BaseSettings, SettingsConfigDict` for Pydantic v2 projects.
- Define a dedicated `Settings` model near application startup or configuration boundaries, not deep inside business logic.
- Use `SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")` when local `.env` loading is desired.
- Read, validate, and document configuration explicitly; do not rely on scattered `os.getenv()` calls for application settings.
- Do not commit real `.env` files or secrets.
- Provide `.env.example` when adding new required environment variables.
- Keep `python-dotenv` as the lighter fallback for small scripts, test setup, or projects that do not otherwise use Pydantic.

### Notifications: `notifiers`

Use `notifiers` for explicit user-facing notifications such as completion alerts, failure alerts, or operational signals.

Guidelines:

- Keep notification configuration outside source code when it contains credentials or endpoints.
- Do not hardcode tokens, webhook URLs, or secrets.
- Treat notification failures as non-critical unless the task is specifically about alerting reliability.

### Dates and times: `arrow`

Prefer `arrow` for user-facing datetime parsing, formatting, timezone handling, and relative date logic.

Guidelines:

- Be explicit about timezone assumptions.
- Avoid naive datetimes for data interchange or persisted records.
- For financial or China-local workflows, prefer `Asia/Shanghai` when the project context indicates it.
- Convert to standard `datetime` only when required by APIs, databases, or libraries.

### HTTP: `httpx`

Prefer `httpx` for HTTP clients.

Guidelines:

- Use `httpx.Client` or `httpx.AsyncClient` for repeated requests.
- Set timeouts explicitly.
- Use `response.raise_for_status()` unless handling status codes intentionally.
- Keep retry/backoff logic explicit or use the project's existing retry helper.
- Do not disable TLS verification except for a clearly documented local/dev-only reason.

Example:

```python
import httpx

with httpx.Client(timeout=10.0) as client:
    response = client.get(url)
    response.raise_for_status()
    data = response.json()
```

### Dataframes / tabular data: `polars`

Prefer `polars` for dataframe-style transformations, CSV/Parquet IO, and larger tabular workloads.

Guidelines:

- Use lazy execution (`scan_*`, `.lazy()`) for large datasets or pipelines.
- Use eager dataframes for small, simple transformations.
- Prefer expression APIs over Python loops.
- Be explicit about schemas and null handling when data quality matters.
- Avoid converting to pandas unless an external API requires it.

### CLI apps: `typer`

Prefer `typer` for command-line interfaces.

Guidelines:

- Use typed function parameters as the CLI contract.
- Keep command functions thin; delegate business logic to testable functions.
- Use `typer.Option` and `typer.Argument` for clarity when defaults or help text matter.
- Return clear exit behavior; raise `typer.Exit(code=...)` for intentional non-zero exits.

### Validation and models: `pydantic`

Prefer `pydantic` for structured inputs, configuration, API payloads, parsed records, and validation boundaries.

Guidelines:

- Use models at system boundaries: config, API input/output, scraped records, messages, and persisted data.
- Keep internal transformations simple; not every dict needs a model.
- Prefer field validators for normalization and validation that belongs to the model.
- Avoid swallowing validation errors; report them with enough context.
- Follow the project's installed Pydantic major version conventions (`BaseModel`, `field_validator` for v2; `validator` for v1 if required by the project).

### Testing: `pytest`

Prefer `pytest` for tests.

Guidelines:

- Add or update tests when fixing bugs or changing behavior.
- Use small, focused tests with clear arrange/act/assert structure.
- Use fixtures for reusable setup, not for hidden control flow.
- Use `pytest.mark.parametrize` for input/output matrices.
- Mock network, filesystem, time, and external services unless the test is explicitly an integration test.
- Test CLI behavior with the project's existing runner style; for Typer projects, use `typer.testing.CliRunner` when appropriate.

## Implementation workflow

1. Inspect project conventions first: dependencies, `pyproject.toml`, existing imports, test layout, and style.
2. Prefer the project's existing toolchain over adding new dependencies.
3. If a preferred package is absent but clearly useful, mention the dependency addition before using it.
4. Make surgical changes and preserve surrounding style.
5. Verify with targeted tests or type/lint commands where practical.

## Dependency management

When adding packages in a `uv` project, prefer telling the user or using the project-approved command, typically:

```bash
uv add package-name
```

For dev-only tools:

```bash
uv add --dev package-name
```

Do not manually edit lockfiles unless that is already the project convention.

## Review checklist

Before finishing Python work, check:

- No `print()` left in application code unless intentionally part of CLI output.
- HTTP calls have explicit timeouts.
- Secrets are not hardcoded in code, tests, or examples.
- Configuration uses `pydantic-settings` when structured validation is useful; lightweight `.env` loading remains local/dev-oriented and documented.
- Terminal output uses `rich` only where it helps human readability.
- Datetime timezone behavior is explicit where relevant.
- Pydantic models match the installed version style.
- Tests cover changed behavior or the absence of tests is explained.
- New dependencies are justified and documented.
