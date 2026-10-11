# PROGRESS — POS Mode initiative

> Maintained by `/pos-next`, `/pos-phase`, `/pos-handoff`. Edit only through those flows (or by hand with the same format).
> **Rule:** a box is ticked only when the work is done **and verified**. Unverified work is marked `(written, not run)`.

**Branch (all repos):** `claude/laundry-vendor-pos-modes-bs0o61`
**Last updated:** 2026-10-11 — Phase 4 🟡 (features built and verified in a real browser; release, device QA and a few items pending)
**Current phase:** 4 (🟡 in progress)

## Phase status

| Phase | Name | Status | Started | Completed |
|---|---|---|---|---|
| 0 | Planning, docs, slash commands | ✅ Done | 2026-10-10 | 2026-10-10 |
| 1 | Foundation: modes + POS onboarding | ✅ Done | 2026-10-10 | 2026-10-11 |
| 2 | Counter core: Home · Book Order · Customers · Price list | ✅ Done | 2026-10-11 | 2026-10-11 |
| 3 | Order lifecycle: Orders · Detail · Payments · Invoice · Tags | ✅ Done | 2026-10-11 | 2026-10-11 |
| 4 | Money, Reports, Polish & Release | 🟡 In progress | 2026-10-11 | — |

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
- [x] 1D-b Push every touched repo — Phase 1 commits are on `origin/main` (PR #1 merged in backend, dashboard, vendor app)

## Phase 2 checklist (details: `docs/pos-mode/PHASE-2.md`)

- [x] 2A-1 Migration `153_counter_order_delivery_flags.sql` — idempotent (run twice in a test), defaults WALK_IN / false
- [x] 2A-2 `book/update/list` accept `deliveryMode`, `isExpress` — validated (400 on bad values), `?deliveryMode=` / `?express=true`; express is a flag only, no price invented
- [x] 2A-3 `/vendor/pos/dashboard` Home tiles (null when not truthful) — new `data.home` block, all 13 tiles are real integers (see `Lndry_backend/docs/pos-counter-home.md`)
- [x] 2A-4 Backend tests + API docs — 5 integration tests on real Postgres (mutation-checked) + `docs/pos-counter-home.md` (the repo has no API_REFERENCE.md)
- [x] 2B-1 Models + `money.dart` — plain Dart models (as in Phase 1), integer paise, Indian grouping, no float money
- [x] 2B-2 Repositories (dashboard, customers, catalogue, quote, book) — + charge/discount rules; contract-tested on REAL captured responses
- [x] 2C-1 POS Home — numbers, plan card, tasks, quick actions. NOT in this phase: WhatsApp action (Phase 4, 4A-6) and tile → filtered Orders (needs the Phase 3 list); tiles are not tappable so there are no dead links
- [x] 2C-2 Customer picker + Add Customer
- [x] 2C-3 Book Order (live quote, draft persistence, idempotent save) — Wallet is NOT offered at booking (needs the customer's OTP approval = Phase 3 Pay Now); Cash / Online / Pay Later are
- [x] 2C-4 Add Garment Price sheet — inline + for garment/category/service; opening on an existing price edits it instead of duplicating
- [x] 2C-5 l10n — 130 keys × en / hi / hi_Latn
- [x] 2D Tests + `scripts/pos-smoke.mjs` + total matches Epic desktop to the paisa — totals verified to the paisa against the SAME `/orders/quote` endpoint Epic calls and against integer arithmetic; Epic itself was not run (it is reference-only)
- [x] 2E Definition of Done verified + pushed (see Log)

## Phase 3 checklist (details: `docs/pos-mode/PHASE-3.md`)

- [x] 3A Models, `order_state.dart`, repositories — plain Dart models, ONE place (`order_state.dart`) for status/payment → label/colour/next step; contract-tested on REAL captured responses (`test/pos/fixtures/order_*.json`)
- [x] 3B-1 Orders list (tabs, filters, search, bulk next-step) — Booked/In Process/Done + "All / Delivered / Cancelled" in the filter; date range, delivery mode, express, balance due; debounced search; infinite scroll; pull-to-refresh; expandable cards; select-all + confirmed bulk move that **never** delivers with a balance due. Not done: "captain" filter (no server filter for it)
- [x] 3B-2 Order detail (timeline, quick actions, info, garments) — customer, Call, status + payment chips, big next-step button (+ "Mark ready anyway" / "Deliver with balance due" questions), timeline with %, Quick Actions, info, payments, garments with tags, WhatsApp. Not done: **customer profile and wallet icons** (need the Phase 4 Customers screens)
- [x] 3B-3 Pay Now sheet (cash/online/wallet) — Cash / Online / Card / Bank, balance + amount rules, reference, double-tap safe, re-reads the order. **Wallet is NOT offered** (see deviations)
- [x] 3B-4 Invoice + Mini invoice — in-app viewer with Share + Print (`printing` package); A4 invoice after delivery, 58/80 mm mini bill any time until cancelled (new backend endpoint)
- [x] 3B-5 Tags — list of garment tags + "Print or share tags" (one QR label per garment, drawn in the app from the server's tag codes) + print-job logging
- [x] 3B-6 Edit order / Cancel order / Assign captain — Edit changes delivery date / mode / express / remarks (all the server allows; garments cannot be edited after booking); Cancel needs a reason; Assign picks pickup/delivery captain
- [x] 3B-7 Permissions + resume/real-time refresh — actions hidden by `orders.view|process|assign_captain`; detail AND list re-read on app resume + pull-to-refresh. The backend emits **no** live event for counter orders, so there is no socket refresh
- [x] 3C Tests + lifecycle contract script — `scripts/pos-smoke.mjs --lifecycle` (58 checks) + backend integration tests + 187 new Flutter tests + 39-check real-browser journey
- [x] 3D Definition of Done verified + pushed (see Log)

## Phase 4 checklist (details: `docs/pos-mode/PHASE-4.md`)

- [x] 4A-1 Search tab — one box over `/vendor/pos/search` (orders by number, customers by name/phone, garment tags), debounce + stale-answer guard, recent searches (per shop, "Clear"), tap → order / profile. **Not done: camera QR/barcode scan** (optional in the plan; no scanner dependency added)
- [x] 4A-2 Customers — list **A–Z with a letter strip**, labelled **Call** / **Profile** on every row, search, add; profile with Call / WhatsApp, "To collect" (sum of the server's per-order balances; tap an order → Pay Now), history, notes, addresses. Delete icon of the reference is **not built** (the backend has no customer delete)
- [x] 4A-3 Expense + cash drawer — add / edit / cancel (reason required), exact paise, types + modes, today / this month; drawer open / close with the server's expected cash and a required reason + approver on any difference; earlier drawers. **Not done: photo attachment** (the API takes a URL; there is no upload endpoint)
- [x] 4A-4 Report — tabs Summary / **Invoices** (total revenue, paged invoice table with Paid / Part paid / Unpaid words, line chart) / Collection (payment mix + chart) / Expenses (by type + chart); Today / 7 days / month / custom dates; **CSV share** (new dependency `share_plus`; **the native share sheet was not run**). Backend: new `GET /vendor/pos/report` reconciled to raw SQL
- [~] 4A-5 POS Settings — customers, price list (Add Garment Price incl. new garment), extra charges + discounts (read-only), WhatsApp messages (read-only, same setting as Epic), team (read-only), language (en / हिन्दी / Hinglish), app mode, log out. **Not done: editing shop / GST / UPI / printer / order series, adding staff, help page, dark mode** (dark mode is disabled app-wide)
- [x] 4A-6 WhatsApp — Home quick action: customer → message sheet (plain chat, payment reminder, Epic's four saved messages) filled from the server's order; `wa.me`, no Business API
- [ ] 4A-7 Notifications deep-links — not started
- [~] 4B-1 Offline-safe cart + save retry — draft survives restart and the same `Idempotency-Key` is reused until the cart changes (Phase 2), so a manual retry never double-books. **Not done: automatic background retry queue**
- [~] 4B-2 Session / permission / offering-revoked edge cases — Phase 1 routing clamps a revoked mode; staff access refreshes; money screens hide for staff without the right. Not exercised on a device
- [ ] 4B-3 Performance pass — not measured (no device)
- [~] 4B-4 Accessibility + "child-simple" audit — every new screen widget-tested at 1.6× text on 360×640; labelled icon + word buttons; chips are real checkboxes; customer rows are real buttons; the primary button of tall sheets is pinned; real-browser accessibility tree checked. Contrast tokens from Phase 1. **No screen reader on a device**
- [~] 4B-5 Localization — every new string in en / hi / hi_Latn (grep for hard-coded strings in the new folders: none). Hindi screens not viewed by eye
- [~] 4B-6 Security — CSV cells that start with `= + - @` are made safe; **fixed a cross-shop name leak** (see Log); recent searches (names/phones) are stored on the device per shop and can be cleared, not cleared at logout; staff rights for counter routes are still enforced only in the app (server gap, Phase 3 note)
- [x] 4B-7 Docs — README (modes), `docs/pos-mode/USER-GUIDE.md`, backend `docs/pos-report.md`, e2e README
- [ ] 4C-1 `ENFORCE_OFFERING` rollout — **waits for your approval; flag stays OFF**
- [ ] 4C-2 Release build + App Releases upload — **blocked: no Android SDK / signing here.** Run `flutter build apk --release --dart-define=FLAVOR=production` on your machine
- [~] 4D Tests / QA — 613 Flutter tests pass (only the known `widget_test.dart` smoke failure); backend suite = only the 2 known failures; real-browser journeys phase2 29/29, phase3 39/39, **phase4 31/31**. **Not done: `integration_test`, the device QA checklist, marketplace regression on a device**
- [ ] 4E Definition of Done — **not met** (see "Not done" items above); phase stays 🟡

## Decisions (confirmed by user)

_None yet. Defaults in `00-MASTER-PLAN.md` §10 are in force until the user changes them._

## Environment notes

- **Reproducible local test recipe (Postgres, Redis, backend, Flutter SDK): `docs/pos-mode/LOCAL-TESTING.md`.** Real-browser journeys: `scripts/pos-web-e2e` (`npm run phase2`, `npm run phase3`). The cloud sandbox is ephemeral; redo it at the start of a session that must run things.
- 2026-10-11: Flutter 3.47.7 was installed at `/root/sdk/flutter` (session-local). `flutter pub get/analyze` rewrite `pubspec.lock` and `analysis_options.yaml` — **never commit those two** (`git checkout --` them first).
- 2026-10-11 (Phase 3): added two Flutter dependencies, `printing` ^5.15.1 (in-app PDF viewer with Share/Print) and `pdf` ^3.13.1 (QR tag labels). `pubspec.lock` contains **only the new entries** (barcode, bidi, pdf, pdf_widget_wrapper, printing, qr); the newer Flutter used here also bumps SDK-pinned packages — those bumps were left out on purpose. Run `flutter pub get` once on your side. **The Android/iOS build with `printing` was not run** (no emulator here).
- Known pre-existing failures on untouched code: backend `tests/unit/step-up.test.js` + one auth test in `tests/integration/lndry-endpoints.test.js`; dashboard 3 `CustomerProfileDrawer` tests + 4 `any` lint errors; Flutter `test/widget_test.dart` smoke test; 626 analyzer infos in `lib`. None are caused by this initiative (each verified on the original commit).


## Blockers / open questions

- Open product question (not blocking): a **POS-first user who later wants Marketplace** is not supported (a second shop would make login ambiguous) — handled by support/admin for now. Confirm if that is acceptable.

## Log (newest first)

- 2026-10-11 — **Phase 4 built, not closed (🟡).**
  Shipped — backend: `GET /vendor/pos/report` (revenue, collection by mode, dues, expenses, status counts, top garments, per-day series; counter orders only), CSV export now = exactly the orders the report counts + formula-safe cells, **counter orders / search / export now show THIS shop's name for a customer** (they showed the global account name, so a second shop saw the first shop's name — found by the Phase 3 browser journey failing; integration test, mutation-checked). Flutter: Search, Customers (A–Z), Customer profile with dues, Expense + cash drawer, Report (4 tabs, charts, CSV share), POS Settings, WhatsApp sheet, ~190 new l10n keys × 3 languages, 150 new tests.
  Verified (real): backend `pos-report` integration tests vs independent SQL (mutation-checked); full backend suite = only the 2 known failures; Flutter 613 pass; release **web** build in real Chromium against the real backend: phase2 29/29, phase3 39/39 (after the name fix), phase4 31/31 — drawer opened/closed and an expense added/cancelled through the screens and read back from the API; Report numbers equal the API (and the API equals hand arithmetic).
  Bugs found by real runs and fixed: the Add Expense / Close drawer buttons scrolled off a phone screen (now pinned); a card holding a heading read as one heading; customer rows were not buttons for a screen reader; the cross-shop name leak above.
  Decisions (please confirm): (1) the permission list has no finance right, so **Expense + cash drawer follow "process orders"** and **Report follows "analytics"**; (2) customer **delete** from the reference is not offered (no backend); (3) WhatsApp messages are read from Epic's `message-templates` setting and **not editable here**, so the two never disagree; (4) the reference screenshots are blue — kept the Epic violet theme as the plan says; layout ideas (A–Z strip, Invoice table + chart, report tabs) are used.
  Not run / not done: Android/iOS build, native share sheet, a real phone, Hindi by eye, camera scan, photo attachment, notification deep-links, automatic retry queue, performance numbers, integration_test, device QA checklist, `ENFORCE_OFFERING` (needs your approval), release upload. Epic desktop/website itself was not run (reference-only; the backend changes are additive except that its order list now shows the shop's own customer name).

- 2026-10-11 — **Phase 3 closed ✅.**
  Shipped — backend: `GET /vendor/counter/orders` gained `status=A,B` (tabs), `offset` (paging), `paymentDue=true` and `tile=…` (exactly the orders a Home tile counts: the tile definitions now live once in `home-tile-filters.js` and the dashboard counts with the same ones); `GET /vendor/counter/orders/:id/invoice` (issued A4 invoice after delivery; `format=mini&paper=58|80` bill via the new `mini-v1` template, any time except cancelled); docs in `Lndry_backend/docs/pos-order-lifecycle.md`. Flutter: Orders (tabs, search, filter sheet, paging, bulk move), Order detail (timeline, next step, Pay Now, Cancel, Edit, Assign captain, Call, WhatsApp, invoice / mini bill viewer, tags with QR labels), Home tiles + task rows that open the exact list, 182 l10n keys × en / hi / hi_Latn.
  Verified (real): backend 6 new integration tests on real Postgres (mutation-checked; includes "every Home tile equals the list behind it"); `node scripts/pos-smoke.mjs --lifecycle` **58/58** against the live API (book → part-pay → overpay refused → skip refused → ready gated → delivery blocked while unpaid → pay → deliver → invoice PDFs → history → paging/tabs/cancel); full backend suite = only the 2 known failures; Flutter `test/pos` **449 tests** (from 262; 187 new, mutation-checked: stale list answers, bulk delivering with a balance, always-sending the override flag, paying more than the balance, the dialog/navigator bug below); contract tests on REAL captured responses; mini bills rendered to PNG and looked at; **release web build of the whole app in real Chromium against the real backend, 39/39 checks, run twice, every claim confirmed through the API** (Home tile → exact list, search, part payment ₹60 by UPI, Start Processing, "garments not scanned" question, "₹100 is still due" question, collect first, deliver, Order Complete, history, invoice + 58/80 mm bills from the server, WhatsApp link with the order text, cancel with reason, edit, assign captain, bulk move, Home numbers = database).
  Bugs found by that verification and fixed: dialogs popped with the page's context, but dialogs live on the root navigator while the Orders tab has its own — "Move orders" closed the screen and moved nothing (only a nested-navigator test or the real browser shows this; test added); the bottom "N selected" bar squeezed its count into one letter per line and hid the button; a tappable `ExpansionTile` inside a coloured `Container` hid its ink (and asserts in debug); order cards and Select-all were not buttons/named checkboxes for a screen reader (now one labelled button per order, one named checkbox); filter chip "x" was not an actionable control (now a labelled **Clear filters** button); overflow in the filter row at large text and in the paper-size row; a spinner showed behind the "garments not scanned" question; WhatsApp links used `+` for spaces (now `%20`).
  Decisions / deviations (please confirm): (1) **Wallet payment is not offered at Pay Now** — the backend's payment endpoint refuses `WALLET` and the OTP-confirmed redemption is wired only into booking; paying an existing order from the wallet would be new money logic (and a Phase 2 decision already kept it out of booking). (2) **Edit Order is a small sheet**, not the Book Order screen: the server only lets an open order change delivery date, mode, express and remarks. (3) Customer **profile / wallet icons** on the order header wait for the Phase 4 Customers screens. (4) **Staff permissions are enforced only in the app** for counter orders: the backend routes check "is a vendor, not a rider" but not `orders.process` etc. — so a staff member without the right is stopped by hidden buttons, not by the server. Changing that would change Epic desktop behaviour; logged for the Phase 4 security review. (5) Bulk "Move to next step" sends "mark ready anyway" for the Ready step (after a confirm that says so) but never delivers an order that still owes money. (6) A ready **home-delivery** order goes "Send for Delivery" → "Deliver Order"; any other goes straight to "Deliver Order". (7) Home tiles Booking/Delivery/Delivered/Revenue/Pending/Express/Pickups-to-assign/Deliveries-due/Deliveries-to-assign/Money-to-collect open their list; **Order requests** (LNDRY marketplace orders) opens nothing — there is no counter list behind it. (8) New dependencies `printing` + `pdf` (see Environment notes).
  Not run / not verified: Epic desktop/website itself (reference-only; it calls the same endpoints) — so "same order on Epic and phone shows identical status" is **not checked by eye**; a phone or emulator (web build only) — so the **Android/iOS build with `printing`, the native PDF viewer, Share and Print were not run**, and the PDF *pages* were not looked at in the app (the web build's viewer needs a CDN the sandbox blocks; the server's PDFs were checked as real PDFs and the mini bills rendered to images); a real staff account on a device; Hindi screens by eye (strings are in; widget-tested for the Orders and detail screens); a thermal printer; Bluetooth printing (out of scope).
  Next: Phase 4 (Search, Customers, Expense + cash drawer, Report, POS Settings, WhatsApp templates, offline-safe cart, accessibility audit, release). `ENFORCE_OFFERING` still OFF.

- 2026-10-11 — **Phase 2 closed ✅.**
  Shipped: backend migration 153 (`delivery_mode`, `is_express`), counter book/update/list flags + filters, `data.home` dashboard tiles, malformed-customer-id 400 fix, `scripts/pos-smoke.mjs`; Flutter money helpers, models, repositories, POS Home, customer picker + Add Customer, Book Order (live server quote, draft persistence, idempotent save, charges/discounts/GST), Add Garment Price (inline create, edit existing), l10n (+130 keys × 3 languages), routes.
  Verified (real): backend 5 new integration tests on real Postgres (tiles checked against independent SQL, mutation-checked; empty vendor = zeros; other vendor never leaks), full backend suite = only the 2 known failures; `pos-smoke.mjs` 32/32 against the live API; Flutter `test/pos` 262 tests (from 147), whole suite 336 pass + the 1 known `widget_test.dart` failure; contract tests on REAL captured responses; **release web build of the whole app in real Chromium against the real backend, 29/29 checks verified through the API** (book walk-in/home-delivery/express/pay-later/online, double tap = one order, draft survives restart, new price appears in the grid, Home numbers = database, charge+discount+18% GST total ₹305.62 = API quote = hand arithmetic).
  Bugs found by that verification and fixed: cart row overflowed on a normal phone (Row → Wrap); error note pushed its message off screen with a long button label; floating snackbars threw on small screens with large text (now fixed behaviour); a queued snackbar hid the "garments removed" notice; malformed customer id gave a 500 with a stack trace (now 400); my own e2e once read the wrong shop through a stale token (runner fixed — never trust a check without confirming the phone in the JWT).
  Decisions / deviations (please confirm): Wallet payment is not offered at booking (needs the customer's OTP approval → Phase 3 Pay Now); WhatsApp quick action → Phase 4; Home tiles are not tappable until Phase 3's Orders list exists; `catalogue.manage` gates Add Garment Price in the app (the server accepts create OR update, so the app is slightly stricter); new customers without an order do not appear in the recent list (same contract as Epic: the list is customers who have orders) but are findable by phone; `todayRevenue` excludes cancelled orders and Epic's mirrored `DESKTOP_PUSH` rows; "today" is the server's UTC date (as the existing `counterSalesToday`).
  Not run: Epic desktop/website itself (reference-only; it calls the same endpoints); a real staff account on a device (hidden buttons are widget-tested only); a physical phone/emulator (web build only); Hindi screens by eye (strings are in, widget-tested for two screens).
  Next: Phase 3 (Orders list, detail, payments incl. wallet, invoice, tags). `ENFORCE_OFFERING` still OFF.

- 2026-10-11 — **Phase 1 closed ✅.** Verified `origin/main` of backend, dashboard and vendor app contains the Phase 1 commits (merge of PR #1); working branches have no diff against it, so the earlier GitHub 403 is resolved. No new code. Cloud session branch is `ccr-a5ba173a-i2kisn` (session-assigned) instead of `claude/laundry-vendor-pos-modes-bs0o61`. Flutter SDK not re-installed this session (nothing re-run). Next: Phase 2.

- 2026-10-11 — **Phase 1 built and verified; push blocked.**
  Shipped: backend migration 152 + `vendor-app-mode` module + admin endpoint + flagged guard (+docs); dashboard "App access" control + list badge; Flutter POS theme, modes provider, router rules, choice screen, 4-step wizard, POS shell with 6 tabs, Settings mode switch (marketplace + POS), 79 l10n keys in 3 languages.
  Verified (real, not mocked): backend 53 unit + 11 integration tests on real Postgres (also under 4 time zones); dashboard 13 tests; Flutter 147 tests in `test/pos` (mutation-checked: router matrix, provider clamp, theme, semantics) + contract test on real captured backend JSON; `flutter analyze` clean for all new files; **release web build of the whole app** driven in real Chromium against the real backend — new-user journey 17/17 and existing-marketplace-owner journey 17/17 (login → choice → shop created → wizard with validation → starter price list → POS → tabs → logout/login resume; marketplace owner sees the unchanged dashboard, adds POS from Settings, switches modes both ways, mode survives restart).
  Bugs found by that verification and fixed: DATE→JS Date shifted a day on IST servers; backfill missed `DESKTOP_PUSH` orders (would have locked Epic shops out once enforcement is on); `2026-02-31` passed date validation (500); Epic's attention/danger colours fail 4.5:1 for text; unset `secondaryContainer` painted a green progress track and white-on-pale tab icons; a `Card` merged the mode switch and Get-POS tile into one screen-reader item.
  Not done / next: push (blocked); `ENFORCE_OFFERING` stays OFF until you approve; Phase 2 next.
  Phase 3 note: READY needs `allowIncomplete`, DELIVERED needs `allowUnpaid` (see PHASE-3.md).

- 2026-10-10 — Phase 0: analysed 5 screenshots + 4 repos; wrote Master Plan, Phase 1–4 docs, CLAUDE.md, PROGRESS.md and slash commands (`/pos-next`, `/pos-status`, `/pos-phase`, `/pos-verify`, `/pos-handoff`). No product code changed.
