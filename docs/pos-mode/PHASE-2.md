# Phase 2 — Counter Core: Home · Book Order · Customers · Price List

**Goal:** the shop owner can open POS Home, see real numbers, add a customer, add a garment price and **book a complete
order with a price quote**. Screens 1, 2 and 5 of the screenshots.

**Needs Phase 1 complete.** Repos: `Lndry_vendor_app` (main), `Lndry_backend` (small additions).
Reference implementation for API shapes: `epic-laundry-desktop/webapp/src/lib/webAdapters/{dashboard,catalogue,orders,quote}.ts` (read-only).

## 2A. Backend additions (`Lndry_backend`)

- [ ] **Migration `153_counter_order_delivery_flags.sql`**: `store_orders.delivery_mode` (`WALK_IN|HOME_DELIVERY|PICKUP`, default `WALK_IN`),
  `store_orders.is_express boolean default false`. Idempotent. (Screenshot 2/3 toggles: Home Delivery · Pickup order · Express Delivery.)
- [ ] `vendor-counter-orders.service.js`: accept `deliveryMode`, `isExpress` in `book()`, `update()`, include in order shape + list filters
  (`?deliveryMode=`, `?express=true`). Express applies the vendor's express charge rule from `vendor-adjustment-rules` if one exists (do **not** invent a price).
  Keep wallet/`vendor_type` logic untouched.
- [ ] `vendor-pos-dashboard.service.js`: extend `GET /vendor/pos/dashboard` with the Home tiles (all vendor-scoped, read-only, one query each, indexed):
  `todayRevenuePaise`, `todayCollectionPaise`, `onlineOrderRequests` (pending marketplace orders for this vendor), `washingToStore`
  (production tasks done, not yet shelved), `bookingsToday`, `deliveriesToday`, `deliveredToday`, `pendingOrders`,
  `unassignedPickups`, `upcomingDeliveries`, `unassignedDeliveries`, `expressOrders`, `collectionDuePaise` (sum of balances).
  **First check each metric against existing columns; if one cannot be computed truthfully, return `null` and note it in PROGRESS.md — never fake a number.**
- [ ] Tests: new fields round-trip; filters; dashboard numbers against seeded fixtures (incl. empty vendor → zeros, other vendor's data never leaks);
  existing counter-order tests still pass.
- [ ] `API_REFERENCE.md` updated.

## 2B. Flutter data layer (`lib/models/pos`, `lib/repositories/pos`)

- [ ] freezed models: `PosDashboard`, `PosCustomer`, `PosCatalogue` (`PosGarment`, `PosCategory`, `PosService`, `PosUnit`, `PosPrice`, `PosTaxRule`),
  `OrderDraft`/`CartLine`, `Quote` (items, charges, discount, other, tax, grandTotal — all **paise ints**), `PaymentMode`, `DeliveryMode`.
- [ ] `lib/features/pos/core/money.dart`: paise↔rupee, `₹1,23,456` Indian grouping, unit-tested (no floating-point money).
- [ ] Repositories (interface + dio impl): dashboard, customers (list/search/create), catalogue (get/sync/create garment|category|service|price|unit),
  charges/discounts (read), `quote()`, `book()`.
- [ ] All calls through the existing dio client; map backend `{success,data}`/`{success:false,code,message}` to existing `ApiException`; show backend messages to the user.

## 2C. Flutter screens

- [ ] **POS Home** `pos_home_page.dart` (screenshot 1): pull-to-refresh; two KPI cards (4 tiles each; tapping a tile opens Orders pre-filtered);
  Quick Actions grid (Book Order primary, WhatsApp, Add New Customer, Add Garment Price); task list rows with colored dot + count + chevron → filtered Orders;
  plan card from `/vendor/app-mode` (hidden if no plan). Loading skeletons, error card with Retry, "No orders yet" empty state.
- [ ] **Customer picker + Add Customer sheet** (`customer_picker.dart`, `add_customer_sheet.dart`): search by name/phone, create with name + phone (10-digit
  validation), recent customers; uses `POST /vendor/counter/customers` (find-or-create).
- [ ] **Book Order** `book_order_page.dart` (screenshot 2):
  customer + delivery date header → 3 toggles → service chips (from catalogue) → category chips → search + "+" → garment grid with − qty + (price shown per
  selected service) → "Selected Garments" cart (qty stepper, edit price, delete) → totals card (Items, Charge, Discount, Other, Tax, **Grand Total**)
  → payment (Cash / Online / Wallet\* / Pay Later) → Remarks → **Save Order**.
  \*Wallet only if `walletAccess`; otherwise hidden (never shown-then-error).
  Live quote: debounce 300 ms → `POST /vendor/counter/orders/quote`; the **server total is the only total shown** (no client-side tax math).
  Draft cart persisted locally (Hive/shared_prefs) so a call or app switch never loses it. Duplicate-tap protection on Save (idempotency key header, see `cors-idempotency.test.js`).
  After save → success sheet: order number, balance, buttons **View Order** / **Book Another**.
- [ ] **Add Garment Price sheet** `add_garment_price_sheet.dart` (screenshot 5): pickers Garment / Category / Service / Unit each with inline "+" create,
  Price field (₹, validation > 0), Add. Requires `vendor_services.create|update` permission — hide the entry point for staff without it (use `myAccessProvider`).
- [ ] Wire Home quick actions and the bottom-nav "Order" tab FAB to Book Order.
- [ ] l10n (en/hi/hi_Latn) for all strings; empty/error/loading states everywhere.

## 2D. Tests

- [ ] Unit: money formatting/rounding, cart math helpers (qty only — totals come from server), quote parsing, dashboard parsing with nulls, delivery-mode mapping.
- [ ] Provider tests with `mocktail` repos: quote debounce, draft restore, save success/failure, permission hiding.
- [ ] Widget tests: Home (loading/empty/data/error), Book Order (add/remove garment, toggles, payment options with/without wallet, Save disabled when cart empty).
- [ ] Backend contract script `scripts/pos-smoke.sh` (or `.mjs`): OTP login → onboarding complete → create customer → add price → quote → book → fetch order → dashboard shows booking.
- [ ] Manual: book 3 different orders (walk-in, home delivery, express) against local backend; compare Grand Total with Epic desktop for the same cart — **must match to the paisa**.

## Definition of done

- POS Home numbers match the database for a seeded vendor; empty vendor shows zeros, not errors.
- A full order is booked from the phone and appears in the Epic desktop/website order list for the same vendor with the same total.
- Add Garment Price creates a price that immediately appears in the Book Order grid.
- Staff without catalogue permission cannot see "Add Garment Price".
- Backend + Flutter tests green or honestly marked; `PROGRESS.md` updated; commits pushed.

## Verify

```bash
cd ../Lndry_backend && npm run lint && npm test
cd ../Lndry_vendor_app && flutter analyze && flutter test test/pos && node ../Lndry_backend/scripts/pos-smoke.mjs   # local API running
```

## Out of scope
Orders list/detail/payments after booking (Phase 3), expenses/reports (Phase 4), CSV import UI, barcode scanning.
