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
  String get riderManagementPhoneInvalid => 'Enter a valid phone number';

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
}
