# CLAUDE.md — LNDRY Vendor App (Flutter)

Flutter app for laundry shop partners. **Active initiative: add a POS mode** (counter billing + CRM) next to the
existing marketplace mode, with its own onboarding. Read this file first in every session.

## START HERE (every new session)

1. Read `PROGRESS.md` (what is done / in progress / next).
2. Run **`/pos-next`** — it picks the right phase automatically and continues from the last checked item.
   Other commands: `/pos-status`, `/pos-phase <1-4>`, `/pos-verify`, `/pos-handoff`.
3. Plan documents: `docs/pos-mode/00-MASTER-PLAN.md` (design, API map, theme) and `docs/pos-mode/PHASE-1…4.md` (checklists).
4. Never start phase N+1 until phase N is marked ✅ in `PROGRESS.md` (Definition of Done met).

## Repos and branch

All four repos live side by side (`/home/user/<name>` in the cloud session). **Branch for all work:**
`claude/laundry-vendor-pos-modes-bs0o61` (create locally if missing; never push elsewhere; never open a PR unless asked).

| Repo | Role in this initiative | Touch? |
|---|---|---|
| `Lndry_vendor_app` | Flutter app — **main work** | Yes |
| `Lndry_backend` | Fastify + Postgres API. POS APIs already exist under `/api/v1/vendor/*`; we add offering/onboarding + small order flags | Yes (small, tested) |
| `Lndry_dashboard_frontend` | Admin dashboard (Next.js) — set vendor offering/plan | Yes (small) |
| `epic-laundry-desktop` | Existing Epic POS (website + desktop). **Reference only: read for screens, colors, API usage. DO NOT MODIFY.** | Read-only |

## Non-negotiable rules

1. **Do not change the existing marketplace UI/behavior.** Allowed edits to marketplace code: router redirects, settings entry, login/onboarding redirect.
2. **Do not modify Epic desktop/website.** The backend must keep serving them exactly as today. The `ENFORCE_OFFERING` flag stays **off** until the user approves.
3. **No second API.** Flutter calls the existing `/api/v1/vendor/...` endpoints (same ones Epic's `webAdapters/*.ts` call). Add backend code only for real gaps and test it.
4. **Server is the source of truth for money.** Show the server quote/total; never compute tax/discount in Dart. Money is integer paise.
5. **Honest status.** If a test/build was not run (e.g. no Flutter SDK), write "written, not run" in `PROGRESS.md`. Never tick a box for something unverified. Never fake numbers on screens (use null → "—").
6. **Easy for anyone:** follow the "child-simple" rules in Master Plan §6 (big buttons, labelled icons, plain words, Hindi/Hinglish strings, color + word for status).
7. **POS look = Epic POS violet** (`#664CF0`, tokens in Master Plan §6). Do not copy the reference screenshots' blue.
8. Keep changes small and committed per logical step; update `PROGRESS.md` in the same commit.

## Architecture cheat-sheet

- State: Riverpod. Routing: go_router (`lib/core/router/vendor_router.dart`, redirect logic is exposed for tests). Network: dio via existing client + auth interceptor. Models: freezed + json_serializable.
- New code lives in `lib/features/pos/**`, `lib/models/pos/**`, `lib/repositories/pos/**`, tests in `test/pos/**` (layout in Master Plan §7).
- Modes: `AppMode {marketplace, pos}` chosen on device, **allowed** by backend `GET /vendor/app-mode` (`offering` = MARKETPLACE | POS | BOTH).
- Backend conventions: module = routes/controller/service/repository/schema; **AJV strips undeclared body fields** (`removeAdditional:'all'`) so validate free-form bodies in the service; migrations are numbered idempotent SQL in `src/database/migrations/` (last: `152_vendor_offering.sql`); **never return a Postgres DATE as a JS Date (select `::text`)**; all POS tables are vendor-scoped — every query must filter by `vendor_id`.
- `vendor_type` (STANDARD/PARTNER/EXCLUSIVE) is a separate axis (walk-in sync + LNDRY wallet). Don't conflate it with `offering`.

## Commands

```bash
# Flutter (this repo)
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed/json
flutter gen-l10n
flutter analyze && flutter test
flutter run --dart-define=FLAVOR=development               # emulator -> http://10.0.2.2:4500/api/v1
flutter build apk --release --dart-define=FLAVOR=production  # ALWAYS pass FLAVOR

# Backend (../Lndry_backend)
npm run setup:local        # postgres + redis in docker, migrate, seed
npm run dev                # API on :4500
npm run lint && npm test

# Dashboard (../Lndry_dashboard_frontend)
npm run lint && npx vitest run && npx tsc --noEmit
```

**Running things locally (Postgres + Redis + backend + Flutter SDK, real browser journeys): see `docs/pos-mode/LOCAL-TESTING.md`.**
Never commit `pubspec.lock` / `analysis_options.yaml` changes made by Flutter tools (`git checkout --` them before committing).

If `flutter` is missing: try to install the SDK per https://docs.flutter.dev/get-started/install/linux (stable channel, Dart ≥ 3.4) — if the network/proxy blocks it, continue writing code and tests, and record "Flutter tests written, not run" in `PROGRESS.md`. Do not skip `dart format`-style care when you cannot run the analyzer: keep code simple and double-check imports and generated-file names (`*.freezed.dart`, `*.g.dart`).

## Commit / push

- Commit message style: short imperative subject; body says what/why; one logical change per commit.
- Push: `git push -u origin claude/laundry-vendor-pos-modes-bs0o61` (on network failure retry up to 4× with 2/4/8/16 s backoff).
- Do this in **every** repo you changed. `/pos-handoff` does it for you.

## Where to find things

- Existing onboarding wizard: `lib/features/onboarding/presentation/pages/vendor_application_page.dart`
- Settings: `lib/features/settings/presentation/pages/settings_page.dart`
- Permissions model: `lib/providers/access_provider.dart`, backend `src/middlewares/vendor-permission.js`
- POS reference UI (read-only): `../epic-laundry-desktop/webapp/src/pages/laundry/*.tsx`, API adapters `../epic-laundry-desktop/webapp/src/lib/webAdapters/*.ts`, theme `../epic-laundry-desktop/webapp/src/index.css`
- Backend POS modules: `../Lndry_backend/src/modules/vendor-counter-orders`, `vendor-pos-catalogue`, `vendor-pos-dashboard`, `vendor-pos-settings`, `vendor-cash-shifts`, `vendor-expenses`, `invoices`
