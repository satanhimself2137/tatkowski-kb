# ROADMAP — ds-application

**Status:** IN PROGRESS — Phase 0 (foundation prep)
**Owner:** Maciej
**Last update:** 12/06/26 by Code

---

## Scope

Apply the Round 3 DS direction (`specs/Hero-DottedPattern-Fix.html` + `Glass-Elevation-System.html`) across all 6 templates × 4 markets + SalesManager. Pattern foundation + E1/E2/E3 surfaces + content bugs (info@ → contact@, #010 refund, blue CTA band) + #039 flag-pl fix. Definition-of-done checklist per template gates the QA pass. Programmatic SEO scale-out is gated on this workstream closing.

**In:**
- Pattern foundation (Hero-DottedPattern-Fix) applied across 6 templates
- E1/E2/E3 glass-elevation surfaces (Glass-Elevation-System) applied across 6 templates
- Content fixes: info@ → contact@ sweep; #010 refund clause alignment with locked T&Cs; blue CTA band copy
- #039 flag-pl rendering fix
- Rollout across IE/UK/ES/PT + SalesManager
- Per-template definition-of-done checklist as QA gate

**Out:**
- Programmatic SEO scale-out (gated on this closing)
- T&Cs wording changes (desktop territory)
- Marketing copy drafting (desktop territory)
- Recruitment pages (standing exclusion)

---

## Decisions

- **12/06/26 — Canonical DS folder is `packages/ui/src/Tatkowski Design System/`** — matches the Claude Design export name so re-export is a drop-in replace. Old hyphenated `design-system/` deleted. Decided by Maciej.
- **12/06/26 — `themes/` lives outside the DS tree at `packages/ui/src/styles/themes/`** — keeps app-owned theme overrides from being clobbered by DS re-exports. Decided by Maciej (option 1 of the migration push-back).

---

## Open questions

- [ ] **Application order across 6 templates** — Pattern-foundation-first across all templates, then E1/E2/E3 pass? Or full template-by-template (pattern + glass + content) before moving on? Latter ships visible pages faster; former gives cleaner diffs.
- [ ] **SalesManager scope** — Same DS pass as public market sites, or trimmed (no hero pattern, glass only on cards)?

---

## Build log

### 12/06/26 20:24 — Code — Round 3 §1.1: pattern.css foundation + no-pattern-opacity rule

Laid down the Brand Pattern token file per spec §7 + direction §3. New `packages/ui/src/styles/tokens/pattern.css` carries 8 zone tokens (hero / body / cta / divider / footer / guide / admin / print), is theme-aware via `--bg`, owns the wrapper opacity rule (the only file allowed to), and defines the hero reading scrim as `[data-pattern-zone="hero"]::before` (radial `--bg` feather, replaces the rejected `1a6e104` opacity hack). Print `@media` switches the live canvas for the seeded PNG bake (asset ships with the baking-studio workstream). Imported in `global.css` after `tokens.css` so the app's tokens still win on any shared variable.

`_adherence.oxlintrc.json` gains a `no-pattern-opacity` selector — any string-literal CSS rule outside `tokens/pattern.css` that targets `.dotted-pattern-wrapper` or `#particleField` with an `opacity` declaration warns. The reverted `1a6e104` patch would now fail this rule.

No observable behaviour change yet. Zone attributes aren't attached to template sections until §1.2, and the IntersectionObserver that mirrors the viewport-center zone's `--pattern-alpha` / `--pattern-pull` onto `:root` (required because the live `DottedPattern` wrapper is fixed-global and won't inherit from a section sibling) also ships in §1.2. All 4 markets build clean: IE 52 · UK 47 · ES 45 · PT 38.

**Files touched:**
- packages/ui/src/styles/tokens/pattern.css (new, 87 lines)
- packages/ui/src/styles/global.css (+2 lines, @import)
- packages/ui/src/Tatkowski Design System/_adherence.oxlintrc.json (+4 lines, no-pattern-opacity selector)

**Commits:**
- a2821f7 — feat(ds): add tokens/pattern.css with 8 zone tokens (Round 3 §1.1)

---

### 12/06/26 19:46 — Code — Phase 0: DS path canonicalisation

Renamed the canonical DS folder to `packages/ui/src/Tatkowski Design System/` (matches the Claude Design export name so future re-exports are a drop-in replace) and deleted the stale hyphenated `packages/ui/src/design-system/`. Moved `themes/ireland-green.css` to `packages/ui/src/styles/themes/ireland-green.css` so app-owned theme overrides don't get blown away on DS re-export (IE irish-translation landing still opts in via `themeAccent: "ireland-green"` — visual identity preserved). Updated the two live import sites (`BaseLayout.astro`, `global.css`), the sweep-accent skip-dir, the `landing.ts` doc comment, and CLAUDE.md path references. Historical phase docs left immutable. All 4 markets build clean: IE 52 · UK 47 · ES 45 · PT 38.

**Files touched:**
- packages/ui/src/layouts/BaseLayout.astro (import path)
- packages/ui/src/styles/global.css (@import path)
- packages/ui/src/styles/themes/ireland-green.css (moved here from design-system/themes/)
- packages/ui/src/data/types/landing.ts (comment)
- tools/sweep-accent.ps1 (skip-dir)
- CLAUDE.md (3 path references)
- packages/ui/src/design-system/** (deleted entirely)

**Commits:**
- 4bc2fa8 — chore(ds): canonicalise DS path to 'Tatkowski Design System/', remove stale design-system/

---

## Done criteria

- [x] Canonical DS folder at `packages/ui/src/Tatkowski Design System/`, stale `design-system/` removed
- [ ] Pattern foundation (Hero-DottedPattern-Fix) applied across all 6 templates
- [ ] E1/E2/E3 glass-elevation surfaces applied across all 6 templates
- [ ] info@ → contact@ sweep complete across IE/UK/ES/PT
- [ ] #010 refund clause aligned with locked T&Cs across IE/UK/ES/PT
- [ ] Blue CTA band copy applied across IE/UK/ES/PT
- [ ] #039 flag-pl fix shipped
- [ ] SalesManager DS pass complete (scope per open question)
- [ ] Per-template definition-of-done checklist green for all 6 templates × 4 markets
- [ ] All 4 markets build clean (IE 52 · UK 47 · ES 45 · PT 38) after final pass

---

## Post-ship summary

[Filled in after Status = SHIPPED.]
