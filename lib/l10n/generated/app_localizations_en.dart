// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonReject => 'Reject';

  @override
  String get commonAccept => 'Accept';

  @override
  String get commonExit => 'Exit';

  @override
  String get commonCallCustomer => 'Call customer';

  @override
  String get commonCouldNotOpenDialer =>
      'Could not open the phone dialer. Please try again.';

  @override
  String get splashAppName => 'Lndry Partner';

  @override
  String get splashTagline => 'Partner Portal';

  @override
  String get authWelcomeBack => 'Welcome Back';

  @override
  String get authLoginSubtitle =>
      'Enter your mobile number to manage your laundry operations';

  @override
  String get authMobileNumberLabel => 'Mobile Number';

  @override
  String get authMobileNumberRequired => 'Mobile number is required';

  @override
  String get authMobileNumberInvalid =>
      'Please enter a valid 10-digit mobile number';

  @override
  String get authGetOtpButton => 'Get OTP';

  @override
  String get authVerifyMobile => 'Verify Mobile';

  @override
  String authOtpSubtitleWithPhone(String phone) {
    return 'Enter the 6-digit OTP code sent to $phone';
  }

  @override
  String get authOtpSubtitleGeneric =>
      'Enter the verification code sent to your mobile';

  @override
  String get authDemoOtpLabel => 'Demo OTP: ';

  @override
  String get authOtpCodeLabel => 'OTP Code';

  @override
  String get authOtpRequired => 'Please enter the OTP code';

  @override
  String get authOtpInvalid => 'Please enter a valid 6-digit code';

  @override
  String get authVerifyCodeButton => 'Verify Code';

  @override
  String get authResendPrompt => 'Didn\'t receive code? ';

  @override
  String get authResendCountdownPrefix => 'Resend code in ';

  @override
  String get authResendOtpButton => 'Resend OTP';

  @override
  String authResendCountdownSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get dashboardTodayClosedTitle => 'Today is marked closed';

  @override
  String get dashboardTodayClosedMessage =>
      'Today is set as a non-working day in your Working Hours schedule, so your store stays closed to customers regardless of this switch. Update Working Hours & Slots to open today.';

  @override
  String get dashboardOpenWorkingHoursButton => 'Open Working Hours';

  @override
  String get dashboardCloseStoreTitle => 'Close Your Store?';

  @override
  String get dashboardOpenStoreTitle => 'Open Your Store?';

  @override
  String get dashboardCloseStoreMessage =>
      'Customers will not be able to place new orders while your store is closed.';

  @override
  String get dashboardOpenStoreMessage =>
      'Your store will be visible to customers and they can place new orders.';

  @override
  String get dashboardCloseStoreButton => 'Close Store';

  @override
  String get dashboardOpenStoreButton => 'Open Store';

  @override
  String get dashboardStoreNowOpen => 'Store is now OPEN';

  @override
  String get dashboardStoreNowClosed => 'Store is now CLOSED';

  @override
  String dashboardActionFailed(String error) {
    return 'Failed: $error';
  }

  @override
  String get dashboardLaundryPartnerFallback => 'Laundry Partner';

  @override
  String get dashboardOpenBadge => 'OPEN';

  @override
  String get dashboardClosedBadge => 'CLOSED';

  @override
  String get dashboardApprovedBadge => 'APPROVED';

  @override
  String get dashboardAvgRating => 'Avg Rating';

  @override
  String get dashboardTotalReviews => 'Total Reviews';

  @override
  String get dashboardAvgTurnaround => 'Avg Turnaround';

  @override
  String dashboardHoursValue(String hours) {
    return '$hours hrs';
  }

  @override
  String get dashboardTodaysOperations => 'Today\'s Operations';

  @override
  String get dashboardTodaysRevenue => 'Today\'s Revenue';

  @override
  String get dashboardPendingOrders => 'Pending Orders';

  @override
  String get dashboardProcessingOrders => 'Processing Orders';

  @override
  String get dashboardReadyPacked => 'Ready / Packed';

  @override
  String get dashboardFailedLoadStats => 'Failed to load statistics';

  @override
  String get dashboardQuickActions => 'Quick Actions';

  @override
  String get dashboardCatalogue => 'Catalogue';

  @override
  String get dashboardSlots => 'Slots';

  @override
  String get dashboardAnalytics => 'Analytics';

  @override
  String get dashboardHelp => 'Help';

  @override
  String get dashboardNewIncomingOrders => 'New Incoming Orders';

  @override
  String get dashboardViewAll => 'View All';

  @override
  String get dashboardAllCaughtUp => 'All caught up!';

  @override
  String get dashboardNoPendingOrders => 'No pending orders at the moment.';

  @override
  String get dashboardFailedLoadOrders => 'Failed to load orders';

  @override
  String dashboardOrderIdLabel(String id) {
    return 'Order #$id';
  }

  @override
  String dashboardOrderItemsSummary(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0 • $names';
  }

  @override
  String get dashboardOrderAccepted => 'Order accepted!';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsNotificationsSection => 'Notifications';

  @override
  String get settingsPushNotifications => 'Push Notifications';

  @override
  String get settingsPushNotificationsSubtitle =>
      'Alerts for new orders, payouts & updates';

  @override
  String get settingsSoundAlerts => 'Sound Alerts';

  @override
  String get settingsSoundAlertsSubtitle => 'Play sound on new order arrival';

  @override
  String get settingsOperationsSection => 'Operations';

  @override
  String get settingsAutoAcceptOrders => 'Auto-Accept Orders';

  @override
  String get settingsAutoAcceptOrdersSubtitle =>
      'Automatically accept orders when capacity is available';

  @override
  String get settingsSupportLegalSection => 'Support & Legal';

  @override
  String get settingsPartnerHelpdesk => 'Partner Helpdesk';

  @override
  String get settingsPartnerHelpdeskSubtitle =>
      'Get support from the LNDRY partner team';

  @override
  String get settingsConnectingHelpdesk => 'Connecting to partner helpdesk…';

  @override
  String get settingsTermsOfService => 'Terms of Service & SLA';

  @override
  String get settingsOpeningTerms => 'Opening Terms of Service…';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsOpeningPrivacy => 'Opening Privacy Policy…';

  @override
  String settingsFooter(String version) {
    return 'Lndry Partner • Version $version\n© 2026 LNDRY Technologies Pvt. Ltd.';
  }

  @override
  String get routerExitAppTitle => 'Exit Application?';

  @override
  String get routerExitAppMessage =>
      'Are you sure you want to exit Lndry Partner?';

  @override
  String get routerPageNotFound => 'Page not found';

  @override
  String get routerUnknownRoute => 'Unknown route';

  @override
  String get routerGoHome => 'Go Home';

  @override
  String get navHome => 'Home';

  @override
  String get navOrders => 'Orders';

  @override
  String get navServices => 'Services';

  @override
  String get navAnalytics => 'Analytics';

  @override
  String get navProfile => 'Profile';

  @override
  String get orderStatusPaymentPending => 'Payment Pending';

  @override
  String get orderStatusPaymentFailed => 'Payment Failed';

  @override
  String get orderStatusWaitingForVendorConfirmation =>
      'Waiting for Vendor Confirmation';

  @override
  String get orderStatusVendorAccepted => 'Scheduled';

  @override
  String get orderStatusPickupAssigned => 'Scheduled';

  @override
  String get orderStatusGoingForPickup => 'Pickup Partner Coming';

  @override
  String get orderStatusPickupOtpVerified => 'Picked Up';

  @override
  String get orderStatusPickedUp => 'Picked Up';

  @override
  String get orderStatusReceivedAtVendor => 'At Partner';

  @override
  String get orderStatusReconciliationPending =>
      'Re-evaluation Submitted — Waiting for Customer Approval';

  @override
  String get orderStatusReconciliationDisputed =>
      'Customer Disputed Re-evaluation';

  @override
  String get orderStatusProcessing => 'Processing';

  @override
  String get orderStatusPacked => 'Packed';

  @override
  String get orderStatusDeliveryAssigned => 'Out for Delivery';

  @override
  String get orderStatusOutForDelivery => 'Out for Delivery';

  @override
  String get orderStatusDeliveryOtpVerified => 'Delivered';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusVendorRejected => 'Rejected by Vendor';

  @override
  String get orderStatusAutoRejected => 'Auto-Rejected';

  @override
  String get orderStatusCustomerCancelled => 'Cancelled';

  @override
  String get orderStatusAdminCancelled => 'Cancelled';

  @override
  String get orderStatusRefundPending => 'Refund Pending';

  @override
  String get orderStatusRefunded => 'Refunded';

  @override
  String get ordersPageTitle => 'Operational Orders';

  @override
  String get ordersTabPending => 'Pending';

  @override
  String get ordersTabActive => 'Active';

  @override
  String get ordersTabReady => 'Ready';

  @override
  String get ordersTabHistory => 'History';

  @override
  String get ordersEmptyPendingTitle => 'No pending orders';

  @override
  String get ordersEmptyPendingSubtitle =>
      'You\'re all caught up! New orders will show up here.';

  @override
  String get ordersEmptyActiveTitle => 'No active orders';

  @override
  String get ordersEmptyActiveSubtitle =>
      'Orders currently being processed or picked up will appear here.';

  @override
  String get ordersEmptyReadyTitle => 'No ready orders';

  @override
  String get ordersEmptyReadySubtitle =>
      'Packed orders and those out for delivery will show here.';

  @override
  String get ordersEmptyHistoryTitle => 'No order history';

  @override
  String get ordersEmptyHistorySubtitle =>
      'Completed and cancelled orders will appear in your history.';

  @override
  String ordersPickupTimeLabel(String time) {
    return 'Pickup: $time';
  }

  @override
  String ordersCreatedTimeLabel(String time) {
    return 'Created: $time';
  }

  @override
  String get ordersReconcileReceiptsButton => 'Reconcile Receipts';

  @override
  String get ordersStartWashingButton => 'Start Washing';

  @override
  String get ordersUpdateStageButton => 'Update Stage';

  @override
  String get ordersMarkPackedButton => 'Mark Packed & Ready';

  @override
  String get ordersUpdateProcessingStageTitle => 'Update Processing Stage';

  @override
  String get ordersStageWashing => 'Washing';

  @override
  String get ordersStageDrying => 'Drying';

  @override
  String get ordersStageIroning => 'Ironing';

  @override
  String get ordersOrderAcceptedSnack => 'Order accepted';

  @override
  String get ordersOrderRejectedSnack => 'Order rejected';

  @override
  String ordersErrorSnack(String error) {
    return 'Error: $error';
  }

  @override
  String ordersStageUpdatedSnack(String stage) {
    return 'Stage updated to $stage';
  }

  @override
  String get orderDetailsPerKg => 'Per kg';

  @override
  String get orderDetailsPerSqFt => 'Per sq ft';

  @override
  String get orderDetailsPerItem => 'Per item';

  @override
  String get orderDetailsChooseServiceTitle => 'Choose a service';

  @override
  String get orderDetailsMoveServiceTitle => 'Move to a different service';

  @override
  String get orderDetailsAddServiceTitle => 'Add a service';

  @override
  String get orderDetailsQuantityLabel => 'Quantity';

  @override
  String get orderDetailsAddButton => 'Add';

  @override
  String orderDetailsPhotoUploadFailed(String error) {
    return 'Photo upload failed: $error';
  }

  @override
  String get orderDetailsPhotoRequired => 'At least one photo is required';

  @override
  String get orderDetailsProblemReportRequired =>
      'Report to Re-evaluation on at least one item before submitting';

  @override
  String get orderDetailsSubmittedForApproval =>
      'Submitted for customer approval';

  @override
  String orderDetailsReconciliationFailed(String error) {
    return 'Reconciliation failed: $error';
  }

  @override
  String get orderDetailsReconcileSheetTitle => 'Reconcile Order items';

  @override
  String get orderDetailsReconcileSheetSubtitle =>
      'This will be sent to the customer for approval before processing continues.';

  @override
  String orderDetailsEstQuantity(String quantity) {
    return 'Est: $quantity';
  }

  @override
  String orderDetailsMovedFrom(String from, String to) {
    return 'Moved from $from → $to';
  }

  @override
  String get orderDetailsChangeServiceAgain => 'Change service again';

  @override
  String get orderDetailsMoveServicePrompt => 'Not the right service? Move it';

  @override
  String get orderDetailsAddServiceButton => 'Add Service';

  @override
  String get orderDetailsAdjustmentNoteLabel => 'Adjustment Note / Reason';

  @override
  String get orderDetailsAdjustmentNoteHint =>
      'e.g. 1 shirt added, dirty collar notes';

  @override
  String get orderDetailsPhotoEvidenceLabel => 'Photo evidence (required)';

  @override
  String get orderDetailsPhotoEvidenceOptionalLabel =>
      'Additional photo evidence (optional — already covered by your re-evaluation report below)';

  @override
  String get orderDetailsReportProblemButton => 'Report to Re-evaluation';

  @override
  String get orderDetailsReportProblemTitle => 'Report to Re-evaluation';

  @override
  String get orderDetailsProblemTypeLabel => 'What\'s the problem?';

  @override
  String get orderDetailsProblemOtherOption => 'Other';

  @override
  String get orderDetailsProblemCustomMessageLabel => 'Describe the problem';

  @override
  String get orderDetailsProblemCustomMessageHint =>
      'e.g. Zipper broken on this item';

  @override
  String get orderDetailsProblemPhotoLabel => 'Photo evidence (1-3 required)';

  @override
  String get orderDetailsProblemRemoveButton => 'Remove';

  @override
  String get orderDetailsProblemSaveButton => 'Save Report';

  @override
  String get orderDetailsReportedProblemsHeader => 'Re-evaluation Reports';

  @override
  String orderDetailsProblemForItem(String item) {
    return 'For: $item';
  }

  @override
  String get orderDetailsSubmitButton => 'Submit for Customer Approval';

  @override
  String get orderDetailsRejectOrderTitle => 'Reject Order';

  @override
  String get orderDetailsRejectionReasonLabel => 'Rejection Reason';

  @override
  String get orderDetailsRejectionReasonHint =>
      'e.g. Shop capacity exceeded today';

  @override
  String get orderDetailsConfirmRejectButton => 'Confirm Reject';

  @override
  String get orderDetailsPageTitle => 'Order Details';

  @override
  String get orderDetailsAwaitingApprovalTitle => 'Awaiting customer approval';

  @override
  String get orderDetailsAwaitingApprovalBody =>
      'The customer is reviewing your proposed total change. Processing is paused until they respond.';

  @override
  String get orderDetailsDisputedTitle =>
      'Customer rejected the proposed total';

  @override
  String get orderDetailsDisputedBody =>
      'Call the customer to resolve this, then resubmit the reconciliation with corrected items/photos.';

  @override
  String get orderDetailsLifecycleStepper => 'Lifecycle Stepper';

  @override
  String get orderDetailsCustomerDetails => 'Customer details';

  @override
  String get orderDetailsCustomerFallback => 'Customer';

  @override
  String orderDetailsCustomerNote(String note) {
    return 'Note: $note';
  }

  @override
  String get orderDetailsGarmentItems => 'Garment Items';

  @override
  String get orderDetailsReconcileCountButton => 'Reconcile count';

  @override
  String orderDetailsQuantityValue(String quantity) {
    return 'Quantity: $quantity';
  }

  @override
  String get orderDetailsSubtotal => 'Subtotal';

  @override
  String get orderDetailsGstTaxes => 'GST / Taxes';

  @override
  String get orderDetailsPlatformFee => 'Platform fee';

  @override
  String get orderDetailsDeliveryFee => 'Delivery fee';

  @override
  String get orderDetailsHandlingFee => 'Handling fee';

  @override
  String get orderDetailsTotalPayable => 'Total Payable';

  @override
  String get orderDetailsServiceFee => 'Service Fee';

  @override
  String orderDetailsLndryCommission(String rate) {
    return 'LNDRY Commission ($rate%)';
  }

  @override
  String get orderDetailsLndryCommissionFlat => 'LNDRY Commission';

  @override
  String orderDetailsGstOnCommission(String rate) {
    return 'GST on Commission ($rate%)';
  }

  @override
  String get orderDetailsVendorPayout => 'You\'ll Receive';

  @override
  String get orderDetailsPickupRiderLabel => 'Pickup Captain';

  @override
  String get orderDetailsDeliveryRiderLabel => 'Delivery Captain';

  @override
  String get orderDetailsAssignRiderHint => 'Choose who handles this order';

  @override
  String get orderDetailsAssignRiderButton => 'Assign';

  @override
  String get orderDetailsAssignRiderTitle => 'Assign Captain';

  @override
  String get orderDetailsNoActiveRiders =>
      'No active captains yet. Add one from Captain Management.';

  @override
  String get orderDetailsRiderAssignedSnack => 'Captain assigned';

  @override
  String get orderDetailsBroadcastButton => 'Broadcast to All Captains';

  @override
  String get orderDetailsBroadcastSnack => 'Broadcast sent to active captains';

  @override
  String orderDetailsAssignedToRider(String name) {
    return 'Assigned to $name';
  }

  @override
  String get orderDetailsOfferPendingBroadcast =>
      'Offer sent to all captains — awaiting acceptance';

  @override
  String orderDetailsOfferPendingSingle(String name) {
    return 'Offered to $name — awaiting response';
  }

  @override
  String get orderDetailsReassignButton => 'Reassign';

  @override
  String get jobOfferTitle => 'New Job Offer!';

  @override
  String jobOfferOrderNumber(String orderNumber) {
    return 'Order #$orderNumber';
  }

  @override
  String get jobOfferAcceptButton => 'Accept';

  @override
  String get jobOfferAcceptedSnack => 'Job accepted — check My Jobs';

  @override
  String get jobOfferUnavailableSnack =>
      'Too late — someone else already took this job';

  @override
  String get jobOfferNotNowButton => 'Not Now';

  @override
  String jobOfferCountdownLabel(String time) {
    return 'Auto re-offers in $time';
  }

  @override
  String get jobOfferExpiredLabel => 'Re-offering now…';

  @override
  String get orderDetailsCustomerReview => 'Customer Review';

  @override
  String get orderDetailsVendorRating => 'Vendor rating';

  @override
  String get orderDetailsDeliveryRating => 'Delivery rating';

  @override
  String get orderDetailsSubmittedReevaluation => 'Submitted Re-evaluation';

  @override
  String get orderDetailsNewServiceAdded => 'New service added';

  @override
  String orderDetailsMovedGeneric(String from, String to) {
    return 'Moved: $from → $to';
  }

  @override
  String get orderDetailsItemFallback => 'Item';

  @override
  String get orderDetailsPreviousTotal => 'Previous total';

  @override
  String get orderDetailsFinalEvaluatedAmount => 'Final Evaluated Amount';

  @override
  String get orderDetailsAdjustmentNoteHeader => 'Adjustment Note';

  @override
  String get orderDetailsPhotoEvidenceHeader => 'Photo Evidence';

  @override
  String get orderDetailsStageWaiting => 'WAITING';

  @override
  String get orderDetailsStageAccepted => 'ACCEPTED';

  @override
  String get orderDetailsStageReceived => 'RECEIVED';

  @override
  String get orderDetailsStageCustomerApproval => 'CUSTOMER APPROVAL';

  @override
  String get orderDetailsStageProcessing => 'PROCESSING';

  @override
  String get orderDetailsStagePacked => 'PACKED';

  @override
  String get orderDetailsStageDelivered => 'DELIVERED';

  @override
  String get orderDetailsRejectOrderButton => 'Reject Order';

  @override
  String get orderDetailsAcceptOrderButton => 'Accept Order';

  @override
  String get orderDetailsMarkReceivedButton => 'Mark as Received';

  @override
  String get orderDetailsReconcileItemsButton => 'Reconcile items';

  @override
  String get orderDetailsStartProcessingButton => 'Start Processing';

  @override
  String get orderDetailsWaitingApprovalStatus =>
      'Waiting for customer approval';

  @override
  String get orderDetailsResubmitButton => 'Resubmit Reconciliation';

  @override
  String orderDetailsErrorLoading(String error) {
    return 'Error loading details: $error';
  }

  @override
  String get orderDetailsOtherCategoryFallback => 'Other';

  @override
  String get serviceCategoryWash => 'Wash';

  @override
  String get serviceCategoryIron => 'Iron';

  @override
  String get serviceCategoryWashAndIron => 'Wash & Iron';

  @override
  String get serviceCategoryDryClean => 'Dry Clean';

  @override
  String get serviceCategoryFold => 'Fold';

  @override
  String get serviceCategoryPremium => 'Premium';

  @override
  String get slotsSunday => 'Sunday';

  @override
  String get slotsMonday => 'Monday';

  @override
  String get slotsTuesday => 'Tuesday';

  @override
  String get slotsWednesday => 'Wednesday';

  @override
  String get slotsThursday => 'Thursday';

  @override
  String get slotsFriday => 'Friday';

  @override
  String get slotsSaturday => 'Saturday';

  @override
  String get servicesStatusPendingReview => 'Pending Review';

  @override
  String get servicesStatusRejected => 'Rejected';

  @override
  String get servicesStatusLive => 'Live';

  @override
  String get servicesPageTitle => 'Catalogue & Services';

  @override
  String get servicesEmptyTitle => 'No Services Yet';

  @override
  String get servicesEmptySubtitle =>
      'Tap \"Add Service\" to pick a category, choose subcategories and set your prices.';

  @override
  String servicesRejectedReason(String reason) {
    return 'Rejected: $reason';
  }

  @override
  String servicesPriceAdjustedByAdmin(String reason) {
    return 'Price adjusted by admin: $reason';
  }

  @override
  String servicesFailedToLoad(String error) {
    return 'Failed to load services: $error';
  }

  @override
  String get servicesAddServiceButton => 'Add Service';

  @override
  String get servicesPickCategorySnack => 'Please pick a category';

  @override
  String get servicesTurnOnSubcategorySnack =>
      'Turn on at least one subcategory to offer';

  @override
  String get servicesEnterPriceSnack =>
      'Enter a price greater than ₹0 for every activated subcategory';

  @override
  String get servicesSubmittedForReview => 'Submitted for admin review';

  @override
  String servicesFailedToSave(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get servicesEditServiceTitle => 'Edit Service';

  @override
  String servicesRejectedByAdminNote(String reason) {
    return 'Rejected by admin: $reason\nMake changes and save to resubmit for review.';
  }

  @override
  String get servicesServiceNameLabel => 'Service Name';

  @override
  String get servicesServiceNameHint => 'e.g. Premium Laundry Services';

  @override
  String get servicesNameRequired => 'Name is required';

  @override
  String get servicesDescriptionLabel => 'Description';

  @override
  String get servicesDescriptionHint =>
      'e.g. Quick turnaround, doorstep pickup';

  @override
  String get servicesDescriptionRequired => 'Description is required';

  @override
  String get servicesCategoryLabel => 'Category';

  @override
  String get servicesCategoryRequired => 'Category is required';

  @override
  String get servicesSubcategoriesHeader => 'Subcategories';

  @override
  String get servicesSubcategoriesSubtitle =>
      'Pick what you want to offer from this category and set your own price. Unit is fixed by admin.';

  @override
  String servicesFailedToLoadSubcategories(String error) {
    return 'Failed to load: $error';
  }

  @override
  String get servicesNoSubcategoriesPublished =>
      'Admin hasn\'t published any subcategories here yet.';

  @override
  String get servicesSaveSubmitButton => 'Save & Submit for Review';

  @override
  String servicesUnitPer(String unit) {
    return 'Unit: per $unit';
  }

  @override
  String servicesDemoPriceReferenceOnly(String price, String unit) {
    return 'Demo price: ₹$price/$unit — reference only';
  }

  @override
  String get servicesPriceAdjustedHeader => 'Price adjusted by admin';

  @override
  String servicesYourPricePer(String unit) {
    return 'Your price per $unit';
  }

  @override
  String get pricingEnterPriceSnack =>
      'Enter a price greater than ₹0 for every activated subcategory.';

  @override
  String get pricingPageTitle => 'Garment Pricing Rates';

  @override
  String get pricingCreateServiceFirst =>
      'Please create a laundry service offering first to configure custom pricing rates.';

  @override
  String pricingFailedToLoad(String error) {
    return 'Failed to load pricing: $error';
  }

  @override
  String pricingErrorLoadingServices(String error) {
    return 'Error loading services: $error';
  }

  @override
  String get pricingSaveChangesButton => 'Save Changes';

  @override
  String get pricingNoSubcategoriesPublished =>
      'Admin hasn\'t published any subcategories for this service yet.';

  @override
  String pricingUnitBillingPer(String unit) {
    return 'Unit billing: per $unit';
  }

  @override
  String pricingDemoPriceChargeWhatYouLike(String price, String unit) {
    return 'Demo price: ₹$price/$unit — you can charge whatever you like';
  }

  @override
  String get pricingPricesSaved => 'Prices saved';

  @override
  String pricingFailedToSavePrices(String error) {
    return 'Failed to save prices: $error';
  }

  @override
  String get inventoryPageTitle => 'Operational Supplies';

  @override
  String get inventoryAddSupplyItemTitle => 'Add Supply Item';

  @override
  String get inventoryItemNameLabel => 'Item Name';

  @override
  String get inventoryItemNameHint => 'e.g. Collar Scrub';

  @override
  String get inventoryRequiredField => 'Required';

  @override
  String get inventoryInitialQtyLabel => 'Initial Qty';

  @override
  String get inventoryMinLimitLabel => 'Min Limit';

  @override
  String get inventoryUnitLabel => 'Unit';

  @override
  String get inventoryUnitHint => 'e.g. Liters, Bags, Cans';

  @override
  String get inventoryAddItemButton => 'Add Item';

  @override
  String get inventoryItemAddedSnack => 'Item added to inventory';

  @override
  String get inventoryLowStockWarningTitle => 'Low Stock Warning';

  @override
  String inventoryLowStockWarningBody(int count) {
    return '$count supplies are running low. Please order soon.';
  }

  @override
  String inventoryQuantityOfThreshold(
      String qty, String threshold, String unit) {
    return '$qty / $threshold $unit (Min limit)';
  }

  @override
  String get inventoryOutBadge => 'OUT';

  @override
  String get inventoryLowBadge => 'LOW';

  @override
  String get slotsPageTitle => 'Working Hours & Slots';

  @override
  String get slotsCapacityRequestedSnack =>
      'Capacity change requested — pending admin approval';

  @override
  String slotsFailedToUpdateCapacity(String error) {
    return 'Failed to update capacity: $error';
  }

  @override
  String slotsFailedGeneric(String error) {
    return 'Failed: $error';
  }

  @override
  String get slotsSlotDeletedSnack => 'Slot deleted';

  @override
  String get slotsClosingAfterOpening =>
      'Closing time must be after opening time.';

  @override
  String get slotsOperationalWorkingHours => 'Operational Working Hours';

  @override
  String get slotsToLabel => 'to';

  @override
  String get slotsClosedLabel => 'Closed';

  @override
  String slotsErrorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get slotsDailyCapacityLimit => 'Daily Capacity Limit';

  @override
  String slotsPendingRequestNotice(String limit) {
    return 'Request to change to $limit orders/day is pending review.';
  }

  @override
  String get slotsMaxOrdersPerDayLabel => 'Max Orders per Day';

  @override
  String get slotsMaxOrdersHint => 'e.g. 20';

  @override
  String get slotsRequiredField => 'Required';

  @override
  String get slotsUpdateRequestButton => 'Update request';

  @override
  String get slotsUpdateButton => 'Update';

  @override
  String slotsErrorLoading(String error) {
    return 'Error loading: $error';
  }

  @override
  String get slotsWeeklySlotsSchedule => 'Weekly Slots Schedule';

  @override
  String get slotsNoCustomSlots =>
      'No custom slots configured. Tap \"+\" to add working hours.';

  @override
  String slotsMaxOrdersBadge(String count) {
    return 'Max $count orders';
  }

  @override
  String get slotsEditPickupTimeSlotTitle => 'Edit Pickup Time Slot';

  @override
  String get slotsAddPickupTimeSlotTitle => 'Add Pickup Time Slot';

  @override
  String get slotsDayOfWeekLabel => 'Day of Week';

  @override
  String get slotsStartTimeLabel => 'Start Time';

  @override
  String get slotsStartTimeHint => 'e.g. 09:00';

  @override
  String get slotsEndTimeLabel => 'End Time';

  @override
  String get slotsEndTimeHint => 'e.g. 12:00';

  @override
  String get slotsMaxOrdersLimitLabel => 'Max Orders Limit';

  @override
  String get slotsMaxOrdersLimitHint => 'e.g. 5';

  @override
  String get slotsInvalidNumber => 'Invalid number';

  @override
  String get slotsUpdateSlotButton => 'Update Slot';

  @override
  String get slotsSaveSlotButton => 'Save Slot';

  @override
  String get slotsSlotUpdatedSnack => 'Slot updated successfully';

  @override
  String get slotsPickupSlotAddedSnack => 'Pickup slot added';

  @override
  String get slotsDayClosedError =>
      'The selected day is closed under Working Hours.';

  @override
  String slotsOutsideWorkingHoursError(String open, String close) {
    return 'Slot times must be within operational working hours ($open to $close).';
  }

  @override
  String slotsOverlapError(String start, String end, String day) {
    return 'This slot overlaps with an existing slot: $start - $end on $day.';
  }

  @override
  String get analyticsWeekSegment => 'Week';

  @override
  String get analyticsMonthSegment => 'Month';

  @override
  String get analyticsFailedToLoad => 'Failed to load analytics';

  @override
  String get analyticsTotalRevenue => 'Total Revenue';

  @override
  String analyticsOrdersDeliveredSub(int count) {
    return '$count orders delivered';
  }

  @override
  String get analyticsAvgTicketSize => 'Avg Ticket Size';

  @override
  String get analyticsPerCompletedOrderSub => 'per completed order';

  @override
  String get analyticsFulfillmentRate => 'Fulfillment Rate';

  @override
  String analyticsOfTotalOrdersSub(int count) {
    return 'of $count total orders';
  }

  @override
  String get analyticsTotalOrders => 'Total Orders';

  @override
  String get analyticsInSelectedPeriodSub => 'in selected period';

  @override
  String analyticsOrderVolumeLastNDays(int days) {
    return 'Order Volume (Last $days Days)';
  }

  @override
  String get analyticsNoOrdersRecorded => 'No orders recorded in this period.';

  @override
  String get analyticsCategoryRevenueShare => 'Category Revenue Share';

  @override
  String get analyticsNoDeliveredOrders =>
      'No delivered orders in this period.';

  @override
  String get analyticsSlaCustomerRetention => 'SLA & Customer Retention';

  @override
  String get analyticsOnTimeDelivery => 'On-Time Delivery';

  @override
  String get analyticsRepeatCustomers => 'Repeat Customers';

  @override
  String get employeesEditStaffTitle => 'Edit Staff Member';

  @override
  String get employeesInviteStaffTitle => 'Invite Staff Member';

  @override
  String get employeesFullNameLabel => 'Full Name';

  @override
  String get employeesFullNameHint => 'e.g. John Doe';

  @override
  String get employeesNameRequired => 'Name is required';

  @override
  String get employeesEmailLabel => 'Email Address';

  @override
  String get employeesEmailHint => 'e.g. johndoe@lndry.com';

  @override
  String get employeesEmailRequired => 'Email is required';

  @override
  String get employeesEmailInvalid => 'Invalid email';

  @override
  String get employeesPhoneOptionalLabel => 'Phone Number (Optional)';

  @override
  String get employeesPhoneHint => 'e.g. 9876543210';

  @override
  String get employeesShopRoleLabel => 'Shop Role';

  @override
  String get employeesRoleOwner => 'Vendor Owner (Admin)';

  @override
  String get employeesRoleStaff => 'Vendor Staff';

  @override
  String get employeesPermissionsHeader => 'Permissions';

  @override
  String get employeesPermReadOrders => 'Read Orders';

  @override
  String get employeesPermProcessOrders => 'Process & Confirm Orders';

  @override
  String get employeesPermManageCatalog => 'Manage Services & Pricing';

  @override
  String get employeesPermManageEmployees => 'Manage Employees';

  @override
  String get employeesSaveChangesButton => 'Save Changes';

  @override
  String get employeesInviteStaffButton => 'Invite Staff';

  @override
  String get employeesStaffUpdatedSnack => 'Staff record updated';

  @override
  String get employeesInvitationSentSnack => 'Invitation sent';

  @override
  String employeesResetPasswordTitle(String name) {
    return 'Reset Password for $name';
  }

  @override
  String get employeesNewPasswordLabel => 'New Password';

  @override
  String get employeesNewPasswordHint =>
      'Minimum 8 characters with 1 letter & 1 digit';

  @override
  String get employeesPasswordTooShort => 'Password too short';

  @override
  String get employeesPasswordUpdatedSnack => 'Password updated successfully';

  @override
  String employeesResetFailedSnack(String error) {
    return 'Reset failed: $error';
  }

  @override
  String get employeesRemoveStaffTitle => 'Remove Staff Member';

  @override
  String employeesRemoveStaffConfirm(String name) {
    return 'Are you sure you want to remove $name from this shop?';
  }

  @override
  String get employeesConfirmRemoveButton => 'Confirm Remove';

  @override
  String get employeesStaffRemovedSnack => 'Staff member removed';

  @override
  String get employeesPageTitle => 'Shop Employees';

  @override
  String get employeesEmptyTitle => 'No Employees Found';

  @override
  String get employeesEmptySubtitle =>
      'Invite staff to assist you in managing laundry intake, status updates, and dispatch.';

  @override
  String get employeesOwnerBadge => 'OWNER';

  @override
  String get employeesStaffBadge => 'STAFF';

  @override
  String get employeesResetPassButton => 'Reset Pass';

  @override
  String get employeesSavePasswordButton => 'Save Password';

  @override
  String get employeesPermissionsButton => 'Permissions';

  @override
  String employeesFailedToLoad(String error) {
    return 'Failed to load employees: $error';
  }

  @override
  String get riderManagementAddRiderTitle => 'Add Captain';

  @override
  String get riderManagementAddRiderSubtitle =>
      'The captain logs in with this phone number, the same way you do.';

  @override
  String get riderManagementFullNameHint => 'e.g. Rahul Sen';

  @override
  String get riderManagementPhoneLabel => 'Phone Number';

  @override
  String get riderManagementPhoneInvalid =>
      'Enter a valid 10-digit mobile number.';

  @override
  String get riderManagementRiderAddedSnack => 'Captain added';

  @override
  String get riderManagementRemoveRiderTitle => 'Remove Captain';

  @override
  String riderManagementRemoveConfirm(String name) {
    return 'Are you sure you want to remove $name?';
  }

  @override
  String get riderManagementPageTitle => 'Captain Management';

  @override
  String get riderManagementEmptyTitle => 'No Captains Yet';

  @override
  String get riderManagementEmptySubtitle =>
      'Add your own delivery captains — they log in with their phone and only see their assigned pickups and deliveries.';

  @override
  String riderManagementFailedToLoad(String error) {
    return 'Failed to load captains: $error';
  }

  @override
  String riderMyJobsTitleWithVendor(String vendor) {
    return '$vendor — My Jobs';
  }

  @override
  String get riderMyJobsTitle => 'My Jobs';

  @override
  String get riderNoJobsTitle => 'No Jobs Right Now';

  @override
  String get riderNoJobsSubtitle =>
      'Pickup and delivery jobs assigned to you will show up here.';

  @override
  String riderFailedToLoadJobs(String error) {
    return 'Failed to load jobs: $error';
  }

  @override
  String get riderPickupBadge => 'PICKUP';

  @override
  String get riderDeliveryBadge => 'DELIVERY';

  @override
  String get riderInProgressBadge => 'IN PROGRESS';

  @override
  String get riderOtpEnterCode => 'Enter the 6-digit code';

  @override
  String get riderOtpPickupConfirmedSnack => 'Pickup confirmed';

  @override
  String get riderOtpDeliveryConfirmedSnack => 'Delivery confirmed';

  @override
  String get riderOtpInvalidExpired =>
      'Invalid or expired code. Please try again.';

  @override
  String get riderConfirmPickupTitle => 'Confirm Pickup';

  @override
  String get riderConfirmDeliveryTitle => 'Confirm Delivery';

  @override
  String get riderOtpPrompt =>
      'Ask the customer for the code shown in their app, then enter it below.';

  @override
  String get riderNoLocationSnack => 'No location available for this address';

  @override
  String get riderCouldNotOpenMaps => 'Could not open Google Maps';

  @override
  String riderCouldNotStartPickup(String error) {
    return 'Could not start pickup: $error';
  }

  @override
  String riderCouldNotStartDelivery(String error) {
    return 'Could not start delivery: $error';
  }

  @override
  String get riderCancelPickupNotAvailable =>
      'Cancel pickup is not available yet.';

  @override
  String get riderJobDetailTitle => 'Job Detail';

  @override
  String riderFailedToLoadJob(String error) {
    return 'Failed to load job: $error';
  }

  @override
  String get riderItemsHeader => 'Items';

  @override
  String get riderNavigateButton => 'Navigate';

  @override
  String riderPaymentPending(String amount) {
    return 'Payment Pending – $amount';
  }

  @override
  String get riderFullPaymentCompleted => 'Full Payment Completed';

  @override
  String get riderRefreshPaymentTooltip => 'Refresh payment status';

  @override
  String get riderCustomerPaymentPendingSnack =>
      'Customer payment is still pending. Delivery cannot be completed.';

  @override
  String get riderStartPickupButton => 'Start Pickup';

  @override
  String get riderStartDeliveryButton => 'Start Delivery';

  @override
  String get riderPickUpButton => 'Pick Up';

  @override
  String get riderMarkDeliveredButton => 'Mark Delivered';

  @override
  String get riderCancelPickupButton => 'Cancel Pickup';

  @override
  String get riderConfirmWeightCountTitle => 'Confirm Weight & Count';

  @override
  String get riderWeighRecountPrompt =>
      'Weigh and recount the customer\'s items now — this corrects their rough estimate before pickup is confirmed.';

  @override
  String get riderWeightAreaBasedHeader => 'Weight / Area Based';

  @override
  String riderEnterExactUnit(String unit) {
    return 'Enter exact $unit';
  }

  @override
  String get riderPieceBasedHeader => 'Piece Based';

  @override
  String riderFailedSaveMeasurements(String error) {
    return 'Failed to save measurements: $error';
  }

  @override
  String get riderSaveContinueButton => 'Save & Continue';

  @override
  String riderWeightBasedItemsLabel(String items) {
    return 'Weight-based items ($items)';
  }

  @override
  String riderMaxPhotosPerItem(String max) {
    return 'Maximum $max photos per item.';
  }

  @override
  String riderFailedSavePhotos(String error) {
    return 'Failed to save photos: $error';
  }

  @override
  String get riderGarmentConditionPhotosTitle => 'Garment Condition Photos';

  @override
  String get riderPhotographEachItemPrompt =>
      'Photograph each item before pickup — this protects both you and the customer if there\'s ever a damage dispute.';

  @override
  String riderPhotosCountLabel(String count, String max) {
    return '$count/$max photos · 1 required, rest optional';
  }

  @override
  String get riderSaveButton => 'Save';

  @override
  String get riderCollectBalanceTitle => 'Collect Balance';

  @override
  String get riderBalanceDueLabel => 'Balance Due';

  @override
  String get riderPaymentMethodCod => 'Payment method: Cash on Delivery';

  @override
  String get riderPaymentMethodOnline => 'Payment method: Online';

  @override
  String get riderNoBalanceDueBanner => 'No balance due for this order.';

  @override
  String get riderCustomerPaysOnlineBanner =>
      'The customer pays this balance online in their own app. No action needed from you.';

  @override
  String get riderCashCollectionRecordedBanner => 'Cash collection recorded.';

  @override
  String riderFailedRecordCashCollection(String error) {
    return 'Failed to record cash collection: $error';
  }

  @override
  String riderConfirmCashCollectedButton(String amount) {
    return 'Confirm $amount Cash Collected';
  }

  @override
  String get riderContinueButton => 'Continue';

  @override
  String get riderDeliveryPhotoTitle => 'Delivery Photo';

  @override
  String get riderOptionalPhotoPrompt =>
      'Optionally photograph the handover as delivery proof. This step can be skipped.';

  @override
  String get riderTakePhotoLabel => 'Take Photo';

  @override
  String riderFailedSavePhoto(String error) {
    return 'Failed to save photo: $error';
  }

  @override
  String get riderSkipContinueButton => 'Skip & Continue';

  @override
  String get notificationsJustNow => 'Just now';

  @override
  String notificationsMinsAgo(int mins) {
    return '$mins mins ago';
  }

  @override
  String notificationsHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hrs ago',
      one: '1 hr ago',
    );
    return '$_temp0';
  }

  @override
  String notificationsDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get notificationsPageTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String notificationsFailedToLoad(String error) {
    return 'Failed to load notifications: $error';
  }

  @override
  String get notificationsEmptyTitle => 'No Notifications Yet';

  @override
  String get notificationsEmptySubtitle =>
      'Operational push updates, payout alerts, and admin pricing notes will appear here.';

  @override
  String get profileUpdatedSnack => 'Profile updated successfully';

  @override
  String get profileCropLogoTitle => 'Crop Logo';

  @override
  String get profileCropBannerTitle => 'Crop Banner Image';

  @override
  String get profileLogoUpdatedSnack => 'Logo updated';

  @override
  String get profileBannerUpdatedSnack => 'Banner image updated';

  @override
  String profileFailedUploadImage(String error) {
    return 'Failed to upload image: $error';
  }

  @override
  String get profileLogoutTitle => 'Logout';

  @override
  String get profileLogoutConfirm =>
      'Are you sure you want to log out of your vendor account?';

  @override
  String get profilePublishedSnack =>
      'Published to marketplace — customers can now discover you.';

  @override
  String profileFailedToPublish(String error) {
    return 'Failed to publish: $error';
  }

  @override
  String get profilePageTitle => 'My Profile';

  @override
  String get profileBestFitNote =>
      'Best fit — logo: 500×500px square. Banner: 780×1080px portrait. Matches exactly how customers see your shop, so nothing gets stretched or cropped oddly.';

  @override
  String get profileEditBusinessDetails => 'Edit Business Details';

  @override
  String get profileBusinessNameLabel => 'Business Name';

  @override
  String get profileRequiredField => 'Required';

  @override
  String get profileBusinessEmailLabel => 'Business Email';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileBusinessDescriptionLabel => 'Business Description';

  @override
  String get profileAddressLine1Label => 'Address Line 1';

  @override
  String get profileCityLabel => 'City';

  @override
  String get profileStateLabel => 'State';

  @override
  String get profilePincodeLabel => 'Pincode';

  @override
  String get profileVerifiedPhoneLabel => 'Verified Phone (cannot change)';

  @override
  String get profileNotSetValue => 'Not set';

  @override
  String get profileAddressFieldLabel => 'Address';

  @override
  String get profileAccountSection => 'Account';

  @override
  String get profileNotificationsSubtitle => 'View order alerts and updates';

  @override
  String get profileSettingsSubtitle => 'App preferences and theme';

  @override
  String get profileBusinessSection => 'Business';

  @override
  String get profileCatalogueSubtitle =>
      'Pick categories, activate subcategories, set your prices';

  @override
  String get profilePublishLabel => 'Publish to Marketplace';

  @override
  String get profilePublishSubtitle =>
      'Make your shop discoverable to customers';

  @override
  String get profileStaffLabel => 'Staff Management';

  @override
  String get profileStaffSubtitle => 'Add and manage employees';

  @override
  String get profileRiderSubtitle => 'Add and manage your delivery captains';

  @override
  String get profileSlotsLabel => 'Pickup Slots';

  @override
  String get profileSlotsSubtitle => 'Manage availability and capacity';

  @override
  String get profileInventoryLabel => 'Inventory & Supplies';

  @override
  String get profileInventorySubtitle => 'Track laundry supplies and stock';

  @override
  String get profileSupportSection => 'Support';

  @override
  String get profileHelpLabel => 'Help & Support';

  @override
  String get profileHelpSubtitle => 'Get assistance from our partner team';

  @override
  String get profileAboutLabel => 'About LNDRY';

  @override
  String profileAboutSubtitle(String version) {
    return 'Version $version • © 2026 LNDRY Technologies';
  }

  @override
  String get onboardingStepBusinessDetails => 'Business Details';

  @override
  String get onboardingStepOwnerBank => 'Owner & Bank Details';

  @override
  String get onboardingStepLocation => 'Shop Location';

  @override
  String get onboardingStepRadius => 'Radius & Capacity';

  @override
  String get onboardingStepDocuments => 'Documents';

  @override
  String get onboardingStepReview => 'Review & Submit';

  @override
  String get onboardingLoadError =>
      'Could not load your application. Please try again.';

  @override
  String get onboardingUploadAllDocuments =>
      'Please upload all required documents before submitting.';

  @override
  String get onboardingUploadDocumentsToContinue =>
      'Please upload all required documents to continue.';

  @override
  String get onboardingVendorApplicationTitle => 'Vendor Application';

  @override
  String get onboardingApplicationSubmittedTitle => 'Application Submitted';

  @override
  String get onboardingApplicationSubmittedBody =>
      'Your application is pending review by our team. We will notify you once it is approved.';

  @override
  String get onboardingLogOutButton => 'Log Out';

  @override
  String onboardingStepOfTotal(int current, int total, String title) {
    return 'Step $current of $total: $title';
  }

  @override
  String get onboardingCorrectionNeeded => 'Correction needed';

  @override
  String get onboardingCorrectionOnlyFlaggedEditable =>
      'Only the sections above are editable — everything else is locked as you originally submitted it.';

  @override
  String get onboardingBusinessNameLabel => 'Business Name';

  @override
  String get onboardingBusinessNameHint => 'e.g. Sparkle Laundry Co.';

  @override
  String get onboardingBusinessNameRequired => 'Business name is required';

  @override
  String get onboardingDescriptionHint =>
      'Tell customers what your shop specializes in';

  @override
  String get onboardingGstLabel => 'GST Number (optional)';

  @override
  String get onboardingPanLabel => 'PAN Number (optional)';

  @override
  String get onboardingOwnerNameLabel => 'Owner Name';

  @override
  String get onboardingOwnerNameHint => 'Full name of the shop owner';

  @override
  String get onboardingOwnerNameRequired => 'Owner name is required';

  @override
  String get onboardingEmailOptionalLabel => 'Email (optional)';

  @override
  String get onboardingBankDetailsOptionalHeader => 'Bank Details (optional)';

  @override
  String get onboardingBankAccountLabel => 'Bank Account Number';

  @override
  String get onboardingIfscLabel => 'IFSC Code';

  @override
  String get onboardingBankNameLabel => 'Bank Name';

  @override
  String get onboardingAccountHolderLabel => 'Account Holder Name';

  @override
  String get onboardingDetectingLocation => 'Detecting…';

  @override
  String get onboardingUseCurrentLocation => 'Use Current Location';

  @override
  String get onboardingAddressLine1Hint => 'Shop / building name';

  @override
  String get onboardingAddressRequired => 'Address is required';

  @override
  String get onboardingAddressLine2Label => 'Address Line 2 (optional)';

  @override
  String get onboardingPincodeRequired => 'Pincode is required';

  @override
  String get onboardingPincodeInvalid => 'Enter a valid 6-digit pincode';

  @override
  String onboardingDetectedCoords(String lat, String lng) {
    return 'Detected: $lat, $lng';
  }

  @override
  String get onboardingRadiusQuestion =>
      'How far should we look for customers around your shop?';

  @override
  String onboardingKmValue(String km) {
    return '$km km';
  }

  @override
  String get onboardingCapacityQuestion =>
      'How many orders can you handle per day?';

  @override
  String get onboardingCustomLabel => 'Custom';

  @override
  String get onboardingUploadDocumentsPrompt =>
      'Upload the following to complete your application.';

  @override
  String get onboardingOwnerIdentityTitle => 'Owner Identity';

  @override
  String get onboardingShopPhotoTitle => 'Shop Photo';

  @override
  String get onboardingServiceListTitle => 'Service List (PDF)';

  @override
  String get onboardingReplaceButton => 'Replace';

  @override
  String get onboardingUploadButton => 'Upload';

  @override
  String get onboardingUploadedLabel => 'Uploaded';

  @override
  String get onboardingReviewPrompt => 'Review your details before submitting.';

  @override
  String get onboardingReviewOwner => 'Owner';

  @override
  String get onboardingReviewServiceRadius => 'Service radius';

  @override
  String get onboardingReviewDailyCapacity => 'Daily capacity';

  @override
  String onboardingOrdersPerDay(int count) {
    return '$count orders/day';
  }

  @override
  String get onboardingReviewOwnerIdentity => 'Owner identity';

  @override
  String get onboardingReviewShopPhoto => 'Shop photo';

  @override
  String get onboardingReviewServiceList => 'Service list';

  @override
  String get onboardingMissingLabel => 'Missing';

  @override
  String get onboardingBackButton => 'Back';

  @override
  String get onboardingSubmitApplicationButton => 'Submit Application';

  @override
  String get onboardingNextButton => 'Next';

  @override
  String get helpFaq1Q => 'How do I accept an order?';

  @override
  String get helpFaq1A =>
      'When a new order arrives, it appears in your Dashboard under \"New Incoming Orders\". Tap \"Accept\" to confirm it, or \"Reject\" if you are unable to fulfil it. Accepted orders move to the Active tab in Orders.';

  @override
  String get helpFaq2Q => 'How do payouts work?';

  @override
  String get helpFaq2A =>
      'LNDRY processes vendor payouts every 7 days. After deducting the platform fee (₹15 per order) and GST, the remaining amount is transferred to your registered bank account via NEFT/IMPS.';

  @override
  String get helpFaq3Q => 'How do I change my working hours?';

  @override
  String get helpFaq3A =>
      'Go to Profile → Pickup Slots (or Quick Actions → Slots on Dashboard). Here you can add, edit, or remove time slots for each day of the week. You can also enable/disable individual slots.';

  @override
  String get helpFaq4Q => 'How do I contact the customer?';

  @override
  String get helpFaq4A =>
      'Open the Order Details page for the specific order. You will see the customer\'s name and a \"Call Customer\" button that dials them directly. Note: the customer\'s full phone number is masked for privacy until the order is accepted.';

  @override
  String get helpFaq5Q => 'What does \"Pending\" status mean?';

  @override
  String get helpFaq5A =>
      'Pending orders are new orders placed by customers that are waiting for your acceptance. You have a time window to accept or reject them. After the window expires, they are auto-rejected.';

  @override
  String get helpFaq6Q => 'How do I update garment prices?';

  @override
  String get helpFaq6A =>
      'Navigate to Profile → Garment Pricing or use the Catalogue tab. Select a service, then add/edit/delete individual garment rates. Changes take effect immediately for new orders.';

  @override
  String get helpFaq7Q => 'Can I manage multiple employees?';

  @override
  String get helpFaq7A =>
      'Yes. Go to Profile → Staff Management. You can add employees, assign roles (Manager, Washer, Ironer, Packer), set permissions, toggle their active status, and reset their passwords.';

  @override
  String get helpFaq8Q => 'What is the platform fee?';

  @override
  String get helpFaq8A =>
      'LNDRY charges a platform fee of ₹15 per order for connecting you with customers, payment processing, and operational support. GST at 18% applies on the platform fee only.';

  @override
  String get helpTicketCreatedSnack =>
      'Support ticket created! We will respond within 24 hours.';

  @override
  String helpFailedCreateTicket(String error) {
    return 'Failed to create ticket: $error';
  }

  @override
  String get helpCreateSupportTicketTitle => 'Create Support Ticket';

  @override
  String get helpCategoryOrderIssue => 'Order Issue';

  @override
  String get helpCategoryPayout => 'Payout';

  @override
  String get helpCategoryTechnical => 'Technical';

  @override
  String get helpCategoryAccount => 'Account';

  @override
  String get helpCategoryOther => 'Other';

  @override
  String get helpSubjectLabel => 'Subject';

  @override
  String get helpSubjectHint => 'Brief description of your issue';

  @override
  String get helpDescriptionHint => 'Provide more details about your issue...';

  @override
  String get helpDescriptionTooShort => 'Please provide more details';

  @override
  String get helpSubmitTicketButton => 'Submit Ticket';

  @override
  String get helpTabContact => 'Contact';

  @override
  String get helpTabFaq => 'FAQ';

  @override
  String get helpTabTickets => 'Tickets';

  @override
  String get helpPartnerSupportTitle => 'LNDRY Partner Support';

  @override
  String get helpPartnerSupportSubtitle =>
      'We are here to help! Reach us through any channel below.\nAvailable Mon–Sat, 9 AM – 7 PM IST.';

  @override
  String get helpReachUsHeader => 'Reach Us';

  @override
  String get helpCallSupportTitle => 'Call Support';

  @override
  String get helpCallSupportSubtitle => '+91 1800-123-5678 (Toll Free)';

  @override
  String get helpCallNowAction => 'Call Now';

  @override
  String get helpCallingSnack => 'Calling LNDRY Support...';

  @override
  String get helpEmailSupportTitle => 'Email Support';

  @override
  String get helpSendEmailAction => 'Send Email';

  @override
  String get helpOpeningEmailSnack => 'Opening email client...';

  @override
  String get helpWhatsappSupportTitle => 'WhatsApp Support';

  @override
  String get helpOpenWhatsappAction => 'Open WhatsApp';

  @override
  String get helpOpeningWhatsappSnack => 'Opening WhatsApp...';

  @override
  String get helpCreateTicketSubtitle => 'Track your issue with a ticket ID';

  @override
  String get helpCreateTicketAction => 'Create Ticket';

  @override
  String get helpResponseTimesHeader => 'Response Times';

  @override
  String get helpPhoneWhatsappLabel => 'Phone / WhatsApp';

  @override
  String get helpImmediateValue => 'Immediate';

  @override
  String get helpLessThan4Hours => '< 4 hours';

  @override
  String get helpSupportTicketLabel => 'Support Ticket';

  @override
  String get helpLessThan24Hours => '< 24 hours';

  @override
  String get helpCantFindAnswer =>
      'Can\'t find your answer? Create a support ticket.';

  @override
  String get helpCreateAction => 'Create';

  @override
  String get helpFailedToLoadTickets => 'Failed to load tickets';

  @override
  String get helpNoTicketsYet => 'No tickets yet';

  @override
  String get helpNoTicketsSubtitle =>
      'Create a ticket and we will respond within 24 hours.';

  @override
  String get helpCreateNewTicketButton => 'Create New Ticket';

  @override
  String get helpYourTicketsHeader => 'Your Tickets';

  @override
  String get helpStatusReplied => 'Replied';

  @override
  String get helpStatusOpen => 'Open';

  @override
  String get helpStatusClosed => 'Closed';

  @override
  String get ticketYouLabel => 'You';

  @override
  String get ticketSupportTeamLabel => 'Support Team';

  @override
  String get ticketWaitingForReplyBanner =>
      'Waiting for a reply from our support team. We usually respond within 24 hours.';

  @override
  String get ticketAreYouSatisfied => 'Are you satisfied with this response?';

  @override
  String get ticketYesButton => 'Yes';

  @override
  String get ticketNoButton => 'No';

  @override
  String get ticketRateExperience => 'Rate your support experience';

  @override
  String get ticketSubmitRatingButton => 'Submit Rating';

  @override
  String get ticketWhatWouldYouAsk => 'What would you like to ask?';

  @override
  String get ticketTypeMessageHint => 'Type your message...';

  @override
  String get ticketSendButton => 'Send';

  @override
  String get ticketThanksForFeedback => 'Thank you for your feedback!';

  @override
  String ticketFailedSubmitRating(String error) {
    return 'Failed to submit rating: $error';
  }

  @override
  String get ticketMessageSentSnack =>
      'Your message was sent to our support team.';

  @override
  String ticketFailedToSend(String error) {
    return 'Failed to send: $error';
  }

  @override
  String get ticketYourRatingHeader => 'Your rating';

  @override
  String get ticketClosedByTeamBanner =>
      'This ticket has been closed by our support team.';

  @override
  String get employeesAddStaffButton => 'Add Staff';

  @override
  String get employeesPhoneRequiredLabel => 'Phone Number';

  @override
  String get employeesPhoneRequiredError =>
      'Enter a valid 10-digit phone number — staff sign in with it';

  @override
  String get employeesPermissionsRequired => 'Select at least one permission';

  @override
  String get employeesPermissionsLoadFailed =>
      'Couldn\'t load the permission list';

  @override
  String get employeesPermissionsHint =>
      'Only the sections you switch on will open for this staff member.';

  @override
  String get employeesStaffOnlyNote =>
      'Staff sign in to the main Partner app. Captains are added under Captain Management.';

  @override
  String get permModuleOrders => 'Orders';

  @override
  String get permOrdersView => 'View orders';

  @override
  String get permOrdersAcceptReject => 'Accept / reject new orders';

  @override
  String get permOrdersProcess => 'Processing & status updates';

  @override
  String get permOrdersReevaluate => 'Re-evaluation';

  @override
  String get permOrdersAssignCaptain => 'Assign / broadcast to captains';

  @override
  String get permModuleCatalogue => 'Catalogue & pricing';

  @override
  String get permCatalogueView => 'View services & pricing';

  @override
  String get permCatalogueManage => 'Manage services & pricing';

  @override
  String get permModuleInventory => 'Inventory';

  @override
  String get permInventoryView => 'View inventory';

  @override
  String get permInventoryManage => 'Manage inventory';

  @override
  String get permModuleSlots => 'Pickup slots';

  @override
  String get permSlotsView => 'View pickup slots';

  @override
  String get permSlotsManage => 'Manage pickup slots & capacity';

  @override
  String get permModuleAnalytics => 'Analytics';

  @override
  String get permAnalyticsView => 'View analytics';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'Couldn\'t reach the server. Check your internet connection and try again.';

  @override
  String get errorTimeout => 'The request took too long. Please try again.';

  @override
  String get errorServerBusy =>
      'The server is busy right now. Please try again in a moment.';

  @override
  String get inventoryLoadFailed => 'Couldn\'t load your supplies.';

  @override
  String get inventoryEmptyTitle => 'No supplies yet';

  @override
  String get inventoryEmptySubtitle => 'Tap + to add your first supply item.';

  @override
  String get notifOffBannerMessage =>
      'Notifications are turned off, so you may miss new orders and job offers.';

  @override
  String get notifOffBannerAction => 'Turn on';

  @override
  String get ordersAssistedBadge => 'Assisted Booking';

  @override
  String get ordersAssistedSummary => 'Service selection required';

  @override
  String get ordersAssistedPriceTbd => 'To be evaluated';

  @override
  String get orderDetailsAssistedTitle =>
      'Assisted Booking / Service Selection Required';

  @override
  String get orderDetailsAssistedBody =>
      'The customer chose \"Book With Expert Check\", so no services or price were selected. Once the garments reach you, inspect them and choose the right services with quantity or weight using \"Choose Services\". The customer approves the price before processing starts.';

  @override
  String get orderDetailsAssistedChooseServices => 'Choose Services';

  @override
  String get orderDetailsAssistedNoServicesYet =>
      'No services selected yet. Inspect the garments and choose the services.';

  @override
  String get orderDetailsAssistedSheetTitle => 'Choose services';

  @override
  String get orderDetailsAssistedSheetSubtitle =>
      'Add a service for each type of garment, with quantity or weight. This is sent to the customer for approval before processing continues. Photos are optional.';

  @override
  String get orderDetailsAssistedAddServiceRequired =>
      'Add at least one service to send for approval.';

  @override
  String get loginSessionEnded =>
      'Your session has ended. Please log in again to continue.';

  @override
  String get posModeMarketplace => 'Marketplace';

  @override
  String get posModePos => 'POS (Counter)';

  @override
  String get posAppModeTitle => 'App mode';

  @override
  String get posAppModeSubtitle => 'Choose what you want to use right now.';

  @override
  String posAppModeSwitched(String mode) {
    return 'Switched to $mode';
  }

  @override
  String get posAppModeNotAllowed =>
      'That mode is not available for your shop.';

  @override
  String get posGetPosTitle => 'Get POS for my shop';

  @override
  String get posGetPosSubtitle =>
      'Make bills and keep customer records for walk-in customers.';

  @override
  String get posFinishSetupTitle => 'Finish POS setup';

  @override
  String get posFinishSetupSubtitle =>
      'You are only a few steps away from using POS.';

  @override
  String get posChoiceTitle => 'What do you need?';

  @override
  String get posChoiceSubtitle =>
      'Pick one to start. You can add the other later.';

  @override
  String get posChoiceMarketplaceTitle => 'Get customers';

  @override
  String get posChoiceMarketplaceBody =>
      'Get orders from the LNDRY customer app. Needs shop details and documents.';

  @override
  String get posChoicePosTitle => 'Run my shop (POS)';

  @override
  String get posChoicePosBody =>
      'Make bills, keep customer records and track your money at the counter. Ready in about 3 minutes.';

  @override
  String get posChoiceBothHint =>
      'Want both? Start with Marketplace, then turn on POS later in Settings.';

  @override
  String get posModeCheckLoading => 'Getting your shop ready…';

  @override
  String get posOnbTitle => 'Set up POS';

  @override
  String posOnbStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get posOnbStepShop => 'Shop details';

  @override
  String get posOnbStepTax => 'Tax & payments';

  @override
  String get posOnbStepCounter => 'Counter setup';

  @override
  String get posOnbStepPrices => 'Price list';

  @override
  String get posOnbShopName => 'Shop name';

  @override
  String get posOnbOwnerName => 'Owner name';

  @override
  String get posOnbAddress => 'Shop address';

  @override
  String get posOnbCity => 'City';

  @override
  String get posOnbState => 'State (optional)';

  @override
  String get posOnbPincode => 'Pincode (optional)';

  @override
  String get posOnbGstSwitch => 'My shop is GST registered';

  @override
  String get posOnbGstin => 'GSTIN (15 characters)';

  @override
  String get posOnbUpi => 'UPI ID (optional)';

  @override
  String get posOnbUpiHint => 'like name@bank';

  @override
  String get posOnbInvoicePrefix => 'Invoice prefix';

  @override
  String get posOnbPrinter => 'Printer';

  @override
  String get posPrinterNone => 'No printer';

  @override
  String get posPrinterSystem => 'Phone / system printer';

  @override
  String get posPrinter58 => 'Thermal 58 mm';

  @override
  String get posPrinter80 => 'Thermal 80 mm';

  @override
  String get posOnbOrderPrefix => 'Order numbers start with';

  @override
  String get posOnbDeliveryDays => 'Usual delivery time (days)';

  @override
  String get posOnbPricesTitle => 'Start your price list';

  @override
  String get posOnbPricesStarter => 'Use the sample price list';

  @override
  String get posOnbPricesStarterBody =>
      'We add common garments and services with sample prices. Please check and change the prices.';

  @override
  String get posOnbPricesOwn => 'I will add my own';

  @override
  String get posOnbPricesOwnBody =>
      'Start empty and add your garments and prices yourself.';

  @override
  String get posNext => 'Next';

  @override
  String get posBack => 'Back';

  @override
  String get posFinish => 'Finish setup';

  @override
  String get posSaving => 'Saving…';

  @override
  String get posErrShopName => 'Enter your shop name';

  @override
  String get posErrOwnerName => 'Enter the owner name';

  @override
  String get posErrAddress => 'Enter your shop address';

  @override
  String get posErrCity => 'Enter your city';

  @override
  String get posErrPincode => 'Pincode must be 6 digits';

  @override
  String get posErrGstin => 'Enter a valid 15-character GSTIN';

  @override
  String get posErrUpi => 'UPI ID should look like name@bank';

  @override
  String get posErrPrefix => 'Use 1 to 6 letters or numbers';

  @override
  String get posErrDays => 'Enter a number from 0 to 30';

  @override
  String get posDoneTitle => 'Your shop is ready!';

  @override
  String get posDoneBody => 'Book your first order from the Home screen.';

  @override
  String posDoneStarterNote(int count) {
    return '$count sample garments were added. Please check their prices.';
  }

  @override
  String get posDoneButton => 'Open POS';

  @override
  String get posOnbOwnerOnlyTitle => 'Ask the shop owner';

  @override
  String get posOnbOwnerOnlyBody =>
      'POS setup must be finished by the shop owner.';

  @override
  String get posLogOut => 'Log out';

  @override
  String get posTabHome => 'Home';

  @override
  String get posTabOrder => 'Order';

  @override
  String get posTabSearch => 'Search';

  @override
  String get posTabExpense => 'Expense';

  @override
  String get posTabReport => 'Report';

  @override
  String get posTabSetting => 'Setting';

  @override
  String get posComingSoonTitle => 'Coming soon';

  @override
  String get posComingSoonBody => 'This part of POS is being built.';

  @override
  String posHomeWelcome(String shop) {
    return 'Welcome, $shop';
  }

  @override
  String get posHomeReady =>
      'Your POS is ready. Booking orders, customers and prices arrive in the next update.';

  @override
  String get posSettingsTitle => 'Settings';

  @override
  String get posSettingsShop => 'Shop';

  @override
  String get posHomeToday => 'Today';

  @override
  String get posTileRevenue => 'Today Revenue';

  @override
  String get posTileCollection => 'Collection';

  @override
  String get posTileOrderRequests => 'Order Request';

  @override
  String get posTileWashingToStore => 'Washing to Store';

  @override
  String get posTileBooking => 'Booking';

  @override
  String get posTileDelivery => 'Delivery';

  @override
  String get posTileDelivered => 'Delivered';

  @override
  String get posTilePending => 'Pending Orders';

  @override
  String get posQuickActions => 'Quick actions';

  @override
  String get posActionBook => 'Book Order';

  @override
  String get posActionAddCustomer => 'Add Customer';

  @override
  String get posActionAddPrice => 'Add Garment Price';

  @override
  String get posTasksTitle => 'To do';

  @override
  String get posTaskUnassignedPickups => 'Pickups to assign';

  @override
  String get posTaskUpcomingDeliveries => 'Deliveries due';

  @override
  String get posTaskUnassignedDeliveries => 'Deliveries to assign';

  @override
  String get posTaskExpress => 'Express orders';

  @override
  String get posTaskOrderRequests => 'Order requests';

  @override
  String get posTaskCollectionDue => 'Money to collect';

  @override
  String get posPlanTitle => 'Your plan';

  @override
  String posPlanValidTo(String date) {
    return 'Valid till $date';
  }

  @override
  String get posHomeLoadError => 'Could not load today\'s numbers.';

  @override
  String get posRetry => 'Try again';

  @override
  String get posHomeEmpty => 'No orders yet. Tap Book Order to start.';

  @override
  String get posCancel => 'Cancel';

  @override
  String get posCustomerPick => 'Choose customer';

  @override
  String get posCustomerSearchHint => 'Search name or phone';

  @override
  String get posCustomerRecent => 'Recent customers';

  @override
  String get posCustomerNone => 'No customer found.';

  @override
  String get posCustomerAddNew => 'Add new customer';

  @override
  String posCustomerAddWithPhone(String phone) {
    return 'Add $phone as a new customer';
  }

  @override
  String get posCustomerLoadError => 'Could not load customers.';

  @override
  String posCustomerOrderCount(int count) {
    return '$count orders';
  }

  @override
  String get posAddCustomerTitle => 'Add customer';

  @override
  String get posCustomerName => 'Customer name';

  @override
  String get posCustomerPhone => 'Mobile number (10 digits)';

  @override
  String get posErrCustomerName => 'Enter the customer\'s name';

  @override
  String get posErrCustomerPhone => 'Enter a 10-digit mobile number';

  @override
  String posCustomerAdded(String name) {
    return '$name added';
  }

  @override
  String get posBookTitle => 'Book Order';

  @override
  String get posBookCustomer => 'Customer';

  @override
  String get posBookDeliveryDate => 'Delivery date';

  @override
  String get posBookHomeDelivery => 'Home Delivery';

  @override
  String get posBookPickup => 'Pickup';

  @override
  String get posBookExpress => 'Express';

  @override
  String get posBookService => 'Service';

  @override
  String get posBookCategory => 'Category';

  @override
  String get posBookAll => 'All';

  @override
  String get posBookSearchGarment => 'Search garment';

  @override
  String get posBookNoServices =>
      'Your price list has no services yet. Add a garment price first.';

  @override
  String get posBookNoGarments => 'No garments with a price for this service.';

  @override
  String posBookNoMatch(String query) {
    return 'No garment matches \"$query\".';
  }

  @override
  String get posBookCatalogueError => 'Could not load your price list.';

  @override
  String get posBookSelected => 'Selected Garments';

  @override
  String get posBookCartEmpty => 'Tap a garment above to add it.';

  @override
  String posBookAddOne(String name) {
    return 'Add one $name';
  }

  @override
  String posBookRemoveOne(String name) {
    return 'Remove one $name';
  }

  @override
  String posBookRemoveLine(String name) {
    return 'Remove $name';
  }

  @override
  String get posBookChangePrice => 'Change price';

  @override
  String get posBookItems => 'Items';

  @override
  String get posBookCharge => 'Charge';

  @override
  String get posBookDiscount => 'Discount';

  @override
  String get posBookTax => 'Tax';

  @override
  String posBookTaxPercent(String percent) {
    return 'Tax ($percent%)';
  }

  @override
  String get posBookGrandTotal => 'Grand Total';

  @override
  String get posBookCalculating => 'Calculating…';

  @override
  String get posBookQuoteError => 'Could not get the price.';

  @override
  String get posBookExtras => 'Charges, discount & GST';

  @override
  String get posBookChargesLabel => 'Charges';

  @override
  String get posBookDiscountsLabel => 'Discounts';

  @override
  String get posBookGstLabel => 'GST';

  @override
  String get posBookNoGst => 'No GST';

  @override
  String get posBookPayment => 'Payment';

  @override
  String get posPayCash => 'Cash';

  @override
  String get posPayOnline => 'Online';

  @override
  String get posPayLater => 'Pay Later';

  @override
  String get posPayNowNote => 'The full amount is received now.';

  @override
  String get posPayLaterNote => 'No payment now. Collect it later.';

  @override
  String get posBookRemarks => 'Remarks (optional)';

  @override
  String get posBookSave => 'Save Order';

  @override
  String get posBookSaving => 'Saving…';

  @override
  String get posBookNeedCustomer => 'Choose a customer to save.';

  @override
  String get posBookNeedGarment => 'Add at least one garment.';

  @override
  String get posBookWaitPrice => 'Waiting for the price…';

  @override
  String get posBookSavedTitle => 'Order saved';

  @override
  String posBookSavedBody(String number, String name) {
    return 'Order $number for $name';
  }

  @override
  String get posBookSavedTotal => 'Total';

  @override
  String get posBookSavedPaid => 'Paid';

  @override
  String get posBookSavedBalance => 'To collect';

  @override
  String get posBookViewOrder => 'View Order';

  @override
  String get posBookAnother => 'Book Another';

  @override
  String get posBookClear => 'Clear';

  @override
  String get posBookClearTitle => 'Clear this order?';

  @override
  String get posBookClearBody => 'The customer and garments will be removed.';

  @override
  String get posBookDraftRestored => 'Your last unsaved order was restored.';

  @override
  String posBookDropped(int count) {
    return '$count garments were removed because their price is no longer in your list.';
  }

  @override
  String get posAddPriceTitle => 'Add Garment Price';

  @override
  String get posEditPriceTitle => 'Change price';

  @override
  String get posPriceGarment => 'Garment';

  @override
  String get posPriceCategory => 'Category';

  @override
  String get posPriceService => 'Service';

  @override
  String get posPriceUnit => 'Unit';

  @override
  String get posPriceRate => 'Price (₹)';

  @override
  String get posPriceAdd => 'Add';

  @override
  String get posPriceSave => 'Save price';

  @override
  String get posPricePickOne => 'Choose…';

  @override
  String get posPriceNone => 'None';

  @override
  String get posPriceNewGarment => 'New garment';

  @override
  String get posPriceNewCategory => 'New category';

  @override
  String get posPriceNewService => 'New service';

  @override
  String get posPriceCreateHint => 'Name';

  @override
  String get posPriceCreate => 'Create';

  @override
  String get posPriceCreateTooltip => 'Create new';

  @override
  String get posPriceErrGarment => 'Choose a garment';

  @override
  String get posPriceErrService => 'Choose a service';

  @override
  String get posPriceErrRate => 'Enter a price like 80 or 80.50';

  @override
  String get posPriceErrName => 'Enter a name';

  @override
  String get posPriceSaved => 'Price saved';

  @override
  String posPriceCurrent(String price) {
    return 'Current price $price';
  }

  @override
  String get posUnitPiece => 'Piece';

  @override
  String get posUnitKg => 'Kilogram';

  @override
  String get posUnitPair => 'Pair';

  @override
  String get posUnitSqft => 'Square foot';

  @override
  String get posBookSubtotal => 'Amount';

  @override
  String posBookQtySemantics(String name, int qty) {
    return '$name, quantity $qty';
  }

  @override
  String get posBookBill => 'Bill';

  @override
  String get posOrdersTitle => 'Orders';

  @override
  String get posOrdTabBooked => 'Booked';

  @override
  String get posOrdTabInProcess => 'In Process';

  @override
  String get posOrdTabDone => 'Done';

  @override
  String get posOrdFilter => 'Filter';

  @override
  String get posOrdSelectAll => 'Select all';

  @override
  String posOrdSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get posOrdMoveNext => 'Move to next step';

  @override
  String get posOrdSearchHint => 'Search name, phone or order no.';

  @override
  String get posOrdEmptyBooked =>
      'No booked orders. Tap Book Order to add one.';

  @override
  String get posOrdEmptyInProcess => 'Nothing is being processed right now.';

  @override
  String get posOrdEmptyDone => 'No orders are ready right now.';

  @override
  String get posOrdEmptyFiltered =>
      'No orders match. Clear the filter or the search.';

  @override
  String get posOrdClearFilters => 'Clear filters';

  @override
  String get posOrdLoadError => 'Could not load the orders.';

  @override
  String get posOrdLoadMoreError => 'Could not load more. Tap to try again.';

  @override
  String posOrdItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String posOrdBalanceDue(String amount) {
    return 'Balance $amount';
  }

  @override
  String posOrdDue(String date) {
    return 'Due $date';
  }

  @override
  String get posOrdExpress => 'Express';

  @override
  String get posOrdHomeDelivery => 'Home Delivery';

  @override
  String get posOrdPickup => 'Pickup';

  @override
  String get posOrdWalkIn => 'At counter';

  @override
  String get posPayStatusPaid => 'Paid';

  @override
  String get posPayStatusPart => 'Part paid';

  @override
  String get posPayStatusUnpaid => 'Unpaid';

  @override
  String get posPhaseBooked => 'Booked';

  @override
  String get posPhaseProcessing => 'Processing';

  @override
  String get posPhaseReady => 'Ready';

  @override
  String get posPhaseOut => 'Out for delivery';

  @override
  String get posPhaseDelivered => 'Delivered';

  @override
  String get posPhaseComplete => 'Order Complete';

  @override
  String get posPhaseCancelled => 'Cancelled';

  @override
  String get posFilterTitle => 'Filter orders';

  @override
  String get posFilterStatus => 'Which orders';

  @override
  String get posFilterThisTab => 'This tab';

  @override
  String get posFilterAllOrders => 'All orders';

  @override
  String get posFilterDeliveredOnly => 'Delivered';

  @override
  String get posFilterCancelledOnly => 'Cancelled';

  @override
  String get posFilterDates => 'Order date';

  @override
  String get posFilterFrom => 'From';

  @override
  String get posFilterTo => 'To';

  @override
  String get posFilterAnyDate => 'Any date';

  @override
  String get posFilterDelivery => 'How it reaches the customer';

  @override
  String get posFilterAnyDelivery => 'Any';

  @override
  String get posFilterExpressOnly => 'Express only';

  @override
  String get posFilterDueOnly => 'Balance due only';

  @override
  String get posFilterApply => 'Show orders';

  @override
  String get posFilterReset => 'Clear';

  @override
  String posBulkTitle(int count) {
    return 'Move $count orders to the next step?';
  }

  @override
  String get posBulkBody =>
      'Each order moves one step: Booked → Processing → Ready → Delivered.';

  @override
  String get posBulkReadyNote =>
      'Orders whose garments were not scanned are marked ready anyway.';

  @override
  String get posBulkDueNote =>
      'Orders with a balance due are NOT delivered here — open them one by one.';

  @override
  String get posBulkGo => 'Move orders';

  @override
  String posBulkDone(int count) {
    return '$count orders moved.';
  }

  @override
  String posBulkPartial(int moved, int failed) {
    return '$moved moved. $failed need a closer look — open them one by one.';
  }

  @override
  String get posBulkNone =>
      'Nothing could be moved. Open the orders one by one.';

  @override
  String posBulkSkipDue(int count) {
    return '$count with a balance due were left for you to open.';
  }

  @override
  String get posOrdDetailTitle => 'Order details';

  @override
  String get posOrdCall => 'Call';

  @override
  String get posOrdCallFailed => 'Could not open the phone.';

  @override
  String get posNextStart => 'Start Processing';

  @override
  String get posNextReady => 'Mark Ready';

  @override
  String get posNextSendOut => 'Send for Delivery';

  @override
  String get posNextDeliver => 'Deliver Order';

  @override
  String get posOrdFinished => 'This order is finished.';

  @override
  String get posOrdCancelledNote => 'This order was cancelled.';

  @override
  String get posReadyAnywayTitle => 'Garments not scanned yet';

  @override
  String get posReadyAnywayBody =>
      'Some garments have not been scanned through processing. Mark the order ready anyway?';

  @override
  String get posReadyAnywayYes => 'Mark ready anyway';

  @override
  String get posNotYet => 'Not yet';

  @override
  String posDeliverDueTitle(String amount) {
    return '$amount is still due';
  }

  @override
  String get posDeliverDueBody =>
      'Collect the payment first, or deliver now and collect later.';

  @override
  String get posCollectFirst => 'Collect payment first';

  @override
  String get posDeliverAnyway => 'Deliver with balance due';

  @override
  String posOrdMoved(String status) {
    return 'Order moved to $status.';
  }

  @override
  String get posOrdChanged =>
      'This order was changed by someone else. It has been reloaded — please check and try again.';

  @override
  String posProgressPercent(int percent) {
    return '$percent% complete';
  }

  @override
  String get posStageBooked => 'Booked';

  @override
  String get posStageProcessed => 'Processed';

  @override
  String get posStageDone => 'Done';

  @override
  String get posStageDelivered => 'Delivered';

  @override
  String get posStageComplete => 'Complete';

  @override
  String get posActionsTitle => 'Quick actions';

  @override
  String get posActPayNow => 'Pay Now';

  @override
  String get posActInvoice => 'View Invoice';

  @override
  String get posActMiniInvoice => 'Mini Invoice';

  @override
  String get posActTag => 'Tags';

  @override
  String get posActEdit => 'Edit Order';

  @override
  String get posActCancel => 'Cancel Order';

  @override
  String get posActAssign => 'Assign Captain';

  @override
  String get posInfoTitle => 'Order info';

  @override
  String get posInfoDelivery => 'Delivery';

  @override
  String get posInfoOrderNo => 'Order no.';

  @override
  String get posInfoInvoiceAmount => 'Invoice amount';

  @override
  String get posInfoPaid => 'Paid';

  @override
  String get posInfoBalance => 'Balance';

  @override
  String get posInfoBookedOn => 'Booked on';

  @override
  String get posInfoDeliveryDate => 'Delivery date';

  @override
  String get posInfoPickupCaptain => 'Pickup captain';

  @override
  String get posInfoDeliveryCaptain => 'Delivery captain';

  @override
  String get posInfoNotAssigned => 'Not assigned';

  @override
  String get posInfoNotes => 'Remarks';

  @override
  String get posInfoCancelReason => 'Reason for cancelling';

  @override
  String get posPaymentsTitle => 'Payments received';

  @override
  String get posPaymentsNone => 'No payment received yet.';

  @override
  String get posModeCash => 'Cash';

  @override
  String get posModeOnline => 'Online';

  @override
  String get posModeCard => 'Card';

  @override
  String get posModeBank => 'Bank';

  @override
  String get posModeWallet => 'Wallet';

  @override
  String get posGarmentsTitle => 'Garments';

  @override
  String get posGarmentsNone => 'No garments on this order.';

  @override
  String get posUnitReceived => 'Received';

  @override
  String get posUnitProcessing => 'In process';

  @override
  String get posUnitReady => 'Ready';

  @override
  String get posUnitOut => 'Out';

  @override
  String get posUnitDelivered => 'Delivered';

  @override
  String get posUnitMissing => 'Missing';

  @override
  String get posUnitCancelled => 'Cancelled';

  @override
  String get posOrdLoadFailed => 'Could not load this order.';

  @override
  String get posOrdLoadingHint => 'Loading the order…';

  @override
  String get posWhatsApp => 'WhatsApp';

  @override
  String get posWaOpenFailed => 'Could not open WhatsApp.';

  @override
  String posWaMessageDue(String name, String number, String status,
      String total, String balance, String shop) {
    return 'Hello $name, your order $number is $status. Total $total, balance $balance. Thank you! — $shop';
  }

  @override
  String posWaMessagePaid(
      String name, String number, String status, String total, String shop) {
    return 'Hello $name, your order $number is $status. Total $total, fully paid. Thank you! — $shop';
  }

  @override
  String get posWaCustomerFallback => 'there';

  @override
  String get posPayTitle => 'Collect payment';

  @override
  String get posPayBalance => 'Balance to collect';

  @override
  String get posPayAmount => 'Amount (₹)';

  @override
  String get posPayFull => 'Full balance';

  @override
  String get posPayHow => 'How is the customer paying?';

  @override
  String get posPayReference => 'Reference (optional)';

  @override
  String get posPayReferenceHint => 'e.g. UPI transaction number';

  @override
  String posPayCollect(String amount) {
    return 'Collect $amount';
  }

  @override
  String get posPayErrZero => 'Enter an amount.';

  @override
  String posPayErrOver(String amount) {
    return 'It cannot be more than the balance $amount.';
  }

  @override
  String posPayDone(String amount) {
    return '$amount collected.';
  }

  @override
  String get posPayCheckFirst =>
      'We could not confirm that payment. The order was reloaded — check the balance before collecting again.';

  @override
  String get posPayNothingDue => 'Nothing is due on this order.';

  @override
  String get posCancelTitle => 'Cancel this order?';

  @override
  String get posCancelBody => 'This cannot be undone.';

  @override
  String get posCancelWhy => 'Why is it being cancelled?';

  @override
  String get posCancelReasonMind => 'Customer changed their mind';

  @override
  String get posCancelReasonMistake => 'Booked by mistake';

  @override
  String get posCancelReasonPrice => 'Price problem';

  @override
  String get posCancelReasonOther => 'Other reason';

  @override
  String get posCancelOtherHint => 'Write the reason (3 letters or more)';

  @override
  String get posCancelRefundNote =>
      'If the customer already paid, give the money back yourself — the app does not refund.';

  @override
  String get posCancelConfirm => 'Cancel Order';

  @override
  String get posCancelKeep => 'Keep the order';

  @override
  String get posCancelDone => 'Order cancelled.';

  @override
  String get posEditTitle => 'Edit order';

  @override
  String get posEditItemsNote =>
      'To change the garments, cancel this order and book a new one.';

  @override
  String get posEditSave => 'Save changes';

  @override
  String get posEditSaved => 'Order updated.';

  @override
  String get posEditNothing => 'Nothing was changed.';

  @override
  String get posAssignTitle => 'Assign captain';

  @override
  String get posAssignPickup => 'Pickup captain';

  @override
  String get posAssignDelivery => 'Delivery captain';

  @override
  String get posAssignKeep => 'Keep as it is';

  @override
  String get posAssignNone =>
      'You have no captains yet. Add one in Settings → Team.';

  @override
  String get posAssignSave => 'Assign';

  @override
  String get posAssignDone => 'Captain assigned.';

  @override
  String get posInvoiceTitle => 'Invoice';

  @override
  String get posMiniTitle => 'Mini bill';

  @override
  String get posPaper58 => '58 mm';

  @override
  String get posPaper80 => '80 mm';

  @override
  String get posPaperLabel => 'Paper size';

  @override
  String get posInvoiceLater =>
      'The invoice is created when the order is delivered. Use Mini Invoice for a bill now.';

  @override
  String get posInvoiceOpenMini => 'Open Mini Invoice';

  @override
  String get posInvoiceFailed => 'Could not prepare the bill.';

  @override
  String get posOk => 'OK';

  @override
  String get posTagsTitle => 'Garment tags';

  @override
  String get posTagsEmpty => 'This order has no tags.';

  @override
  String get posTagsPrint => 'Print or share tags';

  @override
  String get posTagsHint =>
      'Stick one tag on each garment. The code is also written under each QR.';

  @override
  String posTagsPdfTitle(String number) {
    return 'Tags for order $number';
  }

  @override
  String get posTagsFailed => 'Could not prepare the tags.';

  @override
  String get posTileOpensOrders => 'Opens the orders list';

  @override
  String posOrdFiltered(String what) {
    return 'Showing: $what';
  }

  @override
  String get posNoPermission =>
      'You do not have permission to do this. Ask the shop owner.';

  @override
  String get posSearchHint => 'Order no., customer name, phone or tag';

  @override
  String get posSearchStart => 'Type at least 2 letters or numbers to search.';

  @override
  String get posSearchRecent => 'Recent searches';

  @override
  String get posSearchClearRecent => 'Clear';

  @override
  String posSearchNone(String q) {
    return 'Nothing found for \"$q\". Check the spelling or try the phone number.';
  }

  @override
  String get posSearchFailed => 'Could not search right now.';

  @override
  String get posSearchCustomers => 'Customers';

  @override
  String get posSearchOrders => 'Orders';

  @override
  String get posSearchTags => 'Garment tags';

  @override
  String get posSearchAllCustomers => 'All customers';

  @override
  String posSearchOrderLine(String total, String date) {
    return '$total · $date';
  }

  @override
  String posSearchTagLine(String code, String state) {
    return 'Tag $code · $state';
  }

  @override
  String get posCustTitle => 'Customers';

  @override
  String get posCustSearchHint => 'Search by name or phone';

  @override
  String get posCustEmpty =>
      'No customers yet. Book an order or add a customer.';

  @override
  String posCustNoMatch(String q) {
    return 'No customer matches \"$q\".';
  }

  @override
  String get posCustLoadError => 'Could not load customers.';

  @override
  String posCustOrdersCount(int count, String spent) {
    return '$count orders · $spent';
  }

  @override
  String get posCustNewCustomer => 'New customer';

  @override
  String get posCustDuesTitle => 'To collect';

  @override
  String get posCustNoDues => 'Nothing is due. All paid.';

  @override
  String posCustDueOrder(String number) {
    return 'Order $number';
  }

  @override
  String get posCustCollect => 'Collect dues';

  @override
  String get posCustCollectHint => 'Choose an order to collect its balance.';

  @override
  String get posCustHistory => 'Order history';

  @override
  String get posCustNoOrders => 'No orders yet.';

  @override
  String get posCustNotes => 'Notes';

  @override
  String get posCustAddresses => 'Addresses';

  @override
  String get posCustCall => 'Call';

  @override
  String get posCustWhatsApp => 'WhatsApp';

  @override
  String get posCustBook => 'Book order';

  @override
  String get posCustNotFound => 'This customer was not found.';

  @override
  String posCustOwes(String amount) {
    return 'Owes $amount';
  }

  @override
  String posWaSheetTitle(String name) {
    return 'Message $name';
  }

  @override
  String get posWaOpenChat => 'Just open the chat';

  @override
  String get posWaOpenChatBody => 'A short hello. You can type anything.';

  @override
  String posWaHello(String name, String shop) {
    return 'Hello $name, this is $shop.';
  }

  @override
  String posWaForOrder(String number) {
    return 'About order $number';
  }

  @override
  String get posWaNoOrder =>
      'This customer has no order yet, so only a plain chat is possible.';

  @override
  String get posWaPaymentDue => 'Payment reminder';

  @override
  String get posWaPaymentDueBody => 'Shows the balance still to pay.';

  @override
  String get posWaTemplatesFailed => 'Could not load your saved messages.';

  @override
  String get posWaPickCustomer => 'Who do you want to message?';

  @override
  String get posActionWhatsApp => 'WhatsApp';

  @override
  String get posExpTitle => 'Expense';

  @override
  String get posExpToday => 'Today';

  @override
  String get posExpThisMonth => 'This month';

  @override
  String posExpSpent(String amount) {
    return 'Spent: $amount';
  }

  @override
  String get posExpAdd => 'Add Expense';

  @override
  String get posExpEdit => 'Edit expense';

  @override
  String get posExpCancel => 'Cancel expense';

  @override
  String get posExpEmpty =>
      'No expenses in this period. Tap Add Expense when you pay for something.';

  @override
  String get posExpLoadError => 'Could not load expenses.';

  @override
  String get posExpName => 'What was it for?';

  @override
  String get posExpNameHint => 'e.g. Electricity bill';

  @override
  String get posExpAmount => 'Amount (₹)';

  @override
  String get posExpCategory => 'Type of expense';

  @override
  String get posExpMode => 'Paid by';

  @override
  String get posExpDate => 'Date';

  @override
  String get posExpNote => 'Note (optional)';

  @override
  String get posExpReason => 'Why are you changing it?';

  @override
  String get posExpCancelReason => 'Why is it cancelled?';

  @override
  String get posExpSave => 'Save Expense';

  @override
  String get posExpSaved => 'Expense saved.';

  @override
  String get posExpCancelled => 'Expense cancelled.';

  @override
  String get posExpCancelledTag => 'Cancelled';

  @override
  String get posExpKeep => 'Keep it';

  @override
  String get posExpNameRequired => 'Write what the expense was for.';

  @override
  String get posExpAmountInvalid => 'Enter an amount like 250 or 99.50.';

  @override
  String get posExpReasonRequired => 'Please write a reason.';

  @override
  String posExpBy(String category, String mode) {
    return '$category · $mode';
  }

  @override
  String get posCatRent => 'Rent';

  @override
  String get posCatSalary => 'Salary';

  @override
  String get posCatElectricity => 'Electricity';

  @override
  String get posCatWater => 'Water';

  @override
  String get posCatDetergent => 'Detergent & supplies';

  @override
  String get posCatTransport => 'Transport';

  @override
  String get posCatRepair => 'Repair';

  @override
  String get posCatTea => 'Tea & snacks';

  @override
  String get posCatOther => 'Other';

  @override
  String get posExpModeCash => 'Cash';

  @override
  String get posExpModeUpi => 'UPI';

  @override
  String get posExpModeBank => 'Bank';

  @override
  String get posExpModeCard => 'Card';

  @override
  String get posExpModeOther => 'Other';

  @override
  String get posDrawerTitle => 'Cash drawer';

  @override
  String get posDrawerClosed =>
      'The cash drawer is closed. Open it when you start the day.';

  @override
  String get posDrawerOpen => 'Open cash drawer';

  @override
  String get posDrawerClose => 'Close cash drawer';

  @override
  String posDrawerOpenSince(String time) {
    return 'Open since $time';
  }

  @override
  String get posDrawerOpening => 'Cash you started with';

  @override
  String get posDrawerIn => 'Cash received';

  @override
  String get posDrawerOut => 'Cash paid out';

  @override
  String get posDrawerShould => 'Cash that should be in the drawer';

  @override
  String get posDrawerOpeningQ => 'How much cash is in the drawer now?';

  @override
  String get posDrawerOpenSave => 'Open drawer';

  @override
  String get posDrawerCounted => 'Cash you counted (₹)';

  @override
  String posDrawerExpected(String amount) {
    return 'Should be: $amount';
  }

  @override
  String get posDrawerMatch => 'It matches. Nothing is missing.';

  @override
  String posDrawerShort(String amount) {
    return '$amount less than it should be.';
  }

  @override
  String posDrawerExtra(String amount) {
    return '$amount more than it should be.';
  }

  @override
  String get posDrawerWhy => 'Why is it different?';

  @override
  String get posDrawerApprover => 'Approved by (name)';

  @override
  String get posDrawerCloseSave => 'Close drawer';

  @override
  String get posDrawerOpened => 'Cash drawer opened.';

  @override
  String get posDrawerClosedOk => 'Cash drawer closed.';

  @override
  String get posDrawerCountInvalid => 'Enter the cash you counted, like 1250.';

  @override
  String get posDrawerNeedsWhy =>
      'Write why it is different and who approved it.';

  @override
  String get posDrawerPast => 'Earlier drawers';

  @override
  String posDrawerPastLine(String counted, String diff) {
    return 'Counted $counted · $diff';
  }

  @override
  String get posDrawerDiffOk => 'matched';

  @override
  String posDrawerDiffShort(String amount) {
    return '$amount short';
  }

  @override
  String posDrawerDiffExtra(String amount) {
    return '$amount extra';
  }

  @override
  String get posMoneyNoAccess =>
      'Ask the shop owner to give you access to this.';

  @override
  String get posRepTitle => 'Report';

  @override
  String get posRepToday => 'Today';

  @override
  String get posRep7Days => 'Last 7 days';

  @override
  String get posRepMonth => 'This month';

  @override
  String get posRepCustom => 'Pick dates';

  @override
  String posRepPeriod(String from, String to) {
    return '$from to $to';
  }

  @override
  String get posRepBilled => 'Billed';

  @override
  String get posRepBilledHint => 'Total of the orders booked';

  @override
  String get posRepCollected => 'Collected';

  @override
  String get posRepCollectedHint => 'Money received in this period';

  @override
  String get posRepDues => 'Still to collect';

  @override
  String posRepDuesHint(int count) {
    return '$count orders not fully paid';
  }

  @override
  String get posRepSpent => 'Spent';

  @override
  String posRepSpentHint(int count) {
    return '$count expenses';
  }

  @override
  String get posRepNet => 'Collected minus spent';

  @override
  String get posRepOrders => 'Orders';

  @override
  String posRepOrdersCount(int count) {
    return '$count orders booked';
  }

  @override
  String get posRepStBooked => 'Booked';

  @override
  String get posRepStProcess => 'In process';

  @override
  String get posRepStReady => 'Ready';

  @override
  String get posRepStDelivered => 'Delivered';

  @override
  String get posRepStCancelled => 'Cancelled';

  @override
  String get posRepPayMix => 'How customers paid';

  @override
  String get posRepNoPayments => 'No payments in this period.';

  @override
  String get posRepModeWallet => 'Wallet';

  @override
  String get posRepTopGarments => 'Most booked garments';

  @override
  String posRepQty(String qty, String amount) {
    return '$qty · $amount';
  }

  @override
  String get posRepSpendBy => 'Spending by type';

  @override
  String get posRepDaily => 'Day by day';

  @override
  String posRepDayLine(String billed, String collected, String spent) {
    return 'Billed $billed · Collected $collected · Spent $spent';
  }

  @override
  String get posRepExport => 'Share sales file (CSV)';

  @override
  String get posRepExportHint =>
      'Opens in Excel or Google Sheets. One row for each order.';

  @override
  String get posRepExportFailed => 'Could not prepare the file.';

  @override
  String get posRepLoadError => 'Could not load the report.';

  @override
  String get posRepEmpty => 'No orders or expenses in this period.';

  @override
  String get posRepRangeTooLong => 'Please pick at most one year.';

  @override
  String get posRepTabSummary => 'Summary';

  @override
  String get posRepTabInvoices => 'Invoices';

  @override
  String get posRepTabCollection => 'Collection';

  @override
  String get posRepTabExpense => 'Expenses';

  @override
  String get posRepTotalRevenue => 'Total revenue';

  @override
  String get posRepInvNo => 'Invoice no.';

  @override
  String get posRepAmount => 'Amount';

  @override
  String get posRepStatus => 'Status';

  @override
  String posRepPage(int n) {
    return 'Page $n';
  }

  @override
  String get posRepPrev => 'Previous';

  @override
  String get posRepNext => 'Next';

  @override
  String get posRepNoInvoices => 'No invoices in this period.';

  @override
  String get posRepInvoicesFailed => 'Could not load the invoices.';

  @override
  String get posRepChartBilled => 'Billed each day';

  @override
  String get posRepChartCollected => 'Collected each day';

  @override
  String get posRepChartSpent => 'Spent each day';

  @override
  String posRepChartHigh(String amount, String date) {
    return 'Highest: $amount on $date';
  }

  @override
  String get posRepChartNone => 'Nothing to draw yet.';

  @override
  String get posCustProfile => 'Profile';

  @override
  String get posSetCustomers => 'Customers';

  @override
  String get posSetCustomersBody =>
      'See everyone, call them, see what they owe.';

  @override
  String get posSetPrices => 'Price list';

  @override
  String get posSetPricesBody => 'Add a garment or change a price.';

  @override
  String get posSetRules => 'Extra charges and discounts';

  @override
  String get posSetRulesBody => 'The ones you can pick while booking.';

  @override
  String get posSetRulesCharges => 'Extra charges';

  @override
  String get posSetRulesDiscounts => 'Discounts';

  @override
  String get posSetRulesNone =>
      'None yet. They are added on the counter software or the website.';

  @override
  String posSetRuleFlat(String amount) {
    return '$amount flat';
  }

  @override
  String posSetRulePercent(String percent) {
    return '$percent% of the bill';
  }

  @override
  String get posSetMessages => 'WhatsApp messages';

  @override
  String get posSetMessagesBody => 'The messages sent to customers.';

  @override
  String get posSetMessagesHint =>
      'You can change these words on the counter software or the website. They show here too.';

  @override
  String get posSetTeam => 'Team';

  @override
  String get posSetTeamBody => 'Who works in your shop.';

  @override
  String get posSetTeamHint =>
      'To add or remove people, use the counter software or the website.';

  @override
  String get posSetRoleOwner => 'Owner';

  @override
  String get posSetRoleStaff => 'Counter staff';

  @override
  String get posSetRoleRider => 'Captain (pickup / delivery)';

  @override
  String get posSetInactive => 'Not active';

  @override
  String get posSetLanguage => 'Language';

  @override
  String get posSetLoadFailed => 'Could not load this.';

  @override
  String get posSetSectionShop => 'My shop';

  @override
  String get posSetSectionApp => 'This app';
}
