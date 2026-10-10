# PROGRESS — POS Mode initiative

> Maintained by `/pos-next`, `/pos-phase`, `/pos-handoff`. Edit only through those flows (or by hand with the same format).
> **Rule:** a box is ticked only when the work is done **and verified**. Unverified work is marked `(written, not run)`.

**Branch (all repos):** `claude/laundry-vendor-pos-modes-bs0o61`
**Last updated:** 2026-10-10 — planning complete, no implementation started
**Current phase:** 1 (not started)

## Phase status

| Phase | Name | Status | Started | Completed |
|---|---|---|---|---|
| 0 | Planning, docs, slash commands | ✅ Done | 2026-10-10 | 2026-10-10 |
| 1 | Foundation: modes + POS onboarding | ⬜ Not started | — | — |
| 2 | Counter core: Home · Book Order · Customers · Price list | ⬜ Not started | — | — |
| 3 | Order lifecycle: Orders · Detail · Payments · Invoice · Tags | ⬜ Not started | — | — |
| 4 | Money, Reports, Polish & Release | ⬜ Not started | — | — |

Status legend: ⬜ not started · 🟡 in progress · ✅ done (Definition of Done met) · ⛔ blocked (reason in Blockers)

## Phase 1 checklist (details: `docs/pos-mode/PHASE-1.md`)

- [ ] 1A-1 Migration `152_vendor_offering.sql` (+ backfill)
- [ ] 1A-2 `vendor-app-mode` module: `GET /vendor/app-mode`
- [ ] 1A-3 `POST /vendor/pos-onboarding/start`
- [ ] 1A-4 `PATCH /vendor/pos-onboarding` (steps)
- [ ] 1A-5 `POST /vendor/pos-onboarding/complete`
- [ ] 1A-6 Admin `PATCH /vendors/admin/:id/offering` + vendor cannot self-set
- [ ] 1A-7 `requireOffering` guards behind `ENFORCE_OFFERING` (default off)
- [ ] 1A-8 Backend tests green + `API_REFERENCE.md`
- [ ] 1B-1 Dashboard: offering control on vendor detail + list badge
- [ ] 1B-2 Dashboard tests
- [ ] 1C-1 POS theme/colors/fonts
- [ ] 1C-2 App-mode models + repository
- [ ] 1C-3 `appModeProvider` (persist + clamp)
- [ ] 1C-4 Router: POS routes + redirect matrix
- [ ] 1C-5 Choice screen
- [ ] 1C-6 POS onboarding wizard (4 steps)
- [ ] 1C-7 POS shell + bottom nav placeholders
- [ ] 1C-8 Settings: App mode switch + "Get POS"
- [ ] 1C-9 l10n en/hi/hi_Latn
- [ ] 1C-10 Flutter tests (provider, router matrix, onboarding validation, widgets)
- [ ] 1D Definition of Done verified + pushed on all touched repos

## Phase 2 checklist (details: `docs/pos-mode/PHASE-2.md`)

- [ ] 2A-1 Migration `153_counter_order_delivery_flags.sql`
- [ ] 2A-2 `book/update/list` accept `deliveryMode`, `isExpress`
- [ ] 2A-3 `/vendor/pos/dashboard` Home tiles (null when not truthful)
- [ ] 2A-4 Backend tests + API docs
- [ ] 2B-1 Models + `money.dart`
- [ ] 2B-2 Repositories (dashboard, customers, catalogue, quote, book)
- [ ] 2C-1 POS Home
- [ ] 2C-2 Customer picker + Add Customer
- [ ] 2C-3 Book Order (live quote, draft persistence, idempotent save)
- [ ] 2C-4 Add Garment Price sheet
- [ ] 2C-5 l10n
- [ ] 2D Tests + `scripts/pos-smoke.mjs` + total matches Epic desktop to the paisa
- [ ] 2E Definition of Done verified + pushed

## Phase 3 checklist (details: `docs/pos-mode/PHASE-3.md`)

- [ ] 3A Models, `order_state.dart`, repositories
- [ ] 3B-1 Orders list (tabs, filters, search, bulk next-step)
- [ ] 3B-2 Order detail (timeline, quick actions, info, garments)
- [ ] 3B-3 Pay Now sheet (cash/online/wallet)
- [ ] 3B-4 Invoice + Mini invoice
- [ ] 3B-5 Tags
- [ ] 3B-6 Edit order / Cancel order / Assign captain
- [ ] 3B-7 Permissions + resume/real-time refresh
- [ ] 3C Tests + lifecycle contract script
- [ ] 3D Definition of Done verified + pushed

## Phase 4 checklist (details: `docs/pos-mode/PHASE-4.md`)

- [ ] 4A-1 Search tab
- [ ] 4A-2 Customers list/detail/dues
- [ ] 4A-3 Expense tab + cash drawer
- [ ] 4A-4 Report tab + CSV export
- [ ] 4A-5 POS Settings (full)
- [ ] 4A-6 WhatsApp quick action + templates
- [ ] 4A-7 Notifications deep-links
- [ ] 4B-1 Offline-safe cart + save retry
- [ ] 4B-2 Session/permission/offering-revoked edge cases
- [ ] 4B-3 Performance pass
- [ ] 4B-4 Accessibility + "child-simple" audit
- [ ] 4B-5 Localization completeness
- [ ] 4B-6 Security review
- [ ] 4B-7 Docs (README, user guide, API reference)
- [ ] 4C-1 `ENFORCE_OFFERING` rollout decision (user approval)
- [ ] 4C-2 Release build + App Releases upload
- [ ] 4D Device QA checklist + integration test + regression
- [ ] 4E Definition of Done verified + pushed

## Decisions (confirmed by user)

_None yet. Defaults in `00-MASTER-PLAN.md` §10 are in force until the user changes them._

## Environment notes

- 2026-10-10: planning sandbox had Node 22 + psql, **no Flutter/Dart SDK**. Check `flutter --version` at the start of each phase.
- Backend integration tests need Postgres + Redis (`npm run infra:up` needs Docker; if unavailable, use local `psql`/`redis-server` or mark integration tests "not run").

## Blockers / open questions

- (none)

## Log (newest first)

- 2026-10-10 — Phase 0: analysed 5 screenshots + 4 repos; wrote Master Plan, Phase 1–4 docs, CLAUDE.md, PROGRESS.md and slash commands (`/pos-next`, `/pos-status`, `/pos-phase`, `/pos-verify`, `/pos-handoff`). No product code changed.
