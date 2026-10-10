# Phase 3 — Order Lifecycle: Orders · Detail · Payments · Invoice · Tags

**Goal:** after booking, the owner can find an order, push it through Booked → Processed → Done → Delivered, collect payment (full/part),
share invoices, print/share tags, edit or cancel. Screens 3 and 4 of the screenshots.

**Needs Phase 2 complete.** Repos: `Lndry_vendor_app` (main), `Lndry_backend` (only if a gap is found — record it).
Reference: `epic-laundry-desktop/webapp/src/pages/laundry/LaundryOrders.tsx`, `components/laundry/OrderSummaryPage.tsx`, `webAdapters/orders.ts`, `tracking.ts`.

## 3A. Data layer

- [ ] Models: `CounterOrder` (list + detail: items, per-garment unit status, payments, balance, rider names, delivery mode, express, history events),
  `OrderPayment`, `OrderStatusEvent`, `InvoiceInfo`, `PrintJob`, `GarmentUnit`.
- [ ] `order_state.dart`: single mapping table backend `status`/`paymentStatus` → user label, color, next action
  (Master Plan §5). Unit-tested for every state, incl. "Order Complete" = DELIVERED + PAID.
- [ ] Repositories: `listOrders({status, search, from, to, deliveryMode, express, cursor})`, `getOrder`, `updateOrder`, `transition`, `cancel`,
  `assignCaptain`, `listPayments`, `collectPayment`, invoice `generate/get/pdf` (`/api/v1/invoices/...`), print jobs, garment units.

## 3B. Screens

- [ ] **Orders list** `pos_orders_page.dart` (screenshot 4): tabs **Booked / In Process / Done** (+ "All" and "Delivered" behind a filter), Select-all + bulk "Move to next step",
  Filter sheet (date range, delivery mode, express, payment due, captain), search (name/phone/order no, debounced), infinite scroll, pull-to-refresh,
  expandable card (items, amount, balance), colored status chip + word. Home tile/list-row taps deep-link here with the filter preset.
- [ ] **Order detail** `pos_order_detail_page.dart` (screenshot 3): header (customer name, call button → `url_launcher`, profile, wallet if allowed, order code);
  status row + **Process Order** (label changes per next state; confirms when it would deliver with balance due, offering "Collect payment first");
  **timeline** with % (Booked / Processed / Done / Delivered / Complete + timestamps from status events); Quick Actions grid
  (Pay Now, View Invoice, Mini Invoice, Tag, Edit Order, Cancel Order); Order Info tiles; payment status + last method; Garment list with per-item status
  (expand for service/qty/price); WhatsApp floating button (opens `wa.me` with a friendly pre-filled status message, localized).
- [ ] **Pay Now sheet** `payment_sheet.dart`: shows balance, amount field (defaults to balance, cannot exceed), mode Cash / Online / Wallet\* (\*if `walletAccess`;
  wallet flow uses the existing OTP-confirmed redemption endpoints — reuse `vendor-wallet-redemption` routes, no new money logic), reference/notes, **Collect**.
  Double-tap safe. Success updates paid/balance instantly (re-fetch, don't guess).
- [ ] **Invoice / Mini invoice:** View Invoice → fetch PDF → in-app viewer + Share (WhatsApp/Print via system share). Mini Invoice = compact 58/80 mm layout:
  prefer backend rendering; if backend lacks a mini format, add it there (record in PROGRESS.md) rather than building a second invoice engine in Dart.
- [ ] **Tag:** list garment tags/QR for the order (`/vendor/counter/garment-units`, `/vendor/print-jobs`); create print job; share/print PDF.
- [ ] **Edit Order:** reuse Book Order UI in edit mode → `PATCH /vendor/counter/orders/:id`; blocked for DELIVERED/CANCELLED with the backend's message.
- [ ] **Cancel Order:** reason picker + confirm → `/cancel`; shows refund/credit note result if any.
- [ ] **Assign captain** (pickup/delivery) sheet: list `VENDOR_RIDER` employees → `/assign`. Shown only to roles with permission.
- [ ] Permissions: hide/disable actions via `myAccessProvider`; never rely on hiding alone (backend enforces; show its error message on 403).
- [ ] Real-time: refresh list/detail on app resume and when the existing socket/notification channel signals an order change (reuse `socket_io_client` wiring).

## 3C. Tests

- [ ] Unit: `order_state` mapping (every status × payment status), timeline progress %, balance maths from server fields, wa.me message builder.
- [ ] Provider tests: list filters/pagination, transition success/failure (INVALID_TRANSITION, ORDER_CLOSED), payment collect (partial/full/over-balance rejected).
- [ ] Widget tests: Orders tabs & empty states, Detail for each status (button label + enabled actions), Pay sheet validation, Cancel confirm.
- [ ] Backend: if any endpoint was added/changed → vitest + `API_REFERENCE.md`.
- [ ] Contract script extended: book → part-pay → transition ×4 → deliver blocked while unpaid → pay → deliver → invoice PDF returns 200 → events recorded.
- [ ] Manual: same order viewed on Epic desktop and phone shows identical status, paid, balance after each step.

## Definition of done

- Complete order life (book → deliver → paid → invoice) works from the phone only, with correct balances at every step.
- Every action respects permissions and shows backend error text in plain language (no raw codes shown to the user).
- Home tiles deep-link into the right filtered list.
- Tests green or honestly marked; `PROGRESS.md` updated; commits pushed.

## Verify

```bash
cd ../Lndry_vendor_app && flutter analyze && flutter test test/pos
cd ../Lndry_backend && npm test && node scripts/pos-smoke.mjs --lifecycle
```

## Out of scope
Direct Bluetooth ESC/POS printing (Phase 4 optional), refunds/returns/quality-claim screens, production queue screens.
