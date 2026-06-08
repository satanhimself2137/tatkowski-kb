# Roadmap Index

At-a-glance view of every workstream. Each entry links to its roadmap file. Maintained manually — update when status changes.

**Read order for any session:** scan this first. If a workstream looks active or relevant, read its roadmap file in full before acting.

---

## Active

| Workstream | Status | Owner | Last update | File |
|---|---|---|---|---|
| Payments & customer journey | IN PROGRESS — Phase 0 (Claude Design pass) | Maciej | 07/06/26 | [workstream-1-payments-and-journey.md](workstream-1-payments-and-journey.md) |
| Portugal market research | In progress | David (via Claude) | 06/06/26 | [portugal-market-research.md](portugal-market-research.md) |
| WA ↔ Claude watcher | IN PROGRESS — Phase 2 v0.2 SHIPPED, Worker KB proxy + team-log + images + coalescing live | Maciej | 08/06/26 | [wa-watcher.md](wa-watcher.md) |

## Queued (next up)

| Workstream | Notes |
|---|---|
| Interpreting intake widget | Scope locked 06/06/26. SmartQuote equivalent for lead product. Public form on 4 sites + internal B2B log form. Manual quoting (per-job cost variance). [interpreting-intake.md](interpreting-intake.md) |
| Chatwoot on Hetzner | Scope locked 06/06/26. Self-hosted, EUR 4.51/mo, gating prerequisite for WA AI. Queued behind interpreting intake (revenue first). [chatwoot.md](chatwoot.md) |
| WhatsApp AI intake (tatkowski.ai) | Depends on Chatwoot + Meta permanent token + UK/ES WABA numbers. Roadmap not yet created. |
| B2B invoicing mode (SalesManager / Drawer v2) | DEFERRED — only 1 B2B client. Revisit when client #5 or Fyffes hits monthly invoicing. Roadmap not yet created. |
| D1 migration | Architecture move, lands alongside Pro layers. Roadmap not yet created. |
| 90-day R2 auto-purge worker | Cron Trigger over `orders/` prefix. Small build. Roadmap not yet created. |

## Done / Shipped

| Workstream | Shipped | File |
|---|---|---|
| Document-baking studio + viewer | 06/06/26 | [baking-studio.md](baking-studio.md) |
| Drawer v1 — client document portal | 06/06/26 | [drawer.md](drawer.md) |
| Team log (decisions + ideas KB writes from watcher) | 08/06/26 | [team-log.md](team-log.md) |
| WA watcher v0.3 (images + batch coalescing) | 08/06/26 | [wa-watcher-v0.3.md](wa-watcher-v0.3.md) |

## Templates & meta

- [_TEMPLATE.md](_TEMPLATE.md) — structure all roadmap files follow

---

## Status legend

- **NOT STARTED** — scope drafted, no work begun
- **IN PROGRESS — Phase N** — actively building
- **BLOCKED** — waiting on human decision in Open questions
- **DONE** — feature complete, in smoke test
- **SHIPPED** — live in production, post-ship summary written
