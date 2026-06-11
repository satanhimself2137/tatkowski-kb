# To-Do - Maciej Tatkowski (Founder & Director)
_Source of truth for Maciej's tasks. Key items mirrored to KB. Updated 05/06/26._

## Now
- [ ] **12/06 — Call Enoma re: SayMore wiring fault.** SayMore subscription IE_38029628_635116_15279 is keyed to Pro Rubbish Removal's Place ID (Strand Street Malahide, prorubbishremoval.ie, 087 294 2555, 82 reviews) — not ours. The AI Review Responses tool has been auto-posting owner replies on **Pro Rubbish Removal's actual Google profile** under our subscription since 28/10/25. Confirmed live: response text on GBP matches SayMore "Live" status verbatim ("Thank you for the feedback from pro rubbish removal"). Three asks on the call: (1) stop the AI auto-response today, (2) written confirmation of how our subscription posted on another business's GBP, (3) repoint subscription to actual Tatkowski Place ID (service-area Dublin profile, 21 reviews). Don't touch SayMore in the meantime — preserve as evidence. Recap call in email after for paper trail. Screenshots saved in this chat as evidence.
- [ ] Build self-hosted remote MCP server for phone read+write (DECIDED 05/06): Cloudflare Worker, OAuth 2.1 (workers-oauth-provider), GitHub Contents API backed by a fine-grained PAT (tatkowski-kb, read+write) as Worker secret. Tools: read/write KB, todos, ai_notes. Design extensible to orders/SalesManager/WhatsApp later. Add Worker URL as custom connector on desktop (mobile install still beta), then usable from phone. Fallback if needed sooner: Claude Code mobile + GitHub PAT over HTTP.
- [ ] Fix SmartQuoteForm.astro + BookInterpreterForm.astro (packages/ui): replace hardcoded `wa.me/353838710861` with a siteConfig-driven prop so the drawer shows the right number per market. (06/06)
- [ ] PT site geo: Lisbon -> Portimao / Faro (apps/pt site.config.ts + BaseLayout areaServed). NAP-consistency follow-up to the 05/06 phone/hours pass.

## Next
- [ ] Confirm with David that 931 052 617 has never been on WhatsApp before AI Cloud API onboarding.
- [ ] Compliance carry-over as worked: GBP verification (case 4-3059000041687), ICO fee (GBP 40, UK GDPR), FCR cancel by 31/10/26, GSC IE geo-target, CRO B1 return (due 15/06).

## Done (recent)
- [x] 05/06 - BrightLocal PT campaign 972979 ordered + paid (35 citations, $112).
- [x] 05/06 - PT site public contact -> +351 931 052 612, hours 24/7, deployed (715e21d).
- [x] 02/06 - BrightLocal UK hold resolved; campaign 971664 live.
