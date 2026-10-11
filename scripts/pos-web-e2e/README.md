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
```

Env: `API`, `WEB`, `OTP`, `CHROME` (path of a Chromium; the cloud image has `/opt/pw-browsers/chromium-*/chrome-linux/chrome`).

Notes learned the hard way
* Each run creates a **new shop with a random phone** — the backend rate-limits OTPs per phone (`redis-cli flushall` clears it locally).
* The app shows a splash screen for a few seconds after every load; always wait for real content, not a fixed time.
* Filter chips are `checkbox` nodes, buttons are `button`; Flutter's dropdown **menus** are not in the accessibility tree — pick with the keyboard (`Enter`).
* `getByRole('button', { name: 'Add' })` matches by substring: pass `exact: true` or you will press "Add Garment Price".
* Tap the same screen position twice with `page.mouse.click` to test double-tap protection: a locator click waits for the element to be stable and cannot do it.
