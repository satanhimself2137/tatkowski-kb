# ROADMAP — Drawer v1 (Client Document Portal)

**Status:** IN PROGRESS — local-clean, awaiting prod deploy (DNS + KV/R2 + secrets)
**Owner:** Agent (Sonnet 4.6 via Continue.dev) — supervised by Maciej
**Last update:** 06/06/26 by Claude

---

## Scope

**In:**
- New Cloudflare Pages project `apps/drawer/` deployed at `drawer.tatkowski.com`
- Magic-link login (7d token) from delivery emails — one-tap, no friction
- Manual login: email → 6-digit code → HMAC-signed 30-day session cookie
- Order list across all four markets, filtered by logged-in email
- Order detail: timeline, translator (post-paid), cert PDF download, source download
- Profile: name, WhatsApp number, delivery preference toggle (email / WA / both)
- `clientType: 'b2c'` field added to new orders (no backfill on existing)
- Existing per-order page at `tatkowski.com/order/{ref}?t=...` stays live (one-tap from AI emails)

**Out (deferred):**
- B2B mode (invoices, statements, PO refs) — separate v2 layer
- Reprint flow (+€10 hard-copy Revolut link)
- Status push notifications to client (comes with WA AI workstream)
- 90-day auto-purge worker (separate task)
- D1 migration (lands alongside SalesManager Pro)
- IP-based rate limiting (v1 is email-only)
- Email change / multi-email merge

---

## Decisions

- **05/06/26 — 4-stage order flow (Quoted → Paid → In Progress → Delivered)** — "New" is a filter on Quoted, "Needs Sourcing" is an exception flag, not a stage. Decided by Maciej.
- **05/06/26 — Subdomain not path** — `drawer.tatkowski.com` as new Pages project, not nested under tatkowski.com/drawer. Drawer is per-client not per-market. Decided by Maciej.
- **05/06/26 — Coexist with /order/&lt;ref&gt;?t=...** — Don't replace the per-order page. Keep it as the frictionless one-tap path from delivery emails. Drawer adds the returning-client portal layer on top. Decided by Maciej + Claude.
- **05/06/26 — One-tap magic link in delivery emails** — When WA AI / SalesManager emails delivery, link is `drawer.tatkowski.com/api/auth/magic?t=&lt;token&gt;` (7d TTL). No code entry from email path. Decided by Maciej.
- **05/06/26 — KV stays v1, no D1 migration** — ~50 orders, full scan filter by email is fine. D1 lands alongside Pro layers later. Decided by Claude with Maciej accepting.
- **05/06/26 — B2B deferred entirely from drawer v1** — B2B clients use same drawer for downloads only; invoices/statements come in v2 under same auth shell. `clientType` flag added now for future branching. Decided by Maciej.
- **05/06/26 — HMAC session cookies, not JWT, not KV-stored sessions** — Stateless verify, no per-request KV read. Cookie name `drawer_session`, HttpOnly + Secure + SameSite=Lax. Decided by Claude.

---

## Open questions

- [ ] **Final cert PDF storage path** — currently lives at `orders/{ref}/{filename}` with no `cert/` subfolder. Source lives at `orders/{ref}/source/{filename}`. Order record holds both keys explicitly, so retrieval is unambiguous, but the prefix is mixed. Worth restructuring for clarity, or leave alone? Decision: LEAVE ALONE for v1 — order record holds explicit keys, drawer just reads them.

---

## Build log

### 06/06/26 00:08 — Agent (Sonnet 4.6, Continue.dev) — v1.1 polish (commit `4b0146b`)

Follow-up pass on top of v1: mobile responsive layout, case-insensitive email lookup in orders endpoints, separated styles into `drawer.css` (285 lines), Tatkowski logo added to login screen. DrawerApp.tsx slimmed (1035 → ~720 lines) as inline styles moved out. Login screen verified locally at `http://localhost:4325/#/orders` — branded with orange top border, logo + lockup, "Sign in to your portal / Enter your email and we'll send you a 6-digit sign-in code." Visual matches spec.

**Files touched:**
- `apps/drawer/src/styles/drawer.css` (new, 285 lines)
- `apps/drawer/src/components/DrawerApp.tsx` (refactored, -313 / +0 ≈ inline styles → external)
- `apps/drawer/src/pages/index.astro` (logo import)
- `apps/drawer/public/tatkowski-logo.png` (new)
- `apps/drawer/functions/api/orders.ts` (case-insensitive email match)
- `apps/drawer/functions/api/orders/[ref].ts` (case-insensitive email match)

**Commits:**
- `4b0146b fix(drawer): v1.1 mobile responsive, orders case-insensitive, brand styling`

### 05/06/26 23:37 — Agent (Sonnet 4.6, Continue.dev) — v1 build (commit `24cc064`)

Full v1 scaffolded and shipped to main. Backend (auth + orders + profile), frontend (DrawerApp.tsx single-file React app with login → list → detail → profile flow), wrangler.toml + Pages adapter. Sales worker `admin-order-upload.js` updated to inject magic-link into delivery emails alongside per-order token URL. Payment-worker stamps `clientType: 'b2c'` on new orders. Pre-existing per-order page at `tatkowski.com/order/{ref}?t=...` left intact (one-tap path from AI emails preserved). Bundled with unrelated changes (PWA close button polish, footer dark-mode fixes, IE translation page refresh).

**Files touched (drawer-only, 19 files):**
- `apps/drawer/astro.config.mjs`, `package.json`, `tsconfig.json`, `wrangler.toml`
- `apps/drawer/functions/_lib/auth.ts` (155 lines — HMAC session sign/verify, code TTL, email send)
- `apps/drawer/functions/api/auth/{logout,magic,request-code,verify-code}.ts`
- `apps/drawer/functions/api/orders.ts`, `orders/[ref].ts`, `orders/[ref]/download/[type].ts`
- `apps/drawer/functions/api/profile.ts`
- `apps/drawer/functions/_routes.json`
- `apps/drawer/src/components/DrawerApp.tsx` (1035 lines)
- `apps/drawer/src/pages/index.astro`
- `apps/drawer/public/_headers`, `_redirects`

**Cross-app changes:**
- `apps/sales/functions/api/admin-order-upload.js` — magic-link injection in delivery email body
- `workers/payment-worker/src/index.ts` — `clientType: 'b2c'` on new orders
- `.github/copilot-instructions.md` — drawer rules added

**Commits:**
- `24cc064 feat(drawer): v1 client document portal — magic-link + code login, orders, profile, B2C clientType`

### 05/06/26 19:30 — Claude — Pre-build scope & prompt

Drafted full agent prompt covering 7 phases (READ, SCAFFOLD, BACKEND, FRONTEND, INTEGRATION, VISUAL LOOP, DEPLOY, KB UPDATE). Saved to `/mnt/user-data/outputs/drawer-v1-build.md` and handed to Maciej. Maciej fired into Continue.dev with Sonnet 4.6.

Key shape decisions baked into the prompt (see Decisions section above).

**Files touched (planning only, no code yet):**
- (none — agent will scaffold `apps/drawer/`)

**Commits:**
- (none yet)

---

## Done criteria

- [x] `apps/drawer/` scaffolded with Astro 5 + React 18, Cloudflare Pages adapter
- [~] `wrangler.toml` bindings: ORDERS_KV, ORDERS_R2; secrets RESEND_API_KEY + SESSION_HMAC_SECRET set via wrangler — *wrangler.toml committed; secrets not yet set on prod Pages project*
- [x] Backend routes live: `/api/auth/request-code`, `/api/auth/verify-code`, `/api/auth/magic`, `/api/auth/logout`, `/api/orders`, `/api/orders/:ref`, `/api/orders/:ref/download/:type`, `/api/profile`
- [x] Frontend: login screen (email + code steps), order list, order detail, profile
- [x] Existing per-order delivery email (`admin-order-upload.js`) injects magic-link alongside the per-order token URL
- [x] `clientType: 'b2c'` added to new orders in admin-order-upload.js, upload-source.js, payment-worker
- [~] Visual loop pass at 390px + 1440px on all 4 screens — *login screen verified at desktop ~870px viewport; v1.1 was responsive pass but no committed Playwright screenshots for list/detail/profile yet*
- [ ] TypeScript clean (`pnpm -F @tatkowski/drawer typecheck`) — *not verified*
- [ ] DNS: `drawer.tatkowski.com` CNAME live, custom domain bound to Pages project
- [ ] Smoke test on prod: magic-link from email lands logged in; manual code login works; download works; profile persists; sign-out works

---

## Next actions (to reach SHIPPED)

1. `pnpm -F @tatkowski/drawer typecheck` — verify clean
2. Visual loop: Playwright at 390px + 1440px across login, list, detail, profile — commit screenshots
3. `wrangler kv:namespace create "ORDERS_KV"` → confirm same namespace as sales/ie (shared) or new (segregated). v1 spec assumes shared.
4. Set Pages secrets: `RESEND_API_KEY`, `SESSION_HMAC_SECRET` (generate long random)
5. Create Pages project `tatkowski-drawer`, point to `apps/drawer/`, set build cmd + output dir
6. Add `drawer.tatkowski.com` CNAME in Cloudflare DNS → bind as custom domain on Pages project
7. Smoke test: real magic link → real download → sign out → manual code re-login

---

## Post-ship summary

[To be filled when Status = SHIPPED.]
