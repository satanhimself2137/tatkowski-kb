# Hero split layout — site-vs-DS divergence

The IE homepage (and by inheritance UK/ES/PT) uses a two-card split
hero: left = value-prop card, right = SmartQuote upload panel.

The DS spec does NOT bless this pattern. The canonical DS website kit
at `packages/ui/src/tatkowski-design-system/ui_kits/website/site.css`
defines a single-column centred hero (max-width 860px, text-align
centre) with SmartQuote as a modal overlay launched from a CTA button.

The split is a site-specific divergence introduced before the DS was
formalised. It is functional and now equal-height-polished (commit
92cd7ec — fix(hero): IE certified-translation split-card equal-height
polish) but should be revisited:

- Option A: canonise the split in a future DS round — author it as a
  formal `hero-split` pattern in `ui_kits/website/` with token-driven
  spacing, equal-height baked in, and responsive stack rules.
- Option B: migrate the site to the DS canonical (single-column hero
  + modal SmartQuote) — bigger change, would unify the layout language
  across all marketing surfaces.

No decision needed now. This file exists so the next DS round picks it
up rather than rediscovering the divergence.

## Implementation note

The split lives in `apps/ie/src/pages/certified-translation.astro`
(not `index.astro` — the homepage is a landing-overlay/mode-selector,
no split hero there). Classes: `.sqf-hero-ctx-wrap` (parent flex
container), `.sqf-ctx-panel` (left value-prop), `.sqf-hero-form-col`
(right SmartQuote). Equal-height achieved via `align-items: stretch`
on the parent inside `@media (min-width: 860px)`.
