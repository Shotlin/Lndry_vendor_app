# PROGRESS — POS Mode initiative

> Maintained by `/pos-next`, `/pos-phase`, `/pos-handoff`. Edit only through those flows (or by hand with the same format).
> **Rule:** a box is ticked only when the work is done **and verified**. Unverified work is marked `(written, not run)`.

**Branch (all repos):** `claude/laundry-vendor-pos-modes-bs0o61`
**Last updated:** 2026-10-11 — Phase 1 built and verified locally; **not pushed** (GitHub App has no access to the repos — see Blockers)
**Current phase:** 1 (🟡 only the push is left; then Phase 2)

## Phase status

| Phase | Name | Status | Started | Completed |
|---|---|---|---|---|
| 0 | Planning, docs, slash commands | ✅ Done | 2026-10-10 | 2026-10-10 |
| 1 | Foundation: modes + POS onboarding | 🟡 Built & verified; push blocked | 2026-10-10 | — |
| 2 | Counter core: Home · Book Order · Customers · Price list | ⬜ Not started | — | — |
| 3 | Order lifecycle: Orders · Detail · Payments · Invoice · Tags | ⬜ Not started | — | — |
| 4 | Money, Reports, Polish & Release | ⬜ Not started | — | — |

Status legend: ⬜ not started · 🟡 in progress · ✅ done (Definition of Done met) · ⛔ blocked (reason in Blockers)

## Phase 1 checklist (details: `docs/pos-mode/PHASE-1.md`)

- [x] 1A-1 Migration `152_vendor_offering.sql` (+ backfill) — migration applied, re-applied and backfill-tested on real Postgres
- [x] 1A-2 `vendor-app-mode` module: `GET /vendor/app-mode`
- [x] 1A-3 `POST /vendor/pos-onboarding/start` — idempotent, 8 concurrent starts → 1 shop
- [x] 1A-4 `PATCH /vendor/pos-onboarding` (steps)
- [x] 1A-5 `POST /vendor/pos-onboarding/complete`
- [x] 1A-6 Admin `PATCH /vendors/admin/:id/offering` + vendor cannot self-set — as `PUT /vendors/admin/:id/offering`
- [x] 1A-7 `requireOffering` guards behind `ENFORCE_OFFERING` (default off) — off by default; verified both modes
- [x] 1A-8 Backend tests green + `API_REFERENCE.md` — 53 unit + 11 real-DB integration tests; contract in `Lndry_backend/docs/vendor-app-mode.md`
- [x] 1B-1 Dashboard: offering control on vendor detail + list badge
- [x] 1B-2 Dashboard tests — 13 tests
- [x] 1C-1 POS theme/colors/fonts — + accessible text variants, theme leak fixes
- [x] 1C-2 App-mode models + repository — plain Dart models; contract-tested against REAL captured responses
- [x] 1C-3 `appModeProvider` (persist + clamp)
- [x] 1C-4 Router: POS routes + redirect matrix
- [x] 1C-5 Choice screen
- [x] 1C-6 POS onboarding wizard (4 steps)
- [x] 1C-7 POS shell + bottom nav placeholders
- [x] 1C-8 Settings: App mode switch + "Get POS"
- [x] 1C-9 l10n en/hi/hi_Latn — 79 keys × en / hi / hi_Latn
- [x] 1C-10 Flutter tests (provider, router matrix, onboarding validation, widgets) — 147 tests in `test/pos`
- [x] 1D-a Definition of Done verified (see Log)
- [ ] 1D-b **Push** every touched repo (blocked: GitHub 403) — run `/pos-handoff` once access is fixed, then mark Phase 1 ✅

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

- **Reproducible local test recipe (Postgres, Redis, backend, Flutter SDK): `docs/pos-mode/LOCAL-TESTING.md`.** The cloud sandbox is ephemeral; redo it at the start of a session that must run things.
- 2026-10-11: Flutter 3.47.7 was installed at `/root/sdk/flutter` (session-local). `flutter pub get/analyze` rewrite `pubspec.lock` and `analysis_options.yaml` — **never commit those two** (`git checkout --` them first).
- Known pre-existing failures on untouched code: backend `tests/unit/step-up.test.js` + one auth test in `tests/integration/lndry-endpoints.test.js`; dashboard 3 `CustomerProfileDrawer` tests + 4 `any` lint errors; Flutter `test/widget_test.dart` smoke test; 626 analyzer infos in `lib`. None are caused by this initiative (each verified on the original commit).


## Blockers / open questions

- **GitHub push is refused (403): "Claude doesn't have GitHub access to Shotlin/<repo>".** Fix: connect/reinstall the Claude GitHub App for the `Shotlin` org at https://claude.ai/connect-github (an org owner installs it at https://github.com/apps/claude/installations/select_target). Local commits exist on branch `claude/laundry-vendor-pos-modes-bs0o61` in `Lndry_backend`, `Lndry_dashboard_frontend` and `Lndry_vendor_app`.
- Open product question (not blocking): a **POS-first user who later wants Marketplace** is not supported (a second shop would make login ambiguous) — handled by support/admin for now. Confirm if that is acceptable.

## Log (newest first)

- 2026-10-11 — **Phase 1 built and verified; push blocked.**
  Shipped: backend migration 152 + `vendor-app-mode` module + admin endpoint + flagged guard (+docs); dashboard "App access" control + list badge; Flutter POS theme, modes provider, router rules, choice screen, 4-step wizard, POS shell with 6 tabs, Settings mode switch (marketplace + POS), 79 l10n keys in 3 languages.
  Verified (real, not mocked): backend 53 unit + 11 integration tests on real Postgres (also under 4 time zones); dashboard 13 tests; Flutter 147 tests in `test/pos` (mutation-checked: router matrix, provider clamp, theme, semantics) + contract test on real captured backend JSON; `flutter analyze` clean for all new files; **release web build of the whole app** driven in real Chromium against the real backend — new-user journey 17/17 and existing-marketplace-owner journey 17/17 (login → choice → shop created → wizard with validation → starter price list → POS → tabs → logout/login resume; marketplace owner sees the unchanged dashboard, adds POS from Settings, switches modes both ways, mode survives restart).
  Bugs found by that verification and fixed: DATE→JS Date shifted a day on IST servers; backfill missed `DESKTOP_PUSH` orders (would have locked Epic shops out once enforcement is on); `2026-02-31` passed date validation (500); Epic's attention/danger colours fail 4.5:1 for text; unset `secondaryContainer` painted a green progress track and white-on-pale tab icons; a `Card` merged the mode switch and Get-POS tile into one screen-reader item.
  Not done / next: push (blocked); `ENFORCE_OFFERING` stays OFF until you approve; Phase 2 next.
  Phase 3 note: READY needs `allowIncomplete`, DELIVERED needs `allowUnpaid` (see PHASE-3.md).

- 2026-10-10 — Phase 0: analysed 5 screenshots + 4 repos; wrote Master Plan, Phase 1–4 docs, CLAUDE.md, PROGRESS.md and slash commands (`/pos-next`, `/pos-status`, `/pos-phase`, `/pos-verify`, `/pos-handoff`). No product code changed.
