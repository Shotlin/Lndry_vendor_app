import 'package:image_picker/image_picker.dart';
import '../../models/models.dart';
import '../../shared/repositories/base_repository.dart';

abstract interface class VendorRepository {
  Future<SendOtpResult> sendOtp(String phone);
  
  Future<VerifyOtpVendorResult> verifyOtp({
    required String phone,
    required String otp,
    String? challengeId,
    Map<String, dynamic>? device,
  });
  
  Future<TokenPair> refreshTokens();
  
  Future<void> logout();
  
  // -- Profile operations
  Future<VendorModel> getProfile();
  
  Future<VendorModel> updateProfile({
    required String name,
    required String email,
    String? description,
    String? addressLine1,
    String? city,
    String? state,
    String? pincode,
    String? logoUrl,
    String? bannerUrl,
  });

  Future<VendorModel> toggleStoreOpen(bool isOpen);

  Future<void> publishProfile();

  /// Uploads [file] to the shared Cloudinary-backed image store and returns
  /// its hosted URL. Used for the vendor's own logo/banner — same endpoint
  /// the admin dashboard uses, just not admin-gated.
  Future<String> uploadImage(XFile file, {String? folder});

  // -- Onboarding application (wizard)
  Future<VendorApplicationModel> getOrCreateApplication();

  Future<VendorApplicationModel> getApplicationMe();

  Future<VendorApplicationModel> updateApplicationOwner(
    String appId, {
    String? ownerName,
    String? email,
    String? phone,
    String? bankAccountNumber,
    String? bankIfsc,
    String? bankName,
    String? bankHolderName,
  });

  Future<VendorApplicationModel> updateApplicationBusiness(
    String appId, {
    String? name,
    String? description,
    String? gstNumber,
    String? panNumber,
  });

  Future<VendorApplicationModel> updateApplicationLocation(
    String appId, {
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    double? lat,
    double? lng,
  });

  Future<VendorApplicationModel> updateApplicationRadius(
    String appId,
    double requestedRadiusKm, {
    int? requestedDailyCapacity,
  });

  Future<String> uploadApplicationDocument(
    String appId, {
    required String documentType,
    required XFile file,
  });

  Future<void> deleteApplicationDocument(String appId, String documentId);

  Future<VendorApplicationModel> submitApplication(String appId);

  Future<VendorApplicationModel> resubmitApplication(String appId);

  // -- Service categories (real, backend-fetched)
  Future<List<CategoryModel>> getServiceCategories();

  /// Admin-published subcategories under [categoryId] — what a vendor can
  /// pick from on the Pricing screen. Never created/edited by the vendor.
  Future<List<GarmentTypeModel>> getGarmentTypes(String categoryId);

  // -- Catalogue services
  Future<List<ServiceModel>> getMyServices();
  
  Future<ServiceModel> addService(ServiceModel service);
  
  Future<ServiceModel> updateService(ServiceModel service);
  
  Future<void> toggleServiceAvailability(String serviceId, bool isAvailable);

  Future<void> deleteService(String serviceId);

  Future<Map<String, dynamic>> getServiceDetails(String serviceId);

  Future<void> addGarmentRate(
    String serviceId, {
    String? garmentTypeId,
    String? garmentTypeName,
    required double rate,
    String? rateUnit,
  });

  Future<void> deleteGarmentRate(String serviceId, String garmentTypeId);

  /// Saves every changed subcategory rate for [serviceId] in one call —
  /// activating, re-pricing, or deactivating any number of rows costs a
  /// single request instead of one per row.
  Future<void> bulkUpsertGarmentRates(String serviceId, List<GarmentRateUpsertItem> items);

  // -- Orders operations
  Future<OrderModel> getOrder(String orderId);

  Future<PaginatedResponse<OrderModel>> getIncomingOrders({
    PaginationParams params,
    String? status,
  });
  
  Future<OrderModel> acceptOrder(String orderId);
  
  Future<OrderModel> rejectOrder(String orderId, {String? reason});

  /// Manually assign (or reassign) a specific rider/staff to this order.
  /// [employeeId] is a vendor_employees.id (as returned by [getRiders] /
  /// [getEmployees]), not the person's own user id.
  Future<OrderModel> assignRider(String orderId, String employeeId);

  /// Broadcast this order to every active rider at once — first to
  /// accept wins. Phase 3 of the rider-assignment initiative.
  Future<void> broadcastRider(String orderId);

  /// Atomically accept a job offer received over the socket
  /// ([JobOffer]/`job:offered`) — the rider-side counterpart of
  /// [broadcastRider]. Throws if someone else already claimed it.
  Future<void> acceptJobOffer(String orderId);

  Future<OrderModel> markOrderReady(String orderId);

  Future<OrderModel> updateProcessingStage(String orderId, String stage);

  /// Vendor's authoritative recalculation — staged, requires customer
  /// accept/reject (unlike [submitPickupMeasurements]'s immediate apply).
  /// Returns the raw proposal result (`status`, `reconciliation_id`,
  /// previous/proposed payable amounts) — callers should re-fetch
  /// [getOrder] afterwards to pick up the new `RECONCILIATION_PENDING`
  /// status and banner state, rather than trying to reconstruct a full
  /// [OrderModel] from this response.
  Future<Map<String, dynamic>> reconcileOrder(
    String orderId, {
    List<Map<String, dynamic>>? lines,
    double? confirmedWeightKg,
    String? adjustmentReason,
    required List<String> photoUrls,
    /// Services that weren't on the order at all — a genuine addition, or
    /// the destination for a partial quantity moved out of an existing
    /// continuous-unit line. Each `{garment_type_id, quantity}`.
    List<Map<String, dynamic>>? newLines,
  });

  /// This vendor's own active service catalog (category + service name +
  /// garment type + unit + rate + image), used to populate the "move this
  /// item to a different service" / "add a service" pickers during
  /// reconciliation — e.g. reclassifying a delicate item from a per-kg wash
  /// to a per-piece dry-clean service, or adding a service that wasn't on
  /// the order at all.
  Future<List<ReclassifyOption>> getVendorServiceCatalog();

  Future<Map<String, dynamic>> getDashboardStats();
  
  // -- Device tokens
  Future<void> registerDevice({
    required String deviceId,
    required String platform,
    required String fcmToken,
  });
  
  Future<void> unregisterDevice(String deviceId);

  // -- Notifications
  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 20});
  Future<void> markNotificationRead(String notificationId);
  Future<void> markAllNotificationsRead();
  Future<void> deleteNotification(String notificationId);

  // -- Employee staff management
  Future<List<EmployeeModel>> getEmployees();

  Future<EmployeeModel> createEmployee({
    required String name,
    required String email,
    required String role,
    String? phone,
    List<String>? permissions,
  });

  Future<EmployeeModel> updateEmployee(
    String id, {
    required String role,
    required List<String> permissions,
    required bool isActive,
  });

  Future<void> deleteEmployee(String id);

  Future<void> resetEmployeePassword(String id, String newPassword);

  // -- Rider management (vendor's own delivery staff — a VENDOR_RIDER-scoped
  // slice of the same vendor_employees roster as Staff Management, but riders
  // log in via phone-OTP only, so no email is collected at creation).
  Future<List<EmployeeModel>> getRiders();

  Future<EmployeeModel> createRider({
    required String name,
    required String phone,
  });

  // -- Rider job fulfillment (rider's own restricted view)
  Future<List<RiderJobModel>> getRiderJobs();

  Future<RiderJobModel> getRiderJobDetail(String orderId);

  /// Jobs currently offered to this rider, pending accept — Phase 6 of
  /// the rider-assignment initiative. Checked on socket (re)connect so a
  /// still-open offer isn't missed just because the app was closed or
  /// briefly disconnected when it was first broadcast.
  Future<List<RiderJobModel>> getJobOffers();

  /// Marks the rider as on the way to pickup (order status -> GOING_FOR_PICKUP).
  Future<void> startPickup(String orderId);

  /// Marks the rider as on the way to deliver (order status -> OUT_FOR_DELIVERY).
  Future<void> startDelivery(String orderId);

  /// Rider's doorstep weigh-in/recount — corrects the customer's rough
  /// self-declared weight/piece-count. Applies immediately, no customer
  /// approval needed. Called before [submitPickupPhotos]. `lines` carries a
  /// whole-number `confirmed_quantity` for piece-priced lines only —
  /// continuous-unit lines (kg, sq ft) go through [confirmedWeightKg]
  /// instead, an exact decimal (e.g. 1.2).
  Future<void> submitPickupMeasurements(
    String orderId, {
    double? confirmedWeightKg,
    required List<Map<String, dynamic>> lines,
  });

  Future<void> submitPickupPhotos(
    String orderId,
    List<Map<String, dynamic>> photos,
  );

  Future<void> verifyPickupOtp(String orderId, String otp);

  /// Rider confirms cash collected for a COD order's balance at delivery.
  /// Called before [verifyDeliveryOtp]. Returns
  /// `{orderId, balance_collected_paise}`.
  Future<Map<String, dynamic>> collectBalance(String orderId);

  /// Optional delivery-proof photo(s), captured before OTP entry.
  Future<void> submitDeliveryPhotos(
    String orderId,
    List<Map<String, dynamic>> photos,
  );

  Future<void> verifyDeliveryOtp(String orderId, String otp);

  // -- Capacity & Slots management
  Future<Map<String, dynamic>> getCapacity();

  /// Submits a daily-capacity change for admin approval — no longer applies
  /// instantly. The returned map is the capacity_requests row; getCapacity()
  /// then surfaces it back as `pending_capacity_request` until reviewed.
  Future<void> requestCapacityChange(int maxOrdersPerDay);

  Future<List<PickupSlotModel>> getPickupSlots();

  Future<PickupSlotModel> createPickupSlot({
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    int? maxOrders,
  });

  Future<PickupSlotModel> updatePickupSlot(
    String id, {
    int? maxOrders,
    bool? isActive,
  });

  Future<void> deletePickupSlot(String id);

  // -- Analytics
  /// Returns computed analytics summary for the given period ('week' or 'month').
  Future<Map<String, dynamic>> getAnalyticsSummary({String period = 'week'});

  // -- Working Hours
  Future<Map<int, Map<String, dynamic>>> getWorkingHours();
  Future<void> updateWorkingHours(int dayOfWeek, {required bool isOpen, required String openTime, required String closeTime});

  // -- Support Tickets
  Future<Map<String, dynamic>> createSupportTicket({
    required String title,
    required String description,
    required String category,
  });
  Future<List<Map<String, dynamic>>> getSupportTickets();
  Future<Map<String, dynamic>> getSupportTicket(String id);
  /// Vendor confirms satisfied with the admin's reply — 1-5 stars, closes the ticket.
  Future<Map<String, dynamic>> rateSupportTicket(String id, int rating);
  /// Vendor says not satisfied — sends a follow-up message, reopens the ticket.
  Future<Map<String, dynamic>> followUpSupportTicket(String id, String message);
}

class ReclassifyOption {
  const ReclassifyOption({
    required this.garmentTypeId,
    required this.garmentName,
    required this.unit,
    required this.ratePaise,
    required this.serviceName,
    this.categoryName,
    this.imageUrl,
  });

  final String garmentTypeId;
  final String garmentName;
  final String unit;
  final int ratePaise;
  final String serviceName;
  final String? categoryName;
  final String? imageUrl;

  /// True for units priced by a continuous measurement (kg, sq ft) rather
  /// than a discrete count — these take an exact decimal correction, never
  /// a +/- stepper.
  bool get isWeightBased {
    final u = unit.toLowerCase();
    return u == 'kg' || u == 'sqft';
  }
}

class SendOtpResult {
  const SendOtpResult({
    required this.challengeId,
    required this.expiresIn,
    this.devOtp,
  });

  final String challengeId;
  final int expiresIn;
  final String? devOtp;
}

class TokenPair {
  const TokenPair({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
}

class VerifyOtpVendorResult {
  const VerifyOtpVendorResult({
    required this.accessToken,
    required this.refreshToken,
    required this.vendor,
    this.isNewUser = false,
    this.userPhone,
    this.shopRole,
    this.permissions = const [],
  });

  final String accessToken;
  final String refreshToken;
  final VendorModel vendor;

  /// True only on the first successful OTP verification for this phone.
  /// The vendor app uses this to enter onboarding before loading any
  /// dashboard/profile data.
  final bool isNewUser;
  final String? userPhone;

  /// e.g. 'VENDOR_OWNER' / 'VENDOR_STAFF' / 'VENDOR_RIDER' — determines
  /// whether this session sees the full vendor dashboard or the
  /// restricted rider job-fulfillment view.
  final String? shopRole;
  final List<String> permissions;
}

class GarmentRateUpsertItem {
  const GarmentRateUpsertItem({
    required this.garmentTypeId,
    required this.ratePaise,
    this.isActive = true,
  });

  final String garmentTypeId;
  final int ratePaise;
  final bool isActive;
}
