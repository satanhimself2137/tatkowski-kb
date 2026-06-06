# Roadmap Index

At-a-glance view of every workstream. Each entry links to its roadmap file. Maintained manually — update when status changes.

**Read order for any session:** scan this first. If a workstream looks active or relevant, read its roadmap file in full before acting.

---

## Active

| Workstream | Status | Owner | Last update | File |
|---|---|---|---|---|
| Document-baking studio + viewer | NOT STARTED | Maciej | 06/06/26 | [baking-studio.md](baking-studio.md) |

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
| Drawer v1 — client document portal | 06/06/26 | [drawer.md](drawer.md) |

## Templates & meta

- [_TEMPLATE.md](_TEMPLATE.md) — structure all roadmap files follow

---

## Status legend

- **NOT STARTED** — scope drafted, no work begun
- **IN PROGRESS — Phase N** — actively building
- **BLOCKED** — waiting on human decision in Open questions
- **DONE** — feature complete, in smoke test
- **SHIPPED** — live in production, post-ship summary written
