// ignore_for_file: prefer_const_constructors
// (FakeAuth builds a NEW AuthAuthenticated per sign-in on purpose — identical const objects would not notify listeners.)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lndry_vendor_app/core/services/storage_service.dart';
import 'package:lndry_vendor_app/models/models.dart';
import 'package:lndry_vendor_app/models/pos/app_mode_model.dart';
import 'package:lndry_vendor_app/providers/auth_provider.dart';
import 'package:lndry_vendor_app/repositories/abstract/app_mode_repository.dart';
import 'package:lndry_vendor_app/repositories/repositories.dart';

/// Storage with in-memory secure values (the real one needs a platform channel).
class MemStorage extends StorageService {
  MemStorage({required super.prefs});
  final Map<String, String> secure = {};
  @override
  Future<void> saveSecure(String key, String value) async => secure[key] = value;
  @override
  Future<String?> getSecure(String key) async => secure[key];
  @override
  Future<void> deleteSecure(String key) async => secure.remove(key);
  @override
  Future<void> deleteAllSecure() async => secure.clear();
  @override
  Future<Map<String, String>> getAllSecure() async => Map.of(secure);
}

AppModeInfo info({
  String offering = 'BOTH',
  String status = 'COMPLETED',
  List<String> allowed = const ['MARKETPLACE', 'POS'],
  String role = 'VENDOR_OWNER',
  String? vendorId = 'v1',
  bool needsOnboarding = false,
  bool canStart = false,
  String shop = 'Sparkle',
  bool hasVendor = true,
}) =>
    AppModeInfo.fromJson({
      'hasVendor': hasVendor,
      'vendorId': vendorId,
      'shopName': shop,
      'role': role,
      'offering': offering,
      'posOnboardingStatus': status,
      'allowedModes': allowed,
      'needsPosOnboarding': needsOnboarding,
      'canStartPos': canStart,
    });

/// A scriptable AppModeRepository that records every call.
class FakeAppModeRepo implements AppModeRepository {
  FakeAppModeRepo({AppModeInfo? mode}) : mode = mode ?? info();

  AppModeInfo mode;
  Object? getError;
  Object? startError;
  Object? saveError;
  Object? completeError;
  Object? onboardingError;
  PosOnboardingState onboarding = const PosOnboardingState(status: PosOnboardingStatus.inProgress, nextStep: 'shop', missingSteps: ['shop', 'tax', 'counter', 'pricelist']);
  PosStartResult? startResult;
  PosCompleteResult? completeResult;

  int getCalls = 0;
  int startCalls = 0;
  final List<(String, Map<String, dynamic>)> saved = [];
  int completeCalls = 0;

  @override
  Future<AppModeInfo> getAppMode() async {
    getCalls++;
    if (getError != null) throw getError!;
    return mode;
  }

  @override
  Future<PosStartResult> startPosOnboarding() async {
    startCalls++;
    if (startError != null) throw startError!;
    return startResult ?? PosStartResult(info: mode, created: false, needsTokenRefresh: false);
  }

  @override
  Future<PosOnboardingState> getPosOnboarding() async {
    if (onboardingError != null) throw onboardingError!;
    return onboarding;
  }

  @override
  Future<PosOnboardingState> savePosOnboardingStep(String step, Map<String, dynamic> data) async {
    if (saveError != null) throw saveError!;
    saved.add((step, data));
    return onboarding;
  }

  @override
  Future<PosCompleteResult> completePosOnboarding() async {
    completeCalls++;
    if (completeError != null) throw completeError!;
    return completeResult ?? PosCompleteResult(info: info(offering: 'POS', allowed: const ['POS']), starterCounts: const {'garments': 13});
  }
}

class _NoVendorRepo implements VendorRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// An AuthNotifier we can drive by hand; records adoptNewVendorSession.
class FakeAuth extends AuthNotifier {
  FakeAuth(StorageService storage) : super(_NoVendorRepo(), storage);
  int adoptCalls = 0;
  Object? adoptError;

  // Not const on purpose: every real sign-in/profile refresh is a NEW state object (identical objects do not notify).
  void signInOwner() => state = AuthAuthenticated(
        VendorModel(
          id: 'v1',
          name: 'Shop',
          description: '',
          ownerName: 'Owner',
          phone: '9999999999',
          address: AddressModel(id: 'a', userId: 'u', line1: 'x', city: 'c', state: 's', pincode: '400001', type: AddressType.home),
        ),
        shopRole: 'VENDOR_OWNER',
      );
  void signInRider() => state = AuthAuthenticated(
        VendorModel(
          id: 'v1',
          name: 'Shop',
          description: '',
          ownerName: 'Owner',
          phone: '9999999999',
          address: AddressModel(id: 'a', userId: 'u', line1: 'x', city: 'c', state: 's', pincode: '400001', type: AddressType.home),
        ),
        shopRole: 'VENDOR_RIDER',
      );
  void newUser(String phone) => state = AuthNeedsVendorApplication(phone);
  void signOut() => state = const AuthUnauthenticated();

  @override
  Future<void> adoptNewVendorSession({String shopRole = 'VENDOR_OWNER'}) async {
    adoptCalls++;
    if (adoptError != null) throw adoptError!;
    signInOwner();
  }
}

/// Lets a test grab a [Ref] to construct notifiers directly.
final refProvider = Provider<Ref>((ref) => ref);
