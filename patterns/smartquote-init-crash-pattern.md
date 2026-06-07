---
name: smartquote-init-crash-pattern
description: SmartQuoteForm _sqfInitAll forEach callback crashes silently before attaching event handlers when a variable is referenced without being declared
metadata:
  type: reference
---

# Pattern: SmartQuoteForm init-time ReferenceError silently kills all event handlers

## What happens

`SmartQuoteForm.astro` has a single `<script>` tag (no `is:inline`) processed by Vite as an ES module. ES modules run in strict mode. `_sqfInitAll` iterates over all `[data-sqf-instance]` roots with `.forEach(function(root) { ... })`.

If any code in that callback accesses an **undeclared** variable at init time (i.e. outside a function body), strict-mode ESM throws `ReferenceError`. The `forEach` callback terminates immediately for that iteration. **All event handlers defined after the crash point are never attached.** This includes the dropzone click handler, drag handlers, file-input change handler, etc.

The symptom: upload flow is completely dead (browse button does nothing, drag-and-drop does nothing) with no visible error to the user. Console shows the ReferenceError only if devtools are open.

## Why it's hard to spot

- The crash kills the CURRENT iteration of `forEach` but later iterations may succeed (though in practice all three instances share the same code path, so all crash).
- `_startAiIdleCycle()` is called EARLY in the callback, so the AI status cycling animation runs even when the rest of init failed — giving false confidence.
- Step dot `cursor:pointer` is also set BEFORE the crash point, for the same reason.
- Vite HMR updates the module in place but doesn't re-fire `astro:page-load`, so after a fix the old (broken) listener is still registered alongside the new one. Only a full page reload clears it.

## Trigger condition

Removing a variable from the DOM-ref declarations block (lines ~2015–2086 in SmartQuoteForm.astro) while leaving its name in any init-time expression.

**Init-time = any code executed synchronously during the `forEach` callback, outside a function definition.**

Function bodies (`function foo() { ... }`) are fine — accessing an undeclared var inside a function body only throws when the function is called, not at init time.

## How to detect before committing

```bash
# grep for bare variable names that are NOT declared in the const block
grep -n "reviewContinueBtn\|panelReview\|panel3\|confirmRecapEl" packages/ui/src/components/SmartQuoteForm.astro
```

Cross-reference against declared `const` refs at lines 2015–2086. If a name appears in code OUTSIDE a `function` body and is NOT declared in the const block, it will crash.

## Fix applied (commit a8e7003, 07/06/26)

Removed three crash sites left behind by e76ae80:
1. `if (reviewContinueBtn) { reviewContinueBtn.addEventListener(...) }` — init-time block
2. `if (panelReview) panelReview.hidden = true;` in `resetToStep1()` call at init
3. `if (confirmRecapEl) confirmRecapEl.textContent = ...` in `proceedManualBtn` handler setup

Remaining refs to those vars inside `showReviewPanel()` and `goToStep3()` bodies are acceptable — those functions are currently dead (never called) and the refs are guarded by `if (var)` anyway.

## Pre-commit checklist addition

Before any commit touching the `const` declarations block (lines 2015–2086) of SmartQuoteForm.astro:
1. Run the grep above
2. For each hit: confirm it's inside a `function` body OR the name IS declared
3. Build the market and confirm the dev server browse button opens the file picker
