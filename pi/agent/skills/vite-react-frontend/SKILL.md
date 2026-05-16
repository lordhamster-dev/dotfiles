---
name: vite-react-frontend
description: Build, modify, debug, and deliver modern frontend applications with Vite + React + TypeScript. Use for creating React single-page apps, landing pages, dashboards, interactive prototypes, component development, styling and responsive implementation, frontend state management, API integration, accessibility and performance improvements, Vite build configuration, tests, and quality checks. Defaults to Vite + React + TypeScript + CSS variables/modular CSS; reuse existing project conventions first and avoid unrelated refactors. Not applicable to pure backend work, CLI tools, data-processing scripts, or tasks unrelated to browser UI.
---

# Vite React Frontend

This skill positions the agent as a product-focused frontend engineer: build maintainable, verifiable, high-quality browser applications with **Vite + React + TypeScript**.

It borrows the core workflow from `web-design-engineer`, but the output is not a single-file CDN prototype. The target is an engineered Vite/React project or a focused change inside an existing Vite/React codebase.

Core principle: **clarify product and visual direction first, then write maintainable components; ship a runnable v0 early, then complete states, interactions, responsiveness, and quality checks.**

---

## Scope

✅ Use this skill for:
- Creating Vite + React apps, pages, components, and interactive prototypes
- Turning designs, screenshots, or PRDs into React components and pages
- Building landing pages, dashboards, admin UIs, showcase pages, form flows, and data visualization pages
- Adjusting CSS, responsiveness, animation, layout, themes, and dark mode
- Frontend state management, API integration, routing, form validation, and client-side error handling
- Vite configuration, build issues, TypeScript, ESLint, Vitest, and Playwright-related frontend problems
- Improving usability, accessibility, visual quality, and code quality in an existing React UI

❌ Do not use this skill for:
- Pure backend APIs, databases, CLI tools, or offline data-processing scripts
- Algorithm/system tasks unrelated to browser UI
- Native mobile, desktop, or non-React stacks, unless the task is specifically to migrate to Vite + React

---

## Default Stack

- Build tool: Vite
- Framework: React + TypeScript
- Components: function components + Hooks
- Styling: CSS variables + plain CSS / CSS Modules; use Tailwind, Sass, or UI frameworks only when the project already uses them or the user explicitly asks
- Routing: add React Router only when multiple pages/views are required; do not add it for a single page
- State: prefer local state / Context; consider Zustand/Jotai/Redux only for genuinely complex cross-page state, and prefer existing dependencies
- Data fetching: prefer existing project wrappers; consider TanStack Query only when caching, retry, deduplication, or background refresh is needed
- Tests: Vitest + React Testing Library, unless the project already has a test system
- End-to-end tests: Playwright only when requested or already present

**Do not add dependencies just to make the project look professional.** If a capability is used once, implement it simply. Dependencies must solve a real problem.

---

## Workflow

### Step 0: Read Project Context

Before coding, identify the task type:

1. **Existing project**: read `package.json`, Vite config, entry files, routing, style entry points, relevant components, and project conventions.
2. **New project**: confirm app name, target page/functionality, whether routing is needed, whether tests are needed, and target browsers/devices.
3. **Brand/product tasks**: if the task involves a real company, product, SDK, version, event, or other factual claim, verify from available sources first. If there is no web access or reliable source, ask the user instead of inventing facts.
4. **Visual tasks**: collect screenshots, Figma, brand assets, existing UI, or competitor references first. If no reference exists, explain the quality impact and propose 2–3 possible visual directions.

### Step 1: Clarify Requirements Without Over-Questioning

If the provided information is enough, implement directly. If not, ask only the questions that block implementation.

Prioritize clarifying:
- Deliverable: new app, single page, component, bug fix, refactor, or config fix?
- Scope: which pages, states, and devices must be covered?
- Visual direction: follow an existing design system, or create one from scratch?
- Data: real API, mock data, or static placeholder? Do not fabricate real business data.
- Verification: which commands should prove the work is complete?

### Step 2: Plan Verifiable Goals

Convert the request into verifiable goals, for example:

```markdown
1. Map the existing Vite/React entry points and styling system → Verification: explain the intended change points
2. Implement the page skeleton and core components → Verification: local build passes
3. Complete interactions, state handling, and responsiveness → Verification: key path is clickable and mobile/desktop layouts work
4. Run quality checks → Verification: typecheck/test/build pass
```

For complex tasks (multiple pages, architectural changes, or expected >5 tool calls), create a plan first and align with the user.

### Step 3: Design System First for Visual Work

Before writing UI, provide concise design decisions. For small fixes, compress this to 2–3 sentences.

```markdown
Design Decisions:
- Color: primary / neutral / semantic colors and their source
- Typography: existing project font or specified font; avoid template-like display choices by default
- Spacing: base unit and density
- Radius/shadow: hierarchy and usage boundaries
- Motion: duration, easing, and triggers
- Responsiveness: key breakpoints and layout changes
```

If the direction is uncertain, pause for confirmation. If the user already provided a clear PRD/design, proceed.

### Step 4: Build a Runnable v0 First

Prioritize a v0 that runs and shows the main structure:

- Page structure, core layout, base tokens, and primary interaction entry points
- Honest placeholders: `[image]`, `[icon]`, `[real data needed]`
- Not every state needs to be complete yet, but the code must not break the app

The value of v0 is early course correction. Do not build a full component library before showing the direction.

### Step 5: Complete the Implementation

After the v0 direction is confirmed, complete:

- Component decomposition: split only when reuse or complexity justifies it; avoid over-abstraction
- State coverage: default, hover, focus, active, disabled, loading, empty, error
- Responsiveness: check at least mobile, tablet, and desktop; avoid text overflow
- Accessibility: semantic tags, labels, keyboard focus; use ARIA only when semantics cannot express the behavior
- Error handling: failed request, empty data, and loading states must be visible
- Performance: avoid unnecessary heavy dependencies and repeated renders; use reasonable image sizes and lazy loading where appropriate

### Step 6: Verify and Deliver

Before delivery, run the available project commands. Preferred order:

1. `npm/pnpm/yarn/bun run typecheck` if present
2. `npm/pnpm/yarn/bun test` if present and not long-running/interactive
3. `npm/pnpm/yarn/bun run build`
4. `npm/pnpm/yarn/bun run lint` if present

If scripts are missing, do not introduce a full tooling setup just for verification; explain what was not run and why. If build/tests fail, fix one error at a time and verify again.

---

## New Vite + React Project Rules

Prefer the directory specified by the user. If no directory is specified, ask for the project directory name first to avoid generating many files in the wrong location.

Default scaffold (`dev` is long-running; ask the user to run it manually in their terminal):

```bash
npm create vite@latest <app-name> -- --template react-ts
cd <app-name>
npm install
# User runs manually: npm run dev
```

If the user's environment or repository already has a package manager lockfile, follow it:

| File | Package manager |
|---|---|
| `pnpm-lock.yaml` | pnpm |
| `yarn.lock` | yarn |
| `bun.lock` / `bun.lockb` | bun |
| `package-lock.json` | npm |

Suggested structure after initialization. Create only what is needed:

```text
src/
  main.tsx
  App.tsx
  styles/
    tokens.css
    global.css
  components/
  pages/
  hooks/
  lib/
  assets/
```

---

## React Coding Rules

- Use PascalCase for components; use `useXxx` for Hooks.
- Define explicit TypeScript prop types; do not force `React.FC` for simple components.
- Use local variables or `useMemo` for derived data; do not overuse `useMemo`.
- Put side effects in `useEffect` and handle cleanup functions.
- Form controls must have labels; clickable elements should be real `button`/`a` elements when appropriate.
- Use stable business IDs for list keys; avoid index keys for data that can be added, removed, or reordered.
- Do not put large objects/functions into Context without a reason.
- Do not perform requests or side effects during render.
- Do not use `dangerouslySetInnerHTML` unless the content is trusted and there is a clear reason.

---

## CSS and Visual Rules

- Manage design tokens with CSS custom properties: colors, spacing, radius, shadows, fonts, and motion.
- Prefer Grid/Flex; do not rely on magic numbers to force layout.
- Use `clamp()` for fluid type and `text-wrap: pretty` for better line breaks.
- Use `@container` for component-level responsiveness when helpful; use media queries for page-level responsiveness.
- Respect `prefers-reduced-motion`; motion must not block usability.
- Colors must come from the design system. When extending colors, derive them from the primary/brand color rather than adding random new hues.
- Do not default to purple-pink-blue gradients, emoji icons, colored-left-border cards, fake logo walls, or fabricated testimonials/data.
- When assets are missing, use honest placeholders instead of cheap fake illustrations. Brand tasks must use real logos/product imagery/screenshots or clearly mark them as pending.

---

## Vite Rules

- Modify `vite.config.ts` only when necessary.
- Client-exposed environment variables must use the `VITE_` prefix; never put secrets in frontend environment variables.
- If path aliases are needed, keep them simple, for example `@ -> src`, and sync `tsconfig`.
- Static assets: put component-owned assets in `src/assets`; put assets that should be copied as-is in `public`.
- When deploying under a subpath, configure `base` correctly and avoid hard-coded absolute paths.
- Do not import Node-only APIs into browser code.

---

## Pre-Delivery Checklist

- [ ] Requested scope is covered; no large unrequested modules were added
- [ ] `package.json` scripts and package manager usage are correct
- [ ] TypeScript has no obvious type errors
- [ ] Build passes, or the failure reason and next step are clearly explained
- [ ] Target viewports have no horizontal overflow, text truncation, or collapsed layout
- [ ] Interactive elements include necessary hover/focus/disabled states
- [ ] Loading/empty/error states are covered where relevant
- [ ] Forms are accessible, keyboard-operable, and have visible focus states
- [ ] No fabricated data, fake brand assets, or unsupported factual claims
- [ ] No unused imports, orphan components, or debug logs
- [ ] Changes are focused; no unrelated refactors

---

## Reference Routing

For more detailed implementation templates, read: `references/vite-react-playbook.md`.
