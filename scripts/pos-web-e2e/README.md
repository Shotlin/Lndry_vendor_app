# POS mode — real-browser journeys

These scripts run the **release web build of the whole Vendor App** in a real Chromium against a **real local backend**,
and check the result in the database/API afterwards (never only on screen).

Why web: it is the only way to run the real app without a phone or emulator in a cloud session. The widget tests
(`test/pos`) cover each screen in isolation; these cover the journey end to end.

## Run (see `docs/pos-mode/LOCAL-TESTING.md` for Postgres/Redis/backend/Flutter setup)

```bash
# 1. backend with test OTPs and CORS for the web origin (local only!)
cd ../Lndry_backend
#   .env:  TEST_BYPASS_OTP_PHONES=*   CORS_ORIGINS=http://localhost:8081
node src/server.js &

# 2. the app, built for web (CanvasKit bundled so no CDN is needed)
cd ../Lndry_vendor_app
flutter build web --release --no-web-resources-cdn \
  --dart-define=FLAVOR=development --dart-define=API_BASE_URL=http://localhost:4500/api/v1
(cd build/web && python3 -m http.server 8081 &)

# 3. run the journey (installs the browser driver, playwright-core, into this folder only)
cd scripts/pos-web-e2e && npm install && npm run phase2      # exit code 1 on any failed check
npm run phase4                                               # Search, Customers, Expense + cash drawer, Report, Settings, WhatsApp (31 checks)
npm run phase3                                               # the whole life of an order (Orders, detail, pay, deliver, invoice, cancel, edit, captain, bulk)
```

Env: `API`, `WEB`, `OTP`, `CHROME` (path of a Chromium; the cloud image has `/opt/pw-browsers/chromium-*/chrome-linux/chrome`).

Notes learned the hard way
* Each run creates a **new shop with a random phone** — the backend rate-limits OTPs per phone (`redis-cli flushall` clears it locally).
* The app shows a splash screen for a few seconds after every load; always wait for real content, not a fixed time.
* Filter chips are `checkbox` nodes, buttons are `button`; Flutter's dropdown **menus** are not in the accessibility tree — pick with the keyboard (`Enter`).
* `getByRole('button', { name: 'Add' })` matches by substring: pass `exact: true` or you will press "Add Garment Price".
* Tap the same screen position twice with `page.mouse.click` to test double-tap protection: a locator click waits for the element to be stable and cannot do it.
* Phase 3 additions: the bottom bar's items are `tab`s (`getByRole('tab', { name: /^Order/ })`); screens opened with `push` (order detail, invoice) do **not** change the URL, so check the screen's content, not `page.url()`;
  the **first** tap on a Flutter text field only wakes its native input — tap the box centre twice with `page.mouse.click` (Playwright's `click({ force: true })` never focuses it) and find a field that already holds text by role only (its name is no longer the hint);
  `wa.me` is unreachable from the sandbox — `ctx.route('https://wa.me/**', …)` answers it so the popup's address can be read; every run needs a **new captain phone** (a phone can be a captain in one shop only);
  the web build's PDF viewer downloads pdf.js from unpkg, which the sandbox blocks — it logs one page error at the invoice step and cannot draw the PDF (phones use native rendering).

* Phase 4: newer Flutter builds render headings as real `<header>` elements — `heard()` reads those too. Choice chips are `checkbox` nodes (`getByRole('checkbox', { name })`). A card that holds a heading is merged into ONE node, so do not mark headings inside cards.
* Phone numbers are global accounts: a customer phone reused by another run shows the **shop's own** typed name only since the 'own name per shop' backend fix.
