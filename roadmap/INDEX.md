# Roadmap Index

At-a-glance view of every workstream. Each entry links to its roadmap file. Maintained manually — update when status changes.

**Read order for any session:** scan this first. If a workstream looks active or relevant, read its roadmap file in full before acting.

---

## Active

| Workstream | Status | Owner | Last update | File |
|---|---|---|---|---|
| Drawer v1 — client document portal | IN PROGRESS — local-clean, awaiting prod deploy | Agent (Continue.dev) | 06/06/26 | [drawer.md](drawer.md) |

## Queued (next up)

| Workstream | Notes |
|---|---|
| Chatwoot on Hetzner | Gating prerequisite for WA AI + escalation. ~half-day build, EUR 4.51/mo. Roadmap not yet created. |
| Document-baking studio | Separate role; ingests PDF/JPG/PNG/DOCX, bakes QR + logo, handles WA-arrived docs. Roadmap not yet created. |
| WhatsApp AI intake (tatkowski.ai) | Depends on Chatwoot + Meta permanent token + UK/ES WABA numbers. Roadmap not yet created. |
| Interpreting intake (SalesManager) | No SmartQuote equivalent for lead product. Roadmap not yet created. |
| B2B invoicing mode (SalesManager / Drawer v2) | Deferred from drawer v1. Triggers when client #5 or Fyffes hits monthly invoicing. Roadmap not yet created. |
| D1 migration | Architecture move, lands alongside Pro layers. Roadmap not yet created. |
| 90-day R2 auto-purge worker | Cron Trigger over `orders/` prefix. Small build. Roadmap not yet created. |

## Done / Shipped

| Workstream | Shipped | File |
|---|---|---|
| (nothing yet) | | |

## Templates & meta

- [_TEMPLATE.md](_TEMPLATE.md) — structure all roadmap files follow

---

## Status legend

- **NOT STARTED** — scope drafted, no work begun
- **IN PROGRESS — Phase N** — actively building
- **BLOCKED** — waiting on human decision in Open questions
- **DONE** — feature complete, in smoke test
- **SHIPPED** — live in production, post-ship summary written
