# Vite React Playbook

Read this file on demand. It provides concrete patterns for Vite + React + TypeScript projects so the agent does not need to make the same decisions from scratch every time.

---

## 1. Package Manager Selection

Check the lockfile first and stay consistent:

```text
pnpm-lock.yaml      -> pnpm
package-lock.json   -> npm
yarn.lock           -> yarn
bun.lock/bun.lockb  -> bun
```

Common command placeholders:

```bash
<pm> install
<pm> run dev
<pm> run build
<pm> run test
<pm> run lint
<pm> run typecheck
```

Do not mix package managers in an existing project, and avoid generating a new lockfile for a different manager.

---

## 2. Minimal Project Structure

Create only the directories required by the current task.

```text
src/
  main.tsx             # React mount point
  App.tsx              # Root component
  styles/
    tokens.css         # Design tokens
    global.css         # Reset / global typography
  components/          # Reusable components
  pages/               # Route-level pages
  hooks/               # Reusable hooks
  lib/                 # API, utilities, formatting functions
  assets/              # Assets processed by the bundler
```

Recommended entry point:

```tsx
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './styles/tokens.css';
import './styles/global.css';
import App from './App';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
);
```

---

## 3. CSS Token Template

```css
:root {
  color-scheme: light;

  --color-bg: oklch(98% 0.01 95);
  --color-surface: oklch(100% 0 0);
  --color-text: oklch(20% 0.02 260);
  --color-muted: oklch(48% 0.03 260);
  --color-border: oklch(88% 0.02 260);
  --color-primary: oklch(58% 0.16 250);
  --color-primary-contrast: oklch(99% 0 0);

  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-6: 1.5rem;
  --space-8: 2rem;
  --space-12: 3rem;
  --space-16: 4rem;

  --radius-sm: 0.5rem;
  --radius-md: 0.875rem;
  --radius-lg: 1.25rem;
  --radius-xl: 2rem;

  --shadow-1: 0 1px 2px oklch(20% 0.02 260 / 8%);
  --shadow-2: 0 18px 60px oklch(20% 0.02 260 / 14%);

  --font-display: 'Sora', 'Avenir Next', ui-sans-serif, system-ui, sans-serif;
  --font-body: 'Source Sans 3', 'Aptos', ui-sans-serif, system-ui, sans-serif;

  --ease-out: cubic-bezier(0.16, 1, 0.3, 1);
  --duration-fast: 160ms;
  --duration-normal: 260ms;
}

@media (prefers-color-scheme: dark) {
  :root {
    color-scheme: dark;
    --color-bg: oklch(16% 0.02 260);
    --color-surface: oklch(22% 0.025 260);
    --color-text: oklch(94% 0.01 260);
    --color-muted: oklch(72% 0.025 260);
    --color-border: oklch(34% 0.025 260);
  }
}
```

Note: these fonts are only template defaults. For real work, prefer the project's existing fonts or the brand fonts. Do not treat template fonts as a design decision.

---

## 4. Global CSS Template

```css
* {
  box-sizing: border-box;
}

html {
  min-width: 320px;
  background: var(--color-bg);
  color: var(--color-text);
  font-family: var(--font-body);
  line-height: 1.5;
  text-rendering: optimizeLegibility;
}

body {
  margin: 0;
  min-height: 100vh;
}

button,
input,
textarea,
select {
  font: inherit;
}

button {
  cursor: pointer;
}

button:disabled {
  cursor: not-allowed;
}

img,
svg,
video,
canvas {
  display: block;
  max-width: 100%;
}

:focus-visible {
  outline: 3px solid color-mix(in oklch, var(--color-primary), white 20%);
  outline-offset: 3px;
}

@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    scroll-behavior: auto !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## 5. Component Template

```tsx
type StatCardProps = {
  label: string;
  value: string;
  trend?: 'up' | 'down' | 'flat';
};

export function StatCard({ label, value, trend = 'flat' }: StatCardProps) {
  return (
    <article className="stat-card" data-trend={trend}>
      <p className="stat-card__label">{label}</p>
      <strong className="stat-card__value">{value}</strong>
    </article>
  );
}
```

Companion CSS:

```css
.stat-card {
  display: grid;
  gap: var(--space-3);
  padding: var(--space-6);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  background: var(--color-surface);
  box-shadow: var(--shadow-1);
  transition:
    transform var(--duration-normal) var(--ease-out),
    box-shadow var(--duration-normal) var(--ease-out);
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-2);
}

.stat-card__label {
  margin: 0;
  color: var(--color-muted);
  font-size: 0.875rem;
}

.stat-card__value {
  font-family: var(--font-display);
  font-size: clamp(2rem, 5vw, 4.5rem);
  line-height: 0.95;
  letter-spacing: -0.05em;
  text-wrap: pretty;
}
```

---

## 6. Data Request Pattern

For simple pages, prefer a small wrapper:

```ts
export async function requestJson<T>(url: string, init?: RequestInit): Promise<T> {
  const response = await fetch(url, init);

  if (!response.ok) {
    throw new Error(`Request failed: ${response.status}`);
  }

  return response.json() as Promise<T>;
}
```

Components must cover loading/error/empty states:

```tsx
if (status === 'loading') return <LoadingState />;
if (status === 'error') return <ErrorState onRetry={retry} />;
if (items.length === 0) return <EmptyState />;
```

Only introduce TanStack Query when there is a real need for caching, pagination, background refresh, deduplication, retry behavior, or similar concerns.

---

## 7. Form Pattern

- Every input needs a visible label, or an equivalent `aria-label`.
- Associate error text with inputs via `aria-describedby`.
- Submit buttons must cover loading/disabled states.

```tsx
<label className="field">
  <span>Email</span>
  <input
    type="email"
    name="email"
    autoComplete="email"
    aria-describedby={error ? 'email-error' : undefined}
    aria-invalid={Boolean(error)}
  />
</label>
{error ? <p id="email-error" role="alert">{error}</p> : null}
```

---

## 8. Routing Criteria

Do not introduce routing when multiple views are not needed.

When routing is needed, keep it simple:

```tsx
import { createBrowserRouter, RouterProvider } from 'react-router-dom';

const router = createBrowserRouter([
  { path: '/', element: <HomePage /> },
  { path: '/settings', element: <SettingsPage /> },
]);

export function AppRouter() {
  return <RouterProvider router={router} />;
}
```

When deploying under a subpath, synchronize Vite `base` with the router basename.

---

## 9. Test Priorities

Prioritize logic that has business branches or is likely to regress:

- Pure functions: formatting, filtering, permission decisions
- Components: key text, button states, form errors, empty states
- Do not test implementation details: class names, internal state names, animation internals

Example:

```tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';

it('calls onSubmit on submit', async () => {
  const onSubmit = vi.fn();
  render(<SignupForm onSubmit={onSubmit} />);

  await userEvent.type(screen.getByLabelText(/email/i), 'me@example.com');
  await userEvent.click(screen.getByRole('button', { name: /submit/i }));

  expect(onSubmit).toHaveBeenCalledWith({ email: 'me@example.com' });
});
```

---

## 10. Common Anti-Patterns

- Building a large component library for a single page upfront.
- Extracting every `div` into a component.
- Using random mock numbers as if they were real business results.
- Copying competitor logos or user avatars without a source.
- Introducing a UI framework because CSS is inconvenient.
- Manipulating the DOM directly in React to avoid proper state design.
- Using `any` to silence type errors without explaining why.
- Changing build configuration to solve a component bug.
- Mixing npm/pnpm/yarn/bun.
- Editing unrelated files just to “clean things up”.
