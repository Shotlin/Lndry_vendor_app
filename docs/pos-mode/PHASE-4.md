# Phase 4 — Money, Reports, Polish & Release

**Goal:** finish the bottom-nav (Search · Expense · Report · Setting), add reliability and language polish, QA on real devices, produce a release build.

**Needs Phase 3 complete.** Repos: `Lndry_vendor_app` (main), `Lndry_backend` (gaps only), `Lndry_dashboard_frontend` (offering/plan polish).
Reference: `LaundryExpenses.tsx`, `LaundryCashClosing.tsx`, `LaundryReports.tsx`, `LaundryStatistics.tsx`, `LaundrySettings.tsx`, `webAdapters/{finance,financeReports,reports,statistics}.ts`.

## 4A. Features

- [ ] **Search tab** `pos_search_page.dart`: one box → `GET /vendor/pos/search` (orders, customers, garments by tag/QR). Recent searches. Tap result → detail.
  Camera QR/barcode scan for garment tags (optional if time-boxed; record in PROGRESS.md).
- [ ] **Customers** `customers_page.dart` / detail: list + search, profile (phone, address, notes, preferences from `vendor-customer-profiles`),
  order history, ledger/balance due (`vendor-customer-ledger`), "Collect dues", WhatsApp, call.
- [ ] **Expense tab** `expense_page.dart`: day/month list, categories, **Add Expense** sheet (amount, category, mode, note, optional photo via `image_picker`),
  edit/cancel with reason. **Cash drawer card**: open shift (opening cash), live expected cash, close shift (counted cash, variance, note). Uses `/vendor/expenses`, `/vendor/cash-shifts`.
- [ ] **Report tab** `report_page.dart`: Today / 7 days / month / custom; revenue, collection, dues, orders by status, payment mix (Cash/Online/Wallet),
  top garments, expense vs income; simple charts (reuse chart lib already in project or add one lightweight dependency — justify in PROGRESS.md);
  **Export / Share CSV** via `/vendor/pos/counter-sales/export`; finance overview from `/vendor/finance/overview`.
- [ ] **POS Settings** `pos_settings_page.dart`: shop profile, tax/GST, UPI, order-number series, printer profile, charges & discounts (list/enable), price list shortcut
  + "Sync from LNDRY", team (staff list; add staff uses existing employees module + permission picker), language (en / हिन्दी / Hinglish), theme (light/dark/system),
  **App mode switch** (from Phase 1), logout, help/support (reuse help page).
- [ ] **WhatsApp**: Home quick action opens a chat chooser (customer search → `wa.me`) with message templates (order booked / ready / delivered / payment due) —
  templates editable later; no WhatsApp Business API in scope.
- [ ] **Notifications**: reuse existing push/local notification pipeline; POS events (online order request, payment received) deep-link into POS screens when in POS mode.

## 4B. Reliability & polish

- [ ] **Offline-safe cart & drafts**: persisted cart, queued "Save Order" retry with idempotency key when the network drops mid-save (show "Saving… will retry"), never double-book.
- [ ] **Session/permissions edge cases**: token refresh mid-flow, owner removes staff while app open, offering revoked while in POS mode → friendly screen + automatic fall back to allowed mode.
- [ ] **Performance**: list virtualization, image caching for garment icons, no rebuild storms (`select` on providers), cold start < 2.5 s on a mid-range Android, scroll at 60 fps in Orders (profile mode check).
- [ ] **Accessibility & "child-simple" audit** against Master Plan §6 checklist: 48 dp targets, text scale 1.3×, contrast ≥ 4.5:1 on all brand/wash pairs, labels on all icons, screen-reader labels, color-not-alone for status.
- [ ] **Localization completeness**: no hard-coded strings (grep check), Hindi and Hinglish reviewed for every new key; number/date formatting per locale.
- [ ] **Security**: no tokens or customer PII in logs (`pretty_dio_logger` debug only), secure storage for tokens (existing), screenshots of invoices not cached publicly, URL launcher inputs sanitized.
- [ ] **Docs**: update `README.md` (modes, onboarding, how to run POS mode), `CLAUDE.md`, backend `API_REFERENCE.md`, short user guide `docs/pos-mode/USER-GUIDE.md` with the 6 tabs in plain words.

## 4C. Release readiness

- [ ] Turn on `ENFORCE_OFFERING` **only after**: (a) staging log shows zero unexpected would-block events for existing Epic users, (b) you approve. Document rollback (flip env flag).
- [ ] Android release build with `--dart-define=FLAVOR=production` (README warns about silent fallback to development); iOS build if signing available.
- [ ] Version bump in `pubspec.yaml`, changelog, upload through the existing **App Releases** page in the admin dashboard (`/app-releases`) with staged rollout.
- [ ] Smoke test on the production API with a test vendor (not real customer data).

## 4D. Tests & QA

- [ ] Unit/widget tests for every new screen (loading/empty/error/data), report maths, CSV export, cash-shift variance, expense validation, offline retry queue.
- [ ] `integration_test/pos_flow_test.dart`: onboarding → book → pay → deliver → expense → close shift → report numbers reconcile.
- [ ] Backend: full `npm test`; reconcile report totals vs raw SQL on seeded data.
- [ ] **Device QA checklist** (record results in PROGRESS.md): 360×640 phone, large phone, tablet portrait; Android 10+ ; Hindi; dark mode; 1.3× font; slow 3G; airplane mode mid-save; rotate; kill & resume app; switch Marketplace↔POS ×10 without logout; staff user with limited permissions; rider account cannot enter POS.
- [ ] Regression: marketplace flow (accept order, rider jobs, pricing, slots) unchanged.

## Definition of done

- All six bottom tabs work with real data; Marketplace mode untouched.
- Report totals equal the sum of orders/expenses in the database (spot-check 3 days).
- QA checklist complete; no P0/P1 open; `flutter analyze` clean; backend + dashboard + Flutter tests green or each skipped item justified.
- Release build produced and uploaded (or exact blocker recorded).
- `PROGRESS.md` shows all phases ✅; final summary of known limitations.

## Verify

```bash
cd ../Lndry_backend && npm run lint && npm test
cd ../Lndry_dashboard_frontend && npm run lint && npx vitest run && npx tsc --noEmit
cd ../Lndry_vendor_app && flutter analyze && flutter test && flutter test integration_test && flutter build apk --release --dart-define=FLAVOR=production
```

## Out of scope
Multi-store switching, subscription billing/payments, WhatsApp Business API automation, full offline order sync, marketplace UI redesign.
