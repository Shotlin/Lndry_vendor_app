# Local testing recipe (cloud sandbox or your laptop)

Everything below was used to verify Phase 1 for real (real Postgres, real API, real Flutter compiler/tests).
The cloud sandbox is ephemeral — repeat this at the start of a session that needs to run things.

## 1. Services

```bash
# Postgres 16 + Redis are installed in the sandbox but not running
pg_ctlcluster 16 main start        # or: service postgresql start
redis-server --daemonize yes --dir /tmp   # --dir /tmp so dump.rdb never lands inside a repo
su postgres -c "psql -c \"CREATE USER lndry_user WITH PASSWORD 'lndry_pw' SUPERUSER;\" -c \"CREATE DATABASE lndry_db OWNER lndry_user;\""
```
No Docker in the sandbox, so `npm run setup:local` does not work there.

## 2. Backend (`Lndry_backend`)

```bash
cd Lndry_backend && npm ci
# .env is git-ignored. Start from .env.example and change:
#   DB_PORT=5432  DB_PASSWORD=lndry_pw  REDIS_PORT=6379  BULL_REDIS_PORT=6379   (the example uses 6380!)
# and add (the app refuses to boot without the first):
#   WEBSITE_PARTNER_LEAD_HMAC_SECRET=<any 32+ chars>
#   TEST_BYPASS_OTP_PHONES=*        # OTP is always 123456 — local only, never in production
#   ALLOW_AUTO_APPROVE_VENDOR=true  # optional, marketplace applications approve instantly
node src/database/migrate.js        # applies every migration (idempotent)
nohup node src/server.js > /tmp/server.log 2>&1 & echo $! > /tmp/server.pid   # API on :4500
# stop with:  kill $(cat /tmp/server.pid)      (do NOT use `pkill -f` — it can match your own shell)
```

Tests:
```bash
npx vitest run tests/unit/vendor-app-mode.test.js tests/integration/vendor-offering.test.js   # needs the migrated DB
TZ=Asia/Kolkata npx vitest run ...    # run date-sensitive code under several time zones
npm test                              # whole suite
```
Pre-existing failures on the untouched code (not caused by this initiative): `tests/unit/step-up.test.js`
(logger level env) and one auth test in `tests/integration/lndry-endpoints.test.js`.

OTP login for curl experiments (a **fresh** `send-otp` is needed before every `verify-otp`):
```bash
B=localhost:4500/api/v1; H='content-type: application/json'
curl -s -X POST $B/auth/send-otp   -H "$H" -d '{"phone":"9876500001"}'
curl -s -X POST $B/auth/verify-otp -H "$H" -d '{"phone":"9876500001","otp":"123456"}'   # -> data.accessToken / refreshToken
# After creating a shop, renew the token so it carries the shop:
curl -s -X POST $B/auth/refresh-token -H "$H" -d '{"refreshToken":"<refreshToken>"}'
```
OTP login only issues CUSTOMER/RIDER roles. For an admin call locally, mint a token with the backend's own helper:
`node -e "import('./src/utils/jwt.js').then(m=>console.log(m.signAccessToken({id:'<user uuid>',phone:'x',role:'ADMIN'})))"`.

## 3. Flutter (`Lndry_vendor_app`)

```bash
# SDK (stable, Dart >= 3.4; the lock file wants Flutter >= 3.44). Storage is reachable through the proxy; github.com is not.
mkdir -p /root/sdk && cd /root/sdk
curl -L -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.7-stable.tar.xz && tar -xf flutter_linux_3.47.7-stable.tar.xz
export PATH=/root/sdk/flutter/bin:$PATH FLUTTER_SUPPRESS_ANALYTICS=true CI=true
git config --global --add safe.directory /root/sdk/flutter
cd /home/user/Lndry_vendor_app && flutter pub get
flutter gen-l10n                      # after editing any .arb (generated files ARE committed)
flutter analyze lib test/pos          # see "Known baseline" below
flutter test --no-pub                 # whole suite
flutter test --no-pub test/pos        # POS tests only
# Adding a package changes pubspec.lock; a newer SDK ALSO bumps SDK-pinned packages. Commit only the new entries (see PROGRESS.md, Environment notes).
```

**Do not commit** `pubspec.lock` or `analysis_options.yaml` changes made by the tools: a newer Flutter rewrites
SDK-pinned packages in the lock file and adds `build/**, android/**, ios/**, web/**` to the analyzer excludes.
Run `git checkout -- pubspec.lock analysis_options.yaml` before committing, and never `git stash` while the
analyzer has just modified `analysis_options.yaml` (the pop will refuse).

### Known baseline (untouched code, 2026-10-10)
* `flutter analyze lib`: 626 info/warning items already exist (mostly lint style). Check that **new** files add none.
* `test/widget_test.dart` "App smoke test" fails on the original commit (a 5 s secure-storage timer is still pending when the widget tree is disposed). Not part of this initiative.

### Test patterns used in `test/pos`
* `fakes.dart`: `FakeAppModeRepo` (scriptable), `FakeAuth` (drive sign-in by hand; **let `AuthNotifier`'s background restore finish first**, it ends by setting "signed out"), `MemStorage`.
* `fixtures/*.json`: REAL backend responses (re-capture with the curl recipe above if the API changes).
* Router tests run the app's real `vendorRedirectForTest(..., appMode:)` against placeholder screens.
* Mutation-check new tests: break the rule under test, confirm tests fail, restore.

## 4. Real-browser journeys (whole app, real backend)

`scripts/pos-web-e2e/` runs the release **web** build of the full Vendor App in Chromium against the local backend and
verifies results through the API (`README.md` there has the exact commands). Backend side: `.env` needs
`TEST_BYPASS_OTP_PHONES=*` and `CORS_ORIGINS=http://localhost:8081`. The backend contract check
`node ../Lndry_backend/scripts/pos-smoke.mjs` needs no browser at all.

Phase 3: `node ../Lndry_backend/scripts/pos-smoke.mjs --lifecycle` adds the order-life contract (58 checks, no browser) and `npm run phase3` in `scripts/pos-web-e2e` the 39-check browser journey (details in that README).

Gotchas (all hit in Phase 2): OTPs are rate-limited per phone (`redis-cli flushall` locally) so every run makes a new shop;
the app sits on a splash for a few seconds; a test that "verifies" with a stale token reads the wrong shop — always check the
phone inside the JWT matches the shop you drove.

### Lessons from Phase 3 (things only a real browser or a nested navigator shows)
* Pages inside the POS tab shell live in a **nested navigator**; `showDialog` uses the **root** one. Always pop a dialog with the dialog builder's own context
  (`builder: (dialogContext) => … Navigator.of(dialogContext).pop(…)`), never the page's. Test it with a page hosted in its own `Navigator` (see `pos_orders_page_test.dart`, "inside the real tab shell").
* Look at the accessibility tree (`scripts/pos-web-e2e` prints it): an `InkWell` alone is a "group", not a button; a checkbox next to a `Text` is an unnamed checkbox. Wrap the tap area in `Semantics(button: true, label: …, excludeSemantics: true)`.
* Default test fonts are wider than real ones, so a widget test can pass while a Row squeezes a label on a real phone: assert the label's height (one line) in the test.
