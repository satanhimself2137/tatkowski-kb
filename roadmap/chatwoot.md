# ROADMAP — Chatwoot on Hetzner

**Status:** NOT STARTED — queued behind baking studio + interpreting intake
**Owner:** Maciej
**Last update:** 06/06/26 by Claude

---

## Scope

Stand up a self-hosted Chatwoot instance on a Hetzner CX22 (EUR 4.51/mo, IE datacentre) as the gating prerequisite for the WhatsApp AI layer. Chatwoot provides a unified inbox for IE/UK/ES/PT WhatsApp numbers, lets agents reply manually until the AI plugs in, and exposes a REST API the AI worker can talk to later. Embed Chatwoot inside SalesManager as a bottom-nav route so operators don't context-switch.

**In:**
- Hetzner CX22 provisioned in IE datacentre (per KB section 11)
- Chatwoot self-hosted via official Docker setup
- Reverse proxy + SSL (Caddy or Traefik) on a subdomain — likely chat.tatkowski.com
- IE WhatsApp Cloud API (Phone Number ID 1170128006173405) connected as first inbox
- Agent accounts: Maciej, Magda, David, Artur (4 seats)
- Embed inside SalesManager as a route (`/inbox` or bottom-nav item) — iframe with auth pass-through
- Webhook endpoint registered for future AI worker integration
- Basic operational runbook (backup, restart, update procedure)

**Out:**
- AI integration (lives in separate WhatsApp AI workstream)
- UK/ES/PT WABA registration (depends on SIM provisioning — David sourcing ES, UK number TBD)
- Migration of IE citations off +353 838710861 to IE WABA number (separate task in roadmap or todos/maciej.md)
- Conversation routing rules / SLA dashboards (out for v1)
- Custom Chatwoot UI / branding beyond logo
- Multi-language agent UI (English only for ops)

---

## Decisions

- **06/06/26 — Self-host on Hetzner, not SaaS** — EUR 4.51/mo vs $19+/agent SaaS = no contest for a 4-agent team. Self-host also means data stays in EU (GDPR clean). Decided by Maciej (KB-locked).
- **06/06/26 — Queued behind interpreting intake** — interpreting intake is the revenue lever, Chatwoot is plumbing. Build product first. Decided by Maciej 06/06/26.
- **06/06/26 — Embed in SalesManager** — single operating cockpit per KB section 16. Operators stay in SalesManager. Decided by Maciej (KB-locked).

---

## Open questions

- [ ] **Subdomain choice: chat.tatkowski.com or inbox.tatkowski.com?** — Cosmetic but pick before SSL cert.
- [ ] **Backup strategy: Hetzner snapshot, or external (e.g. B2 / R2)?** — Snapshots are easy but vendor-locked. External backup adds setup time. Recommend Hetzner snapshots for v1.
- [ ] **Auth pass-through into embedded Chatwoot** — Chatwoot has its own SSO via SAML or JWT. SalesManager uses a custom token. Either bridge them, or operators log in to Chatwoot separately (less smooth but simpler).
- [ ] **CX22 sizing** — 2 vCPU / 4GB RAM / 40GB SSD. Chatwoot Docker stack (Rails + Sidekiq + Postgres + Redis) at low traffic should fit. If memory pressure shows up, bump to CX32.

---

## Build log

[Empty — work has not started.]

---

## Done criteria

- [ ] Hetzner CX22 running, SSH access set up
- [ ] Chatwoot live at chosen subdomain with valid SSL
- [ ] IE WABA connected, test message received in Chatwoot inbox
- [ ] 4 agent accounts created and tested
- [ ] Chatwoot embedded inside SalesManager and renders correctly
- [ ] Test WA conversation handled end-to-end through Chatwoot (incoming → agent reply → client receives)
- [ ] Backup mechanism in place (snapshot or otherwise)
- [ ] Runbook documented in `tools/chatwoot-runbook.md` in the KB repo
- [ ] Cost confirmed at ~EUR 4.51/mo on first billing cycle

---

## Post-ship summary

[To be filled when Status = SHIPPED.]
