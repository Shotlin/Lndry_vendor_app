import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/core/services/device_permissions.dart';
import 'package:lndry_vendor_app/core/services/permission_prompter.dart';
import 'package:lndry_vendor_app/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A phone whose answers we control; records every system dialog raised.
class _FakePhone implements PermissionPlatform {
  _FakePhone({
    this.notifications = PermissionOutcome.denied,
    this.location = PermissionOutcome.denied,
    this.notificationsAnswer = PermissionOutcome.granted,
    this.locationAnswer = PermissionOutcome.granted,
  });

  PermissionOutcome notifications;
  PermissionOutcome location;
  final PermissionOutcome notificationsAnswer;
  final PermissionOutcome locationAnswer;
  final List<String> dialogs = [];
  bool _open = false;
  bool overlapped = false;

  Future<PermissionOutcome> _dialog(String name, PermissionOutcome answer) async {
    if (_open) overlapped = true; // two dialogs at the same moment
    _open = true;
    dialogs.add(name);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    _open = false;
    return answer;
  }

  @override
  Future<PermissionOutcome> notificationStatus() async => notifications;
  @override
  Future<PermissionOutcome> locationStatus() async => location;
  @override
  Future<PermissionOutcome> requestNotification() async {
    notifications = await _dialog('notifications', notificationsAnswer);
    return notifications;
  }

  @override
  Future<PermissionOutcome> requestLocation() async {
    location = await _dialog('location', locationAnswer);
    return location;
  }
}

Future<StorageService> _storage() async {
  SharedPreferences.setMockInitialValues({});
  return StorageService(prefs: await SharedPreferences.getInstance());
}

void main() {
  test('fresh install: notifications first, then location, one at a time', () async {
    final phone = _FakePhone();
    final calls = <String>[];
    final p = PermissionPrompter(
      storage: await _storage(),
      platform: phone,
      onNotificationsGranted: () async => calls.add('token-sync'),
      onLocationGranted: () async => calls.add('fetch-location'),
    );
    await p.runIfNeeded();
    expect(phone.dialogs, ['notifications', 'location']);
    expect(phone.overlapped, isFalse);
    expect(calls, ['token-sync', 'fetch-location'], reason: 'follow-ups run after the matching Allow');
  });

  test('never asked again on later launches', () async {
    final phone = _FakePhone();
    final storage = await _storage();
    await PermissionPrompter(storage: storage, platform: phone).runIfNeeded();
    expect(phone.dialogs.length, 2);
    // Next launch: brand new prompter, same storage.
    await PermissionPrompter(storage: storage, platform: phone).runIfNeeded();
    await PermissionPrompter(storage: storage, platform: phone).runIfNeeded();
    expect(phone.dialogs.length, 2);
  });

  test('denying never blocks and is not asked again', () async {
    final phone = _FakePhone(
      notificationsAnswer: PermissionOutcome.denied,
      locationAnswer: PermissionOutcome.denied,
    );
    final storage = await _storage();
    var followUps = 0;
    Future<void> follow() async => followUps++;
    final p = PermissionPrompter(
      storage: storage, platform: phone, onNotificationsGranted: follow, onLocationGranted: follow,
    );
    await p.runIfNeeded(); // completes normally
    expect(phone.dialogs, ['notifications', 'location']);
    expect(followUps, 0, reason: 'no token sync / location fetch without permission');
    await PermissionPrompter(storage: storage, platform: phone).runIfNeeded();
    expect(phone.dialogs.length, 2, reason: 'a denial is remembered');
  });

  test('already decided permissions raise no dialog', () async {
    final granted = _FakePhone(notifications: PermissionOutcome.granted, location: PermissionOutcome.granted);
    await PermissionPrompter(storage: await _storage(), platform: granted).runIfNeeded();
    expect(granted.dialogs, isEmpty);

    final blocked = _FakePhone(notifications: PermissionOutcome.blocked, location: PermissionOutcome.blocked);
    await PermissionPrompter(storage: await _storage(), platform: blocked).runIfNeeded();
    expect(blocked.dialogs, isEmpty, reason: 'blocked in Settings: only a contextual "Open Settings" can help');
  });

  test('only the undecided one is asked', () async {
    final phone = _FakePhone(notifications: PermissionOutcome.granted);
    await PermissionPrompter(storage: await _storage(), platform: phone).runIfNeeded();
    expect(phone.dialogs, ['location']);
  });

  test('simultaneous triggers share one run (no double dialogs)', () async {
    final phone = _FakePhone();
    final p = PermissionPrompter(storage: await _storage(), platform: phone);
    await Future.wait([p.runIfNeeded(), p.runIfNeeded(), p.runIfNeeded()]);
    expect(phone.dialogs, ['notifications', 'location']);
    expect(phone.overlapped, isFalse);
  });

  test('a failing follow-up never stops the flow', () async {
    final phone = _FakePhone();
    final p = PermissionPrompter(
      storage: await _storage(),
      platform: phone,
      onNotificationsGranted: () async => throw StateError('backend down'),
    );
    await p.runIfNeeded();
    expect(phone.dialogs, ['notifications', 'location']);
  });
}
