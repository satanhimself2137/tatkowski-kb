# Roadmap Index

At-a-glance view of every workstream. Each entry links to its roadmap file. Maintained manually — update when status changes.

**Read order for any session:** scan this first. If a workstream looks active or relevant, read its roadmap file in full before acting.

---

## Active

| Workstream | Status | Owner | Last update | File |
|---|---|---|---|---|
| Payments & customer journey | IN PROGRESS — Phase 0 (Claude Design pass) | Maciej | 07/06/26 | [workstream-1-payments-and-journey.md](workstream-1-payments-and-journey.md) |
| Portugal market research | In progress | David (via Claude) | 06/06/26 | [portugal-market-research.md](portugal-market-research.md) |

## Queued (next up)

| Workstream | Notes |
|---|---|
| ES + PT localisation pass | NEW — gating prerequisite for ES/PT programmatic SEO scale-out. Surfaced by ds-application Round 3 close: ES service-detail data files + several pages/*.astro on .es/.pt domains still in English, with Ireland-rooted authority terminology (SNIG/Garda/QQI/areaServed Ireland). See ds-application sign-off §6 for full surface list. Roadmap not yet created. |
| Interpreting intake widget | Scope locked 06/06/26. SmartQuote equivalent for lead product. Public form on 4 sites + internal B2B log form. Manual quoting (per-job cost variance). [interpreting-intake.md](interpreting-intake.md) |
| Chatwoot on Hetzner | Scope locked 06/06/26. Self-hosted, EUR 4.51/mo, gating prerequisite for WA AI. Queued behind interpreting intake (revenue first). [chatwoot.md](chatwoot.md) |
| WhatsApp AI intake (tatkowski.ai) | Depends on Chatwoot + Meta permanent token + UK/ES WABA numbers. Roadmap not yet created. |
| B2B invoicing mode (SalesManager / Drawer v2) | DEFERRED — only 1 B2B client. Revisit when client #5 or Fyffes hits monthly invoicing. Roadmap not yet created. |
| D1 migration | Architecture move, lands alongside Pro layers. Roadmap not yet created. |
| 90-day R2 auto-purge worker | Cron Trigger over `orders/` prefix. Small build. Roadmap not yet created. |

## Done / Shipped

| Workstream | Shipped | File |
|---|---|---|
| Page-level token sweep + dark-mode override completion — 12 commits, IE+UK+ES+PT all 4 homepages + 11 IE-unique pages + 2 shared components; all bare #ff6a1a tokenized | 13/06/26 | [page-token-sweep.md](page-token-sweep.md) |
| DS application — Round 3 (pattern foundation + E1/E2/E3 surfaces + #010 refund alignment + #039 flag-pl + blue CTA + info@→contact@) — 18 commits, 88 verification screenshots, 7 carry-forwards (incl. ES+PT localisation gating ES/PT SEO scale-out). IE+UK programmatic SEO scale-out UNBLOCKED | 12/06/26 | [ds-application.md](ds-application.md) — sign-off in monorepo `docs/ds-application-signoff-2026-06-12.md` |
| Design-system conformance (Phases A–I + DocTypePage + Bug Sweep + Phase J post-ship + Phase K close-out) — 6 production templates, 47 pages migrated across IE/UK/ES/PT, 647-line fix-layer retired, SmartQuote modal #014/#017 RESOLVED, brand-namespace `apple-*` → `tk-*` rename, IP audit clean, Tier 2 glass-kept decision logged | 12/06/26 | [design-system-conformance.md](design-system-conformance.md) |
| Interpreting corpus — cashflow intelligence extraction (11 books) | 11/06/26 | [interpreting-corpus-research.md](interpreting-corpus-research.md) |
| WA Watcher v0.5 — chat hygiene + model controls | 09/06/26 | [wa-watcher-v0.5.md](wa-watcher-v0.5.md) |
| Document-baking studio + viewer | 06/06/26 | [baking-studio.md](baking-studio.md) |
| Drawer v1 — client document portal | 06/06/26 | [drawer.md](drawer.md) |
| Team log (decisions + ideas KB writes from watcher) | 08/06/26 | [team-log.md](team-log.md) |
| WA watcher v0.3 (images + batch coalescing) | 08/06/26 | [wa-watcher-v0.3.md](wa-watcher-v0.3.md) |
| WA watcher v0.4 (inbound docs + outbound files via clipboard-paste + KB_WRITE) | 08/06/26 | [wa-watcher-v0.4.md](wa-watcher-v0.4.md) |

## Templates & meta

- [_TEMPLATE.md](_TEMPLATE.md) — structure all roadmap files follow

---

## Status legend

- **NOT STARTED** — scope drafted, no work begun
- **IN PROGRESS — Phase N** — actively building
- **BLOCKED** — waiting on human decision in Open questions
- **DONE** — feature complete, in smoke test
- **SHIPPED** — live in production, post-ship summary written
