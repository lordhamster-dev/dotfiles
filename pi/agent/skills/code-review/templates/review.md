---
date: {iso_datetime}
repository: {repository}
branch: {branch}
commit: {commit}
scope: "{scope}"
status: {approved | needs_changes | requesting_changes}
severity:
  critical: {critical_count}
  important: {important_count}
  suggestion: {suggestion_count}
verification:
  verified: {verified_count}
  demoted: {demoted_count}
  dropped: {dropped_count}
tags: [code-review]
---

# Code Review — {scope}

**Status:** `{status}`  
**Reviewed:** {files_count} files  
**Findings:** {critical_count} 🔴 · {important_count} 🟡 · {suggestion_count} 🔵 · {discussion_count} 💭

## Summary

{short_summary}

## 🔴 Critical

### {ID} — {headline}

**Evidence:** `{file:line}` — `{verbatim_line}`

**Why:** {mechanism_and_impact}

**Fix:** {specific_fix}

---

## 🟡 Important

### {ID} — {headline}

**Evidence:** `{file:line}` — `{verbatim_line}`

**Why:** {mechanism_and_impact}

**Fix:** {specific_fix}

---

## 🔵 Suggestions

### {ID} — {headline}

**Evidence:** `{file:line}` — `{verbatim_line}`

**Why:** {mechanism_and_impact}

**Fix:** {specific_fix}

---

## 💭 Discussion

### {ID} — {question_or_tradeoff}

**Evidence:** `{file:line}` — `{verbatim_line}`

**Context:** {what_needs_author_intent}

---

## Checks Performed

- Scope resolved as: `{scope_resolution}`
- Diff/context reviewed: {diff_context}
- Tests reviewed: {tests_reviewed}
- Dependencies reviewed: {dependencies_reviewed}
- Security-sensitive sinks checked: {security_checked}
- Verification pass: {verification_summary}

## Files Reviewed

{file_list}

## Notes

{notes}
