# LNDRY Vendor App — POS Mode: Master Plan

> Source of truth for the whole initiative. Phase detail lives in `PHASE-1.md` … `PHASE-4.md`.
> Live status lives in `/PROGRESS.md`. Rules for every session live in `/CLAUDE.md`.

## 1. What we are building (plain words)

The LNDRY Vendor App today is a **marketplace** app: customers book through the LNDRY customer app,
and the shop owner handles those orders here.

We already built a full **POS / CRM** for the counter ("Epic Laundry" — website + Windows/Mac software)
and the backend already has the POS APIs. We now bring the POS **inside the Flutter vendor app** as a
second **mode**, so a shop owner can run the counter from their phone.

Two things are separate and must stay separate:

| | Marketplace mode (today's UI) | POS mode (new) |
|---|---|---|
| Who | Laundry vendors who get customers from the LNDRY customer app | Shops that want billing + CRM for their own walk-in customers |
| Orders come from | LNDRY customer app | The shop itself (counter, phone, WhatsApp) |
| Onboarding | Existing 6-step vendor application, admin KYC review, then published | **New, short POS onboarding** (no radius, no KYC documents, no marketplace publishing) |
| UI | Existing screens — **do not change** | New violet POS UI, built from the screenshots |

A vendor can be **Marketplace only**, **POS only**, or **Both**. "Both" vendors switch mode in
**Settings → App mode**. POS-only shops never see marketplace screens (and vice versa).

**Do not touch** the Epic desktop/website software. We only *read* it (it is the reference for screens,
colors and API usage). Same for the existing marketplace screens.

## 2. What already exists (verified in code on 2026-10-10)

**Backend `Lndry_backend` already has the whole POS API** under `/api/v1/vendor/...`:

| Need | Existing endpoint(s) |
|---|---|
| POS dashboard KPIs | `GET /vendor/pos/dashboard`, `GET /vendor/pos/search`, CSV export |
| Customers | `GET/POST /vendor/counter/customers`, `/vendor/customer-profiles`, `/vendor/customer-ledger` |
| Garments / services / prices / taxes | `GET /vendor/pos-catalogue`, `POST|PUT .../garments|services|categories|prices|taxes`, `POST .../sync` |
| Charges & discounts | `/vendor/adjustment-rules/charge|discount` |
| Price quote + booking | `POST /vendor/counter/orders/quote`, `POST /vendor/counter/orders` |
| Order list / detail / edit | `GET /vendor/counter/orders`, `/:id`, `PATCH /:id` |
| Lifecycle | `POST /:id/transition` (BOOKED→PICKED_UP→IN_PROCESS→READY→OUT_FOR_DELIVERY→DELIVERED, CANCELLED), `/:id/cancel`, `/:id/assign` (captain) |
| Payments | `GET/POST /vendor/counter/orders/:id/payments` (Cash / Online / Wallet / Pay Later) |
| Invoices & tags | `/api/v1/invoices/orders/:orderId`, `/generate`, `/pdf` (note: not under `/vendor`); `/vendor/print-jobs`; garment-units, containers |
| Cash drawer, expenses | `/vendor/cash-shifts`, `/vendor/expenses` |
| Reports / finance | `/vendor/finance/overview|statutory`, `/vendor/report-views`, `/vendor/pos/counter-sales/export` |
| Holds, imports, settings | `/vendor/order-holds`, `/vendor/imports`, `/vendor/pos-settings` |
| Walk-in sync + wallet gate | `vendors.vendor_type` (STANDARD / PARTNER / EXCLUSIVE) + `GET /vendor/counter/access` |
| Auth | Phone + OTP (`/auth/send-otp`, `/verify-otp`, `/refresh-token`, `/my-roles`), roles VENDOR_OWNER / STAFF / RIDER |

The Epic web app already calls these same endpoints (`epic-laundry-desktop/webapp/src/lib/webAdapters/*.ts`) —
that is our **working contract reference**. Flutter calls the same endpoints; we do not invent a second API.

**Flutter `Lndry_vendor_app`**: Riverpod + go_router + dio + freezed, feature-first folders, design tokens in
`lib/core/design`, l10n (en / hi / hi_Latn), bottom-nav shell (`vendor_router.dart`), 6-step onboarding
(`vendor_application_page.dart`), settings page, permission model (`access_provider.dart`).

**Dashboard `Lndry_dashboard_frontend`** (admin, Next.js): vendor list/detail already shows and sets `vendor_type`.

## 3. What is missing (the real work)

1. **No "offering/mode" concept.** Nothing says whether a vendor is Marketplace, POS or Both, and there is
   no POS onboarding. → backend entitlement + onboarding endpoints (Phase 1).
2. **No mode switch in the app** and no POS UI. → Flutter mode plumbing + POS shell (Phase 1), screens (2–4).
3. **Counter orders have no home-delivery / pickup / express flags** (screenshot 2 & 3 show them). Only rider
   assignment exists. → small backend migration (Phase 2).
4. **Plan/subscription card** on Home ("Enterprise 5 Store, ₹30000/year, valid to 03-Nov-2026"). → add
   `pos_plan_name`, `pos_valid_to` to the entitlement; admin sets it manually. **No billing integration in scope.**
5. Home tiles "Order Request", "Washing Area to Store", "Unassigned Pickups/Deliveries", "Collection Amount" —
   verify each can be computed from existing tables; add read-only aggregate fields to `/vendor/pos/dashboard`
   where not (Phase 2).

## 4. The mode model

### 4.1 Backend (entitlement = what the vendor is *allowed* to use)

New columns on `vendors` (migration `152_vendor_offering.sql`, idempotent like `143_vendor_types.sql`):

| Column | Values | Meaning |
|---|---|---|
| `offering` | `MARKETPLACE` \| `POS` \| `BOTH` | What the admin/vendor activated. **Backfill (see 4.1a): existing vendors that already use POS → `BOTH`; all others → `MARKETPLACE`.** |
| `pos_onboarding_status` | `NOT_STARTED` \| `IN_PROGRESS` \| `COMPLETED` | Progress of the POS setup wizard |
| `pos_plan_name`, `pos_valid_to` | text, date | Shown on POS Home card; set by admin |

New endpoints (vendor-scoped, owner only for writes):

| Endpoint | Purpose |
|---|---|
| `GET /api/v1/vendor/app-mode` | `{ offering, posOnboardingStatus, posPlanName, posValidTo, vendorType, appSync, walletAccess, allowedModes: ["MARKETPLACE","POS"] }` |
| `POST /api/v1/vendor/pos-onboarding/start` | Marketplace vendor asks for POS, or a brand-new POS-only user starts. Creates the `vendors` row if needed (`offering=POS`, not published, no KYC). |
| `PATCH /api/v1/vendor/pos-onboarding` | Save wizard step (business, tax/GST, UPI, printer, opening setup) |
| `POST /api/v1/vendor/pos-onboarding/complete` | Mark complete; seeds default catalogue (garments/services/prices) via existing `pos-catalogue/sync` or starter pack |
| `PATCH /api/v1/vendors/admin/:id/offering` | Admin sets offering / plan / validity (audited, like `adminSetVendorType`) |

#### 4.1a Do-not-break rule (important)

Today the backend lets **every** vendor call POS routes, and shops already run the Epic desktop/website POS on them.
So the migration must not lock anyone out:

- Backfill: a vendor with any counter order (`store_orders.source = 'COUNTER'`), POS catalogue row or cash shift →
  `offering='BOTH'`, `pos_onboarding_status='COMPLETED'`. Every other existing vendor → `MARKETPLACE`.
- Enforcement is behind env flag **`ENFORCE_OFFERING`** (default **`false`**). While off, the guards only *log*
  what they would have blocked. We turn it on only after checking that log on staging/production and getting your OK.
- Epic desktop/website are never modified; if one ever hits `POS_NOT_ENABLED` the flag goes back off.

`offering` is **enforced by the backend** (when `ENFORCE_OFFERING=true`): POS routes (`/vendor/counter/*`, `/vendor/pos*`, …) return `403 POS_NOT_ENABLED`
when `offering = MARKETPLACE`; marketplace routes return `403 MARKETPLACE_NOT_ENABLED` when `offering = POS`.
The app only decides what to *show*; the server decides what is *allowed* (same principle as `vendor_type`).

> `vendor_type` (STANDARD/PARTNER/EXCLUSIVE) is a **different axis** and stays as is: it only says whether POS walk-in
> sales sync to the customer's LNDRY app and whether the LNDRY wallet works at the counter.
> POS-only vendors are created as `STANDARD` (least access) until an admin promotes them.

### 4.2 Flutter (selected mode = what the user is *currently using*)

- `AppMode { marketplace, pos }` stored per device with `shared_preferences` (key `app_mode_v1`), validated
  against `allowedModes` from `/vendor/app-mode` on every launch/login.
- `appModeProvider` (Riverpod) → `vendor_router.dart` picks the shell: marketplace shell (unchanged) or **POS shell**.
- Rules: `MARKETPLACE`-only → no switch shown. `POS`-only → no switch shown, POS shell always.
  `BOTH` → **Settings → App mode** switch (Marketplace / POS), remembers last choice.
- Marketplace vendor without POS sees **Settings → "Get POS for my shop"** → starts POS onboarding.
- Switching mode never logs out and never loses a draft cart.

### 4.3 Onboarding paths

```
Login (phone + OTP)
 └─ GET /auth/my-roles + GET /vendor/app-mode
     ├─ no vendor yet ─────────► "What do you need?"  [ Get customers (Marketplace) ]  [ Run my shop (POS) ]  [ Both ]
     │                              ├─ Marketplace → existing 6-step vendor application (unchanged)
     │                              └─ POS / Both  → POS onboarding (below)
     ├─ offering=MARKETPLACE ───► marketplace shell (unchanged)
     ├─ offering=POS, onboarding incomplete ─► POS onboarding (resume)
     └─ offering=POS|BOTH, complete ─► POS shell (or last chosen mode)
```

**POS onboarding wizard (4 short steps, ~3 minutes):**
1. **Shop details** – shop name, owner name, phone (prefilled), address, city
2. **Tax & payments** – GST on/off + GSTIN, UPI ID, currency (INR), invoice prefix
3. **Counter setup** – printer profile (58/80 mm / none), order-number series, default delivery days
4. **Start price list** – "Use LNDRY starter price list" (default) or "I will add my own" (+ CSV import later)
→ Done screen: "Your shop is ready. Book your first order." → POS Home.

No documents, no service radius, no admin review, not listed in the customer app.

## 5. POS UI — screens derived from the 5 screenshots

The screenshots are a competitor-style mobile POS used as a **layout reference**. We copy the *workflow and
information layout*, but use **our own look** (section 6), our own icons/labels, and plain-language wording.

| # | Screenshot | Our screen | Key elements |
|---|---|---|---|
| 1 | Home | **POS Home** | Two KPI cards of 4 tiles: Today Revenue, Collection, Order Request, Washing→Store; Booking, Delivery, Delivered, Pending Orders. **Quick Actions**: Book Order (primary), WhatsApp, Add New Customer, Add Garment Price. Task list with counts: Unassigned Pickups, Upcoming Deliveries, Unassigned Deliveries, Express Delivery, Order Request, Collection Amount. Plan card (name, ₹/year, valid-to). Bottom nav: **Home · Order · Search · Expense · Report · Setting** |
| 2 | Order & Billing | **Book Order** | Customer picker (name+phone, add new), delivery date, toggles Home Delivery / Pickup / Express; service chips (Dry Cleaning, Wash & Fold, Wash & Steam Iron, …); category chips (All, Men, Women, Household, …); garment search + "+" add garment; **garment grid with − qty +**; Selected Garments cart (edit price / delete); totals row (Items, Charge, Discount, Other, Tax) + **Grand Total**; Payment (Cash / Online / Wallet / Pay Later); Remarks; **Save Order** |
| 3 | Order detail | **Order Detail** | Customer + call/profile/wallet icons; order code; status + **Process Order** (next state); progress timeline Booked → Processed → Done → Delivered → Complete with %; Quick actions: Pay Now, View Invoice, Mini Invoice, Tag, Edit Order, Cancel Order; Order Info (home delivery/pickup, order no, invoice amount, paid, balance, booking & delivery date); Payment status; Garment info list with per-garment status; WhatsApp floating button |
| 4 | Customer Orders | **Orders** | Tabs: Booked / In Process / Done; Select-all, Filter, Search (name/phone/order no); order cards (code, order no, customer, status chip, expand) |
| 5 | Add Garment Price | **Add Garment Price** (bottom sheet) | Garment, Category, Service, Unit pickers each with "+" to create inline; Price; Add |

State names shown to the user ↔ backend:

| User sees | Backend `status` |
|---|---|
| Booked | `BOOKED` (and `PICKED_UP`) |
| Processed | `IN_PROCESS` |
| Done | `READY` |
| Delivered | `OUT_FOR_DELIVERY` → `DELIVERED` |
| Order Complete | `DELIVERED` **and** `paymentStatus = PAID` |
| Cancelled | `CANCELLED` |

## 6. Visual design — "my POS desktop color", easy for anyone

Colors come from Epic POS (`epic-laundry-desktop/webapp/src/index.css`, `tailwind.config.ts`) — **not** the blue
of the reference screenshots.

| Token | Hex | Use |
|---|---|---|
| `posBrand` | `#664CF0` | Primary buttons, active tab, links |
| `posBrandStrong` | `#5138CF` | Pressed state, header |
| `posBrandWash` | `#F0EDFF` | Selected chip / tile background |
| `posBrandMist` | `#E3DDFF` | Dividers on brand areas |
| `posCanvas` | `#F8F7FC` | Screen background |
| `posPaper` | `#FFFEFE` | Cards |
| `posInk` | `#241A45` | Headings |
| `posCopy` | `#4F4A62` | Body text |
| `posMuted` | `#767086` | Hints |
| `posLine` | `#E5E0F2` | Card borders |
| `posSuccess` / wash | `#187B5C` / `#E9F7F1` | Paid, Done, Delivered |
| `posAttention` / wash | `#A96916` / `#FFF3D7` | Icons, borders, fills for Pending / Balance due |
| `posDanger` / wash | `#DC2626` / `#FEF2F2` | Icons, borders, fills for Cancel / errors |
| `posAttentionText` | `#8A5412` | **Words** on attention wash/paper (5.67:1). Epic's own `#A96916` is only 4.04:1 on its wash |
| `posDangerText` | `#B91C1C` | **Words** on danger wash/paper (5.91:1). Epic's own `#DC2626` is only 4.41:1 on its wash |
| Dark: canvas / paper / brand | `#14121C` / `#201E2A` / `#B8AAFF` | Dark theme |

Font: **Manrope** (same as desktop POS) via `google_fonts`.

"Any child can understand" rules (enforced in review):
- One main action per screen, as a big (min 48 dp) filled button at the bottom.
- Every icon has a text label. No icon-only buttons except back/close/search.
- Short words: "Save Order", "Add Customer", "Collect Payment" — no accounting jargon.
- Money always `₹1,234` with the balance in amber/red, paid in green.
- Status always shown as colored chip **plus** word (not color alone).
- Empty states say what to do next ("No orders yet. Tap **Book Order**.").
- English + Hindi (+ Hinglish) strings for every new label (`app_en.arb`, `app_hi.arb`, `app_hi_Latn.arb`).
- Works one-handed: primary actions in the bottom 40% of the screen.

## 7. Code layout (Flutter)

```
lib/features/pos/
  core/        pos_theme.dart, pos_colors.dart, pos_shell.dart, pos_providers.dart, pos_api.dart (dio wrapper), money.dart
  mode/        app_mode.dart, app_mode_provider.dart, app_mode_repository.dart, mode_switch_tile.dart
  onboarding/  pos_choice_page.dart, pos_onboarding_page.dart (4 steps), pos_onboarding_provider.dart
  home/        pos_home_page.dart, widgets/kpi_card.dart, quick_actions.dart, task_list.dart, plan_card.dart
  booking/     book_order_page.dart, garment_grid.dart, cart_panel.dart, totals_card.dart, payment_picker.dart,
               add_garment_price_sheet.dart, customer_picker.dart
  orders/      pos_orders_page.dart, pos_order_detail_page.dart, order_timeline.dart, order_actions.dart, payment_sheet.dart
  customers/   customers_page.dart, customer_detail_page.dart, add_customer_sheet.dart
  search/      pos_search_page.dart
  expense/     expense_page.dart, add_expense_sheet.dart, cash_shift_card.dart
  report/      report_page.dart (day / week / month, payment mix, top garments, CSV share)
  settings/    pos_settings_page.dart (mode switch, shop, tax, printer, order series, team, language)
lib/models/pos/        freezed models (counter_order, pos_customer, pos_garment, pos_price, quote, payment, cash_shift, expense, app_mode)
lib/repositories/pos/  abstract + api implementations
```

Rules: reuse `dio_client_provider`, existing auth interceptor and token refresh; **do not** fork networking.
Keep marketplace code untouched except: router (`vendor_router.dart`), settings entry, login/onboarding redirect.

## 8. Testing strategy

| Layer | How | Where |
|---|---|---|
| Backend unit/integration | `vitest` (existing). New tests per endpoint: entitlement guard, onboarding steps, admin offering change, 403 codes, migration idempotency, existing vendors default to MARKETPLACE | `Lndry_backend/tests/unit`, `tests/integration` |
| Backend contract smoke | Run the API locally (Postgres + Redis via `npm run setup:local`), `curl`/script the full flow: OTP login → POS onboarding → quote → book → pay → transition → report | `scripts/` |
| Flutter unit | Riverpod providers, mode rules, money formatting, order-state mapping, quote parsing (`flutter_test`, `mocktail`) | `test/pos/` |
| Flutter widget | Each screen: loading / empty / error / data; mode switch; onboarding validation (`test/pos/…`) | `test/pos/` |
| Router tests | Redirect matrix: (offering × onboarding status × selected mode × signed-in) → expected shell | `test/pos/router_mode_test.dart` (pattern: existing `session_expiry_test.dart`) |
| Flutter integration | `integration_test` against local backend: full day flow | `integration_test/pos_flow_test.dart` |
| Dashboard | `vitest` + Playwright already configured; test offering control on vendor detail | `Lndry_dashboard_frontend/src/__tests__` |
| Manual device QA | Android phone + small-screen (360×640) + Hindi + dark mode checklist in `PHASE-4.md` | — |

**Environment note (2026-10-10):** the cloud sandbox used for planning has Node 22 and psql but **no Flutter/Dart SDK**.
Phase work that needs `flutter test` must either install the SDK first (`/pos-next` step 0 checks and tries; see
`CLAUDE.md`) or be marked **"written, not run"** in `PROGRESS.md` — never claim Flutter tests passed if they were not run.

## 9. Phases at a glance

| Phase | Name | Outcome you can see |
|---|---|---|
| **1** | Foundation: modes + POS onboarding | Admin can set a vendor to POS/Both; app asks "Marketplace or POS?"; POS onboarding wizard works; Settings has the mode switch; empty violet POS shell with bottom nav |
| **2** | Counter core: Home + Book Order + Customers + Price list | POS Home with real numbers; book a full order end-to-end; add customer; add garment price |
| **3** | Order lifecycle: Orders, Detail, Payments, Invoice, Tags | Orders list with tabs; move order Booked→Delivered; take payments; share invoice/mini invoice; tags; edit/cancel |
| **4** | Money, Reports, Polish & Release | Expense + cash drawer; reports; search; WhatsApp; Hindi; offline-safe cart; QA; release build |

Each phase ends with: tests green (or honestly marked), `PROGRESS.md` updated, commit pushed to
`claude/laundry-vendor-pos-modes-bs0o61` on every repo touched.

## 10. Assumptions to confirm (defaults chosen so work is never blocked)

1. **POS-only signup is self-serve in the app** (user picks "Run my shop (POS)" at first login). Default plan = trial/none; admin sets plan & validity later.
2. **Marketplace vendor adding POS is self-serve** (Settings → Get POS) and activates immediately; admin can revoke. *(Alternative: admin approval first — a one-line change in Phase 1.)*
3. **POS-only vendors are `STANDARD`** vendor_type (no customer-app sync, no LNDRY wallet) until admin promotes.
4. **No billing/payment gateway** for POS subscription in this scope — admin sets plan name/validity.
5. **Single branch per vendor** in the app for now (screenshot shows "Enterprise 5 Store" plan, but multi-store switching is out of scope).
6. **Printing** = share PDF / thermal-printer via system share first; direct Bluetooth ESC/POS printing is optional in Phase 4.
7. **Offline**: cart/draft survives app restart and flaky network in Phase 4; full offline order sync (like Epic desktop) is out of scope.
