# LNDRY Vendor App

Flutter app for laundry-shop partners (owners and staff) to manage orders, pricing, inventory, employees, and pickup/delivery slots against the [LNDRY backend](../Lndry_backend).

## Stack

- **State management:** Riverpod (`flutter_riverpod`)
- **Routing:** `go_router`
- **Networking:** `dio` (+ `pretty_dio_logger` in debug builds only)
- **Local storage:** `shared_preferences`, `flutter_secure_storage`, `hive_flutter`
- **Serialization:** `freezed` / `json_serializable`
- **Firebase:** Auth, Firestore, Storage, Messaging (requires a real Firebase project — see below)

## Getting started

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs   # freezed/json codegen
flutter run --dart-define=FLAVOR=development
```

By default (no `FLAVOR` passed) the app resolves to the `development` flavor, which points the API base URL at `http://10.0.2.2:4500/api/v1` (Android emulator → host machine loopback). Override with `--dart-define=API_BASE_URL=...` for a physical device or a different local backend port.

## Building a release

**Always pass the flavor explicitly** — there is no CI pipeline enforcing this yet, so it's a manual step:

```bash
flutter build apk --release --dart-define=FLAVOR=production
flutter build ipa --release --dart-define=FLAVOR=production
```

If `FLAVOR` is omitted, the build silently falls back to `development` and ships pointing at the emulator-only API URL — a real functional bug, not just a debug artifact. (The debug banner and dev-preview overlay are separately guarded by Flutter's own release/debug build flag and can't leak into a release build regardless of `FLAVOR` — see `lib/config/env.dart`.)

## Firebase setup

`android/app/google-services.json` currently ships a placeholder (`lndry-dev-placeholder` project). Push notifications and any Firebase-backed features won't work until it's replaced with a real Firebase project's config file.

## Project structure

```
lib/
├── api/repositories/     # Real backend-backed repositories (ApiVendorRepository, ...)
├── config/                # Env, flavors, app-wide config
├── core/
│   ├── design/            # Design tokens
│   ├── network/            # Dio client setup
│   ├── router/             # go_router configuration
│   ├── services/           # Storage and other app services
│   ├── theme/               # Colors, typography, theme data
│   └── widgets/             # Shared low-level widgets (buttons, cards, dialogs, ...)
├── features/               # Feature-first modules: analytics, auth, dashboard, employees,
│                            # help, inventory, notifications, orders, pricing, profile,
│                            # services, settings, slots, splash
├── models/                 # Data models
├── providers/               # Riverpod providers
├── repositories/abstract/  # Repository interfaces
└── shared/                 # Cross-feature widgets and repositories
```

## Testing

```bash
flutter test
```

Test coverage here is currently minimal (`test/widget_test.dart`, `test/parser_test.dart`) — most confidence in this app comes from manual QA against the real backend, not automated tests.
