# Phase 1 — Foundation: Modes + POS Onboarding

**Goal:** a vendor can be Marketplace, POS or Both; the app knows it; POS-only/new shops can onboard; "Both" vendors
can switch mode in Settings; an empty violet POS shell opens. **No real POS screens yet.**

**Repos touched:** `Lndry_backend` (main), `Lndry_vendor_app` (main), `Lndry_dashboard_frontend` (small).
**Branch (all repos):** `claude/laundry-vendor-pos-modes-bs0o61`.
Read first: `00-MASTER-PLAN.md` §4 (mode model), §6 (colors). Do not edit existing marketplace screens beyond what is listed.

## 1A. Backend (`Lndry_backend`)

- [ ] **Migration `src/database/migrations/152_vendor_offering.sql`** (idempotent `DO $$ … IF NOT EXISTS`, style of `143_vendor_types.sql`):
  `vendors.offering` (`MARKETPLACE|POS|BOTH`, CHECK, default `MARKETPLACE`), `pos_onboarding_status`
  (`NOT_STARTED|IN_PROGRESS|COMPLETED`, default `NOT_STARTED`), `pos_plan_name text`, `pos_valid_to date`,
  `pos_onboarding_data jsonb default '{}'`. Backfill per Master Plan §4.1a (existing POS users → `BOTH` + `COMPLETED`).
  Check the highest existing migration number first; renumber if `152` is taken.
- [ ] **Module `src/modules/vendor-app-mode/`** (4-file shape: routes/service/repository/schema; see `docs/ARCHITECTURE.md`):
  - `GET /api/v1/vendor/app-mode` – any non-rider roster member; `Cache-Control: no-store`. Returns
    `{ offering, posOnboardingStatus, posPlanName, posValidTo, vendorType, appSync, walletAccess, allowedModes }`
    (`allowedModes` derived from offering **and** onboarding: POS appears only when `COMPLETED`).
  - `POST /api/v1/vendor/pos-onboarding/start` – any authenticated user. If the user has no vendor: create `vendors` row
    (`offering='POS'`, `vendor_type='STANDARD'`, **not published, no application/KYC**) + owner roster record
    (`vendor_employees`, role `VENDOR_OWNER`). If they already have a marketplace vendor: set `offering='BOTH'`,
    `pos_onboarding_status='IN_PROGRESS'`. Idempotent.
  - `PATCH /api/v1/vendor/pos-onboarding` – owner only; body validated **in the service** (the app's AJV uses
    `removeAdditional:'all'`, so free-form bodies must not rely on route schemas). Steps: `shop`, `tax`, `counter`, `pricelist`.
    Stores into `pos_onboarding_data` and the real settings (`vendor-pos-settings` keys, tax rules via `pos-catalogue`).
  - `POST /api/v1/vendor/pos-onboarding/complete` – owner; validates required fields (shop name, owner name; GSTIN format
    only when GST is on); applies starter price list if chosen; sets `COMPLETED`; writes audit event.
  - `PATCH /api/v1/vendors/admin/:id/offering` – admin permission, body `{ offering, pos_plan_name?, pos_valid_to? }`,
    audited like `adminSetVendorType` (`vendors.service.js:1589`). `offering` must **not** be settable through the vendor's
    own profile update (mirror `delete data.vendor_type`, `vendors.service.js:69`).
- [ ] **Guards (flagged):** middleware `requireOffering('POS'|'MARKETPLACE')` applied to POS route groups and marketplace route
  groups; behind `ENFORCE_OFFERING` env (default false → log only). Add the var to `src/config/env.js` and `.env.example` if present.
- [ ] Register routes in `src/app.js` next to the other `/api/v1/vendor/*` modules.
- [ ] **Tests (vitest)** `tests/unit/vendor-app-mode.test.js` + `tests/integration/vendor-offering.test.js`:
  default offering for a new marketplace vendor; backfill rule; `app-mode` payload per offering × status; start → patch → complete
  happy path; complete with missing fields → 400; non-owner PATCH → 403; rider → 403; admin set offering audited; vendor cannot
  set own offering; guard with flag off (allowed + logged) and on (403 `POS_NOT_ENABLED` / `MARKETPLACE_NOT_ENABLED`); migration runs twice safely.
- [ ] Update `API_REFERENCE.md` with the 5 endpoints.

## 1B. Admin dashboard (`Lndry_dashboard_frontend`)

- [ ] `src/services/vendors.service.ts`: `setVendorOffering(id, {offering, planName, validTo})`.
- [ ] Vendor detail page `src/app/(dashboard)/vendors/[vendorId]/page.tsx` (+ `hooks/useVendorDetail.ts`): "App access" card —
  offering select (Marketplace / POS / Both), POS plan name, valid-to date, onboarding status badge. Mirror the existing
  vendor-type control's look and confirmation dialog. Vendors list: add an "Offering" column/badge.
- [ ] Tests in `src/__tests__` (vitest): service call shape; select disabled while saving; error toast on 4xx.

## 1C. Flutter (`Lndry_vendor_app`)

- [ ] **Theme:** `lib/features/pos/core/pos_colors.dart` (all tokens from Master Plan §6), `pos_theme.dart` (`ThemeData` light+dark,
  Manrope via `google_fonts`, 12–16 dp radii, 48 dp min buttons). Add Manrope to l10n-safe font fallback (Devanagari).
- [ ] **Models** (`lib/models/pos/app_mode_model.dart`, freezed + json, run `build_runner`): `VendorOffering`, `PosOnboardingStatus`, `AppModeInfo`.
- [ ] **Repository** `lib/repositories/pos/app_mode_repository.dart` (+ `api_` impl using the existing dio client): `getAppMode`, `startPosOnboarding`, `savePosOnboardingStep`, `completePosOnboarding`.
- [ ] **State** `lib/features/pos/mode/app_mode_provider.dart`: loads `AppModeInfo` after auth, persists chosen `AppMode`
  (`shared_preferences` `app_mode_v1`), clamps it to `allowedModes`, exposes `setMode()`. Re-fetches on app resume.
- [ ] **Router** `lib/core/router/vendor_router.dart`: add POS routes (`/pos/...`) + redirect rules per Master Plan §4.3;
  extend the exposed redirect function so it stays unit-testable (pattern at `vendor_router.dart:153`). Marketplace shell untouched.
- [ ] **Choice screen** `pos_choice_page.dart` ("What do you need?" 3 big cards) shown only when the signed-in user has no vendor and no application.
- [ ] **POS onboarding** `pos_onboarding_page.dart` — 4 steps from Master Plan §4.3, progress dots, big Next button, inline validation,
  resumes at the first incomplete step, saves per step (draft survives app kill). Finish screen → POS Home.
- [ ] **POS shell** `pos_shell.dart`: bottom nav **Home · Order · Search · Expense · Report · Setting**; each tab is a placeholder
  "Coming in Phase N" using `StatefulShellRoute.indexedStack` like the marketplace shell.
- [ ] **Settings:** add **App mode** section to `settings_page.dart` (marketplace) and `pos_settings_page.dart` (POS): segmented switch
  when `allowedModes.length > 1`; "Get POS for my shop" tile when offering is `MARKETPLACE`. Switch shows a short confirm and keeps the session.
- [ ] **l10n:** all new strings in `app_en.arb`, `app_hi.arb`, `app_hi_Latn.arb`; run `flutter gen-l10n`.
- [ ] **Tests** `test/pos/`: `app_mode_provider_test.dart` (clamping, persistence), `router_mode_test.dart` (full redirect matrix),
  `pos_onboarding_validation_test.dart` (GSTIN, UPI, required fields), `mode_switch_widget_test.dart`, `pos_shell_test.dart`.

## Definition of done

- A marketplace vendor's app looks and behaves exactly as before (regression: existing `test/` suite still passes).
- Admin sets a vendor to **Both** → vendor reopens app → Settings shows the switch → switching shows the POS shell and back.
- A brand-new phone number picks **Run my shop (POS)** → finishes 4 steps → lands on the POS shell; a `vendors` row exists with `offering=POS`, not published.
- Backend tests green; Flutter tests green **or** explicitly recorded as "written, not run" with the reason.
- `ENFORCE_OFFERING` is **off** and documented; Epic POS endpoints behave exactly as before.
- `PROGRESS.md` updated; commits pushed on every touched repo.

## Verify (run these)

```bash
# backend
cd ../Lndry_backend && npm run lint && npx vitest run tests/unit/vendor-app-mode.test.js tests/integration/vendor-offering.test.js && npm test
# dashboard
cd ../Lndry_dashboard_frontend && npm run lint && npx vitest run && npx tsc --noEmit
# flutter
cd ../Lndry_vendor_app && flutter pub get && dart run build_runner build --delete-conflicting-outputs && flutter gen-l10n && flutter analyze && flutter test
```

## Out of scope
Real POS screens, subscription billing, multi-store switching, changing marketplace UI.

---

## As built (2026-10-10) — differences from the plan above and facts learned

**Backend**
* Admin endpoint is **`PUT /api/v1/vendors/admin/:id/offering`** (mirrors `vendor-type`), not PATCH. Body `{offering, pos_plan_name?, pos_valid_to?}`.
* Contract doc is **`Lndry_backend/docs/vendor-app-mode.md`** (the repo's `API_REFERENCE.md` only covers the old customer API).
* Vendor detail/list reads (`findById`, `findMany`, `update` return) now include `offering, pos_onboarding_status, pos_plan_name, pos_valid_to`; the dashboard needs them.
* `pos_valid_to` is selected `::text`. A Postgres `DATE` arrives as a JS `Date` at local midnight; on an IST server `toISOString()` shows the **previous day** (reproduced: 2026-11-03 → 2026-11-02). Never convert a DATE column to a JS Date.
* Backfill treats **any** `store_orders` row as POS use — the Epic desktop pushes orders with `source = 'DESKTOP_PUSH'`, not `'COUNTER'`.
* A calendar-date check must round-trip (`new Date(v).toISOString().slice(0,10) === v`): `Date.parse('2026-02-31')` does not fail.
* A user who already has a marketplace *application* cannot start a POS-only shop (`409 MARKETPLACE_APPLICATION_EXISTS`) — a second shop would make login ambiguous. A POS-first user adding Marketplace later is **not** supported yet (support/admin task).
* `ENFORCE_OFFERING` is OFF. With it ON the guard was verified: POS-only vendor → marketplace routes `403 MARKETPLACE_NOT_ENABLED`; POS routes, `/vendor/app-mode`, unauthenticated 401 unaffected.
* Wizard answers live in `vendors.pos_onboarding_data`; only shop name/owner/address and GSTIN are mirrored into real columns. They are **not** written into `vendor_pos_settings` (Epic-owned shapes) — map them when the POS settings screens are built (Phase 4).

**Flutter**
* Plain Dart models (no freezed codegen) for the new types.
* Two extra routes: `/choose-product` (first-run) and `/mode-check` (spinner until the backend answers so the wrong UI never flashes). A failed/old backend → falls back to Marketplace.
* `vendorRedirectForTest(..., appMode:)` has an optional `appMode`; `null` = old behaviour, so existing tests keep their signature.
* Staff of a BOTH shop can use the mode switch; "Get POS" / "Finish POS setup" are owner-only.
* Saved mode is keyed per vendor (`app_mode_v1:<vendorId>`); the "I chose Marketplace" flag is keyed per phone.
* Theme: Epic's `attention` (#A96916) and `danger` (#DC2626) fail 4.5:1 for words on their washes → added `attentionText` / `dangerText`. Material derives tab icons, segmented buttons and progress tracks from `secondaryContainer`; left unset it rendered a **green progress track and white-on-pale tab icons** — pinned to the brand wash and guarded by `pos_colors_test.dart`.
* `ModeSwitchSection` also lives in the **marketplace** Settings page (top of the list); it renders nothing unless it applies.

**Verified end to end (real Chromium + real Flutter web build + real backend + real Postgres):** new phone → OTP → choice → POS shop created → 4-step wizard (with validation) → starter price list → POS Home → tabs → logout → login lands on POS Home. See `LOCAL-TESTING.md`.

