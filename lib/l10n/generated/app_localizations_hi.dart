// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get commonOk => 'ठीक है';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonRetry => 'पुनः प्रयास करें';

  @override
  String get commonReject => 'अस्वीकार करें';

  @override
  String get commonAccept => 'स्वीकार करें';

  @override
  String get commonExit => 'बाहर निकलें';

  @override
  String get commonCallCustomer => 'ग्राहक को कॉल करें';

  @override
  String get commonCouldNotOpenDialer =>
      'फोन डायलर नहीं खुल सका। कृपया फिर से कोशिश करें।';

  @override
  String get splashAppName => 'Lndry Partner';

  @override
  String get splashTagline => 'पार्टनर पोर्टल';

  @override
  String get authWelcomeBack => 'वापसी पर स्वागत है';

  @override
  String get authLoginSubtitle =>
      'अपने लॉन्ड्री कामकाज को संभालने के लिए अपना मोबाइल नंबर दर्ज करें';

  @override
  String get authMobileNumberLabel => 'मोबाइल नंबर';

  @override
  String get authMobileNumberRequired => 'मोबाइल नंबर आवश्यक है';

  @override
  String get authMobileNumberInvalid =>
      'कृपया मान्य 10 अंकों का मोबाइल नंबर दर्ज करें';

  @override
  String get authGetOtpButton => 'OTP प्राप्त करें';

  @override
  String get authVerifyMobile => 'मोबाइल सत्यापित करें';

  @override
  String authOtpSubtitleWithPhone(String phone) {
    return '$phone पर भेजा गया 6 अंकों का OTP कोड दर्ज करें';
  }

  @override
  String get authOtpSubtitleGeneric =>
      'अपने मोबाइल पर भेजा गया सत्यापन कोड दर्ज करें';

  @override
  String get authDemoOtpLabel => 'डेमो OTP: ';

  @override
  String get authOtpCodeLabel => 'OTP कोड';

  @override
  String get authOtpRequired => 'कृपया OTP कोड दर्ज करें';

  @override
  String get authOtpInvalid => 'कृपया मान्य 6 अंकों का कोड दर्ज करें';

  @override
  String get authVerifyCodeButton => 'कोड सत्यापित करें';

  @override
  String get authResendPrompt => 'कोड प्राप्त नहीं हुआ? ';

  @override
  String get authResendCountdownPrefix => 'कोड इतने समय में फिर भेजें: ';

  @override
  String get authResendOtpButton => 'OTP फिर भेजें';

  @override
  String authResendCountdownSeconds(int seconds) {
    return '$seconds सेकंड';
  }

  @override
  String get dashboardTodayClosedTitle => 'आज बंद के रूप में चिह्नित है';

  @override
  String get dashboardTodayClosedMessage =>
      'आज आपके वर्किंग ऑवर्स शेड्यूल में गैर-कार्य दिवस के रूप में सेट है, इसलिए इस स्विच के बावजूद आपका स्टोर ग्राहकों के लिए बंद रहेगा। आज खोलने के लिए वर्किंग ऑवर्स और स्लॉट्स अपडेट करें।';

  @override
  String get dashboardOpenWorkingHoursButton => 'वर्किंग ऑवर्स खोलें';

  @override
  String get dashboardCloseStoreTitle => 'अपना स्टोर बंद करें?';

  @override
  String get dashboardOpenStoreTitle => 'अपना स्टोर खोलें?';

  @override
  String get dashboardCloseStoreMessage =>
      'जब तक आपका स्टोर बंद है, ग्राहक नए ऑर्डर नहीं दे पाएंगे।';

  @override
  String get dashboardOpenStoreMessage =>
      'आपका स्टोर ग्राहकों को दिखेगा और वे नए ऑर्डर दे सकेंगे।';

  @override
  String get dashboardCloseStoreButton => 'स्टोर बंद करें';

  @override
  String get dashboardOpenStoreButton => 'स्टोर खोलें';

  @override
  String get dashboardStoreNowOpen => 'स्टोर अब खुला है';

  @override
  String get dashboardStoreNowClosed => 'स्टोर अब बंद है';

  @override
  String dashboardActionFailed(String error) {
    return 'विफल: $error';
  }

  @override
  String get dashboardLaundryPartnerFallback => 'लॉन्ड्री पार्टनर';

  @override
  String get dashboardOpenBadge => 'खुला';

  @override
  String get dashboardClosedBadge => 'बंद';

  @override
  String get dashboardApprovedBadge => 'स्वीकृत';

  @override
  String get dashboardAvgRating => 'औसत रेटिंग';

  @override
  String get dashboardTotalReviews => 'कुल रिव्यू';

  @override
  String get dashboardAvgTurnaround => 'औसत टर्नअराउंड';

  @override
  String dashboardHoursValue(String hours) {
    return '$hours घंटे';
  }

  @override
  String get dashboardTodaysOperations => 'आज की गतिविधियां';

  @override
  String get dashboardTodaysRevenue => 'आज की कमाई';

  @override
  String get dashboardPendingOrders => 'लंबित ऑर्डर';

  @override
  String get dashboardProcessingOrders => 'प्रोसेसिंग में ऑर्डर';

  @override
  String get dashboardReadyPacked => 'तैयार / पैक्ड';

  @override
  String get dashboardFailedLoadStats => 'आंकड़े लोड नहीं हो सके';

  @override
  String get dashboardQuickActions => 'त्वरित कार्य';

  @override
  String get dashboardCatalogue => 'कैटलॉग';

  @override
  String get dashboardSlots => 'स्लॉट्स';

  @override
  String get dashboardAnalytics => 'एनालिटिक्स';

  @override
  String get dashboardHelp => 'सहायता';

  @override
  String get dashboardNewIncomingOrders => 'नए आने वाले ऑर्डर';

  @override
  String get dashboardViewAll => 'सभी देखें';

  @override
  String get dashboardAllCaughtUp => 'सब पूरा हो गया!';

  @override
  String get dashboardNoPendingOrders => 'फिलहाल कोई लंबित ऑर्डर नहीं है।';

  @override
  String get dashboardFailedLoadOrders => 'ऑर्डर लोड नहीं हो सके';

  @override
  String dashboardOrderIdLabel(String id) {
    return 'ऑर्डर #$id';
  }

  @override
  String dashboardOrderItemsSummary(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '1 आइटम',
    );
    return '$_temp0 • $names';
  }

  @override
  String get dashboardOrderAccepted => 'ऑर्डर स्वीकार कर लिया गया!';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsLanguageTitle => 'भाषा';

  @override
  String get settingsNotificationsSection => 'सूचनाएं';

  @override
  String get settingsPushNotifications => 'पुश सूचनाएं';

  @override
  String get settingsPushNotificationsSubtitle =>
      'नए ऑर्डर, भुगतान और अपडेट के लिए अलर्ट';

  @override
  String get settingsSoundAlerts => 'साउंड अलर्ट';

  @override
  String get settingsSoundAlertsSubtitle => 'नया ऑर्डर आने पर साउंड बजाएं';

  @override
  String get settingsOperationsSection => 'संचालन';

  @override
  String get settingsAutoAcceptOrders => 'ऑर्डर स्वतः स्वीकार करें';

  @override
  String get settingsAutoAcceptOrdersSubtitle =>
      'क्षमता उपलब्ध होने पर ऑर्डर स्वतः स्वीकार करें';

  @override
  String get settingsSupportLegalSection => 'सहायता और कानूनी जानकारी';

  @override
  String get settingsPartnerHelpdesk => 'पार्टनर हेल्पडेस्क';

  @override
  String get settingsPartnerHelpdeskSubtitle =>
      'LNDRY पार्टनर टीम से सहायता प्राप्त करें';

  @override
  String get settingsConnectingHelpdesk =>
      'पार्टनर हेल्पडेस्क से जुड़ रहे हैं…';

  @override
  String get settingsTermsOfService => 'सेवा की शर्तें और SLA';

  @override
  String get settingsOpeningTerms => 'सेवा की शर्तें खोली जा रही हैं…';

  @override
  String get settingsPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get settingsOpeningPrivacy => 'गोपनीयता नीति खोली जा रही है…';

  @override
  String settingsFooter(String version) {
    return 'Lndry Partner • वर्शन $version\n© 2026 LNDRY Technologies Pvt. Ltd.';
  }

  @override
  String get routerExitAppTitle => 'एप्लिकेशन से बाहर निकलें?';

  @override
  String get routerExitAppMessage =>
      'क्या आप वाकई Lndry Partner से बाहर निकलना चाहते हैं?';

  @override
  String get routerPageNotFound => 'पेज नहीं मिला';

  @override
  String get routerUnknownRoute => 'अज्ञात रूट';

  @override
  String get routerGoHome => 'होम पर जाएं';

  @override
  String get navHome => 'होम';

  @override
  String get navOrders => 'ऑर्डर';

  @override
  String get navServices => 'सेवाएं';

  @override
  String get navAnalytics => 'एनालिटिक्स';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get orderStatusPaymentPending => 'भुगतान लंबित';

  @override
  String get orderStatusPaymentFailed => 'भुगतान विफल';

  @override
  String get orderStatusWaitingForVendorConfirmation =>
      'पार्टनर की पुष्टि का इंतज़ार';

  @override
  String get orderStatusVendorAccepted => 'शेड्यूल्ड';

  @override
  String get orderStatusPickupAssigned => 'शेड्यूल्ड';

  @override
  String get orderStatusGoingForPickup => 'पिकअप पार्टनर आ रहा है';

  @override
  String get orderStatusPickupOtpVerified => 'पिक अप हो गया';

  @override
  String get orderStatusPickedUp => 'पिक अप हो गया';

  @override
  String get orderStatusReceivedAtVendor => 'पार्टनर के पास पहुंचा';

  @override
  String get orderStatusReconciliationPending =>
      'पुनर्मूल्यांकन सबमिट — ग्राहक की स्वीकृति का इंतज़ार';

  @override
  String get orderStatusReconciliationDisputed =>
      'ग्राहक ने पुनर्मूल्यांकन को अस्वीकार किया';

  @override
  String get orderStatusProcessing => 'प्रोसेसिंग में';

  @override
  String get orderStatusPacked => 'पैक्ड';

  @override
  String get orderStatusDeliveryAssigned => 'डिलीवरी के लिए निकला';

  @override
  String get orderStatusOutForDelivery => 'डिलीवरी के लिए निकला';

  @override
  String get orderStatusDeliveryOtpVerified => 'डिलीवर हो गया';

  @override
  String get orderStatusDelivered => 'डिलीवर हो गया';

  @override
  String get orderStatusVendorRejected => 'पार्टनर द्वारा अस्वीकृत';

  @override
  String get orderStatusAutoRejected => 'स्वतः अस्वीकृत';

  @override
  String get orderStatusCustomerCancelled => 'रद्द';

  @override
  String get orderStatusAdminCancelled => 'रद्द';

  @override
  String get orderStatusRefundPending => 'रिफंड लंबित';

  @override
  String get orderStatusRefunded => 'रिफंड हो गया';

  @override
  String get ordersPageTitle => 'ऑपरेशनल ऑर्डर';

  @override
  String get ordersTabPending => 'लंबित';

  @override
  String get ordersTabActive => 'सक्रिय';

  @override
  String get ordersTabReady => 'तैयार';

  @override
  String get ordersTabHistory => 'इतिहास';

  @override
  String get ordersEmptyPendingTitle => 'कोई लंबित ऑर्डर नहीं';

  @override
  String get ordersEmptyPendingSubtitle =>
      'सब पूरा हो गया! नए ऑर्डर यहां दिखेंगे।';

  @override
  String get ordersEmptyActiveTitle => 'कोई सक्रिय ऑर्डर नहीं';

  @override
  String get ordersEmptyActiveSubtitle =>
      'प्रोसेसिंग या पिक अप हो रहे ऑर्डर यहां दिखेंगे।';

  @override
  String get ordersEmptyReadyTitle => 'कोई तैयार ऑर्डर नहीं';

  @override
  String get ordersEmptyReadySubtitle =>
      'पैक्ड और डिलीवरी के लिए निकले ऑर्डर यहां दिखेंगे।';

  @override
  String get ordersEmptyHistoryTitle => 'ऑर्डर इतिहास खाली है';

  @override
  String get ordersEmptyHistorySubtitle =>
      'पूरे हुए और रद्द किए गए ऑर्डर यहां आपके इतिहास में दिखेंगे।';

  @override
  String ordersPickupTimeLabel(String time) {
    return 'पिकअप: $time';
  }

  @override
  String ordersCreatedTimeLabel(String time) {
    return 'बना: $time';
  }

  @override
  String get ordersReconcileReceiptsButton => 'रसीदें मिलाएं';

  @override
  String get ordersStartWashingButton => 'धुलाई शुरू करें';

  @override
  String get ordersUpdateStageButton => 'स्टेज अपडेट करें';

  @override
  String get ordersMarkPackedButton => 'पैक्ड व तैयार मार्क करें';

  @override
  String get ordersUpdateProcessingStageTitle => 'प्रोसेसिंग स्टेज अपडेट करें';

  @override
  String get ordersStageWashing => 'धुलाई';

  @override
  String get ordersStageDrying => 'सुखाना';

  @override
  String get ordersStageIroning => 'इस्त्री';

  @override
  String get ordersOrderAcceptedSnack => 'ऑर्डर स्वीकार हो गया';

  @override
  String get ordersOrderRejectedSnack => 'ऑर्डर अस्वीकार हो गया';

  @override
  String ordersErrorSnack(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String ordersStageUpdatedSnack(String stage) {
    return 'स्टेज अपडेट होकर $stage हो गया';
  }

  @override
  String get orderDetailsPerKg => 'प्रति किलो';

  @override
  String get orderDetailsPerSqFt => 'प्रति वर्ग फुट';

  @override
  String get orderDetailsPerItem => 'प्रति आइटम';

  @override
  String get orderDetailsChooseServiceTitle => 'एक सेवा चुनें';

  @override
  String get orderDetailsMoveServiceTitle => 'किसी दूसरी सेवा में ले जाएं';

  @override
  String get orderDetailsAddServiceTitle => 'सेवा जोड़ें';

  @override
  String get orderDetailsQuantityLabel => 'मात्रा';

  @override
  String get orderDetailsAddButton => 'जोड़ें';

  @override
  String orderDetailsPhotoUploadFailed(String error) {
    return 'फोटो अपलोड नहीं हो सकी: $error';
  }

  @override
  String get orderDetailsPhotoRequired => 'कम से कम एक फोटो आवश्यक है';

  @override
  String get orderDetailsProblemReportRequired =>
      'सबमिट करने से पहले कम से कम एक आइटम पर Report to Re-evaluation करें';

  @override
  String get orderDetailsSubmittedForApproval =>
      'ग्राहक की स्वीकृति के लिए भेज दिया गया';

  @override
  String orderDetailsReconciliationFailed(String error) {
    return 'पुनर्मूल्यांकन विफल: $error';
  }

  @override
  String get orderDetailsReconcileSheetTitle => 'ऑर्डर आइटम मिलाएं';

  @override
  String get orderDetailsReconcileSheetSubtitle =>
      'यह प्रोसेसिंग जारी रहने से पहले ग्राहक की स्वीकृति के लिए भेजा जाएगा।';

  @override
  String orderDetailsEstQuantity(String quantity) {
    return 'अनुमानित: $quantity';
  }

  @override
  String orderDetailsMovedFrom(String from, String to) {
    return '$from से $to में ले जाया गया';
  }

  @override
  String get orderDetailsChangeServiceAgain => 'सेवा फिर से बदलें';

  @override
  String get orderDetailsMoveServicePrompt => 'सही सेवा नहीं है? इसे बदलें';

  @override
  String get orderDetailsAddServiceButton => 'सेवा जोड़ें';

  @override
  String get orderDetailsAdjustmentNoteLabel => 'समायोजन नोट / कारण';

  @override
  String get orderDetailsAdjustmentNoteHint =>
      'जैसे: 1 शर्ट जोड़ी गई, कॉलर पर दाग है';

  @override
  String get orderDetailsPhotoEvidenceLabel => 'फोटो सबूत (आवश्यक)';

  @override
  String get orderDetailsPhotoEvidenceOptionalLabel =>
      'अतिरिक्त फोटो सबूत (वैकल्पिक — यह पहले से ही नीचे दी गई आपकी पुनर्मूल्यांकन रिपोर्ट में शामिल है)';

  @override
  String get orderDetailsReportProblemButton =>
      'पुनर्मूल्यांकन में रिपोर्ट करें';

  @override
  String get orderDetailsReportProblemTitle =>
      'पुनर्मूल्यांकन में रिपोर्ट करें';

  @override
  String get orderDetailsProblemTypeLabel => 'समस्या क्या है?';

  @override
  String get orderDetailsProblemOtherOption => 'अन्य';

  @override
  String get orderDetailsProblemCustomMessageLabel => 'समस्या बताएं';

  @override
  String get orderDetailsProblemCustomMessageHint =>
      'जैसे: इस वस्तु की ज़िप टूटी है';

  @override
  String get orderDetailsProblemPhotoLabel => 'फोटो सबूत (1-3 आवश्यक)';

  @override
  String get orderDetailsProblemRemoveButton => 'हटाएं';

  @override
  String get orderDetailsProblemSaveButton => 'रिपोर्ट सेव करें';

  @override
  String get orderDetailsReportedProblemsHeader => 'पुनर्मूल्यांकन रिपोर्ट्स';

  @override
  String orderDetailsProblemForItem(String item) {
    return 'के लिए: $item';
  }

  @override
  String get orderDetailsSubmitButton => 'ग्राहक की स्वीकृति के लिए सबमिट करें';

  @override
  String get orderDetailsRejectOrderTitle => 'ऑर्डर अस्वीकार करें';

  @override
  String get orderDetailsRejectionReasonLabel => 'अस्वीकृति का कारण';

  @override
  String get orderDetailsRejectionReasonHint =>
      'जैसे: आज दुकान की क्षमता पूरी हो गई';

  @override
  String get orderDetailsConfirmRejectButton => 'अस्वीकृति की पुष्टि करें';

  @override
  String get orderDetailsPageTitle => 'ऑर्डर विवरण';

  @override
  String get orderDetailsAwaitingApprovalTitle =>
      'ग्राहक की स्वीकृति का इंतज़ार';

  @override
  String get orderDetailsAwaitingApprovalBody =>
      'ग्राहक आपके प्रस्तावित बदलाव की समीक्षा कर रहा है। जवाब मिलने तक प्रोसेसिंग रुकी रहेगी।';

  @override
  String get orderDetailsDisputedTitle =>
      'ग्राहक ने प्रस्तावित राशि को अस्वीकार किया';

  @override
  String get orderDetailsDisputedBody =>
      'इसे सुलझाने के लिए ग्राहक को कॉल करें, फिर सही आइटम/फोटो के साथ पुनर्मूल्यांकन दोबारा भेजें।';

  @override
  String get orderDetailsLifecycleStepper => 'लाइफसाइकल स्टेपर';

  @override
  String get orderDetailsCustomerDetails => 'ग्राहक विवरण';

  @override
  String get orderDetailsCustomerFallback => 'ग्राहक';

  @override
  String orderDetailsCustomerNote(String note) {
    return 'नोट: $note';
  }

  @override
  String get orderDetailsGarmentItems => 'कपड़ों की सूची';

  @override
  String get orderDetailsReconcileCountButton => 'गिनती मिलाएं';

  @override
  String orderDetailsQuantityValue(String quantity) {
    return 'मात्रा: $quantity';
  }

  @override
  String get orderDetailsSubtotal => 'सबटोटल';

  @override
  String get orderDetailsGstTaxes => 'GST / टैक्स';

  @override
  String get orderDetailsPlatformFee => 'प्लेटफॉर्म फीस';

  @override
  String get orderDetailsDeliveryFee => 'डिलीवरी फीस';

  @override
  String get orderDetailsHandlingFee => 'हैंडलिंग फीस';

  @override
  String get orderDetailsTotalPayable => 'कुल देय राशि';

  @override
  String get orderDetailsServiceFee => 'सेवा शुल्क';

  @override
  String orderDetailsLndryCommission(String rate) {
    return 'LNDRY कमीशन ($rate%)';
  }

  @override
  String get orderDetailsLndryCommissionFlat => 'LNDRY कमीशन';

  @override
  String orderDetailsGstOnCommission(String rate) {
    return 'कमीशन पर GST ($rate%)';
  }

  @override
  String get orderDetailsVendorPayout => 'आपको मिलेगा';

  @override
  String get orderDetailsPickupRiderLabel => 'पिकअप कैप्टन';

  @override
  String get orderDetailsDeliveryRiderLabel => 'डिलीवरी कैप्टन';

  @override
  String get orderDetailsAssignRiderHint => 'चुनें कि यह ऑर्डर कौन संभालेगा';

  @override
  String get orderDetailsAssignRiderButton => 'असाइन करें';

  @override
  String get orderDetailsAssignRiderTitle => 'कैप्टन असाइन करें';

  @override
  String get orderDetailsNoActiveRiders =>
      'अभी तक कोई सक्रिय कैप्टन नहीं है। कैप्टन प्रबंधन से एक जोड़ें।';

  @override
  String get orderDetailsRiderAssignedSnack => 'कैप्टन असाइन किया गया';

  @override
  String get orderDetailsBroadcastButton => 'सभी कैप्टन को भेजें';

  @override
  String get orderDetailsBroadcastSnack => 'सक्रिय कैप्टन को भेज दिया गया';

  @override
  String orderDetailsAssignedToRider(String name) {
    return '$name को असाइन किया गया';
  }

  @override
  String get orderDetailsOfferPendingBroadcast =>
      'सभी कैप्टन को ऑफर भेजा गया — स्वीकृति की प्रतीक्षा है';

  @override
  String orderDetailsOfferPendingSingle(String name) {
    return '$name को ऑफर किया गया — प्रतिक्रिया की प्रतीक्षा है';
  }

  @override
  String get orderDetailsReassignButton => 'फिर से असाइन करें';

  @override
  String get jobOfferTitle => 'नया जॉब ऑफर!';

  @override
  String jobOfferOrderNumber(String orderNumber) {
    return 'ऑर्डर #$orderNumber';
  }

  @override
  String get jobOfferAcceptButton => 'स्वीकार करें';

  @override
  String get jobOfferAcceptedSnack => 'जॉब स्वीकार किया गया — माय जॉब्स देखें';

  @override
  String get jobOfferUnavailableSnack =>
      'देर हो गई — यह जॉब किसी और ने ले लिया';

  @override
  String get jobOfferNotNowButton => 'अभी नहीं';

  @override
  String jobOfferCountdownLabel(String time) {
    return '$time में फिर से भेजा जाएगा';
  }

  @override
  String get jobOfferExpiredLabel => 'फिर से भेजा जा रहा है…';

  @override
  String get orderDetailsCustomerReview => 'ग्राहक समीक्षा';

  @override
  String get orderDetailsVendorRating => 'पार्टनर रेटिंग';

  @override
  String get orderDetailsDeliveryRating => 'डिलीवरी रेटिंग';

  @override
  String get orderDetailsSubmittedReevaluation =>
      'पुनर्मूल्यांकन सबमिट किया गया';

  @override
  String get orderDetailsNewServiceAdded => 'नई सेवा जोड़ी गई';

  @override
  String orderDetailsMovedGeneric(String from, String to) {
    return 'स्थानांतरित: $from से $to';
  }

  @override
  String get orderDetailsItemFallback => 'आइटम';

  @override
  String get orderDetailsPreviousTotal => 'पिछला कुल';

  @override
  String get orderDetailsFinalEvaluatedAmount => 'अंतिम मूल्यांकित राशि';

  @override
  String get orderDetailsAdjustmentNoteHeader => 'समायोजन नोट';

  @override
  String get orderDetailsPhotoEvidenceHeader => 'फोटो सबूत';

  @override
  String get orderDetailsStageWaiting => 'प्रतीक्षा';

  @override
  String get orderDetailsStageAccepted => 'स्वीकृत';

  @override
  String get orderDetailsStageReceived => 'प्राप्त';

  @override
  String get orderDetailsStageCustomerApproval => 'ग्राहक स्वीकृति';

  @override
  String get orderDetailsStageProcessing => 'प्रोसेसिंग';

  @override
  String get orderDetailsStagePacked => 'पैक्ड';

  @override
  String get orderDetailsStageDelivered => 'डिलीवर';

  @override
  String get orderDetailsRejectOrderButton => 'ऑर्डर अस्वीकार करें';

  @override
  String get orderDetailsAcceptOrderButton => 'ऑर्डर स्वीकार करें';

  @override
  String get orderDetailsMarkReceivedButton => 'प्राप्त के रूप में मार्क करें';

  @override
  String get orderDetailsReconcileItemsButton => 'आइटम मिलाएं';

  @override
  String get orderDetailsStartProcessingButton => 'प्रोसेसिंग शुरू करें';

  @override
  String get orderDetailsWaitingApprovalStatus =>
      'ग्राहक की स्वीकृति का इंतज़ार';

  @override
  String get orderDetailsResubmitButton => 'पुनर्मूल्यांकन दोबारा भेजें';

  @override
  String orderDetailsErrorLoading(String error) {
    return 'विवरण लोड करने में त्रुटि: $error';
  }

  @override
  String get orderDetailsOtherCategoryFallback => 'अन्य';

  @override
  String get serviceCategoryWash => 'वॉश';

  @override
  String get serviceCategoryIron => 'आयरन';

  @override
  String get serviceCategoryWashAndIron => 'वॉश & आयरन';

  @override
  String get serviceCategoryDryClean => 'ड्राई क्लीन';

  @override
  String get serviceCategoryFold => 'फोल्ड';

  @override
  String get serviceCategoryPremium => 'प्रीमियम';

  @override
  String get slotsSunday => 'रविवार';

  @override
  String get slotsMonday => 'सोमवार';

  @override
  String get slotsTuesday => 'मंगलवार';

  @override
  String get slotsWednesday => 'बुधवार';

  @override
  String get slotsThursday => 'गुरुवार';

  @override
  String get slotsFriday => 'शुक्रवार';

  @override
  String get slotsSaturday => 'शनिवार';

  @override
  String get servicesStatusPendingReview => 'समीक्षा लंबित';

  @override
  String get servicesStatusRejected => 'अस्वीकृत';

  @override
  String get servicesStatusLive => 'लाइव';

  @override
  String get servicesPageTitle => 'कैटलॉग और सेवाएं';

  @override
  String get servicesEmptyTitle => 'अभी तक कोई सेवा नहीं';

  @override
  String get servicesEmptySubtitle =>
      'कैटेगरी चुनने, सबकैटेगरी चुनने और अपनी कीमतें सेट करने के लिए \"सेवा जोड़ें\" पर टैप करें।';

  @override
  String servicesRejectedReason(String reason) {
    return 'अस्वीकृत: $reason';
  }

  @override
  String servicesPriceAdjustedByAdmin(String reason) {
    return 'एडमिन द्वारा कीमत समायोजित: $reason';
  }

  @override
  String servicesFailedToLoad(String error) {
    return 'सेवाएं लोड नहीं हो सकीं: $error';
  }

  @override
  String get servicesAddServiceButton => 'सेवा जोड़ें';

  @override
  String get servicesPickCategorySnack => 'कृपया एक कैटेगरी चुनें';

  @override
  String get servicesTurnOnSubcategorySnack =>
      'पेश करने के लिए कम से कम एक सबकैटेगरी चालू करें';

  @override
  String get servicesEnterPriceSnack =>
      'हर सक्रिय सबकैटेगरी के लिए ₹0 से अधिक कीमत दर्ज करें';

  @override
  String get servicesSubmittedForReview => 'एडमिन समीक्षा के लिए भेज दिया गया';

  @override
  String servicesFailedToSave(String error) {
    return 'सेव करने में विफल: $error';
  }

  @override
  String get servicesEditServiceTitle => 'सेवा संपादित करें';

  @override
  String servicesRejectedByAdminNote(String reason) {
    return 'एडमिन द्वारा अस्वीकृत: $reason\nबदलाव करें और पुनः समीक्षा के लिए सेव करें।';
  }

  @override
  String get servicesServiceNameLabel => 'सेवा का नाम';

  @override
  String get servicesServiceNameHint => 'जैसे: प्रीमियम लॉन्ड्री सेवाएं';

  @override
  String get servicesNameRequired => 'नाम आवश्यक है';

  @override
  String get servicesDescriptionLabel => 'विवरण';

  @override
  String get servicesDescriptionHint => 'जैसे: तेज़ टर्नअराउंड, डोरस्टेप पिकअप';

  @override
  String get servicesDescriptionRequired => 'विवरण आवश्यक है';

  @override
  String get servicesCategoryLabel => 'कैटेगरी';

  @override
  String get servicesCategoryRequired => 'कैटेगरी आवश्यक है';

  @override
  String get servicesSubcategoriesHeader => 'सबकैटेगरी';

  @override
  String get servicesSubcategoriesSubtitle =>
      'इस कैटेगरी से जो पेश करना चाहते हैं उसे चुनें और अपनी कीमत सेट करें। यूनिट एडमिन द्वारा तय है।';

  @override
  String servicesFailedToLoadSubcategories(String error) {
    return 'लोड नहीं हो सका: $error';
  }

  @override
  String get servicesNoSubcategoriesPublished =>
      'एडमिन ने अभी तक यहां कोई सबकैटेगरी प्रकाशित नहीं की है।';

  @override
  String get servicesSaveSubmitButton => 'सेव करें और समीक्षा के लिए भेजें';

  @override
  String servicesUnitPer(String unit) {
    return 'यूनिट: प्रति $unit';
  }

  @override
  String servicesDemoPriceReferenceOnly(String price, String unit) {
    return 'डेमो कीमत: ₹$price/$unit — केवल संदर्भ के लिए';
  }

  @override
  String get servicesPriceAdjustedHeader => 'एडमिन द्वारा कीमत समायोजित';

  @override
  String servicesYourPricePer(String unit) {
    return 'आपकी कीमत प्रति $unit';
  }

  @override
  String get pricingEnterPriceSnack =>
      'हर सक्रिय सबकैटेगरी के लिए ₹0 से अधिक कीमत दर्ज करें।';

  @override
  String get pricingPageTitle => 'गारमेंट प्राइसिंग रेट्स';

  @override
  String get pricingCreateServiceFirst =>
      'कस्टम प्राइसिंग रेट्स सेट करने के लिए पहले एक लॉन्ड्री सेवा बनाएं।';

  @override
  String pricingFailedToLoad(String error) {
    return 'प्राइसिंग लोड नहीं हो सकी: $error';
  }

  @override
  String pricingErrorLoadingServices(String error) {
    return 'सेवाएं लोड करने में त्रुटि: $error';
  }

  @override
  String get pricingSaveChangesButton => 'बदलाव सेव करें';

  @override
  String get pricingNoSubcategoriesPublished =>
      'एडमिन ने अभी तक इस सेवा के लिए कोई सबकैटेगरी प्रकाशित नहीं की है।';

  @override
  String pricingUnitBillingPer(String unit) {
    return 'यूनिट बिलिंग: प्रति $unit';
  }

  @override
  String pricingDemoPriceChargeWhatYouLike(String price, String unit) {
    return 'डेमो कीमत: ₹$price/$unit — आप जो चाहें चार्ज कर सकते हैं';
  }

  @override
  String get pricingPricesSaved => 'कीमतें सेव हो गईं';

  @override
  String pricingFailedToSavePrices(String error) {
    return 'कीमतें सेव करने में विफल: $error';
  }

  @override
  String get inventoryPageTitle => 'ऑपरेशनल सप्लाई';

  @override
  String get inventoryAddSupplyItemTitle => 'सप्लाई आइटम जोड़ें';

  @override
  String get inventoryItemNameLabel => 'आइटम का नाम';

  @override
  String get inventoryItemNameHint => 'जैसे: कॉलर स्क्रब';

  @override
  String get inventoryRequiredField => 'आवश्यक';

  @override
  String get inventoryInitialQtyLabel => 'शुरुआती मात्रा';

  @override
  String get inventoryMinLimitLabel => 'न्यूनतम सीमा';

  @override
  String get inventoryUnitLabel => 'यूनिट';

  @override
  String get inventoryUnitHint => 'जैसे: लीटर, बैग्स, कैन';

  @override
  String get inventoryAddItemButton => 'आइटम जोड़ें';

  @override
  String get inventoryItemAddedSnack => 'आइटम इन्वेंटरी में जोड़ा गया';

  @override
  String get inventoryLowStockWarningTitle => 'स्टॉक कम है';

  @override
  String inventoryLowStockWarningBody(int count) {
    return '$count सप्लाई कम हो रही हैं। कृपया जल्द ऑर्डर करें।';
  }

  @override
  String inventoryQuantityOfThreshold(
      String qty, String threshold, String unit) {
    return '$qty / $threshold $unit (न्यूनतम सीमा)';
  }

  @override
  String get inventoryOutBadge => 'खत्म';

  @override
  String get inventoryLowBadge => 'कम';

  @override
  String get slotsPageTitle => 'वर्किंग ऑवर्स और स्लॉट्स';

  @override
  String get slotsCapacityRequestedSnack =>
      'क्षमता बदलाव का अनुरोध भेजा गया — एडमिन की मंजूरी लंबित';

  @override
  String slotsFailedToUpdateCapacity(String error) {
    return 'क्षमता अपडेट करने में विफल: $error';
  }

  @override
  String slotsFailedGeneric(String error) {
    return 'विफल: $error';
  }

  @override
  String get slotsSlotDeletedSnack => 'स्लॉट हटाया गया';

  @override
  String get slotsClosingAfterOpening =>
      'बंद होने का समय खुलने के समय के बाद होना चाहिए।';

  @override
  String get slotsOperationalWorkingHours => 'ऑपरेशनल वर्किंग ऑवर्स';

  @override
  String get slotsToLabel => 'से';

  @override
  String get slotsClosedLabel => 'बंद';

  @override
  String slotsErrorGeneric(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get slotsDailyCapacityLimit => 'दैनिक क्षमता सीमा';

  @override
  String slotsPendingRequestNotice(String limit) {
    return '$limit ऑर्डर/दिन में बदलने का अनुरोध समीक्षा में लंबित है।';
  }

  @override
  String get slotsMaxOrdersPerDayLabel => 'प्रतिदिन अधिकतम ऑर्डर';

  @override
  String get slotsMaxOrdersHint => 'जैसे: 20';

  @override
  String get slotsRequiredField => 'आवश्यक';

  @override
  String get slotsUpdateRequestButton => 'अनुरोध अपडेट करें';

  @override
  String get slotsUpdateButton => 'अपडेट करें';

  @override
  String slotsErrorLoading(String error) {
    return 'लोड करने में त्रुटि: $error';
  }

  @override
  String get slotsWeeklySlotsSchedule => 'साप्ताहिक स्लॉट शेड्यूल';

  @override
  String get slotsNoCustomSlots =>
      'कोई कस्टम स्लॉट सेट नहीं है। वर्किंग ऑवर्स जोड़ने के लिए \"+\" पर टैप करें।';

  @override
  String slotsMaxOrdersBadge(String count) {
    return 'अधिकतम $count ऑर्डर';
  }

  @override
  String get slotsEditPickupTimeSlotTitle => 'पिकअप टाइम स्लॉट संपादित करें';

  @override
  String get slotsAddPickupTimeSlotTitle => 'पिकअप टाइम स्लॉट जोड़ें';

  @override
  String get slotsDayOfWeekLabel => 'सप्ताह का दिन';

  @override
  String get slotsStartTimeLabel => 'शुरुआती समय';

  @override
  String get slotsStartTimeHint => 'जैसे: 09:00';

  @override
  String get slotsEndTimeLabel => 'अंतिम समय';

  @override
  String get slotsEndTimeHint => 'जैसे: 12:00';

  @override
  String get slotsMaxOrdersLimitLabel => 'अधिकतम ऑर्डर सीमा';

  @override
  String get slotsMaxOrdersLimitHint => 'जैसे: 5';

  @override
  String get slotsInvalidNumber => 'अमान्य संख्या';

  @override
  String get slotsUpdateSlotButton => 'स्लॉट अपडेट करें';

  @override
  String get slotsSaveSlotButton => 'स्लॉट सेव करें';

  @override
  String get slotsSlotUpdatedSnack => 'स्लॉट सफलतापूर्वक अपडेट हुआ';

  @override
  String get slotsPickupSlotAddedSnack => 'पिकअप स्लॉट जोड़ा गया';

  @override
  String get slotsDayClosedError => 'वर्किंग ऑवर्स के तहत चुना गया दिन बंद है।';

  @override
  String slotsOutsideWorkingHoursError(String open, String close) {
    return 'स्लॉट का समय ऑपरेशनल वर्किंग ऑवर्स ($open से $close) के भीतर होना चाहिए।';
  }

  @override
  String slotsOverlapError(String start, String end, String day) {
    return 'यह स्लॉट $day को मौजूदा स्लॉट $start - $end से टकराता है।';
  }

  @override
  String get analyticsWeekSegment => 'सप्ताह';

  @override
  String get analyticsMonthSegment => 'महीना';

  @override
  String get analyticsFailedToLoad => 'एनालिटिक्स लोड नहीं हो सका';

  @override
  String get analyticsTotalRevenue => 'कुल कमाई';

  @override
  String analyticsOrdersDeliveredSub(int count) {
    return '$count ऑर्डर डिलीवर हुए';
  }

  @override
  String get analyticsAvgTicketSize => 'औसत टिकट साइज़';

  @override
  String get analyticsPerCompletedOrderSub => 'प्रति पूर्ण ऑर्डर';

  @override
  String get analyticsFulfillmentRate => 'पूर्ति दर';

  @override
  String analyticsOfTotalOrdersSub(int count) {
    return 'कुल $count ऑर्डर में से';
  }

  @override
  String get analyticsTotalOrders => 'कुल ऑर्डर';

  @override
  String get analyticsInSelectedPeriodSub => 'चुनी गई अवधि में';

  @override
  String analyticsOrderVolumeLastNDays(int days) {
    return 'ऑर्डर वॉल्यूम (पिछले $days दिन)';
  }

  @override
  String get analyticsNoOrdersRecorded => 'इस अवधि में कोई ऑर्डर दर्ज नहीं है।';

  @override
  String get analyticsCategoryRevenueShare => 'कैटेगरी रेवेन्यू शेयर';

  @override
  String get analyticsNoDeliveredOrders =>
      'इस अवधि में कोई डिलीवर ऑर्डर नहीं है।';

  @override
  String get analyticsSlaCustomerRetention => 'SLA और ग्राहक रिटेंशन';

  @override
  String get analyticsOnTimeDelivery => 'समय पर डिलीवरी';

  @override
  String get analyticsRepeatCustomers => 'रिपीट ग्राहक';

  @override
  String get employeesEditStaffTitle => 'स्टाफ सदस्य संपादित करें';

  @override
  String get employeesInviteStaffTitle => 'स्टाफ सदस्य आमंत्रित करें';

  @override
  String get employeesFullNameLabel => 'पूरा नाम';

  @override
  String get employeesFullNameHint => 'जैसे: जॉन डो';

  @override
  String get employeesNameRequired => 'नाम आवश्यक है';

  @override
  String get employeesEmailLabel => 'ईमेल पता';

  @override
  String get employeesEmailHint => 'जैसे: johndoe@lndry.com';

  @override
  String get employeesEmailRequired => 'ईमेल आवश्यक है';

  @override
  String get employeesEmailInvalid => 'अमान्य ईमेल';

  @override
  String get employeesPhoneOptionalLabel => 'फोन नंबर (वैकल्पिक)';

  @override
  String get employeesPhoneHint => 'जैसे: 9876543210';

  @override
  String get employeesShopRoleLabel => 'शॉप रोल';

  @override
  String get employeesRoleOwner => 'वेंडर ओनर (एडमिन)';

  @override
  String get employeesRoleStaff => 'वेंडर स्टाफ';

  @override
  String get employeesPermissionsHeader => 'परमिशन';

  @override
  String get employeesPermReadOrders => 'ऑर्डर देखें';

  @override
  String get employeesPermProcessOrders => 'ऑर्डर प्रोसेस और पुष्टि करें';

  @override
  String get employeesPermManageCatalog => 'सेवाएं और कीमतें प्रबंधित करें';

  @override
  String get employeesPermManageEmployees => 'कर्मचारी प्रबंधित करें';

  @override
  String get employeesSaveChangesButton => 'बदलाव सेव करें';

  @override
  String get employeesInviteStaffButton => 'स्टाफ आमंत्रित करें';

  @override
  String get employeesStaffUpdatedSnack => 'स्टाफ रिकॉर्ड अपडेट हुआ';

  @override
  String get employeesInvitationSentSnack => 'आमंत्रण भेजा गया';

  @override
  String employeesResetPasswordTitle(String name) {
    return '$name के लिए पासवर्ड रीसेट करें';
  }

  @override
  String get employeesNewPasswordLabel => 'नया पासवर्ड';

  @override
  String get employeesNewPasswordHint =>
      'कम से कम 8 अक्षर, 1 अक्षर और 1 अंक के साथ';

  @override
  String get employeesPasswordTooShort => 'पासवर्ड बहुत छोटा है';

  @override
  String get employeesPasswordUpdatedSnack => 'पासवर्ड सफलतापूर्वक अपडेट हुआ';

  @override
  String employeesResetFailedSnack(String error) {
    return 'रीसेट विफल: $error';
  }

  @override
  String get employeesRemoveStaffTitle => 'स्टाफ सदस्य हटाएं';

  @override
  String employeesRemoveStaffConfirm(String name) {
    return 'क्या आप वाकई $name को इस दुकान से हटाना चाहते हैं?';
  }

  @override
  String get employeesConfirmRemoveButton => 'हटाने की पुष्टि करें';

  @override
  String get employeesStaffRemovedSnack => 'स्टाफ सदस्य हटाया गया';

  @override
  String get employeesPageTitle => 'शॉप कर्मचारी';

  @override
  String get employeesEmptyTitle => 'कोई कर्मचारी नहीं मिला';

  @override
  String get employeesEmptySubtitle =>
      'लॉन्ड्री इनटेक, स्टेटस अपडेट और डिस्पैच में मदद के लिए स्टाफ आमंत्रित करें।';

  @override
  String get employeesOwnerBadge => 'ओनर';

  @override
  String get employeesStaffBadge => 'स्टाफ';

  @override
  String get employeesResetPassButton => 'पासवर्ड रीसेट';

  @override
  String get employeesSavePasswordButton => 'पासवर्ड सेव करें';

  @override
  String get employeesPermissionsButton => 'परमिशन';

  @override
  String employeesFailedToLoad(String error) {
    return 'कर्मचारी लोड नहीं हो सके: $error';
  }

  @override
  String get riderManagementAddRiderTitle => 'कैप्टन जोड़ें';

  @override
  String get riderManagementAddRiderSubtitle =>
      'कैप्टन इसी फोन नंबर से लॉगिन करेगा, जैसे आप करते हैं।';

  @override
  String get riderManagementFullNameHint => 'जैसे: राहुल सेन';

  @override
  String get riderManagementPhoneLabel => 'फोन नंबर';

  @override
  String get riderManagementPhoneInvalid =>
      'एक मान्य 10 अंकों का मोबाइल नंबर दर्ज करें।';

  @override
  String get riderManagementRiderAddedSnack => 'कैप्टन जोड़ा गया';

  @override
  String get riderManagementRemoveRiderTitle => 'कैप्टन हटाएं';

  @override
  String riderManagementRemoveConfirm(String name) {
    return 'क्या आप वाकई $name को हटाना चाहते हैं?';
  }

  @override
  String get riderManagementPageTitle => 'कैप्टन प्रबंधन';

  @override
  String get riderManagementEmptyTitle => 'अभी तक कोई कैप्टन नहीं';

  @override
  String get riderManagementEmptySubtitle =>
      'अपने खुद के डिलीवरी कैप्टन जोड़ें — वे अपने फोन से लॉगिन करते हैं और केवल अपनी सौंपी गई पिकअप और डिलीवरी देखते हैं।';

  @override
  String riderManagementFailedToLoad(String error) {
    return 'कैप्टन लोड नहीं हो सके: $error';
  }

  @override
  String riderMyJobsTitleWithVendor(String vendor) {
    return '$vendor — मेरे काम';
  }

  @override
  String get riderMyJobsTitle => 'मेरे काम';

  @override
  String get riderNoJobsTitle => 'अभी कोई काम नहीं';

  @override
  String get riderNoJobsSubtitle =>
      'आपको सौंपे गए पिकअप और डिलीवरी काम यहां दिखेंगे।';

  @override
  String riderFailedToLoadJobs(String error) {
    return 'काम लोड नहीं हो सके: $error';
  }

  @override
  String get riderPickupBadge => 'पिकअप';

  @override
  String get riderDeliveryBadge => 'डिलीवरी';

  @override
  String get riderInProgressBadge => 'जारी है';

  @override
  String get riderOtpEnterCode => '6 अंकों का कोड दर्ज करें';

  @override
  String get riderOtpPickupConfirmedSnack => 'पिकअप की पुष्टि हुई';

  @override
  String get riderOtpDeliveryConfirmedSnack => 'डिलीवरी की पुष्टि हुई';

  @override
  String get riderOtpInvalidExpired =>
      'अमान्य या समय-सीमा समाप्त कोड। कृपया फिर से कोशिश करें।';

  @override
  String get riderConfirmPickupTitle => 'पिकअप की पुष्टि करें';

  @override
  String get riderConfirmDeliveryTitle => 'डिलीवरी की पुष्टि करें';

  @override
  String get riderOtpPrompt =>
      'ग्राहक से उनके ऐप में दिखा कोड पूछें, फिर उसे नीचे दर्ज करें।';

  @override
  String get riderNoLocationSnack => 'इस पते के लिए कोई लोकेशन उपलब्ध नहीं है';

  @override
  String get riderCouldNotOpenMaps => 'Google Maps नहीं खोल सके';

  @override
  String riderCouldNotStartPickup(String error) {
    return 'पिकअप शुरू नहीं हो सका: $error';
  }

  @override
  String riderCouldNotStartDelivery(String error) {
    return 'डिलीवरी शुरू नहीं हो सकी: $error';
  }

  @override
  String get riderCancelPickupNotAvailable =>
      'पिकअप रद्द करना अभी उपलब्ध नहीं है।';

  @override
  String get riderJobDetailTitle => 'काम का विवरण';

  @override
  String riderFailedToLoadJob(String error) {
    return 'काम लोड नहीं हो सका: $error';
  }

  @override
  String get riderItemsHeader => 'आइटम';

  @override
  String get riderNavigateButton => 'नेविगेट करें';

  @override
  String riderPaymentPending(String amount) {
    return 'भुगतान लंबित – $amount';
  }

  @override
  String get riderFullPaymentCompleted => 'पूरा भुगतान हो गया';

  @override
  String get riderRefreshPaymentTooltip => 'भुगतान की स्थिति रिफ्रेश करें';

  @override
  String get riderCustomerPaymentPendingSnack =>
      'ग्राहक का भुगतान अभी भी लंबित है। डिलीवरी पूरी नहीं की जा सकती।';

  @override
  String get riderStartPickupButton => 'पिकअप शुरू करें';

  @override
  String get riderStartDeliveryButton => 'डिलीवरी शुरू करें';

  @override
  String get riderPickUpButton => 'पिक अप करें';

  @override
  String get riderMarkDeliveredButton => 'डिलीवर के रूप में मार्क करें';

  @override
  String get riderCancelPickupButton => 'पिकअप रद्द करें';

  @override
  String get riderConfirmWeightCountTitle => 'वजन और गिनती की पुष्टि करें';

  @override
  String get riderWeighRecountPrompt =>
      'अभी ग्राहक के आइटम को तौलें और गिनें — यह पिकअप की पुष्टि से पहले उनके अनुमान को सही करता है।';

  @override
  String get riderWeightAreaBasedHeader => 'वजन / क्षेत्रफल आधारित';

  @override
  String riderEnterExactUnit(String unit) {
    return 'सटीक $unit दर्ज करें';
  }

  @override
  String get riderPieceBasedHeader => 'पीस आधारित';

  @override
  String riderFailedSaveMeasurements(String error) {
    return 'माप सेव नहीं हो सका: $error';
  }

  @override
  String get riderSaveContinueButton => 'सेव करें और जारी रखें';

  @override
  String riderWeightBasedItemsLabel(String items) {
    return 'वजन-आधारित आइटम ($items)';
  }

  @override
  String riderMaxPhotosPerItem(String max) {
    return 'प्रति आइटम अधिकतम $max फोटो।';
  }

  @override
  String riderFailedSavePhotos(String error) {
    return 'फोटो सेव नहीं हो सकीं: $error';
  }

  @override
  String get riderGarmentConditionPhotosTitle => 'कपड़ों की स्थिति की फोटो';

  @override
  String get riderPhotographEachItemPrompt =>
      'पिकअप से पहले हर आइटम की फोटो लें — इससे डैमेज विवाद होने पर आप और ग्राहक दोनों सुरक्षित रहते हैं।';

  @override
  String riderPhotosCountLabel(String count, String max) {
    return '$count/$max फोटो · 1 आवश्यक, बाकी वैकल्पिक';
  }

  @override
  String get riderSaveButton => 'सेव करें';

  @override
  String get riderCollectBalanceTitle => 'बकाया राशि लें';

  @override
  String get riderBalanceDueLabel => 'बकाया राशि';

  @override
  String get riderPaymentMethodCod => 'भुगतान का तरीका: कैश ऑन डिलीवरी';

  @override
  String get riderPaymentMethodOnline => 'भुगतान का तरीका: ऑनलाइन';

  @override
  String get riderNoBalanceDueBanner =>
      'इस ऑर्डर के लिए कोई बकाया राशि नहीं है।';

  @override
  String get riderCustomerPaysOnlineBanner =>
      'ग्राहक यह बकाया राशि अपने ऐप में ऑनलाइन चुकाता है। आपको कुछ करने की आवश्यकता नहीं है।';

  @override
  String get riderCashCollectionRecordedBanner => 'कैश कलेक्शन दर्ज हो गया।';

  @override
  String riderFailedRecordCashCollection(String error) {
    return 'कैश कलेक्शन दर्ज नहीं हो सका: $error';
  }

  @override
  String riderConfirmCashCollectedButton(String amount) {
    return '$amount कैश कलेक्ट होने की पुष्टि करें';
  }

  @override
  String get riderContinueButton => 'जारी रखें';

  @override
  String get riderDeliveryPhotoTitle => 'डिलीवरी फोटो';

  @override
  String get riderOptionalPhotoPrompt =>
      'वैकल्पिक रूप से हैंडओवर की फोटो लें, डिलीवरी प्रूफ के रूप में। इसे छोड़ा जा सकता है।';

  @override
  String get riderTakePhotoLabel => 'फोटो लें';

  @override
  String riderFailedSavePhoto(String error) {
    return 'फोटो सेव नहीं हो सकी: $error';
  }

  @override
  String get riderSkipContinueButton => 'छोड़ें और जारी रखें';

  @override
  String get notificationsJustNow => 'अभी अभी';

  @override
  String notificationsMinsAgo(int mins) {
    return '$mins मिनट पहले';
  }

  @override
  String notificationsHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours घंटे पहले',
      one: '1 घंटा पहले',
    );
    return '$_temp0';
  }

  @override
  String notificationsDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन पहले',
      one: '1 दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String get notificationsPageTitle => 'सूचनाएं';

  @override
  String get notificationsMarkAllRead => 'सभी पढ़ा हुआ मार्क करें';

  @override
  String notificationsFailedToLoad(String error) {
    return 'सूचनाएं लोड नहीं हो सकीं: $error';
  }

  @override
  String get notificationsEmptyTitle => 'अभी तक कोई सूचना नहीं';

  @override
  String get notificationsEmptySubtitle =>
      'ऑपरेशनल पुश अपडेट, भुगतान अलर्ट और एडमिन प्राइसिंग नोट यहां दिखेंगे।';

  @override
  String get profileUpdatedSnack => 'प्रोफाइल सफलतापूर्वक अपडेट हुई';

  @override
  String get profileCropLogoTitle => 'लोगो क्रॉप करें';

  @override
  String get profileCropBannerTitle => 'बैनर इमेज क्रॉप करें';

  @override
  String get profileLogoUpdatedSnack => 'लोगो अपडेट हुआ';

  @override
  String get profileBannerUpdatedSnack => 'बैनर इमेज अपडेट हुई';

  @override
  String profileFailedUploadImage(String error) {
    return 'इमेज अपलोड नहीं हो सकी: $error';
  }

  @override
  String get profileLogoutTitle => 'लॉगआउट';

  @override
  String get profileLogoutConfirm =>
      'क्या आप वाकई अपने वेंडर अकाउंट से लॉगआउट करना चाहते हैं?';

  @override
  String get profilePublishedSnack =>
      'मार्केटप्लेस पर प्रकाशित हुआ — ग्राहक अब आपको खोज सकते हैं।';

  @override
  String profileFailedToPublish(String error) {
    return 'प्रकाशित करने में विफल: $error';
  }

  @override
  String get profilePageTitle => 'मेरी प्रोफाइल';

  @override
  String get profileBestFitNote =>
      'बेस्ट फिट — लोगो: 500×500px वर्ग। बैनर: 780×1080px पोर्ट्रेट। बिल्कुल वैसा ही जैसा ग्राहक आपकी दुकान को देखते हैं, ताकि कुछ भी खिंचे या गलत तरीके से क्रॉप न हो।';

  @override
  String get profileEditBusinessDetails => 'बिजनेस विवरण संपादित करें';

  @override
  String get profileBusinessNameLabel => 'बिजनेस का नाम';

  @override
  String get profileRequiredField => 'आवश्यक';

  @override
  String get profileBusinessEmailLabel => 'बिजनेस ईमेल';

  @override
  String get profileEmailLabel => 'ईमेल';

  @override
  String get profileBusinessDescriptionLabel => 'बिजनेस विवरण';

  @override
  String get profileAddressLine1Label => 'पता लाइन 1';

  @override
  String get profileCityLabel => 'शहर';

  @override
  String get profileStateLabel => 'राज्य';

  @override
  String get profilePincodeLabel => 'पिनकोड';

  @override
  String get profileVerifiedPhoneLabel => 'सत्यापित फोन (बदला नहीं जा सकता)';

  @override
  String get profileNotSetValue => 'सेट नहीं है';

  @override
  String get profileAddressFieldLabel => 'पता';

  @override
  String get profileAccountSection => 'अकाउंट';

  @override
  String get profileNotificationsSubtitle => 'ऑर्डर अलर्ट और अपडेट देखें';

  @override
  String get profileSettingsSubtitle => 'ऐप प्राथमिकताएं और थीम';

  @override
  String get profileBusinessSection => 'बिजनेस';

  @override
  String get profileCatalogueSubtitle =>
      'कैटेगरी चुनें, सबकैटेगरी सक्रिय करें, अपनी कीमतें सेट करें';

  @override
  String get profilePublishLabel => 'मार्केटप्लेस पर प्रकाशित करें';

  @override
  String get profilePublishSubtitle =>
      'अपनी दुकान को ग्राहकों के लिए खोजने योग्य बनाएं';

  @override
  String get profileStaffLabel => 'स्टाफ प्रबंधन';

  @override
  String get profileStaffSubtitle => 'कर्मचारी जोड़ें और प्रबंधित करें';

  @override
  String get profileRiderSubtitle =>
      'अपने डिलीवरी कैप्टन जोड़ें और प्रबंधित करें';

  @override
  String get profileSlotsLabel => 'पिकअप स्लॉट्स';

  @override
  String get profileSlotsSubtitle => 'उपलब्धता और क्षमता प्रबंधित करें';

  @override
  String get profileInventoryLabel => 'इन्वेंटरी और सप्लाई';

  @override
  String get profileInventorySubtitle => 'लॉन्ड्री सप्लाई और स्टॉक ट्रैक करें';

  @override
  String get profileSupportSection => 'सहायता';

  @override
  String get profileHelpLabel => 'सहायता और समर्थन';

  @override
  String get profileHelpSubtitle => 'हमारी पार्टनर टीम से सहायता प्राप्त करें';

  @override
  String get profileAboutLabel => 'LNDRY के बारे में';

  @override
  String profileAboutSubtitle(String version) {
    return 'वर्शन $version • © 2026 LNDRY Technologies';
  }

  @override
  String get onboardingStepBusinessDetails => 'बिजनेस विवरण';

  @override
  String get onboardingStepOwnerBank => 'मालिक और बैंक विवरण';

  @override
  String get onboardingStepLocation => 'दुकान का स्थान';

  @override
  String get onboardingStepRadius => 'रेडियस और क्षमता';

  @override
  String get onboardingStepDocuments => 'दस्तावेज़';

  @override
  String get onboardingStepReview => 'समीक्षा और सबमिट';

  @override
  String get onboardingLoadError =>
      'आपका आवेदन लोड नहीं हो सका। कृपया फिर से कोशिश करें।';

  @override
  String get onboardingUploadAllDocuments =>
      'सबमिट करने से पहले कृपया सभी आवश्यक दस्तावेज़ अपलोड करें।';

  @override
  String get onboardingUploadDocumentsToContinue =>
      'आगे बढ़ने के लिए कृपया सभी आवश्यक दस्तावेज़ अपलोड करें।';

  @override
  String get onboardingVendorApplicationTitle => 'वेंडर आवेदन';

  @override
  String get onboardingApplicationSubmittedTitle => 'आवेदन सबमिट हो गया';

  @override
  String get onboardingApplicationSubmittedBody =>
      'आपका आवेदन हमारी टीम की समीक्षा में है। स्वीकृत होने पर हम आपको सूचित करेंगे।';

  @override
  String get onboardingLogOutButton => 'लॉग आउट';

  @override
  String onboardingStepOfTotal(int current, int total, String title) {
    return 'स्टेप $current / $total: $title';
  }

  @override
  String get onboardingCorrectionNeeded => 'सुधार आवश्यक';

  @override
  String get onboardingCorrectionOnlyFlaggedEditable =>
      'केवल ऊपर दिए गए सेक्शन संपादित किए जा सकते हैं — बाकी सब वैसा ही लॉक है जैसा आपने मूल रूप से सबमिट किया था।';

  @override
  String get onboardingBusinessNameLabel => 'बिजनेस का नाम';

  @override
  String get onboardingBusinessNameHint => 'जैसे: Sparkle Laundry Co.';

  @override
  String get onboardingBusinessNameRequired => 'बिजनेस का नाम आवश्यक है';

  @override
  String get onboardingDescriptionHint =>
      'ग्राहकों को बताएं आपकी दुकान किस चीज़ में विशेषज्ञ है';

  @override
  String get onboardingGstLabel => 'GST नंबर (वैकल्पिक)';

  @override
  String get onboardingPanLabel => 'PAN नंबर (वैकल्पिक)';

  @override
  String get onboardingOwnerNameLabel => 'मालिक का नाम';

  @override
  String get onboardingOwnerNameHint => 'दुकान के मालिक का पूरा नाम';

  @override
  String get onboardingOwnerNameRequired => 'मालिक का नाम आवश्यक है';

  @override
  String get onboardingEmailOptionalLabel => 'ईमेल (वैकल्पिक)';

  @override
  String get onboardingBankDetailsOptionalHeader => 'बैंक विवरण (वैकल्पिक)';

  @override
  String get onboardingBankAccountLabel => 'बैंक खाता संख्या';

  @override
  String get onboardingIfscLabel => 'IFSC कोड';

  @override
  String get onboardingBankNameLabel => 'बैंक का नाम';

  @override
  String get onboardingAccountHolderLabel => 'खाताधारक का नाम';

  @override
  String get onboardingDetectingLocation => 'पता लगाया जा रहा है…';

  @override
  String get onboardingUseCurrentLocation => 'वर्तमान स्थान का उपयोग करें';

  @override
  String get onboardingAddressLine1Hint => 'दुकान / इमारत का नाम';

  @override
  String get onboardingAddressRequired => 'पता आवश्यक है';

  @override
  String get onboardingAddressLine2Label => 'पता लाइन 2 (वैकल्पिक)';

  @override
  String get onboardingPincodeRequired => 'पिनकोड आवश्यक है';

  @override
  String get onboardingPincodeInvalid => 'एक मान्य 6-अंकीय पिनकोड दर्ज करें';

  @override
  String onboardingDetectedCoords(String lat, String lng) {
    return 'पता चला: $lat, $lng';
  }

  @override
  String get onboardingRadiusQuestion =>
      'हमें आपकी दुकान के आसपास कितनी दूर तक ग्राहक ढूंढने चाहिए?';

  @override
  String onboardingKmValue(String km) {
    return '$km किमी';
  }

  @override
  String get onboardingCapacityQuestion =>
      'आप प्रतिदिन कितने ऑर्डर संभाल सकते हैं?';

  @override
  String get onboardingCustomLabel => 'कस्टम';

  @override
  String get onboardingUploadDocumentsPrompt =>
      'अपना आवेदन पूरा करने के लिए निम्नलिखित अपलोड करें।';

  @override
  String get onboardingOwnerIdentityTitle => 'मालिक की पहचान';

  @override
  String get onboardingShopPhotoTitle => 'दुकान की फोटो';

  @override
  String get onboardingServiceListTitle => 'सेवा सूची (PDF)';

  @override
  String get onboardingReplaceButton => 'बदलें';

  @override
  String get onboardingUploadButton => 'अपलोड करें';

  @override
  String get onboardingUploadedLabel => 'अपलोड हो गया';

  @override
  String get onboardingReviewPrompt => 'सबमिट करने से पहले अपना विवरण जांचें।';

  @override
  String get onboardingReviewOwner => 'मालिक';

  @override
  String get onboardingReviewServiceRadius => 'सेवा रेडियस';

  @override
  String get onboardingReviewDailyCapacity => 'दैनिक क्षमता';

  @override
  String onboardingOrdersPerDay(int count) {
    return '$count ऑर्डर/दिन';
  }

  @override
  String get onboardingReviewOwnerIdentity => 'मालिक की पहचान';

  @override
  String get onboardingReviewShopPhoto => 'दुकान की फोटो';

  @override
  String get onboardingReviewServiceList => 'सेवा सूची';

  @override
  String get onboardingMissingLabel => 'गुम';

  @override
  String get onboardingBackButton => 'वापस';

  @override
  String get onboardingSubmitApplicationButton => 'आवेदन सबमिट करें';

  @override
  String get onboardingNextButton => 'अगला';

  @override
  String get helpFaq1Q => 'मैं ऑर्डर कैसे स्वीकार करूं?';

  @override
  String get helpFaq1A =>
      'जब कोई नया ऑर्डर आता है, तो यह आपके डैशबोर्ड पर \"नए आने वाले ऑर्डर\" के तहत दिखता है। इसे पुष्ट करने के लिए \"स्वीकार करें\" पर टैप करें, या यदि आप पूरा नहीं कर सकते तो \"अस्वीकार करें\" पर टैप करें। स्वीकृत ऑर्डर ऑर्डर्स के Active टैब में चले जाते हैं।';

  @override
  String get helpFaq2Q => 'भुगतान कैसे काम करता है?';

  @override
  String get helpFaq2A =>
      'LNDRY हर 7 दिन में वेंडर भुगतान प्रोसेस करता है। प्लेटफॉर्म फीस (₹15 प्रति ऑर्डर) और GST काटने के बाद, बाकी राशि NEFT/IMPS के ज़रिए आपके रजिस्टर्ड बैंक खाते में ट्रांसफर हो जाती है।';

  @override
  String get helpFaq3Q => 'मैं अपने वर्किंग ऑवर्स कैसे बदलूं?';

  @override
  String get helpFaq3A =>
      'प्रोफाइल → पिकअप स्लॉट्स पर जाएं (या डैशबोर्ड पर Quick Actions → Slots)। यहां आप हफ्ते के हर दिन के लिए टाइम स्लॉट जोड़ सकते हैं, संपादित कर सकते हैं, या हटा सकते हैं। आप अलग-अलग स्लॉट चालू/बंद भी कर सकते हैं।';

  @override
  String get helpFaq4Q => 'मैं ग्राहक से संपर्क कैसे करूं?';

  @override
  String get helpFaq4A =>
      'उस ऑर्डर की Order Details पेज खोलें। आपको ग्राहक का नाम और एक \"Call Customer\" बटन दिखेगा जो सीधे उन्हें कॉल करता है। ध्यान दें: ऑर्डर स्वीकार होने तक ग्राहक का पूरा फोन नंबर गोपनीयता के लिए छिपा रहता है।';

  @override
  String get helpFaq5Q => '\"Pending\" स्टेटस का क्या मतलब है?';

  @override
  String get helpFaq5A =>
      'Pending ऑर्डर वे नए ऑर्डर हैं जो ग्राहकों ने दिए हैं और आपकी स्वीकृति का इंतज़ार कर रहे हैं। इन्हें स्वीकार या अस्वीकार करने के लिए आपके पास एक समय सीमा होती है। समय सीमा खत्म होने के बाद, वे अपने आप अस्वीकृत हो जाते हैं।';

  @override
  String get helpFaq6Q => 'मैं कपड़ों की कीमतें कैसे अपडेट करूं?';

  @override
  String get helpFaq6A =>
      'प्रोफाइल → गारमेंट प्राइसिंग पर जाएं या कैटलॉग टैब का उपयोग करें। एक सेवा चुनें, फिर अलग-अलग गारमेंट रेट जोड़ें/संपादित करें/हटाएं। बदलाव नए ऑर्डर के लिए तुरंत लागू होते हैं।';

  @override
  String get helpFaq7Q => 'क्या मैं कई कर्मचारियों को प्रबंधित कर सकता हूं?';

  @override
  String get helpFaq7A =>
      'हां। प्रोफाइल → स्टाफ प्रबंधन पर जाएं। आप कर्मचारी जोड़ सकते हैं, भूमिकाएं (मैनेजर, वॉशर, आयरनर, पैकर) असाइन कर सकते हैं, परमिशन सेट कर सकते हैं, उनकी सक्रिय स्थिति टॉगल कर सकते हैं, और उनके पासवर्ड रीसेट कर सकते हैं।';

  @override
  String get helpFaq8Q => 'प्लेटफॉर्म फीस क्या है?';

  @override
  String get helpFaq8A =>
      'LNDRY आपको ग्राहकों से जोड़ने, भुगतान प्रोसेसिंग और ऑपरेशनल सहायता के लिए प्रति ऑर्डर ₹15 का प्लेटफॉर्म फीस लेता है। GST 18% केवल प्लेटफॉर्म फीस पर लागू होता है।';

  @override
  String get helpTicketCreatedSnack =>
      'सपोर्ट टिकट बन गया! हम 24 घंटे के भीतर जवाब देंगे।';

  @override
  String helpFailedCreateTicket(String error) {
    return 'टिकट बनाने में विफल: $error';
  }

  @override
  String get helpCreateSupportTicketTitle => 'सपोर्ट टिकट बनाएं';

  @override
  String get helpCategoryOrderIssue => 'ऑर्डर समस्या';

  @override
  String get helpCategoryPayout => 'भुगतान';

  @override
  String get helpCategoryTechnical => 'तकनीकी';

  @override
  String get helpCategoryAccount => 'अकाउंट';

  @override
  String get helpCategoryOther => 'अन्य';

  @override
  String get helpSubjectLabel => 'विषय';

  @override
  String get helpSubjectHint => 'अपनी समस्या का संक्षिप्त विवरण';

  @override
  String get helpDescriptionHint =>
      'अपनी समस्या के बारे में अधिक जानकारी दें...';

  @override
  String get helpDescriptionTooShort => 'कृपया अधिक जानकारी दें';

  @override
  String get helpSubmitTicketButton => 'टिकट सबमिट करें';

  @override
  String get helpTabContact => 'संपर्क';

  @override
  String get helpTabFaq => 'FAQ';

  @override
  String get helpTabTickets => 'टिकट';

  @override
  String get helpPartnerSupportTitle => 'LNDRY पार्टनर सपोर्ट';

  @override
  String get helpPartnerSupportSubtitle =>
      'हम मदद के लिए यहां हैं! नीचे दिए गए किसी भी माध्यम से हमसे संपर्क करें।\nसोम–शनि, सुबह 9 – शाम 7 बजे तक उपलब्ध।';

  @override
  String get helpReachUsHeader => 'हमसे संपर्क करें';

  @override
  String get helpCallSupportTitle => 'कॉल सपोर्ट';

  @override
  String get helpCallSupportSubtitle => '+91 1800-123-5678 (टोल फ्री)';

  @override
  String get helpCallNowAction => 'अभी कॉल करें';

  @override
  String get helpCallingSnack => 'LNDRY सपोर्ट को कॉल किया जा रहा है...';

  @override
  String get helpEmailSupportTitle => 'ईमेल सपोर्ट';

  @override
  String get helpSendEmailAction => 'ईमेल भेजें';

  @override
  String get helpOpeningEmailSnack => 'ईमेल क्लाइंट खोला जा रहा है...';

  @override
  String get helpWhatsappSupportTitle => 'WhatsApp सपोर्ट';

  @override
  String get helpOpenWhatsappAction => 'WhatsApp खोलें';

  @override
  String get helpOpeningWhatsappSnack => 'WhatsApp खोला जा रहा है...';

  @override
  String get helpCreateTicketSubtitle =>
      'टिकट ID के साथ अपनी समस्या को ट्रैक करें';

  @override
  String get helpCreateTicketAction => 'टिकट बनाएं';

  @override
  String get helpResponseTimesHeader => 'जवाब देने का समय';

  @override
  String get helpPhoneWhatsappLabel => 'फोन / WhatsApp';

  @override
  String get helpImmediateValue => 'तुरंत';

  @override
  String get helpLessThan4Hours => '< 4 घंटे';

  @override
  String get helpSupportTicketLabel => 'सपोर्ट टिकट';

  @override
  String get helpLessThan24Hours => '< 24 घंटे';

  @override
  String get helpCantFindAnswer => 'अपना जवाब नहीं मिला? सपोर्ट टिकट बनाएं।';

  @override
  String get helpCreateAction => 'बनाएं';

  @override
  String get helpFailedToLoadTickets => 'टिकट लोड नहीं हो सके';

  @override
  String get helpNoTicketsYet => 'अभी तक कोई टिकट नहीं';

  @override
  String get helpNoTicketsSubtitle =>
      'टिकट बनाएं और हम 24 घंटे के भीतर जवाब देंगे।';

  @override
  String get helpCreateNewTicketButton => 'नया टिकट बनाएं';

  @override
  String get helpYourTicketsHeader => 'आपके टिकट';

  @override
  String get helpStatusReplied => 'जवाब मिला';

  @override
  String get helpStatusOpen => 'खुला';

  @override
  String get helpStatusClosed => 'बंद';

  @override
  String get ticketYouLabel => 'आप';

  @override
  String get ticketSupportTeamLabel => 'सपोर्ट टीम';

  @override
  String get ticketWaitingForReplyBanner =>
      'हमारी सपोर्ट टीम के जवाब का इंतज़ार है। हम आमतौर पर 24 घंटे के भीतर जवाब देते हैं।';

  @override
  String get ticketAreYouSatisfied => 'क्या आप इस जवाब से संतुष्ट हैं?';

  @override
  String get ticketYesButton => 'हां';

  @override
  String get ticketNoButton => 'नहीं';

  @override
  String get ticketRateExperience => 'अपने सपोर्ट अनुभव को रेट करें';

  @override
  String get ticketSubmitRatingButton => 'रेटिंग सबमिट करें';

  @override
  String get ticketWhatWouldYouAsk => 'आप क्या पूछना चाहेंगे?';

  @override
  String get ticketTypeMessageHint => 'अपना संदेश टाइप करें...';

  @override
  String get ticketSendButton => 'भेजें';

  @override
  String get ticketThanksForFeedback => 'आपकी प्रतिक्रिया के लिए धन्यवाद!';

  @override
  String ticketFailedSubmitRating(String error) {
    return 'रेटिंग सबमिट करने में विफल: $error';
  }

  @override
  String get ticketMessageSentSnack =>
      'आपका संदेश हमारी सपोर्ट टीम को भेज दिया गया।';

  @override
  String ticketFailedToSend(String error) {
    return 'भेजने में विफल: $error';
  }

  @override
  String get ticketYourRatingHeader => 'आपकी रेटिंग';

  @override
  String get ticketClosedByTeamBanner =>
      'यह टिकट हमारी सपोर्ट टीम द्वारा बंद कर दिया गया है।';

  @override
  String get employeesAddStaffButton => 'स्टाफ जोड़ें';

  @override
  String get employeesPhoneRequiredLabel => 'फ़ोन नंबर';

  @override
  String get employeesPhoneRequiredError =>
      'सही 10 अंकों का फ़ोन नंबर डालें — स्टाफ इसी से लॉगिन करेगा';

  @override
  String get employeesPermissionsRequired => 'कम से कम एक अनुमति चुनें';

  @override
  String get employeesPermissionsLoadFailed => 'अनुमति सूची लोड नहीं हो सकी';

  @override
  String get employeesPermissionsHint =>
      'केवल वही सेक्शन खुलेंगे जिन्हें आप चालू करेंगे।';

  @override
  String get employeesStaffOnlyNote =>
      'स्टाफ मुख्य पार्टनर ऐप में लॉगिन करता है। कैप्टन को कैप्टन मैनेजमेंट में जोड़ें।';

  @override
  String get permModuleOrders => 'ऑर्डर';

  @override
  String get permOrdersView => 'ऑर्डर देखें';

  @override
  String get permOrdersAcceptReject => 'नए ऑर्डर स्वीकार / अस्वीकार करें';

  @override
  String get permOrdersProcess => 'प्रोसेसिंग और स्टेटस अपडेट';

  @override
  String get permOrdersReevaluate => 'री-इवैल्यूएशन';

  @override
  String get permOrdersAssignCaptain => 'कैप्टन को असाइन / ब्रॉडकास्ट करें';

  @override
  String get permModuleCatalogue => 'कैटलॉग और कीमत';

  @override
  String get permCatalogueView => 'सर्विस और कीमत देखें';

  @override
  String get permCatalogueManage => 'सर्विस और कीमत मैनेज करें';

  @override
  String get permModuleInventory => 'इन्वेंटरी';

  @override
  String get permInventoryView => 'इन्वेंटरी देखें';

  @override
  String get permInventoryManage => 'इन्वेंटरी मैनेज करें';

  @override
  String get permModuleSlots => 'पिकअप स्लॉट';

  @override
  String get permSlotsView => 'पिकअप स्लॉट देखें';

  @override
  String get permSlotsManage => 'पिकअप स्लॉट और क्षमता मैनेज करें';

  @override
  String get permModuleAnalytics => 'एनालिटिक्स';

  @override
  String get permAnalyticsView => 'एनालिटिक्स देखें';

  @override
  String get errorGeneric => 'कुछ गड़बड़ हो गई। कृपया फिर से कोशिश करें।';

  @override
  String get errorNetwork =>
      'सर्वर तक नहीं पहुँच सके। अपना इंटरनेट जाँचें और फिर कोशिश करें।';

  @override
  String get errorTimeout =>
      'अनुरोध में बहुत समय लगा। कृपया फिर से कोशिश करें।';

  @override
  String get errorServerBusy =>
      'सर्वर अभी व्यस्त है। कृपया थोड़ी देर में फिर कोशिश करें।';

  @override
  String get inventoryLoadFailed => 'आपकी सप्लाई लोड नहीं हो सकी।';

  @override
  String get inventoryEmptyTitle => 'अभी कोई सप्लाई नहीं';

  @override
  String get inventoryEmptySubtitle =>
      'पहला सप्लाई आइटम जोड़ने के लिए + दबाएँ।';

  @override
  String get notifOffBannerMessage =>
      'सूचनाएँ बंद हैं, इसलिए आप नए ऑर्डर और जॉब ऑफ़र मिस कर सकते हैं।';

  @override
  String get notifOffBannerAction => 'चालू करें';

  @override
  String get ordersAssistedBadge => 'असिस्टेड बुकिंग';

  @override
  String get ordersAssistedSummary => 'सेवा चुनना ज़रूरी है';

  @override
  String get ordersAssistedPriceTbd => 'मूल्यांकन बाकी है';

  @override
  String get orderDetailsAssistedTitle => 'असिस्टेड बुकिंग / सेवा चुनना ज़रूरी';

  @override
  String get orderDetailsAssistedBody =>
      'ग्राहक ने \"Book With Expert Check\" चुना है, इसलिए कोई सेवा या कीमत नहीं चुनी गई। कपड़े आप तक पहुँचने पर उन्हें जाँचें और \"सेवाएँ चुनें\" से सही सेवाएँ, मात्रा या वज़न चुनें। प्रोसेसिंग शुरू होने से पहले ग्राहक कीमत को मंज़ूरी देगा।';

  @override
  String get orderDetailsAssistedChooseServices => 'सेवाएँ चुनें';

  @override
  String get orderDetailsAssistedNoServicesYet =>
      'अभी कोई सेवा नहीं चुनी गई। कपड़े जाँचें और सेवाएँ चुनें।';

  @override
  String get orderDetailsAssistedSheetTitle => 'सेवाएँ चुनें';

  @override
  String get orderDetailsAssistedSheetSubtitle =>
      'हर तरह के कपड़े के लिए मात्रा या वज़न के साथ एक सेवा जोड़ें। प्रोसेसिंग जारी रहने से पहले यह ग्राहक की स्वीकृति के लिए भेजा जाएगा। फ़ोटो वैकल्पिक हैं।';

  @override
  String get orderDetailsAssistedAddServiceRequired =>
      'स्वीकृति के लिए भेजने से पहले कम से कम एक सेवा जोड़ें।';

  @override
  String get loginSessionEnded =>
      'आपका सत्र समाप्त हो गया है। जारी रखने के लिए कृपया दोबारा लॉग इन करें।';

  @override
  String get posModeMarketplace => 'मार्केटप्लेस';

  @override
  String get posModePos => 'POS (काउंटर)';

  @override
  String get posAppModeTitle => 'ऐप मोड';

  @override
  String get posAppModeSubtitle =>
      'अभी आप क्या इस्तेमाल करना चाहते हैं, चुनें।';

  @override
  String posAppModeSwitched(String mode) {
    return '$mode पर बदल गया';
  }

  @override
  String get posAppModeNotAllowed => 'यह मोड आपकी दुकान के लिए उपलब्ध नहीं है।';

  @override
  String get posGetPosTitle => 'मेरी दुकान के लिए POS लें';

  @override
  String get posGetPosSubtitle =>
      'दुकान पर आने वाले ग्राहकों के बिल बनाएं और रिकॉर्ड रखें।';

  @override
  String get posFinishSetupTitle => 'POS सेटअप पूरा करें';

  @override
  String get posFinishSetupSubtitle =>
      'POS इस्तेमाल करने के लिए बस कुछ कदम बाकी हैं।';

  @override
  String get posChoiceTitle => 'आपको क्या चाहिए?';

  @override
  String get posChoiceSubtitle =>
      'शुरू करने के लिए एक चुनें। दूसरा बाद में जोड़ सकते हैं।';

  @override
  String get posChoiceMarketplaceTitle => 'ग्राहक पाएं';

  @override
  String get posChoiceMarketplaceBody =>
      'LNDRY ग्राहक ऐप से ऑर्डर पाएं। दुकान की जानकारी और दस्तावेज़ चाहिए।';

  @override
  String get posChoicePosTitle => 'मेरी दुकान चलाएं (POS)';

  @override
  String get posChoicePosBody =>
      'काउंटर पर बिल बनाएं, ग्राहकों का रिकॉर्ड रखें और पैसों का हिसाब देखें। लगभग 3 मिनट में तैयार।';

  @override
  String get posChoiceBothHint =>
      'दोनों चाहिए? पहले मार्केटप्लेस चुनें, फिर सेटिंग्स में POS चालू करें।';

  @override
  String get posModeCheckLoading => 'आपकी दुकान तैयार हो रही है…';

  @override
  String get posOnbTitle => 'POS सेटअप';

  @override
  String posOnbStepOf(int current, int total) {
    return 'चरण $current / $total';
  }

  @override
  String get posOnbStepShop => 'दुकान की जानकारी';

  @override
  String get posOnbStepTax => 'टैक्स और भुगतान';

  @override
  String get posOnbStepCounter => 'काउंटर सेटअप';

  @override
  String get posOnbStepPrices => 'रेट लिस्ट';

  @override
  String get posOnbShopName => 'दुकान का नाम';

  @override
  String get posOnbOwnerName => 'मालिक का नाम';

  @override
  String get posOnbAddress => 'दुकान का पता';

  @override
  String get posOnbCity => 'शहर';

  @override
  String get posOnbState => 'राज्य (वैकल्पिक)';

  @override
  String get posOnbPincode => 'पिनकोड (वैकल्पिक)';

  @override
  String get posOnbGstSwitch => 'मेरी दुकान GST में रजिस्टर्ड है';

  @override
  String get posOnbGstin => 'GSTIN (15 अक्षर)';

  @override
  String get posOnbUpi => 'UPI ID (वैकल्पिक)';

  @override
  String get posOnbUpiHint => 'जैसे name@bank';

  @override
  String get posOnbInvoicePrefix => 'इनवॉइस की शुरुआत';

  @override
  String get posOnbPrinter => 'प्रिंटर';

  @override
  String get posPrinterNone => 'कोई प्रिंटर नहीं';

  @override
  String get posPrinterSystem => 'फोन / सिस्टम प्रिंटर';

  @override
  String get posPrinter58 => 'थर्मल 58 mm';

  @override
  String get posPrinter80 => 'थर्मल 80 mm';

  @override
  String get posOnbOrderPrefix => 'ऑर्डर नंबर की शुरुआत';

  @override
  String get posOnbDeliveryDays => 'सामान्य डिलीवरी समय (दिन)';

  @override
  String get posOnbPricesTitle => 'अपनी रेट लिस्ट शुरू करें';

  @override
  String get posOnbPricesStarter => 'सैंपल रेट लिस्ट इस्तेमाल करें';

  @override
  String get posOnbPricesStarterBody =>
      'हम आम कपड़े और सेवाएं सैंपल रेट के साथ जोड़ देंगे। कृपया रेट देखकर बदल लें।';

  @override
  String get posOnbPricesOwn => 'मैं खुद जोड़ूंगा';

  @override
  String get posOnbPricesOwnBody =>
      'खाली शुरू करें और अपने कपड़े व रेट खुद जोड़ें।';

  @override
  String get posNext => 'आगे';

  @override
  String get posBack => 'पीछे';

  @override
  String get posFinish => 'सेटअप पूरा करें';

  @override
  String get posSaving => 'सेव हो रहा है…';

  @override
  String get posErrShopName => 'अपनी दुकान का नाम लिखें';

  @override
  String get posErrOwnerName => 'मालिक का नाम लिखें';

  @override
  String get posErrAddress => 'अपनी दुकान का पता लिखें';

  @override
  String get posErrCity => 'अपना शहर लिखें';

  @override
  String get posErrPincode => 'पिनकोड 6 अंकों का होना चाहिए';

  @override
  String get posErrGstin => 'सही 15 अक्षर का GSTIN लिखें';

  @override
  String get posErrUpi => 'UPI ID ऐसा होना चाहिए: name@bank';

  @override
  String get posErrPrefix => '1 से 6 अक्षर या अंक लिखें';

  @override
  String get posErrDays => '0 से 30 के बीच की संख्या लिखें';

  @override
  String get posDoneTitle => 'आपकी दुकान तैयार है!';

  @override
  String get posDoneBody => 'होम स्क्रीन से अपना पहला ऑर्डर बुक करें।';

  @override
  String posDoneStarterNote(int count) {
    return '$count सैंपल कपड़े जोड़े गए हैं। कृपया उनके रेट देख लें।';
  }

  @override
  String get posDoneButton => 'POS खोलें';

  @override
  String get posOnbOwnerOnlyTitle => 'दुकान के मालिक से कहें';

  @override
  String get posOnbOwnerOnlyBody =>
      'POS सेटअप दुकान के मालिक को पूरा करना होगा।';

  @override
  String get posLogOut => 'लॉग आउट';

  @override
  String get posTabHome => 'होम';

  @override
  String get posTabOrder => 'ऑर्डर';

  @override
  String get posTabSearch => 'खोजें';

  @override
  String get posTabExpense => 'खर्च';

  @override
  String get posTabReport => 'रिपोर्ट';

  @override
  String get posTabSetting => 'सेटिंग';

  @override
  String get posComingSoonTitle => 'जल्द आ रहा है';

  @override
  String get posComingSoonBody => 'POS का यह हिस्सा तैयार हो रहा है।';

  @override
  String posHomeWelcome(String shop) {
    return 'स्वागत है, $shop';
  }

  @override
  String get posHomeReady =>
      'आपका POS तैयार है। ऑर्डर बुकिंग, ग्राहक और रेट अगले अपडेट में आएंगे।';

  @override
  String get posSettingsTitle => 'सेटिंग';

  @override
  String get posSettingsShop => 'दुकान';

  @override
  String get posHomeToday => 'आज';

  @override
  String get posTileRevenue => 'आज की कमाई';

  @override
  String get posTileCollection => 'वसूली';

  @override
  String get posTileOrderRequests => 'ऑर्डर रिक्वेस्ट';

  @override
  String get posTileWashingToStore => 'धुलाई से स्टोर';

  @override
  String get posTileBooking => 'बुकिंग';

  @override
  String get posTileDelivery => 'डिलीवरी';

  @override
  String get posTileDelivered => 'डिलीवर हुए';

  @override
  String get posTilePending => 'बाकी ऑर्डर';

  @override
  String get posQuickActions => 'जल्दी करें';

  @override
  String get posActionBook => 'ऑर्डर बुक करें';

  @override
  String get posActionAddCustomer => 'ग्राहक जोड़ें';

  @override
  String get posActionAddPrice => 'कपड़े का रेट जोड़ें';

  @override
  String get posTasksTitle => 'करने के काम';

  @override
  String get posTaskUnassignedPickups => 'पिकअप के लिए कैप्टन चुनें';

  @override
  String get posTaskUpcomingDeliveries => 'डिलीवरी का समय आ गया';

  @override
  String get posTaskUnassignedDeliveries => 'डिलीवरी के लिए कैप्टन चुनें';

  @override
  String get posTaskExpress => 'एक्सप्रेस ऑर्डर';

  @override
  String get posTaskOrderRequests => 'ऑर्डर रिक्वेस्ट';

  @override
  String get posTaskCollectionDue => 'वसूलने वाली रकम';

  @override
  String get posPlanTitle => 'आपका प्लान';

  @override
  String posPlanValidTo(String date) {
    return '$date तक मान्य';
  }

  @override
  String get posHomeLoadError => 'आज के आंकड़े नहीं आ सके।';

  @override
  String get posRetry => 'फिर कोशिश करें';

  @override
  String get posHomeEmpty =>
      'अभी कोई ऑर्डर नहीं। शुरू करने के लिए ऑर्डर बुक करें दबाएं।';

  @override
  String get posCancel => 'रद्द करें';

  @override
  String get posCustomerPick => 'ग्राहक चुनें';

  @override
  String get posCustomerSearchHint => 'नाम या फ़ोन से खोजें';

  @override
  String get posCustomerRecent => 'हाल के ग्राहक';

  @override
  String get posCustomerNone => 'कोई ग्राहक नहीं मिला।';

  @override
  String get posCustomerAddNew => 'नया ग्राहक जोड़ें';

  @override
  String posCustomerAddWithPhone(String phone) {
    return '$phone को नया ग्राहक जोड़ें';
  }

  @override
  String get posCustomerLoadError => 'ग्राहक नहीं आ सके।';

  @override
  String posCustomerOrderCount(int count) {
    return '$count ऑर्डर';
  }

  @override
  String get posAddCustomerTitle => 'ग्राहक जोड़ें';

  @override
  String get posCustomerName => 'ग्राहक का नाम';

  @override
  String get posCustomerPhone => 'मोबाइल नंबर (10 अंक)';

  @override
  String get posErrCustomerName => 'ग्राहक का नाम लिखें';

  @override
  String get posErrCustomerPhone => '10 अंकों का मोबाइल नंबर लिखें';

  @override
  String posCustomerAdded(String name) {
    return '$name जुड़ गए';
  }

  @override
  String get posBookTitle => 'ऑर्डर बुक करें';

  @override
  String get posBookCustomer => 'ग्राहक';

  @override
  String get posBookDeliveryDate => 'डिलीवरी की तारीख';

  @override
  String get posBookHomeDelivery => 'घर पर डिलीवरी';

  @override
  String get posBookPickup => 'पिकअप';

  @override
  String get posBookExpress => 'एक्सप्रेस';

  @override
  String get posBookService => 'सर्विस';

  @override
  String get posBookCategory => 'श्रेणी';

  @override
  String get posBookAll => 'सभी';

  @override
  String get posBookSearchGarment => 'कपड़ा खोजें';

  @override
  String get posBookNoServices =>
      'आपकी रेट लिस्ट में अभी कोई सर्विस नहीं है। पहले कपड़े का रेट जोड़ें।';

  @override
  String get posBookNoGarments => 'इस सर्विस के लिए रेट वाला कोई कपड़ा नहीं।';

  @override
  String posBookNoMatch(String query) {
    return '\"$query\" से कोई कपड़ा नहीं मिला।';
  }

  @override
  String get posBookCatalogueError => 'आपकी रेट लिस्ट नहीं आ सकी।';

  @override
  String get posBookSelected => 'चुने हुए कपड़े';

  @override
  String get posBookCartEmpty => 'जोड़ने के लिए ऊपर कपड़े पर दबाएं।';

  @override
  String posBookAddOne(String name) {
    return 'एक $name और जोड़ें';
  }

  @override
  String posBookRemoveOne(String name) {
    return 'एक $name कम करें';
  }

  @override
  String posBookRemoveLine(String name) {
    return '$name हटाएं';
  }

  @override
  String get posBookChangePrice => 'रेट बदलें';

  @override
  String get posBookItems => 'कुल पीस';

  @override
  String get posBookCharge => 'चार्ज';

  @override
  String get posBookDiscount => 'छूट';

  @override
  String get posBookTax => 'टैक्स';

  @override
  String posBookTaxPercent(String percent) {
    return 'टैक्स ($percent%)';
  }

  @override
  String get posBookGrandTotal => 'कुल रकम';

  @override
  String get posBookCalculating => 'हिसाब लगा रहे हैं…';

  @override
  String get posBookQuoteError => 'रकम नहीं मिल सकी।';

  @override
  String get posBookExtras => 'चार्ज, छूट और GST';

  @override
  String get posBookChargesLabel => 'चार्ज';

  @override
  String get posBookDiscountsLabel => 'छूट';

  @override
  String get posBookGstLabel => 'GST';

  @override
  String get posBookNoGst => 'GST नहीं';

  @override
  String get posBookPayment => 'भुगतान';

  @override
  String get posPayCash => 'नकद';

  @override
  String get posPayOnline => 'ऑनलाइन';

  @override
  String get posPayLater => 'बाद में';

  @override
  String get posPayNowNote => 'पूरी रकम अभी मिल रही है।';

  @override
  String get posPayLaterNote => 'अभी भुगतान नहीं। बाद में लें।';

  @override
  String get posBookRemarks => 'टिप्पणी (वैकल्पिक)';

  @override
  String get posBookSave => 'ऑर्डर सेव करें';

  @override
  String get posBookSaving => 'सेव हो रहा है…';

  @override
  String get posBookNeedCustomer => 'सेव करने के लिए ग्राहक चुनें।';

  @override
  String get posBookNeedGarment => 'कम से कम एक कपड़ा जोड़ें।';

  @override
  String get posBookWaitPrice => 'रकम का इंतज़ार…';

  @override
  String get posBookSavedTitle => 'ऑर्डर सेव हो गया';

  @override
  String posBookSavedBody(String number, String name) {
    return '$name का ऑर्डर $number';
  }

  @override
  String get posBookSavedTotal => 'कुल';

  @override
  String get posBookSavedPaid => 'मिले';

  @override
  String get posBookSavedBalance => 'लेना बाकी';

  @override
  String get posBookViewOrder => 'ऑर्डर देखें';

  @override
  String get posBookAnother => 'एक और बुक करें';

  @override
  String get posBookClear => 'साफ़ करें';

  @override
  String get posBookClearTitle => 'यह ऑर्डर साफ़ करें?';

  @override
  String get posBookClearBody => 'ग्राहक और कपड़े हट जाएंगे।';

  @override
  String get posBookDraftRestored =>
      'आपका पिछला बिना सेव किया ऑर्डर वापस आ गया।';

  @override
  String posBookDropped(int count) {
    return '$count कपड़े हटा दिए गए क्योंकि उनका रेट अब आपकी लिस्ट में नहीं है।';
  }

  @override
  String get posAddPriceTitle => 'कपड़े का रेट जोड़ें';

  @override
  String get posEditPriceTitle => 'रेट बदलें';

  @override
  String get posPriceGarment => 'कपड़ा';

  @override
  String get posPriceCategory => 'श्रेणी';

  @override
  String get posPriceService => 'सर्विस';

  @override
  String get posPriceUnit => 'इकाई';

  @override
  String get posPriceRate => 'रेट (₹)';

  @override
  String get posPriceAdd => 'जोड़ें';

  @override
  String get posPriceSave => 'रेट सेव करें';

  @override
  String get posPricePickOne => 'चुनें…';

  @override
  String get posPriceNone => 'कोई नहीं';

  @override
  String get posPriceNewGarment => 'नया कपड़ा';

  @override
  String get posPriceNewCategory => 'नई श्रेणी';

  @override
  String get posPriceNewService => 'नई सर्विस';

  @override
  String get posPriceCreateHint => 'नाम';

  @override
  String get posPriceCreate => 'बनाएं';

  @override
  String get posPriceCreateTooltip => 'नया बनाएं';

  @override
  String get posPriceErrGarment => 'कपड़ा चुनें';

  @override
  String get posPriceErrService => 'सर्विस चुनें';

  @override
  String get posPriceErrRate => 'रेट लिखें, जैसे 80 या 80.50';

  @override
  String get posPriceErrName => 'नाम लिखें';

  @override
  String get posPriceSaved => 'रेट सेव हो गया';

  @override
  String posPriceCurrent(String price) {
    return 'अभी का रेट $price';
  }

  @override
  String get posUnitPiece => 'पीस';

  @override
  String get posUnitKg => 'किलो';

  @override
  String get posUnitPair => 'जोड़ी';

  @override
  String get posUnitSqft => 'वर्ग फ़ुट';

  @override
  String get posBookSubtotal => 'रकम';

  @override
  String posBookQtySemantics(String name, String qty) {
    return '$name, मात्रा $qty';
  }

  @override
  String posBookQtyDialogTitle(String unit) {
    return 'मात्रा दर्ज करें ($unit)';
  }

  @override
  String get posBookQtyInvalid => '0.1 से 9999 के बीच मात्रा दर्ज करें';

  @override
  String get posBookQtyOk => 'सेट करें';

  @override
  String get posBookBill => 'बिल';

  @override
  String get posOrdersTitle => 'ऑर्डर';

  @override
  String get posOrdTabBooked => 'बुक';

  @override
  String get posOrdTabInProcess => 'प्रोसेस में';

  @override
  String get posOrdTabDone => 'तैयार';

  @override
  String get posOrdFilter => 'फ़िल्टर';

  @override
  String get posOrdSelectAll => 'सभी चुनें';

  @override
  String posOrdSelectedCount(int count) {
    return '$count चुने गए';
  }

  @override
  String get posOrdMoveNext => 'अगले चरण पर ले जाएँ';

  @override
  String get posOrdSearchHint => 'नाम, फ़ोन या ऑर्डर नंबर खोजें';

  @override
  String get posOrdEmptyBooked =>
      'कोई बुक ऑर्डर नहीं। जोड़ने के लिए \"ऑर्डर बुक करें\" दबाएँ।';

  @override
  String get posOrdEmptyInProcess => 'अभी कुछ भी प्रोसेस में नहीं है।';

  @override
  String get posOrdEmptyDone => 'अभी कोई ऑर्डर तैयार नहीं है।';

  @override
  String get posOrdEmptyFiltered =>
      'कोई ऑर्डर नहीं मिला। फ़िल्टर या खोज हटाएँ।';

  @override
  String get posOrdClearFilters => 'फ़िल्टर हटाएँ';

  @override
  String get posOrdLoadError => 'ऑर्डर लोड नहीं हो सके।';

  @override
  String get posOrdLoadMoreError =>
      'और लोड नहीं हो सका। फिर कोशिश करने के लिए दबाएँ।';

  @override
  String posOrdItemsCount(int count) {
    return '$count आइटम';
  }

  @override
  String posOrdBalanceDue(String amount) {
    return 'बकाया $amount';
  }

  @override
  String posOrdDue(String date) {
    return 'डिलीवरी $date';
  }

  @override
  String get posOrdExpress => 'एक्सप्रेस';

  @override
  String get posOrdHomeDelivery => 'होम डिलीवरी';

  @override
  String get posOrdPickup => 'पिकअप';

  @override
  String get posOrdWalkIn => 'काउंटर पर';

  @override
  String get posPayStatusPaid => 'चुकता';

  @override
  String get posPayStatusPart => 'आंशिक भुगतान';

  @override
  String get posPayStatusUnpaid => 'बाकी';

  @override
  String get posPhaseBooked => 'बुक';

  @override
  String get posPhaseProcessing => 'प्रोसेस में';

  @override
  String get posPhaseReady => 'तैयार';

  @override
  String get posPhaseOut => 'डिलीवरी के लिए निकला';

  @override
  String get posPhaseDelivered => 'डिलीवर हो गया';

  @override
  String get posPhaseComplete => 'ऑर्डर पूरा';

  @override
  String get posPhaseCancelled => 'रद्द';

  @override
  String get posFilterTitle => 'ऑर्डर फ़िल्टर करें';

  @override
  String get posFilterStatus => 'कौन से ऑर्डर';

  @override
  String get posFilterThisTab => 'यह टैब';

  @override
  String get posFilterAllOrders => 'सभी ऑर्डर';

  @override
  String get posFilterDeliveredOnly => 'डिलीवर हुए';

  @override
  String get posFilterCancelledOnly => 'रद्द हुए';

  @override
  String get posFilterDates => 'ऑर्डर की तारीख़';

  @override
  String get posFilterFrom => 'से';

  @override
  String get posFilterTo => 'तक';

  @override
  String get posFilterAnyDate => 'कोई भी तारीख़';

  @override
  String get posFilterDelivery => 'ग्राहक तक कैसे पहुँचे';

  @override
  String get posFilterAnyDelivery => 'कोई भी';

  @override
  String get posFilterExpressOnly => 'सिर्फ़ एक्सप्रेस';

  @override
  String get posFilterDueOnly => 'सिर्फ़ बकाया वाले';

  @override
  String get posFilterApply => 'ऑर्डर दिखाएँ';

  @override
  String get posFilterReset => 'हटाएँ';

  @override
  String posBulkTitle(int count) {
    return '$count ऑर्डर अगले चरण पर ले जाएँ?';
  }

  @override
  String get posBulkBody =>
      'हर ऑर्डर एक चरण आगे बढ़ेगा: बुक → प्रोसेस → तैयार → डिलीवर।';

  @override
  String get posBulkReadyNote =>
      'जिन ऑर्डर के कपड़े स्कैन नहीं हुए, वे भी तैयार मान लिए जाएँगे।';

  @override
  String get posBulkDueNote =>
      'जिन पर बकाया है वे यहाँ डिलीवर नहीं होंगे — उन्हें एक-एक करके खोलें।';

  @override
  String get posBulkGo => 'ऑर्डर आगे बढ़ाएँ';

  @override
  String posBulkDone(int count) {
    return '$count ऑर्डर आगे बढ़ गए।';
  }

  @override
  String posBulkPartial(int moved, int failed) {
    return '$moved आगे बढ़े। $failed को देखना होगा — उन्हें एक-एक करके खोलें।';
  }

  @override
  String get posBulkNone => 'कुछ भी आगे नहीं बढ़ सका। ऑर्डर एक-एक करके खोलें।';

  @override
  String posBulkSkipDue(int count) {
    return 'बकाया वाले $count ऑर्डर आपके खोलने के लिए छोड़े गए।';
  }

  @override
  String get posOrdDetailTitle => 'ऑर्डर की जानकारी';

  @override
  String get posOrdCall => 'कॉल';

  @override
  String get posOrdCallFailed => 'फ़ोन नहीं खुल सका।';

  @override
  String get posNextStart => 'प्रोसेस शुरू करें';

  @override
  String get posNextReady => 'तैयार करें';

  @override
  String get posNextSendOut => 'डिलीवरी पर भेजें';

  @override
  String get posNextDeliver => 'ऑर्डर डिलीवर करें';

  @override
  String get posOrdFinished => 'यह ऑर्डर पूरा हो चुका है।';

  @override
  String get posOrdCancelledNote => 'यह ऑर्डर रद्द हो गया था।';

  @override
  String get posReadyAnywayTitle => 'कपड़े अभी स्कैन नहीं हुए';

  @override
  String get posReadyAnywayBody =>
      'कुछ कपड़े प्रोसेसिंग में स्कैन नहीं हुए हैं। फिर भी ऑर्डर तैयार करें?';

  @override
  String get posReadyAnywayYes => 'फिर भी तैयार करें';

  @override
  String get posNotYet => 'अभी नहीं';

  @override
  String posDeliverDueTitle(String amount) {
    return '$amount बाकी है';
  }

  @override
  String get posDeliverDueBody =>
      'पहले भुगतान लें, या अभी डिलीवर करें और बाद में लें।';

  @override
  String get posCollectFirst => 'पहले भुगतान लें';

  @override
  String get posDeliverAnyway => 'बकाया के साथ डिलीवर करें';

  @override
  String posOrdMoved(String status) {
    return 'ऑर्डर अब \"$status\" है।';
  }

  @override
  String get posOrdChanged =>
      'यह ऑर्डर किसी और ने बदल दिया। इसे दोबारा लोड कर दिया है — देखकर फिर कोशिश करें।';

  @override
  String posProgressPercent(int percent) {
    return '$percent% पूरा';
  }

  @override
  String get posStageBooked => 'बुक';

  @override
  String get posStageProcessed => 'प्रोसेस';

  @override
  String get posStageDone => 'तैयार';

  @override
  String get posStageDelivered => 'डिलीवर';

  @override
  String get posStageComplete => 'पूरा';

  @override
  String get posActionsTitle => 'तुरंत काम';

  @override
  String get posActPayNow => 'अभी भुगतान लें';

  @override
  String get posActInvoice => 'इनवॉइस देखें';

  @override
  String get posActMiniInvoice => 'मिनी इनवॉइस';

  @override
  String get posActTag => 'टैग';

  @override
  String get posActEdit => 'ऑर्डर बदलें';

  @override
  String get posActCancel => 'ऑर्डर रद्द करें';

  @override
  String get posActAssign => 'कैप्टन चुनें';

  @override
  String get posInfoTitle => 'ऑर्डर की जानकारी';

  @override
  String get posInfoDelivery => 'डिलीवरी';

  @override
  String get posInfoOrderNo => 'ऑर्डर नं.';

  @override
  String get posInfoInvoiceAmount => 'बिल की रकम';

  @override
  String get posInfoPaid => 'चुकता';

  @override
  String get posInfoBalance => 'बकाया';

  @override
  String get posInfoBookedOn => 'बुकिंग';

  @override
  String get posInfoDeliveryDate => 'डिलीवरी की तारीख़';

  @override
  String get posInfoPickupCaptain => 'पिकअप कैप्टन';

  @override
  String get posInfoDeliveryCaptain => 'डिलीवरी कैप्टन';

  @override
  String get posInfoNotAssigned => 'चुना नहीं गया';

  @override
  String get posInfoNotes => 'टिप्पणी';

  @override
  String get posInfoCancelReason => 'रद्द करने का कारण';

  @override
  String get posPaymentsTitle => 'मिले भुगतान';

  @override
  String get posPaymentsNone => 'अभी तक कोई भुगतान नहीं मिला।';

  @override
  String get posModeCash => 'नकद';

  @override
  String get posModeOnline => 'ऑनलाइन';

  @override
  String get posModeCard => 'कार्ड';

  @override
  String get posModeBank => 'बैंक';

  @override
  String get posModeWallet => 'वॉलेट';

  @override
  String get posGarmentsTitle => 'कपड़े';

  @override
  String get posGarmentsNone => 'इस ऑर्डर में कोई कपड़ा नहीं।';

  @override
  String get posUnitReceived => 'मिला';

  @override
  String get posUnitProcessing => 'प्रोसेस में';

  @override
  String get posUnitReady => 'तैयार';

  @override
  String get posUnitOut => 'निकला';

  @override
  String get posUnitDelivered => 'डिलीवर';

  @override
  String get posUnitMissing => 'गुम';

  @override
  String get posUnitCancelled => 'रद्द';

  @override
  String get posOrdLoadFailed => 'यह ऑर्डर लोड नहीं हो सका।';

  @override
  String get posOrdLoadingHint => 'ऑर्डर लोड हो रहा है…';

  @override
  String get posWhatsApp => 'व्हाट्सऐप';

  @override
  String get posWaOpenFailed => 'व्हाट्सऐप नहीं खुल सका।';

  @override
  String posWaMessageDue(String name, String number, String status,
      String total, String balance, String shop) {
    return 'नमस्ते $name, आपका ऑर्डर $number \"$status\" है। कुल $total, बकाया $balance। धन्यवाद! — $shop';
  }

  @override
  String posWaMessagePaid(
      String name, String number, String status, String total, String shop) {
    return 'नमस्ते $name, आपका ऑर्डर $number \"$status\" है। कुल $total, पूरा भुगतान हो चुका है। धन्यवाद! — $shop';
  }

  @override
  String get posWaCustomerFallback => 'जी';

  @override
  String get posPayTitle => 'भुगतान लें';

  @override
  String get posPayBalance => 'लेने के लिए बकाया';

  @override
  String get posPayAmount => 'रकम (₹)';

  @override
  String get posPayFull => 'पूरा बकाया';

  @override
  String get posPayHow => 'ग्राहक कैसे भुगतान कर रहा है?';

  @override
  String get posPayReference => 'रेफ़रेंस (ज़रूरी नहीं)';

  @override
  String get posPayReferenceHint => 'जैसे UPI ट्रांज़ैक्शन नंबर';

  @override
  String posPayCollect(String amount) {
    return '$amount लें';
  }

  @override
  String get posPayErrZero => 'रकम डालें।';

  @override
  String posPayErrOver(String amount) {
    return 'यह बकाया $amount से ज़्यादा नहीं हो सकता।';
  }

  @override
  String posPayDone(String amount) {
    return '$amount मिल गए।';
  }

  @override
  String get posPayCheckFirst =>
      'भुगतान की पुष्टि नहीं हो सकी। ऑर्डर दोबारा लोड किया है — दोबारा लेने से पहले बकाया देखें।';

  @override
  String get posPayNothingDue => 'इस ऑर्डर पर कुछ बकाया नहीं।';

  @override
  String get posCancelTitle => 'यह ऑर्डर रद्द करें?';

  @override
  String get posCancelBody => 'इसे वापस नहीं किया जा सकता।';

  @override
  String get posCancelWhy => 'रद्द क्यों कर रहे हैं?';

  @override
  String get posCancelReasonMind => 'ग्राहक ने मन बदल लिया';

  @override
  String get posCancelReasonMistake => 'गलती से बुक हुआ';

  @override
  String get posCancelReasonPrice => 'दाम की दिक्कत';

  @override
  String get posCancelReasonOther => 'कोई और कारण';

  @override
  String get posCancelOtherHint => 'कारण लिखें (कम से कम 3 अक्षर)';

  @override
  String get posCancelRefundNote =>
      'अगर ग्राहक पहले ही भुगतान कर चुका है, तो पैसे खुद लौटाएँ — ऐप रिफ़ंड नहीं करता।';

  @override
  String get posCancelConfirm => 'ऑर्डर रद्द करें';

  @override
  String get posCancelKeep => 'ऑर्डर रखें';

  @override
  String get posCancelDone => 'ऑर्डर रद्द हो गया।';

  @override
  String get posEditTitle => 'ऑर्डर बदलें';

  @override
  String get posEditItemsNote =>
      'कपड़े बदलने के लिए यह ऑर्डर रद्द करके नया बुक करें।';

  @override
  String get posEditSave => 'बदलाव सहेजें';

  @override
  String get posEditSaved => 'ऑर्डर बदल गया।';

  @override
  String get posEditNothing => 'कुछ नहीं बदला।';

  @override
  String get posAssignTitle => 'कैप्टन चुनें';

  @override
  String get posAssignPickup => 'पिकअप कैप्टन';

  @override
  String get posAssignDelivery => 'डिलीवरी कैप्टन';

  @override
  String get posAssignKeep => 'जैसा है वैसा रखें';

  @override
  String get posAssignNone =>
      'अभी कोई कैप्टन नहीं है। सेटिंग → टीम में जोड़ें।';

  @override
  String get posAssignSave => 'चुनें';

  @override
  String get posAssignDone => 'कैप्टन चुन लिया गया।';

  @override
  String get posInvoiceTitle => 'इनवॉइस';

  @override
  String get posMiniTitle => 'मिनी बिल';

  @override
  String get posPaper58 => '58 मिमी';

  @override
  String get posPaper80 => '80 मिमी';

  @override
  String get posPaperLabel => 'काग़ज़ का साइज़';

  @override
  String get posInvoiceLater =>
      'इनवॉइस ऑर्डर डिलीवर होने पर बनता है। अभी बिल के लिए \"मिनी इनवॉइस\" इस्तेमाल करें।';

  @override
  String get posInvoiceOpenMini => 'मिनी इनवॉइस खोलें';

  @override
  String get posInvoiceFailed => 'बिल तैयार नहीं हो सका।';

  @override
  String get posOk => 'ठीक है';

  @override
  String get posTagsTitle => 'कपड़ों के टैग';

  @override
  String get posTagsEmpty => 'इस ऑर्डर के कोई टैग नहीं हैं।';

  @override
  String get posTagsPrint => 'टैग प्रिंट या शेयर करें';

  @override
  String get posTagsHint =>
      'हर कपड़े पर एक टैग लगाएँ। हर QR के नीचे कोड भी लिखा है।';

  @override
  String posTagsPdfTitle(String number) {
    return 'ऑर्डर $number के टैग';
  }

  @override
  String get posTagsFailed => 'टैग तैयार नहीं हो सके।';

  @override
  String get posTileOpensOrders => 'ऑर्डर सूची खुलती है';

  @override
  String posOrdFiltered(String what) {
    return 'दिखा रहे हैं: $what';
  }

  @override
  String get posNoPermission =>
      'आपको यह करने की अनुमति नहीं है। दुकान के मालिक से पूछें।';

  @override
  String get posSearchHint => 'ऑर्डर नं., ग्राहक का नाम, फ़ोन या टैग';

  @override
  String get posSearchStart => 'खोजने के लिए कम से कम 2 अक्षर या अंक लिखें।';

  @override
  String get posSearchRecent => 'हाल की खोजें';

  @override
  String get posSearchClearRecent => 'हटाएँ';

  @override
  String posSearchNone(String q) {
    return '\"$q\" के लिए कुछ नहीं मिला। वर्तनी जाँचें या फ़ोन नंबर आज़माएँ।';
  }

  @override
  String get posSearchFailed => 'अभी खोज नहीं हो पाई।';

  @override
  String get posSearchCustomers => 'ग्राहक';

  @override
  String get posSearchOrders => 'ऑर्डर';

  @override
  String get posSearchTags => 'कपड़े के टैग';

  @override
  String get posSearchAllCustomers => 'सभी ग्राहक';

  @override
  String posSearchOrderLine(String total, String date) {
    return '$total · $date';
  }

  @override
  String posSearchTagLine(String code, String state) {
    return 'टैग $code · $state';
  }

  @override
  String get posCustTitle => 'ग्राहक';

  @override
  String get posCustSearchHint => 'नाम या फ़ोन से खोजें';

  @override
  String get posCustEmpty =>
      'अभी कोई ग्राहक नहीं। ऑर्डर बुक करें या ग्राहक जोड़ें।';

  @override
  String posCustNoMatch(String q) {
    return '\"$q\" से कोई ग्राहक नहीं मिला।';
  }

  @override
  String get posCustLoadError => 'ग्राहक नहीं खुल पाए।';

  @override
  String posCustOrdersCount(int count, String spent) {
    return '$count ऑर्डर · $spent';
  }

  @override
  String get posCustNewCustomer => 'नया ग्राहक';

  @override
  String get posCustDuesTitle => 'वसूलना है';

  @override
  String get posCustNoDues => 'कुछ बकाया नहीं। सब चुकता।';

  @override
  String posCustDueOrder(String number) {
    return 'ऑर्डर $number';
  }

  @override
  String get posCustCollect => 'बकाया वसूलें';

  @override
  String get posCustCollectHint => 'बैलेंस वसूलने के लिए ऑर्डर चुनें।';

  @override
  String get posCustHistory => 'ऑर्डर का इतिहास';

  @override
  String get posCustNoOrders => 'अभी कोई ऑर्डर नहीं।';

  @override
  String get posCustNotes => 'नोट्स';

  @override
  String get posCustAddresses => 'पते';

  @override
  String get posCustCall => 'कॉल करें';

  @override
  String get posCustWhatsApp => 'व्हाट्सऐप';

  @override
  String get posCustNotFound => 'यह ग्राहक नहीं मिला।';

  @override
  String posCustOwes(String amount) {
    return 'बकाया $amount';
  }

  @override
  String posWaSheetTitle(String name) {
    return '$name को संदेश भेजें';
  }

  @override
  String get posWaOpenChat => 'सिर्फ़ चैट खोलें';

  @override
  String get posWaOpenChatBody => 'एक छोटा नमस्ते। आप कुछ भी लिख सकते हैं।';

  @override
  String posWaHello(String name, String shop) {
    return 'नमस्ते $name, मैं $shop से बोल रहा/रही हूँ।';
  }

  @override
  String posWaForOrder(String number) {
    return 'ऑर्डर $number के बारे में';
  }

  @override
  String get posWaNoOrder =>
      'इस ग्राहक का अभी कोई ऑर्डर नहीं, इसलिए सिर्फ़ सादी चैट खुल सकती है।';

  @override
  String get posWaPaymentDue => 'भुगतान की याद दिलाएँ';

  @override
  String get posWaPaymentDueBody => 'बकाया रकम दिखाता है।';

  @override
  String get posWaTemplatesFailed => 'आपके सेव किए संदेश नहीं खुल पाए।';

  @override
  String get posActionWhatsApp => 'व्हाट्सऐप';

  @override
  String get posExpTitle => 'खर्च';

  @override
  String get posExpToday => 'आज';

  @override
  String get posExpThisMonth => 'इस महीने';

  @override
  String posExpSpent(String amount) {
    return 'खर्च: $amount';
  }

  @override
  String get posExpAdd => 'खर्च जोड़ें';

  @override
  String get posExpEdit => 'खर्च बदलें';

  @override
  String get posExpCancel => 'खर्च रद्द करें';

  @override
  String get posExpEmpty =>
      'इस अवधि में कोई खर्च नहीं। कुछ चुकाएँ तो \"खर्च जोड़ें\" दबाएँ।';

  @override
  String get posExpLoadError => 'खर्च नहीं खुल पाए।';

  @override
  String get posExpName => 'किस चीज़ का खर्च?';

  @override
  String get posExpNameHint => 'जैसे बिजली का बिल';

  @override
  String get posExpAmount => 'रकम (₹)';

  @override
  String get posExpCategory => 'खर्च का प्रकार';

  @override
  String get posExpMode => 'भुगतान का तरीका';

  @override
  String get posExpDate => 'तारीख';

  @override
  String get posExpNote => 'नोट (वैकल्पिक)';

  @override
  String get posExpReason => 'इसे क्यों बदल रहे हैं?';

  @override
  String get posExpCancelReason => 'इसे रद्द क्यों कर रहे हैं?';

  @override
  String get posExpSave => 'खर्च सेव करें';

  @override
  String get posExpSaved => 'खर्च सेव हो गया।';

  @override
  String get posExpCancelled => 'खर्च रद्द हो गया।';

  @override
  String get posExpCancelledTag => 'रद्द';

  @override
  String get posExpKeep => 'रहने दें';

  @override
  String get posExpNameRequired => 'लिखें कि खर्च किस चीज़ का था।';

  @override
  String get posExpAmountInvalid => '250 या 99.50 जैसी रकम लिखें।';

  @override
  String get posExpReasonRequired => 'कृपया कारण लिखें।';

  @override
  String posExpBy(String category, String mode) {
    return '$category · $mode';
  }

  @override
  String get posCatRent => 'किराया';

  @override
  String get posCatSalary => 'वेतन';

  @override
  String get posCatElectricity => 'बिजली';

  @override
  String get posCatWater => 'पानी';

  @override
  String get posCatDetergent => 'डिटर्जेंट और सामान';

  @override
  String get posCatTransport => 'ढुलाई/यात्रा';

  @override
  String get posCatRepair => 'मरम्मत';

  @override
  String get posCatTea => 'चाय-नाश्ता';

  @override
  String get posCatOther => 'अन्य';

  @override
  String get posExpModeCash => 'नकद';

  @override
  String get posExpModeUpi => 'यूपीआई';

  @override
  String get posExpModeBank => 'बैंक';

  @override
  String get posExpModeCard => 'कार्ड';

  @override
  String get posExpModeOther => 'अन्य';

  @override
  String get posDrawerTitle => 'कैश दराज';

  @override
  String get posDrawerClosed => 'कैश दराज बंद है। दिन शुरू करते समय खोलें।';

  @override
  String get posDrawerOpen => 'कैश दराज खोलें';

  @override
  String get posDrawerClose => 'कैश दराज बंद करें';

  @override
  String posDrawerOpenSince(String time) {
    return '$time से खुला है';
  }

  @override
  String get posDrawerOpening => 'शुरू में नकद';

  @override
  String get posDrawerIn => 'नकद आया';

  @override
  String get posDrawerOut => 'नकद गया';

  @override
  String get posDrawerShould => 'दराज में होना चाहिए';

  @override
  String get posDrawerOpeningQ => 'दराज में अभी कितना नकद है?';

  @override
  String get posDrawerOpenSave => 'दराज खोलें';

  @override
  String get posDrawerCounted => 'आपने गिना हुआ नकद (₹)';

  @override
  String posDrawerExpected(String amount) {
    return 'होना चाहिए: $amount';
  }

  @override
  String get posDrawerMatch => 'हिसाब मिल गया। कुछ कम नहीं है।';

  @override
  String posDrawerShort(String amount) {
    return '$amount कम है।';
  }

  @override
  String posDrawerExtra(String amount) {
    return '$amount ज़्यादा है।';
  }

  @override
  String get posDrawerWhy => 'फ़र्क क्यों है?';

  @override
  String get posDrawerApprover => 'किसने मंज़ूर किया (नाम)';

  @override
  String get posDrawerCloseSave => 'दराज बंद करें';

  @override
  String get posDrawerOpened => 'कैश दराज खुल गया।';

  @override
  String get posDrawerClosedOk => 'कैश दराज बंद हो गया।';

  @override
  String get posDrawerCountInvalid => 'गिना हुआ नकद लिखें, जैसे 1250।';

  @override
  String get posDrawerNeedsWhy =>
      'लिखें कि फ़र्क क्यों है और किसने मंज़ूर किया।';

  @override
  String get posDrawerPast => 'पिछले दराज';

  @override
  String posDrawerPastLine(String counted, String diff) {
    return 'गिना $counted · $diff';
  }

  @override
  String get posDrawerDiffOk => 'हिसाब मिला';

  @override
  String posDrawerDiffShort(String amount) {
    return '$amount कम';
  }

  @override
  String posDrawerDiffExtra(String amount) {
    return '$amount ज़्यादा';
  }

  @override
  String get posMoneyNoAccess => 'इसके लिए दुकान के मालिक से अनुमति माँगें।';

  @override
  String get posRepTitle => 'रिपोर्ट';

  @override
  String get posRepToday => 'आज';

  @override
  String get posRep7Days => 'पिछले 7 दिन';

  @override
  String get posRepMonth => 'इस महीने';

  @override
  String get posRepCustom => 'तारीख चुनें';

  @override
  String posRepPeriod(String from, String to) {
    return '$from से $to';
  }

  @override
  String get posRepBilled => 'बिल बना';

  @override
  String get posRepBilledHint => 'बुक हुए ऑर्डर का कुल';

  @override
  String get posRepCollected => 'वसूला';

  @override
  String get posRepCollectedHint => 'इस अवधि में मिला पैसा';

  @override
  String get posRepDues => 'अभी वसूलना है';

  @override
  String posRepDuesHint(int count) {
    return '$count ऑर्डर पूरे चुकाए नहीं';
  }

  @override
  String get posRepSpent => 'खर्च हुआ';

  @override
  String posRepSpentHint(int count) {
    return '$count खर्च';
  }

  @override
  String get posRepNet => 'वसूला − खर्च';

  @override
  String get posRepOrders => 'ऑर्डर';

  @override
  String posRepOrdersCount(int count) {
    return '$count ऑर्डर बुक हुए';
  }

  @override
  String get posRepStBooked => 'बुक';

  @override
  String get posRepStProcess => 'प्रोसेस में';

  @override
  String get posRepStReady => 'तैयार';

  @override
  String get posRepStDelivered => 'डिलीवर';

  @override
  String get posRepStCancelled => 'रद्द';

  @override
  String get posRepPayMix => 'ग्राहकों ने कैसे चुकाया';

  @override
  String get posRepNoPayments => 'इस अवधि में कोई भुगतान नहीं।';

  @override
  String get posRepModeWallet => 'वॉलेट';

  @override
  String get posRepTopGarments => 'सबसे ज़्यादा बुक कपड़े';

  @override
  String posRepQty(String qty, String amount) {
    return '$qty · $amount';
  }

  @override
  String get posRepSpendBy => 'खर्च का प्रकार';

  @override
  String get posRepDaily => 'दिन-ब-दिन';

  @override
  String posRepDayLine(String billed, String collected, String spent) {
    return 'बिल $billed · वसूला $collected · खर्च $spent';
  }

  @override
  String get posRepExport => 'बिक्री फ़ाइल भेजें (CSV)';

  @override
  String get posRepExportHint =>
      'Excel या Google Sheets में खुलती है। हर ऑर्डर की एक पंक्ति।';

  @override
  String get posRepExportFailed => 'फ़ाइल तैयार नहीं हो पाई।';

  @override
  String get posRepLoadError => 'रिपोर्ट नहीं खुल पाई।';

  @override
  String get posRepEmpty => 'इस अवधि में कोई ऑर्डर या खर्च नहीं।';

  @override
  String get posRepRangeTooLong => 'कृपया अधिकतम एक साल चुनें।';

  @override
  String get posRepTabSummary => 'सारांश';

  @override
  String get posRepTabInvoices => 'इनवॉइस';

  @override
  String get posRepTabCollection => 'वसूली';

  @override
  String get posRepTabExpense => 'खर्च';

  @override
  String get posRepTotalRevenue => 'कुल कमाई';

  @override
  String get posRepInvNo => 'इनवॉइस नं.';

  @override
  String get posRepAmount => 'रकम';

  @override
  String get posRepStatus => 'स्थिति';

  @override
  String posRepPage(int n) {
    return 'पेज $n';
  }

  @override
  String get posRepPrev => 'पिछला';

  @override
  String get posRepNext => 'अगला';

  @override
  String get posRepNoInvoices => 'इस अवधि में कोई इनवॉइस नहीं।';

  @override
  String get posRepInvoicesFailed => 'इनवॉइस नहीं खुल पाए।';

  @override
  String get posRepChartBilled => 'हर दिन का बिल';

  @override
  String get posRepChartCollected => 'हर दिन की वसूली';

  @override
  String get posRepChartSpent => 'हर दिन का खर्च';

  @override
  String posRepChartHigh(String amount, String date) {
    return 'सबसे ज़्यादा: $amount, $date को';
  }

  @override
  String get posRepChartNone => 'अभी दिखाने के लिए कुछ नहीं।';

  @override
  String get posCustProfile => 'प्रोफ़ाइल';

  @override
  String get posSetCustomers => 'ग्राहक';

  @override
  String get posSetCustomersBody => 'सभी ग्राहक देखें, कॉल करें, बकाया देखें।';

  @override
  String get posSetPrices => 'दाम सूची';

  @override
  String get posSetPricesBody => 'कपड़ा जोड़ें या दाम बदलें।';

  @override
  String get posSetRules => 'अतिरिक्त शुल्क और छूट';

  @override
  String get posSetRulesBody => 'जो बुकिंग में चुन सकते हैं।';

  @override
  String get posSetRulesCharges => 'अतिरिक्त शुल्क';

  @override
  String get posSetRulesDiscounts => 'छूट';

  @override
  String get posSetRulesNone =>
      'अभी कोई नहीं। ये काउंटर सॉफ़्टवेयर या वेबसाइट से जुड़ते हैं।';

  @override
  String posSetRuleFlat(String amount) {
    return '$amount तय';
  }

  @override
  String posSetRulePercent(String percent) {
    return 'बिल का $percent%';
  }

  @override
  String get posSetMessages => 'व्हाट्सऐप संदेश';

  @override
  String get posSetMessagesBody => 'ग्राहकों को भेजे जाने वाले संदेश।';

  @override
  String get posSetMessagesHint =>
      'ये शब्द काउंटर सॉफ़्टवेयर या वेबसाइट पर बदल सकते हैं। यहाँ भी दिखेंगे।';

  @override
  String get posSetTeam => 'टीम';

  @override
  String get posSetTeamBody => 'आपकी दुकान में कौन काम करता है।';

  @override
  String get posSetTeamHint =>
      'लोग जोड़ने या हटाने के लिए काउंटर सॉफ़्टवेयर या वेबसाइट इस्तेमाल करें।';

  @override
  String get posSetRoleOwner => 'मालिक';

  @override
  String get posSetRoleStaff => 'काउंटर स्टाफ़';

  @override
  String get posSetRoleRider => 'कैप्टन (पिकअप/डिलीवरी)';

  @override
  String get posSetInactive => 'सक्रिय नहीं';

  @override
  String get posSetLanguage => 'भाषा';

  @override
  String get posSetLoadFailed => 'यह नहीं खुल पाया।';

  @override
  String get posSetSectionShop => 'मेरी दुकान';

  @override
  String get posSetSectionApp => 'यह ऐप';
}

/// The translations for Hindi, using the Latin script (`hi_Latn`).
class AppLocalizationsHiLatn extends AppLocalizationsHi {
  AppLocalizationsHiLatn() : super('hi_Latn');

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel karein';

  @override
  String get commonRetry => 'Retry karein';

  @override
  String get commonReject => 'Reject karein';

  @override
  String get commonAccept => 'Accept karein';

  @override
  String get commonExit => 'Exit karein';

  @override
  String get commonCallCustomer => 'Customer ko call karein';

  @override
  String get commonCouldNotOpenDialer =>
      'Phone dialer open nahi ho paya. Please phir try karein.';

  @override
  String get splashAppName => 'Lndry Partner';

  @override
  String get splashTagline => 'Partner Portal';

  @override
  String get authWelcomeBack => 'Welcome Back';

  @override
  String get authLoginSubtitle =>
      'Apna laundry business manage karne ke liye mobile number daalein';

  @override
  String get authMobileNumberLabel => 'Mobile Number';

  @override
  String get authMobileNumberRequired => 'Mobile number daalna zaroori hai';

  @override
  String get authMobileNumberInvalid => 'Sahi 10-digit mobile number daalein';

  @override
  String get authGetOtpButton => 'OTP Lein';

  @override
  String get authVerifyMobile => 'Mobile Verify Karein';

  @override
  String authOtpSubtitleWithPhone(String phone) {
    return '$phone par bheja gaya 6-digit OTP code daalein';
  }

  @override
  String get authOtpSubtitleGeneric =>
      'Apne mobile par bheja gaya verification code daalein';

  @override
  String get authDemoOtpLabel => 'Demo OTP: ';

  @override
  String get authOtpCodeLabel => 'OTP Code';

  @override
  String get authOtpRequired => 'OTP code daalein';

  @override
  String get authOtpInvalid => 'Sahi 6-digit code daalein';

  @override
  String get authVerifyCodeButton => 'Code Verify Karein';

  @override
  String get authResendPrompt => 'Code nahi mila? ';

  @override
  String get authResendCountdownPrefix => 'Code dobara bhejein in ';

  @override
  String get authResendOtpButton => 'OTP Dobara Bhejein';

  @override
  String authResendCountdownSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get dashboardTodayClosedTitle => 'Aaj closed mark kiya gaya hai';

  @override
  String get dashboardTodayClosedMessage =>
      'Aapke Working Hours schedule mein aaj non-working day set hai, isliye is switch se koi fark nahi padega — store customers ke liye band hi rahega. Aaj open karne ke liye Working Hours & Slots update karein.';

  @override
  String get dashboardOpenWorkingHoursButton => 'Working Hours Kholein';

  @override
  String get dashboardCloseStoreTitle => 'Apna Store Band Karein?';

  @override
  String get dashboardOpenStoreTitle => 'Apna Store Open Karein?';

  @override
  String get dashboardCloseStoreMessage =>
      'Jab tak store band hai, customers naye orders place nahi kar payenge.';

  @override
  String get dashboardOpenStoreMessage =>
      'Aapka store customers ko dikhega aur wo naye orders place kar sakenge.';

  @override
  String get dashboardCloseStoreButton => 'Store Band Karein';

  @override
  String get dashboardOpenStoreButton => 'Store Open Karein';

  @override
  String get dashboardStoreNowOpen => 'Store ab OPEN hai';

  @override
  String get dashboardStoreNowClosed => 'Store ab CLOSED hai';

  @override
  String dashboardActionFailed(String error) {
    return 'Fail ho gaya: $error';
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
  String get dashboardTodaysOperations => 'Aaj ka Operations';

  @override
  String get dashboardTodaysRevenue => 'Aaj ka Revenue';

  @override
  String get dashboardPendingOrders => 'Pending Orders';

  @override
  String get dashboardProcessingOrders => 'Processing Orders';

  @override
  String get dashboardReadyPacked => 'Ready / Packed';

  @override
  String get dashboardFailedLoadStats => 'Stats load nahi ho paaye';

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
  String get dashboardNewIncomingOrders => 'Naye Incoming Orders';

  @override
  String get dashboardViewAll => 'Sab Dekhein';

  @override
  String get dashboardAllCaughtUp => 'Sab caught up hai!';

  @override
  String get dashboardNoPendingOrders => 'Abhi koi pending order nahi hai.';

  @override
  String get dashboardFailedLoadOrders => 'Orders load nahi ho paaye';

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
  String get dashboardOrderAccepted => 'Order accept ho gaya!';

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
      'Naye orders, payouts aur updates ke alerts';

  @override
  String get settingsSoundAlerts => 'Sound Alerts';

  @override
  String get settingsSoundAlertsSubtitle =>
      'Naya order aane par sound bajayein';

  @override
  String get settingsOperationsSection => 'Operations';

  @override
  String get settingsAutoAcceptOrders => 'Orders Auto-Accept Karein';

  @override
  String get settingsAutoAcceptOrdersSubtitle =>
      'Capacity available hone par orders khud accept ho jayenge';

  @override
  String get settingsSupportLegalSection => 'Support & Legal';

  @override
  String get settingsPartnerHelpdesk => 'Partner Helpdesk';

  @override
  String get settingsPartnerHelpdeskSubtitle =>
      'LNDRY partner team se help lein';

  @override
  String get settingsConnectingHelpdesk =>
      'Partner helpdesk se connect ho raha hai…';

  @override
  String get settingsTermsOfService => 'Terms of Service & SLA';

  @override
  String get settingsOpeningTerms => 'Terms of Service khul raha hai…';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsOpeningPrivacy => 'Privacy Policy khul raha hai…';

  @override
  String settingsFooter(String version) {
    return 'Lndry Partner • Version $version\n© 2026 LNDRY Technologies Pvt. Ltd.';
  }

  @override
  String get routerExitAppTitle => 'App Band Karein?';

  @override
  String get routerExitAppMessage =>
      'Kya aap sach mein Lndry Partner se exit karna chahte hain?';

  @override
  String get routerPageNotFound => 'Page Nahi Mila';

  @override
  String get routerUnknownRoute => 'Unknown route';

  @override
  String get routerGoHome => 'Home Par Jaayein';

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
  String get orderStatusPaymentFailed => 'Payment Fail Ho Gaya';

  @override
  String get orderStatusWaitingForVendorConfirmation =>
      'Partner ki Confirmation ka Wait';

  @override
  String get orderStatusVendorAccepted => 'Scheduled';

  @override
  String get orderStatusPickupAssigned => 'Scheduled';

  @override
  String get orderStatusGoingForPickup => 'Pickup Partner Aa Raha Hai';

  @override
  String get orderStatusPickupOtpVerified => 'Pickup Ho Gaya';

  @override
  String get orderStatusPickedUp => 'Pickup Ho Gaya';

  @override
  String get orderStatusReceivedAtVendor => 'Partner Ke Paas Pahuncha';

  @override
  String get orderStatusReconciliationPending =>
      'Re-evaluation Submit — Customer Approval ka Wait';

  @override
  String get orderStatusReconciliationDisputed =>
      'Customer Ne Re-evaluation Reject Kiya';

  @override
  String get orderStatusProcessing => 'Processing Mein';

  @override
  String get orderStatusPacked => 'Packed';

  @override
  String get orderStatusDeliveryAssigned => 'Delivery Ke Liye Nikla';

  @override
  String get orderStatusOutForDelivery => 'Delivery Ke Liye Nikla';

  @override
  String get orderStatusDeliveryOtpVerified => 'Deliver Ho Gaya';

  @override
  String get orderStatusDelivered => 'Deliver Ho Gaya';

  @override
  String get orderStatusVendorRejected => 'Partner Ne Reject Kiya';

  @override
  String get orderStatusAutoRejected => 'Auto-Reject Ho Gaya';

  @override
  String get orderStatusCustomerCancelled => 'Cancel';

  @override
  String get orderStatusAdminCancelled => 'Cancel';

  @override
  String get orderStatusRefundPending => 'Refund Pending';

  @override
  String get orderStatusRefunded => 'Refund Ho Gaya';

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
  String get ordersEmptyPendingTitle => 'Koi Pending Order Nahi';

  @override
  String get ordersEmptyPendingSubtitle =>
      'Sab caught up hai! Naye orders yahan dikhenge.';

  @override
  String get ordersEmptyActiveTitle => 'Koi Active Order Nahi';

  @override
  String get ordersEmptyActiveSubtitle =>
      'Processing ya pickup ho rahe orders yahan dikhenge.';

  @override
  String get ordersEmptyReadyTitle => 'Koi Ready Order Nahi';

  @override
  String get ordersEmptyReadySubtitle =>
      'Packed aur delivery ke liye nikle orders yahan dikhenge.';

  @override
  String get ordersEmptyHistoryTitle => 'Order History Khaali Hai';

  @override
  String get ordersEmptyHistorySubtitle =>
      'Complete aur cancel hue orders aapki history mein yahan dikhenge.';

  @override
  String ordersPickupTimeLabel(String time) {
    return 'Pickup: $time';
  }

  @override
  String ordersCreatedTimeLabel(String time) {
    return 'Bana: $time';
  }

  @override
  String get ordersReconcileReceiptsButton => 'Receipts Milayein';

  @override
  String get ordersStartWashingButton => 'Washing Shuru Karein';

  @override
  String get ordersUpdateStageButton => 'Stage Update Karein';

  @override
  String get ordersMarkPackedButton => 'Packed & Ready Mark Karein';

  @override
  String get ordersUpdateProcessingStageTitle =>
      'Processing Stage Update Karein';

  @override
  String get ordersStageWashing => 'Washing';

  @override
  String get ordersStageDrying => 'Drying';

  @override
  String get ordersStageIroning => 'Ironing';

  @override
  String get ordersOrderAcceptedSnack => 'Order accept ho gaya';

  @override
  String get ordersOrderRejectedSnack => 'Order reject ho gaya';

  @override
  String ordersErrorSnack(String error) {
    return 'Error: $error';
  }

  @override
  String ordersStageUpdatedSnack(String stage) {
    return 'Stage update hokar $stage ho gaya';
  }

  @override
  String get orderDetailsPerKg => 'Per kg';

  @override
  String get orderDetailsPerSqFt => 'Per sq ft';

  @override
  String get orderDetailsPerItem => 'Per item';

  @override
  String get orderDetailsChooseServiceTitle => 'Ek Service Chunein';

  @override
  String get orderDetailsMoveServiceTitle => 'Dusri Service Mein Move Karein';

  @override
  String get orderDetailsAddServiceTitle => 'Service Add Karein';

  @override
  String get orderDetailsQuantityLabel => 'Quantity';

  @override
  String get orderDetailsAddButton => 'Add Karein';

  @override
  String orderDetailsPhotoUploadFailed(String error) {
    return 'Photo upload nahi ho payi: $error';
  }

  @override
  String get orderDetailsPhotoRequired => 'Kam se kam ek photo zaroori hai';

  @override
  String get orderDetailsProblemReportRequired =>
      'Submit karne se pehle kam se kam ek item par Report to Re-evaluation karein';

  @override
  String get orderDetailsSubmittedForApproval =>
      'Customer approval ke liye bhej diya gaya';

  @override
  String orderDetailsReconciliationFailed(String error) {
    return 'Reconciliation fail ho gaya: $error';
  }

  @override
  String get orderDetailsReconcileSheetTitle => 'Order Items Milayein';

  @override
  String get orderDetailsReconcileSheetSubtitle =>
      'Processing continue hone se pehle yeh customer approval ke liye bheja jayega.';

  @override
  String orderDetailsEstQuantity(String quantity) {
    return 'Est: $quantity';
  }

  @override
  String orderDetailsMovedFrom(String from, String to) {
    return '$from se $to mein move kiya gaya';
  }

  @override
  String get orderDetailsChangeServiceAgain => 'Service Dobara Badlein';

  @override
  String get orderDetailsMoveServicePrompt =>
      'Sahi service nahi hai? Ise badlein';

  @override
  String get orderDetailsAddServiceButton => 'Service Add Karein';

  @override
  String get orderDetailsAdjustmentNoteLabel => 'Adjustment Note / Reason';

  @override
  String get orderDetailsAdjustmentNoteHint =>
      'Jaise: 1 shirt add hui, collar par daag hai';

  @override
  String get orderDetailsPhotoEvidenceLabel => 'Photo Evidence (Zaroori)';

  @override
  String get orderDetailsPhotoEvidenceOptionalLabel =>
      'Additional Photo Evidence (Optional — yeh pehle se hi neeche diye gaye aapke re-evaluation report mein cover ho chuka hai)';

  @override
  String get orderDetailsReportProblemButton =>
      'Re-evaluation Mein Report Karein';

  @override
  String get orderDetailsReportProblemTitle =>
      'Re-evaluation Mein Report Karein';

  @override
  String get orderDetailsProblemTypeLabel => 'Problem Kya Hai?';

  @override
  String get orderDetailsProblemOtherOption => 'Other';

  @override
  String get orderDetailsProblemCustomMessageLabel => 'Problem Batayein';

  @override
  String get orderDetailsProblemCustomMessageHint =>
      'Jaise: Is item ki zip toothi hai';

  @override
  String get orderDetailsProblemPhotoLabel => 'Photo Evidence (1-3 Zaroori)';

  @override
  String get orderDetailsProblemRemoveButton => 'Hatayein';

  @override
  String get orderDetailsProblemSaveButton => 'Report Save Karein';

  @override
  String get orderDetailsReportedProblemsHeader => 'Re-evaluation Reports';

  @override
  String orderDetailsProblemForItem(String item) {
    return 'Iske Liye: $item';
  }

  @override
  String get orderDetailsSubmitButton =>
      'Customer Approval Ke Liye Submit Karein';

  @override
  String get orderDetailsRejectOrderTitle => 'Order Reject Karein';

  @override
  String get orderDetailsRejectionReasonLabel => 'Reject Karne Ka Reason';

  @override
  String get orderDetailsRejectionReasonHint =>
      'Jaise: Aaj shop ki capacity full ho gayi';

  @override
  String get orderDetailsConfirmRejectButton => 'Reject Confirm Karein';

  @override
  String get orderDetailsPageTitle => 'Order Details';

  @override
  String get orderDetailsAwaitingApprovalTitle => 'Customer Approval Ka Wait';

  @override
  String get orderDetailsAwaitingApprovalBody =>
      'Customer aapke proposed change ko review kar raha hai. Jawab milne tak processing ruki rahegi.';

  @override
  String get orderDetailsDisputedTitle =>
      'Customer Ne Proposed Amount Reject Kiya';

  @override
  String get orderDetailsDisputedBody =>
      'Isse resolve karne ke liye customer ko call karein, phir sahi items/photos ke saath reconciliation dobara bhejein.';

  @override
  String get orderDetailsLifecycleStepper => 'Lifecycle Stepper';

  @override
  String get orderDetailsCustomerDetails => 'Customer Details';

  @override
  String get orderDetailsCustomerFallback => 'Customer';

  @override
  String orderDetailsCustomerNote(String note) {
    return 'Note: $note';
  }

  @override
  String get orderDetailsGarmentItems => 'Garment Items';

  @override
  String get orderDetailsReconcileCountButton => 'Count Milayein';

  @override
  String orderDetailsQuantityValue(String quantity) {
    return 'Quantity: $quantity';
  }

  @override
  String get orderDetailsSubtotal => 'Subtotal';

  @override
  String get orderDetailsGstTaxes => 'GST / Taxes';

  @override
  String get orderDetailsPlatformFee => 'Platform Fee';

  @override
  String get orderDetailsDeliveryFee => 'Delivery Fee';

  @override
  String get orderDetailsHandlingFee => 'Handling Fee';

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
    return 'Commission Par GST ($rate%)';
  }

  @override
  String get orderDetailsVendorPayout => 'Aapko Milega';

  @override
  String get orderDetailsPickupRiderLabel => 'Pickup Captain';

  @override
  String get orderDetailsDeliveryRiderLabel => 'Delivery Captain';

  @override
  String get orderDetailsAssignRiderHint =>
      'Chunein Kaun Yeh Order Handle Karega';

  @override
  String get orderDetailsAssignRiderButton => 'Assign Karein';

  @override
  String get orderDetailsAssignRiderTitle => 'Captain Assign Karein';

  @override
  String get orderDetailsNoActiveRiders =>
      'Abhi Tak Koi Active Captain Nahi Hai. Captain Management Se Ek Add Karein.';

  @override
  String get orderDetailsRiderAssignedSnack => 'Captain Assign Ho Gaya';

  @override
  String get orderDetailsBroadcastButton => 'Sabhi Captains Ko Bhejein';

  @override
  String get orderDetailsBroadcastSnack =>
      'Active Captains Ko Broadcast Bhej Diya Gaya';

  @override
  String orderDetailsAssignedToRider(String name) {
    return '$name Ko Assign Kiya Gaya';
  }

  @override
  String get orderDetailsOfferPendingBroadcast =>
      'Sabhi Captains Ko Offer Bhej Diya — Acceptance Ka Wait Hai';

  @override
  String orderDetailsOfferPendingSingle(String name) {
    return '$name Ko Offer Kiya Gaya — Response Ka Wait Hai';
  }

  @override
  String get orderDetailsReassignButton => 'Reassign Karein';

  @override
  String get jobOfferTitle => 'Naya Job Offer!';

  @override
  String jobOfferOrderNumber(String orderNumber) {
    return 'Order #$orderNumber';
  }

  @override
  String get jobOfferAcceptButton => 'Accept Karein';

  @override
  String get jobOfferAcceptedSnack =>
      'Job Accept Ho Gaya — My Jobs Check Karein';

  @override
  String get jobOfferUnavailableSnack =>
      'Der Ho Gayi — Yeh Job Kisi Aur Ne Le Liya';

  @override
  String get jobOfferNotNowButton => 'Abhi Nahi';

  @override
  String jobOfferCountdownLabel(String time) {
    return '$time Mein Phir Se Bheja Jayega';
  }

  @override
  String get jobOfferExpiredLabel => 'Phir Se Bheja Ja Raha Hai…';

  @override
  String get orderDetailsCustomerReview => 'Customer Review';

  @override
  String get orderDetailsVendorRating => 'Partner Rating';

  @override
  String get orderDetailsDeliveryRating => 'Delivery Rating';

  @override
  String get orderDetailsSubmittedReevaluation =>
      'Re-evaluation Submit Kiya Gaya';

  @override
  String get orderDetailsNewServiceAdded => 'Nayi Service Add Hui';

  @override
  String orderDetailsMovedGeneric(String from, String to) {
    return 'Move Kiya: $from se $to';
  }

  @override
  String get orderDetailsItemFallback => 'Item';

  @override
  String get orderDetailsPreviousTotal => 'Pichla Total';

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
  String get orderDetailsRejectOrderButton => 'Order Reject Karein';

  @override
  String get orderDetailsAcceptOrderButton => 'Order Accept Karein';

  @override
  String get orderDetailsMarkReceivedButton => 'Received Mark Karein';

  @override
  String get orderDetailsReconcileItemsButton => 'Items Milayein';

  @override
  String get orderDetailsStartProcessingButton => 'Processing Shuru Karein';

  @override
  String get orderDetailsWaitingApprovalStatus => 'Customer Approval Ka Wait';

  @override
  String get orderDetailsResubmitButton => 'Reconciliation Dobara Bhejein';

  @override
  String orderDetailsErrorLoading(String error) {
    return 'Details load karne mein error: $error';
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
  String get servicesEmptyTitle => 'Abhi Tak Koi Service Nahi';

  @override
  String get servicesEmptySubtitle =>
      'Category chunne, subcategories chunne aur apni prices set karne ke liye \"Add Service\" par tap karein.';

  @override
  String servicesRejectedReason(String reason) {
    return 'Rejected: $reason';
  }

  @override
  String servicesPriceAdjustedByAdmin(String reason) {
    return 'Admin ne price adjust kiya: $reason';
  }

  @override
  String servicesFailedToLoad(String error) {
    return 'Services load nahi ho payi: $error';
  }

  @override
  String get servicesAddServiceButton => 'Add Service';

  @override
  String get servicesPickCategorySnack => 'Ek category chunein';

  @override
  String get servicesTurnOnSubcategorySnack =>
      'Offer karne ke liye kam se kam ek subcategory on karein';

  @override
  String get servicesEnterPriceSnack =>
      'Har activated subcategory ke liye ₹0 se zyada price daalein';

  @override
  String get servicesSubmittedForReview =>
      'Admin review ke liye bhej diya gaya';

  @override
  String servicesFailedToSave(String error) {
    return 'Save karne mein fail: $error';
  }

  @override
  String get servicesEditServiceTitle => 'Service Edit Karein';

  @override
  String servicesRejectedByAdminNote(String reason) {
    return 'Admin ne reject kiya: $reason\nChanges karke dobara review ke liye save karein.';
  }

  @override
  String get servicesServiceNameLabel => 'Service Ka Naam';

  @override
  String get servicesServiceNameHint => 'Jaise: Premium Laundry Services';

  @override
  String get servicesNameRequired => 'Naam zaroori hai';

  @override
  String get servicesDescriptionLabel => 'Description';

  @override
  String get servicesDescriptionHint =>
      'Jaise: Fast turnaround, doorstep pickup';

  @override
  String get servicesDescriptionRequired => 'Description zaroori hai';

  @override
  String get servicesCategoryLabel => 'Category';

  @override
  String get servicesCategoryRequired => 'Category zaroori hai';

  @override
  String get servicesSubcategoriesHeader => 'Subcategories';

  @override
  String get servicesSubcategoriesSubtitle =>
      'Is category se jo offer karna chahte hain wo chunein aur apni price set karein. Unit admin ne fix kiya hai.';

  @override
  String servicesFailedToLoadSubcategories(String error) {
    return 'Load nahi ho paya: $error';
  }

  @override
  String get servicesNoSubcategoriesPublished =>
      'Admin ne abhi tak yahan koi subcategory publish nahi ki hai.';

  @override
  String get servicesSaveSubmitButton => 'Save Karein & Review Ke Liye Bhejein';

  @override
  String servicesUnitPer(String unit) {
    return 'Unit: per $unit';
  }

  @override
  String servicesDemoPriceReferenceOnly(String price, String unit) {
    return 'Demo price: ₹$price/$unit — sirf reference ke liye';
  }

  @override
  String get servicesPriceAdjustedHeader => 'Admin ne price adjust kiya';

  @override
  String servicesYourPricePer(String unit) {
    return 'Aapki price per $unit';
  }

  @override
  String get pricingEnterPriceSnack =>
      'Har activated subcategory ke liye ₹0 se zyada price daalein.';

  @override
  String get pricingPageTitle => 'Garment Pricing Rates';

  @override
  String get pricingCreateServiceFirst =>
      'Custom pricing rates set karne ke liye pehle ek laundry service banayein.';

  @override
  String pricingFailedToLoad(String error) {
    return 'Pricing load nahi ho payi: $error';
  }

  @override
  String pricingErrorLoadingServices(String error) {
    return 'Services load karne mein error: $error';
  }

  @override
  String get pricingSaveChangesButton => 'Changes Save Karein';

  @override
  String get pricingNoSubcategoriesPublished =>
      'Admin ne abhi tak is service ke liye koi subcategory publish nahi ki hai.';

  @override
  String pricingUnitBillingPer(String unit) {
    return 'Unit billing: per $unit';
  }

  @override
  String pricingDemoPriceChargeWhatYouLike(String price, String unit) {
    return 'Demo price: ₹$price/$unit — aap jo chahein charge kar sakte hain';
  }

  @override
  String get pricingPricesSaved => 'Prices save ho gayi';

  @override
  String pricingFailedToSavePrices(String error) {
    return 'Prices save karne mein fail: $error';
  }

  @override
  String get inventoryPageTitle => 'Operational Supplies';

  @override
  String get inventoryAddSupplyItemTitle => 'Supply Item Add Karein';

  @override
  String get inventoryItemNameLabel => 'Item Ka Naam';

  @override
  String get inventoryItemNameHint => 'Jaise: Collar Scrub';

  @override
  String get inventoryRequiredField => 'Zaroori';

  @override
  String get inventoryInitialQtyLabel => 'Initial Qty';

  @override
  String get inventoryMinLimitLabel => 'Min Limit';

  @override
  String get inventoryUnitLabel => 'Unit';

  @override
  String get inventoryUnitHint => 'Jaise: Liters, Bags, Cans';

  @override
  String get inventoryAddItemButton => 'Item Add Karein';

  @override
  String get inventoryItemAddedSnack => 'Item inventory mein add ho gaya';

  @override
  String get inventoryLowStockWarningTitle => 'Stock Kam Hai';

  @override
  String inventoryLowStockWarningBody(int count) {
    return '$count supplies kam ho rahi hain. Jaldi order karein.';
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
      'Capacity change ka request bheja gaya — admin approval pending';

  @override
  String slotsFailedToUpdateCapacity(String error) {
    return 'Capacity update karne mein fail: $error';
  }

  @override
  String slotsFailedGeneric(String error) {
    return 'Fail: $error';
  }

  @override
  String get slotsSlotDeletedSnack => 'Slot delete ho gaya';

  @override
  String get slotsClosingAfterOpening =>
      'Closing time opening time ke baad hona chahiye.';

  @override
  String get slotsOperationalWorkingHours => 'Operational Working Hours';

  @override
  String get slotsToLabel => 'se';

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
    return '$limit orders/day badalne ka request review mein pending hai.';
  }

  @override
  String get slotsMaxOrdersPerDayLabel => 'Max Orders per Day';

  @override
  String get slotsMaxOrdersHint => 'Jaise: 20';

  @override
  String get slotsRequiredField => 'Zaroori';

  @override
  String get slotsUpdateRequestButton => 'Request Update Karein';

  @override
  String get slotsUpdateButton => 'Update Karein';

  @override
  String slotsErrorLoading(String error) {
    return 'Load karne mein error: $error';
  }

  @override
  String get slotsWeeklySlotsSchedule => 'Weekly Slots Schedule';

  @override
  String get slotsNoCustomSlots =>
      'Koi custom slot set nahi hai. Working hours add karne ke liye \"+\" par tap karein.';

  @override
  String slotsMaxOrdersBadge(String count) {
    return 'Max $count orders';
  }

  @override
  String get slotsEditPickupTimeSlotTitle => 'Pickup Time Slot Edit Karein';

  @override
  String get slotsAddPickupTimeSlotTitle => 'Pickup Time Slot Add Karein';

  @override
  String get slotsDayOfWeekLabel => 'Din';

  @override
  String get slotsStartTimeLabel => 'Start Time';

  @override
  String get slotsStartTimeHint => 'Jaise: 09:00';

  @override
  String get slotsEndTimeLabel => 'End Time';

  @override
  String get slotsEndTimeHint => 'Jaise: 12:00';

  @override
  String get slotsMaxOrdersLimitLabel => 'Max Orders Limit';

  @override
  String get slotsMaxOrdersLimitHint => 'Jaise: 5';

  @override
  String get slotsInvalidNumber => 'Invalid number';

  @override
  String get slotsUpdateSlotButton => 'Slot Update Karein';

  @override
  String get slotsSaveSlotButton => 'Slot Save Karein';

  @override
  String get slotsSlotUpdatedSnack => 'Slot successfully update ho gaya';

  @override
  String get slotsPickupSlotAddedSnack => 'Pickup slot add ho gaya';

  @override
  String get slotsDayClosedError =>
      'Working Hours ke tahat chuna gaya din band hai.';

  @override
  String slotsOutsideWorkingHoursError(String open, String close) {
    return 'Slot ka time operational working hours ($open se $close) ke andar hona chahiye.';
  }

  @override
  String slotsOverlapError(String start, String end, String day) {
    return 'Ye slot $day ko existing slot $start - $end se overlap karta hai.';
  }

  @override
  String get analyticsWeekSegment => 'Week';

  @override
  String get analyticsMonthSegment => 'Month';

  @override
  String get analyticsFailedToLoad => 'Analytics load nahi ho paya';

  @override
  String get analyticsTotalRevenue => 'Total Revenue';

  @override
  String analyticsOrdersDeliveredSub(int count) {
    return '$count orders deliver hue';
  }

  @override
  String get analyticsAvgTicketSize => 'Avg Ticket Size';

  @override
  String get analyticsPerCompletedOrderSub => 'per completed order';

  @override
  String get analyticsFulfillmentRate => 'Fulfillment Rate';

  @override
  String analyticsOfTotalOrdersSub(int count) {
    return 'total $count orders mein se';
  }

  @override
  String get analyticsTotalOrders => 'Total Orders';

  @override
  String get analyticsInSelectedPeriodSub => 'selected period mein';

  @override
  String analyticsOrderVolumeLastNDays(int days) {
    return 'Order Volume (Last $days Days)';
  }

  @override
  String get analyticsNoOrdersRecorded =>
      'Is period mein koi order record nahi hai.';

  @override
  String get analyticsCategoryRevenueShare => 'Category Revenue Share';

  @override
  String get analyticsNoDeliveredOrders =>
      'Is period mein koi delivered order nahi hai.';

  @override
  String get analyticsSlaCustomerRetention => 'SLA & Customer Retention';

  @override
  String get analyticsOnTimeDelivery => 'On-Time Delivery';

  @override
  String get analyticsRepeatCustomers => 'Repeat Customers';

  @override
  String get employeesEditStaffTitle => 'Staff Member Edit Karein';

  @override
  String get employeesInviteStaffTitle => 'Staff Member Invite Karein';

  @override
  String get employeesFullNameLabel => 'Full Name';

  @override
  String get employeesFullNameHint => 'Jaise: John Doe';

  @override
  String get employeesNameRequired => 'Naam zaroori hai';

  @override
  String get employeesEmailLabel => 'Email Address';

  @override
  String get employeesEmailHint => 'Jaise: johndoe@lndry.com';

  @override
  String get employeesEmailRequired => 'Email zaroori hai';

  @override
  String get employeesEmailInvalid => 'Invalid email';

  @override
  String get employeesPhoneOptionalLabel => 'Phone Number (Optional)';

  @override
  String get employeesPhoneHint => 'Jaise: 9876543210';

  @override
  String get employeesShopRoleLabel => 'Shop Role';

  @override
  String get employeesRoleOwner => 'Vendor Owner (Admin)';

  @override
  String get employeesRoleStaff => 'Vendor Staff';

  @override
  String get employeesPermissionsHeader => 'Permissions';

  @override
  String get employeesPermReadOrders => 'Orders Dekhein';

  @override
  String get employeesPermProcessOrders => 'Orders Process & Confirm Karein';

  @override
  String get employeesPermManageCatalog => 'Services & Pricing Manage Karein';

  @override
  String get employeesPermManageEmployees => 'Employees Manage Karein';

  @override
  String get employeesSaveChangesButton => 'Changes Save Karein';

  @override
  String get employeesInviteStaffButton => 'Staff Invite Karein';

  @override
  String get employeesStaffUpdatedSnack => 'Staff record update ho gaya';

  @override
  String get employeesInvitationSentSnack => 'Invitation bhej diya gaya';

  @override
  String employeesResetPasswordTitle(String name) {
    return '$name Ke Liye Password Reset Karein';
  }

  @override
  String get employeesNewPasswordLabel => 'New Password';

  @override
  String get employeesNewPasswordHint =>
      'Kam se kam 8 characters, 1 letter aur 1 digit ke saath';

  @override
  String get employeesPasswordTooShort => 'Password bahut chota hai';

  @override
  String get employeesPasswordUpdatedSnack =>
      'Password successfully update ho gaya';

  @override
  String employeesResetFailedSnack(String error) {
    return 'Reset fail: $error';
  }

  @override
  String get employeesRemoveStaffTitle => 'Staff Member Hatayein';

  @override
  String employeesRemoveStaffConfirm(String name) {
    return 'Kya aap sach mein $name ko is shop se hatana chahte hain?';
  }

  @override
  String get employeesConfirmRemoveButton => 'Remove Confirm Karein';

  @override
  String get employeesStaffRemovedSnack => 'Staff member hata diya gaya';

  @override
  String get employeesPageTitle => 'Shop Employees';

  @override
  String get employeesEmptyTitle => 'Koi Employee Nahi Mila';

  @override
  String get employeesEmptySubtitle =>
      'Laundry intake, status updates aur dispatch mein madad ke liye staff invite karein.';

  @override
  String get employeesOwnerBadge => 'OWNER';

  @override
  String get employeesStaffBadge => 'STAFF';

  @override
  String get employeesResetPassButton => 'Password Reset';

  @override
  String get employeesSavePasswordButton => 'Password Save Karein';

  @override
  String get employeesPermissionsButton => 'Permissions';

  @override
  String employeesFailedToLoad(String error) {
    return 'Employees load nahi ho paaye: $error';
  }

  @override
  String get riderManagementAddRiderTitle => 'Captain Add Karein';

  @override
  String get riderManagementAddRiderSubtitle =>
      'Captain isi phone number se login karega, jaise aap karte hain.';

  @override
  String get riderManagementFullNameHint => 'Jaise: Rahul Sen';

  @override
  String get riderManagementPhoneLabel => 'Phone Number';

  @override
  String get riderManagementPhoneInvalid =>
      'Ek valid 10 digit ka mobile number daalein.';

  @override
  String get riderManagementRiderAddedSnack => 'Captain add ho gaya';

  @override
  String get riderManagementRemoveRiderTitle => 'Captain Hatayein';

  @override
  String riderManagementRemoveConfirm(String name) {
    return 'Kya aap sach mein $name ko hatana chahte hain?';
  }

  @override
  String get riderManagementPageTitle => 'Captain Management';

  @override
  String get riderManagementEmptyTitle => 'Abhi Tak Koi Captain Nahi';

  @override
  String get riderManagementEmptySubtitle =>
      'Apne khud ke delivery captains add karein — wo apne phone se login karte hain aur sirf apni assigned pickups aur deliveries dekhte hain.';

  @override
  String riderManagementFailedToLoad(String error) {
    return 'Captains load nahi ho paaye: $error';
  }

  @override
  String riderMyJobsTitleWithVendor(String vendor) {
    return '$vendor — Mere Jobs';
  }

  @override
  String get riderMyJobsTitle => 'Mere Jobs';

  @override
  String get riderNoJobsTitle => 'Abhi Koi Job Nahi';

  @override
  String get riderNoJobsSubtitle =>
      'Aapko assign kiye gaye pickup aur delivery jobs yahan dikhenge.';

  @override
  String riderFailedToLoadJobs(String error) {
    return 'Jobs load nahi ho paaye: $error';
  }

  @override
  String get riderPickupBadge => 'PICKUP';

  @override
  String get riderDeliveryBadge => 'DELIVERY';

  @override
  String get riderInProgressBadge => 'IN PROGRESS';

  @override
  String get riderOtpEnterCode => '6-digit code daalein';

  @override
  String get riderOtpPickupConfirmedSnack => 'Pickup confirm ho gaya';

  @override
  String get riderOtpDeliveryConfirmedSnack => 'Delivery confirm ho gayi';

  @override
  String get riderOtpInvalidExpired =>
      'Invalid ya expired code. Dobara try karein.';

  @override
  String get riderConfirmPickupTitle => 'Pickup Confirm Karein';

  @override
  String get riderConfirmDeliveryTitle => 'Delivery Confirm Karein';

  @override
  String get riderOtpPrompt =>
      'Customer se unke app mein dikha code puchein, phir neeche daalein.';

  @override
  String get riderNoLocationSnack =>
      'Is address ke liye koi location available nahi hai';

  @override
  String get riderCouldNotOpenMaps => 'Google Maps nahi khul saka';

  @override
  String riderCouldNotStartPickup(String error) {
    return 'Pickup shuru nahi ho saka: $error';
  }

  @override
  String riderCouldNotStartDelivery(String error) {
    return 'Delivery shuru nahi ho saki: $error';
  }

  @override
  String get riderCancelPickupNotAvailable =>
      'Pickup cancel karna abhi available nahi hai.';

  @override
  String get riderJobDetailTitle => 'Job Detail';

  @override
  String riderFailedToLoadJob(String error) {
    return 'Job load nahi ho saka: $error';
  }

  @override
  String get riderItemsHeader => 'Items';

  @override
  String get riderNavigateButton => 'Navigate Karein';

  @override
  String riderPaymentPending(String amount) {
    return 'Payment Pending – $amount';
  }

  @override
  String get riderFullPaymentCompleted => 'Poora Payment Ho Gaya';

  @override
  String get riderRefreshPaymentTooltip => 'Payment status refresh karein';

  @override
  String get riderCustomerPaymentPendingSnack =>
      'Customer ka payment abhi bhi pending hai. Delivery complete nahi ki ja sakti.';

  @override
  String get riderStartPickupButton => 'Pickup Shuru Karein';

  @override
  String get riderStartDeliveryButton => 'Delivery Shuru Karein';

  @override
  String get riderPickUpButton => 'Pick Up Karein';

  @override
  String get riderMarkDeliveredButton => 'Delivered Mark Karein';

  @override
  String get riderCancelPickupButton => 'Pickup Cancel Karein';

  @override
  String get riderConfirmWeightCountTitle => 'Weight & Count Confirm Karein';

  @override
  String get riderWeighRecountPrompt =>
      'Abhi customer ke items ko taulein aur ginein — ye pickup confirm hone se pehle unke andaze ko sahi karta hai.';

  @override
  String get riderWeightAreaBasedHeader => 'Weight / Area Based';

  @override
  String riderEnterExactUnit(String unit) {
    return 'Exact $unit daalein';
  }

  @override
  String get riderPieceBasedHeader => 'Piece Based';

  @override
  String riderFailedSaveMeasurements(String error) {
    return 'Measurements save nahi ho paaye: $error';
  }

  @override
  String get riderSaveContinueButton => 'Save Karein & Continue Karein';

  @override
  String riderWeightBasedItemsLabel(String items) {
    return 'Weight-based items ($items)';
  }

  @override
  String riderMaxPhotosPerItem(String max) {
    return 'Har item ke liye max $max photos.';
  }

  @override
  String riderFailedSavePhotos(String error) {
    return 'Photos save nahi ho payi: $error';
  }

  @override
  String get riderGarmentConditionPhotosTitle => 'Garment Condition Photos';

  @override
  String get riderPhotographEachItemPrompt =>
      'Pickup se pehle har item ki photo lein — isse damage dispute hone par aap aur customer dono safe rehte hain.';

  @override
  String riderPhotosCountLabel(String count, String max) {
    return '$count/$max photos · 1 zaroori, baaki optional';
  }

  @override
  String get riderSaveButton => 'Save Karein';

  @override
  String get riderCollectBalanceTitle => 'Balance Collect Karein';

  @override
  String get riderBalanceDueLabel => 'Balance Due';

  @override
  String get riderPaymentMethodCod => 'Payment method: Cash on Delivery';

  @override
  String get riderPaymentMethodOnline => 'Payment method: Online';

  @override
  String get riderNoBalanceDueBanner =>
      'Is order ke liye koi balance due nahi hai.';

  @override
  String get riderCustomerPaysOnlineBanner =>
      'Customer ye balance apne app mein online pay karta hai. Aapko kuch karne ki zaroorat nahi hai.';

  @override
  String get riderCashCollectionRecordedBanner =>
      'Cash collection record ho gaya.';

  @override
  String riderFailedRecordCashCollection(String error) {
    return 'Cash collection record nahi ho saka: $error';
  }

  @override
  String riderConfirmCashCollectedButton(String amount) {
    return '$amount Cash Collect Hone Ki Confirm Karein';
  }

  @override
  String get riderContinueButton => 'Continue Karein';

  @override
  String get riderDeliveryPhotoTitle => 'Delivery Photo';

  @override
  String get riderOptionalPhotoPrompt =>
      'Optional taur par handover ki photo lein, delivery proof ke roop mein. Ye skip kiya ja sakta hai.';

  @override
  String get riderTakePhotoLabel => 'Photo Lein';

  @override
  String riderFailedSavePhoto(String error) {
    return 'Photo save nahi ho payi: $error';
  }

  @override
  String get riderSkipContinueButton => 'Skip Karein & Continue Karein';

  @override
  String get notificationsJustNow => 'Abhi abhi';

  @override
  String notificationsMinsAgo(int mins) {
    return '$mins min pehle';
  }

  @override
  String notificationsHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ghante pehle',
      one: '1 ghanta pehle',
    );
    return '$_temp0';
  }

  @override
  String notificationsDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days din pehle',
      one: '1 din pehle',
    );
    return '$_temp0';
  }

  @override
  String get notificationsPageTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Sabko Read Mark Karein';

  @override
  String notificationsFailedToLoad(String error) {
    return 'Notifications load nahi ho payin: $error';
  }

  @override
  String get notificationsEmptyTitle => 'Abhi tak koi notification nahi';

  @override
  String get notificationsEmptySubtitle =>
      'Operational push updates, payment alerts aur admin pricing notes yahan dikhenge.';

  @override
  String get profileUpdatedSnack => 'Profile successfully update ho gayi';

  @override
  String get profileCropLogoTitle => 'Logo Crop Karein';

  @override
  String get profileCropBannerTitle => 'Banner Image Crop Karein';

  @override
  String get profileLogoUpdatedSnack => 'Logo update ho gaya';

  @override
  String get profileBannerUpdatedSnack => 'Banner image update ho gayi';

  @override
  String profileFailedUploadImage(String error) {
    return 'Image upload nahi ho payi: $error';
  }

  @override
  String get profileLogoutTitle => 'Logout';

  @override
  String get profileLogoutConfirm =>
      'Kya aap really apne vendor account se logout karna chahte hain?';

  @override
  String get profilePublishedSnack =>
      'Marketplace par publish ho gaya — customers ab aapko dhundh sakte hain.';

  @override
  String profileFailedToPublish(String error) {
    return 'Publish nahi ho paya: $error';
  }

  @override
  String get profilePageTitle => 'Meri Profile';

  @override
  String get profileBestFitNote =>
      'Best fit — Logo: 500×500px square. Banner: 780×1080px portrait. Bilkul waise jaise customers aapki shop dekhte hain, taaki kuch stretch ya galat crop na ho.';

  @override
  String get profileEditBusinessDetails => 'Business Details Edit Karein';

  @override
  String get profileBusinessNameLabel => 'Business Ka Naam';

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
  String get profileVerifiedPhoneLabel =>
      'Verified Phone (change nahi ho sakta)';

  @override
  String get profileNotSetValue => 'Set nahi hai';

  @override
  String get profileAddressFieldLabel => 'Address';

  @override
  String get profileAccountSection => 'Account';

  @override
  String get profileNotificationsSubtitle => 'Order alerts aur updates dekhein';

  @override
  String get profileSettingsSubtitle => 'App preferences aur theme';

  @override
  String get profileBusinessSection => 'Business';

  @override
  String get profileCatalogueSubtitle =>
      'Category choose karein, subcategories activate karein, apni prices set karein';

  @override
  String get profilePublishLabel => 'Marketplace Par Publish Karein';

  @override
  String get profilePublishSubtitle =>
      'Apni shop ko customers ke liye discoverable banayein';

  @override
  String get profileStaffLabel => 'Staff Management';

  @override
  String get profileStaffSubtitle => 'Employees add aur manage karein';

  @override
  String get profileRiderSubtitle =>
      'Apne delivery captains add aur manage karein';

  @override
  String get profileSlotsLabel => 'Pickup Slots';

  @override
  String get profileSlotsSubtitle => 'Availability aur capacity manage karein';

  @override
  String get profileInventoryLabel => 'Inventory & Supplies';

  @override
  String get profileInventorySubtitle =>
      'Laundry supplies aur stock track karein';

  @override
  String get profileSupportSection => 'Support';

  @override
  String get profileHelpLabel => 'Help & Support';

  @override
  String get profileHelpSubtitle => 'Hamari partner team se help lein';

  @override
  String get profileAboutLabel => 'LNDRY Ke Baare Mein';

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
      'Aapka application load nahi ho paya. Please phir try karein.';

  @override
  String get onboardingUploadAllDocuments =>
      'Submit karne se pehle please saare required documents upload karein.';

  @override
  String get onboardingUploadDocumentsToContinue =>
      'Aage badhne ke liye please saare required documents upload karein.';

  @override
  String get onboardingVendorApplicationTitle => 'Vendor Application';

  @override
  String get onboardingApplicationSubmittedTitle =>
      'Application Submit Ho Gaya';

  @override
  String get onboardingApplicationSubmittedBody =>
      'Aapka application hamari team ke review mein hai. Approve hone par hum aapko inform karenge.';

  @override
  String get onboardingLogOutButton => 'Log Out';

  @override
  String onboardingStepOfTotal(int current, int total, String title) {
    return 'Step $current / $total: $title';
  }

  @override
  String get onboardingCorrectionNeeded => 'Correction Zaroori Hai';

  @override
  String get onboardingCorrectionOnlyFlaggedEditable =>
      'Sirf upar diye gaye sections edit kiye ja sakte hain — baaki sab waise hi locked hai jaise aapne originally submit kiya tha.';

  @override
  String get onboardingBusinessNameLabel => 'Business Ka Naam';

  @override
  String get onboardingBusinessNameHint => 'Jaise: Sparkle Laundry Co.';

  @override
  String get onboardingBusinessNameRequired => 'Business ka naam required hai';

  @override
  String get onboardingDescriptionHint =>
      'Customers ko batayein aapki shop kis cheez mein specialize karti hai';

  @override
  String get onboardingGstLabel => 'GST Number (Optional)';

  @override
  String get onboardingPanLabel => 'PAN Number (Optional)';

  @override
  String get onboardingOwnerNameLabel => 'Owner Ka Naam';

  @override
  String get onboardingOwnerNameHint => 'Shop owner ka pura naam';

  @override
  String get onboardingOwnerNameRequired => 'Owner ka naam required hai';

  @override
  String get onboardingEmailOptionalLabel => 'Email (Optional)';

  @override
  String get onboardingBankDetailsOptionalHeader => 'Bank Details (Optional)';

  @override
  String get onboardingBankAccountLabel => 'Bank Account Number';

  @override
  String get onboardingIfscLabel => 'IFSC Code';

  @override
  String get onboardingBankNameLabel => 'Bank Ka Naam';

  @override
  String get onboardingAccountHolderLabel => 'Account Holder Ka Naam';

  @override
  String get onboardingDetectingLocation => 'Detect kiya ja raha hai…';

  @override
  String get onboardingUseCurrentLocation => 'Current Location Use Karein';

  @override
  String get onboardingAddressLine1Hint => 'Shop / building ka naam';

  @override
  String get onboardingAddressRequired => 'Address required hai';

  @override
  String get onboardingAddressLine2Label => 'Address Line 2 (Optional)';

  @override
  String get onboardingPincodeRequired => 'Pincode required hai';

  @override
  String get onboardingPincodeInvalid => 'Ek valid 6-digit pincode daalein';

  @override
  String onboardingDetectedCoords(String lat, String lng) {
    return 'Detect hua: $lat, $lng';
  }

  @override
  String get onboardingRadiusQuestion =>
      'Humein aapki shop ke aas-paas kitni door tak customers dhundhne chahiye?';

  @override
  String onboardingKmValue(String km) {
    return '$km km';
  }

  @override
  String get onboardingCapacityQuestion =>
      'Aap roz kitne orders handle kar sakte hain?';

  @override
  String get onboardingCustomLabel => 'Custom';

  @override
  String get onboardingUploadDocumentsPrompt =>
      'Apna application complete karne ke liye ye upload karein.';

  @override
  String get onboardingOwnerIdentityTitle => 'Owner Identity';

  @override
  String get onboardingShopPhotoTitle => 'Shop Photo';

  @override
  String get onboardingServiceListTitle => 'Service List (PDF)';

  @override
  String get onboardingReplaceButton => 'Replace Karein';

  @override
  String get onboardingUploadButton => 'Upload Karein';

  @override
  String get onboardingUploadedLabel => 'Upload Ho Gaya';

  @override
  String get onboardingReviewPrompt =>
      'Submit karne se pehle apna detail check karein.';

  @override
  String get onboardingReviewOwner => 'Owner';

  @override
  String get onboardingReviewServiceRadius => 'Service Radius';

  @override
  String get onboardingReviewDailyCapacity => 'Daily Capacity';

  @override
  String onboardingOrdersPerDay(int count) {
    return '$count orders/din';
  }

  @override
  String get onboardingReviewOwnerIdentity => 'Owner Identity';

  @override
  String get onboardingReviewShopPhoto => 'Shop Photo';

  @override
  String get onboardingReviewServiceList => 'Service List';

  @override
  String get onboardingMissingLabel => 'Missing';

  @override
  String get onboardingBackButton => 'Back';

  @override
  String get onboardingSubmitApplicationButton => 'Application Submit Karein';

  @override
  String get onboardingNextButton => 'Next';

  @override
  String get helpFaq1Q => 'Main order kaise accept karun?';

  @override
  String get helpFaq1A =>
      'Jab koi naya order aata hai, to ye aapke dashboard par \"New Incoming Orders\" ke under dikhta hai. Confirm karne ke liye \"Accept\" par tap karein, ya agar aap complete nahi kar sakte to \"Reject\" par tap karein. Accepted orders, Orders ke Active tab mein chale jaate hain.';

  @override
  String get helpFaq2Q => 'Payment kaise kaam karta hai?';

  @override
  String get helpFaq2A =>
      'LNDRY har 7 din mein vendor payments process karta hai. Platform fee (₹15 per order) aur GST kaatne ke baad, baaki amount NEFT/IMPS ke through aapke registered bank account mein transfer ho jaata hai.';

  @override
  String get helpFaq3Q => 'Main apne working hours kaise change karun?';

  @override
  String get helpFaq3A =>
      'Profile → Pickup Slots par jaayein (ya dashboard par Quick Actions → Slots). Yahan aap week ke har din ke liye time slots add, edit, ya remove kar sakte hain. Aap individual slots on/off bhi kar sakte hain.';

  @override
  String get helpFaq4Q => 'Main customer se contact kaise karun?';

  @override
  String get helpFaq4A =>
      'Us order ki Order Details page kholein. Aapko customer ka naam aur ek \"Call Customer\" button dikhega jo directly unhe call karta hai. Note: order accept hone tak customer ka pura phone number privacy ke liye hidden rehta hai.';

  @override
  String get helpFaq5Q => '\"Pending\" status ka kya matlab hai?';

  @override
  String get helpFaq5A =>
      'Pending orders wo naye orders hain jo customers ne place kiye hain aur aapki acceptance ka wait kar rahe hain. Inhe accept ya reject karne ke liye aapke paas ek time limit hoti hai. Time limit khatam hone ke baad, ye automatically reject ho jaate hain.';

  @override
  String get helpFaq6Q => 'Main garment prices kaise update karun?';

  @override
  String get helpFaq6A =>
      'Profile → Garment Pricing par jaayein ya Catalog tab use karein. Ek service select karein, phir individual garment rates add/edit/remove karein. Changes naye orders ke liye turant apply ho jaate hain.';

  @override
  String get helpFaq7Q => 'Kya main multiple employees manage kar sakta hun?';

  @override
  String get helpFaq7A =>
      'Haan. Profile → Staff Management par jaayein. Aap employees add kar sakte hain, roles (Manager, Washer, Ironer, Packer) assign kar sakte hain, permissions set kar sakte hain, unki active status toggle kar sakte hain, aur unke password reset kar sakte hain.';

  @override
  String get helpFaq8Q => 'Platform fee kya hai?';

  @override
  String get helpFaq8A =>
      'LNDRY aapko customers se connect karne, payment processing aur operational support ke liye per order ₹15 ka platform fee charge karta hai. GST 18% sirf platform fee par apply hota hai.';

  @override
  String get helpTicketCreatedSnack =>
      'Support ticket ban gaya! Hum 24 hours ke andar reply karenge.';

  @override
  String helpFailedCreateTicket(String error) {
    return 'Ticket create nahi ho paya: $error';
  }

  @override
  String get helpCreateSupportTicketTitle => 'Support Ticket Banayein';

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
  String get helpSubjectHint => 'Apni problem ka short description';

  @override
  String get helpDescriptionHint =>
      'Apni problem ke baare mein zyada detail dein...';

  @override
  String get helpDescriptionTooShort => 'Please zyada detail dein';

  @override
  String get helpSubmitTicketButton => 'Ticket Submit Karein';

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
      'Hum help ke liye yahan hain! Neeche diye gaye kisi bhi medium se humse contact karein.\nMon–Sat, 9 AM – 7 PM tak available.';

  @override
  String get helpReachUsHeader => 'Humse Contact Karein';

  @override
  String get helpCallSupportTitle => 'Call Support';

  @override
  String get helpCallSupportSubtitle => '+91 1800-123-5678 (Toll Free)';

  @override
  String get helpCallNowAction => 'Abhi Call Karein';

  @override
  String get helpCallingSnack => 'LNDRY Support ko call kiya ja raha hai...';

  @override
  String get helpEmailSupportTitle => 'Email Support';

  @override
  String get helpSendEmailAction => 'Email Bhejein';

  @override
  String get helpOpeningEmailSnack => 'Email client khola ja raha hai...';

  @override
  String get helpWhatsappSupportTitle => 'WhatsApp Support';

  @override
  String get helpOpenWhatsappAction => 'WhatsApp Kholein';

  @override
  String get helpOpeningWhatsappSnack => 'WhatsApp khola ja raha hai...';

  @override
  String get helpCreateTicketSubtitle =>
      'Ticket ID ke saath apni problem track karein';

  @override
  String get helpCreateTicketAction => 'Ticket Banayein';

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
      'Apna answer nahi mila? Support ticket banayein.';

  @override
  String get helpCreateAction => 'Banayein';

  @override
  String get helpFailedToLoadTickets => 'Tickets load nahi ho paye';

  @override
  String get helpNoTicketsYet => 'Abhi tak koi ticket nahi';

  @override
  String get helpNoTicketsSubtitle =>
      'Ticket banayein aur hum 24 hours ke andar reply karenge.';

  @override
  String get helpCreateNewTicketButton => 'Naya Ticket Banayein';

  @override
  String get helpYourTicketsHeader => 'Aapke Tickets';

  @override
  String get helpStatusReplied => 'Replied';

  @override
  String get helpStatusOpen => 'Open';

  @override
  String get helpStatusClosed => 'Closed';

  @override
  String get ticketYouLabel => 'Aap';

  @override
  String get ticketSupportTeamLabel => 'Support Team';

  @override
  String get ticketWaitingForReplyBanner =>
      'Hamari support team ke reply ka wait hai. Hum usually 24 hours ke andar reply karte hain.';

  @override
  String get ticketAreYouSatisfied => 'Kya aap is reply se satisfied hain?';

  @override
  String get ticketYesButton => 'Haan';

  @override
  String get ticketNoButton => 'Nahi';

  @override
  String get ticketRateExperience => 'Apne support experience ko rate karein';

  @override
  String get ticketSubmitRatingButton => 'Rating Submit Karein';

  @override
  String get ticketWhatWouldYouAsk => 'Aap kya puchna chahenge?';

  @override
  String get ticketTypeMessageHint => 'Apna message type karein...';

  @override
  String get ticketSendButton => 'Send Karein';

  @override
  String get ticketThanksForFeedback => 'Aapke feedback ke liye dhanyavaad!';

  @override
  String ticketFailedSubmitRating(String error) {
    return 'Rating submit nahi ho payi: $error';
  }

  @override
  String get ticketMessageSentSnack =>
      'Aapka message hamari support team ko bhej diya gaya.';

  @override
  String ticketFailedToSend(String error) {
    return 'Bhejne mein fail: $error';
  }

  @override
  String get ticketYourRatingHeader => 'Aapki Rating';

  @override
  String get ticketClosedByTeamBanner =>
      'Ye ticket hamari support team dwara close kar diya gaya hai.';

  @override
  String get employeesAddStaffButton => 'Staff Jodein';

  @override
  String get employeesPhoneRequiredLabel => 'Phone Number';

  @override
  String get employeesPhoneRequiredError =>
      'Sahi 10 digit ka phone number daalein — staff isi se login karega';

  @override
  String get employeesPermissionsRequired => 'Kam se kam ek permission chunein';

  @override
  String get employeesPermissionsLoadFailed =>
      'Permission list load nahi ho payi';

  @override
  String get employeesPermissionsHint =>
      'Sirf wahi sections khulenge jo aap on karenge.';

  @override
  String get employeesStaffOnlyNote =>
      'Staff main Partner app mein login karta hai. Captains ko Captain Management mein add karein.';

  @override
  String get permModuleOrders => 'Orders';

  @override
  String get permOrdersView => 'Orders Dekhein';

  @override
  String get permOrdersAcceptReject => 'Naye Orders Accept / Reject Karein';

  @override
  String get permOrdersProcess => 'Processing & Status Update';

  @override
  String get permOrdersReevaluate => 'Re-evaluation';

  @override
  String get permOrdersAssignCaptain => 'Captains Ko Assign / Broadcast Karein';

  @override
  String get permModuleCatalogue => 'Catalogue & Pricing';

  @override
  String get permCatalogueView => 'Services & Pricing Dekhein';

  @override
  String get permCatalogueManage => 'Services & Pricing Manage Karein';

  @override
  String get permModuleInventory => 'Inventory';

  @override
  String get permInventoryView => 'Inventory Dekhein';

  @override
  String get permInventoryManage => 'Inventory Manage Karein';

  @override
  String get permModuleSlots => 'Pickup Slots';

  @override
  String get permSlotsView => 'Pickup Slots Dekhein';

  @override
  String get permSlotsManage => 'Pickup Slots & Capacity Manage Karein';

  @override
  String get permModuleAnalytics => 'Analytics';

  @override
  String get permAnalyticsView => 'Analytics Dekhein';

  @override
  String get errorGeneric =>
      'Kuch gadbad ho gayi. Kripya phir se koshish karein.';

  @override
  String get errorNetwork =>
      'Server tak nahi pahunch sake. Apna internet check karein aur phir koshish karein.';

  @override
  String get errorTimeout =>
      'Request mein bahut time laga. Kripya phir se koshish karein.';

  @override
  String get errorServerBusy =>
      'Server abhi busy hai. Kripya thodi der mein phir koshish karein.';

  @override
  String get inventoryLoadFailed => 'Aapki supplies load nahi ho saki.';

  @override
  String get inventoryEmptyTitle => 'Abhi koi supply nahi';

  @override
  String get inventoryEmptySubtitle =>
      'Pehla supply item jodne ke liye + dabayein.';

  @override
  String get notifOffBannerMessage =>
      'Notifications band hain, isliye aap naye orders aur job offers miss kar sakte hain.';

  @override
  String get notifOffBannerAction => 'Chalu karein';

  @override
  String get ordersAssistedBadge => 'Assisted Booking';

  @override
  String get ordersAssistedSummary => 'Service chunna zaroori hai';

  @override
  String get ordersAssistedPriceTbd => 'Evaluate hona baaki hai';

  @override
  String get orderDetailsAssistedTitle =>
      'Assisted Booking / Service Chunna Zaroori';

  @override
  String get orderDetailsAssistedBody =>
      'Customer ne \"Book With Expert Check\" chuna hai, isliye koi service ya price select nahi hui. Kapde aap tak pahunchne par unhein check karein aur \"Services Chunein\" se sahi services, quantity ya weight chunein. Processing shuru hone se pehle customer price approve karega.';

  @override
  String get orderDetailsAssistedChooseServices => 'Services Chunein';

  @override
  String get orderDetailsAssistedNoServicesYet =>
      'Abhi koi service select nahi hui. Kapde check karein aur services chunein.';

  @override
  String get orderDetailsAssistedSheetTitle => 'Services Chunein';

  @override
  String get orderDetailsAssistedSheetSubtitle =>
      'Har tarah ke kapde ke liye quantity ya weight ke saath ek service add karein. Processing continue hone se pehle yeh customer approval ke liye bheja jayega. Photos optional hain.';

  @override
  String get orderDetailsAssistedAddServiceRequired =>
      'Approval ke liye bhejne se pehle kam se kam ek service add karein.';

  @override
  String get loginSessionEnded =>
      'Aapka session khatam ho gaya hai. Aage badhne ke liye kripya dobara login karein.';

  @override
  String get posModeMarketplace => 'Marketplace';

  @override
  String get posModePos => 'POS (Counter)';

  @override
  String get posAppModeTitle => 'App mode';

  @override
  String get posAppModeSubtitle =>
      'Abhi aap kya use karna chahte hain, chunein.';

  @override
  String posAppModeSwitched(String mode) {
    return '$mode par badal gaya';
  }

  @override
  String get posAppModeNotAllowed =>
      'Yeh mode aapki dukaan ke liye uplabdh nahin hai.';

  @override
  String get posGetPosTitle => 'Meri dukaan ke liye POS lein';

  @override
  String get posGetPosSubtitle =>
      'Dukaan par aane wale customers ke bill banayein aur record rakhein.';

  @override
  String get posFinishSetupTitle => 'POS setup poora karein';

  @override
  String get posFinishSetupSubtitle =>
      'POS use karne ke liye bas kuch kadam baaki hain.';

  @override
  String get posChoiceTitle => 'Aapko kya chahiye?';

  @override
  String get posChoiceSubtitle =>
      'Shuru karne ke liye ek chunein. Doosra baad mein jod sakte hain.';

  @override
  String get posChoiceMarketplaceTitle => 'Customers paayein';

  @override
  String get posChoiceMarketplaceBody =>
      'LNDRY customer app se order paayein. Dukaan ki jaankari aur documents chahiye.';

  @override
  String get posChoicePosTitle => 'Meri dukaan chalayein (POS)';

  @override
  String get posChoicePosBody =>
      'Counter par bill banayein, customers ka record rakhein aur paison ka hisaab dekhein. Lagbhag 3 minute mein taiyaar.';

  @override
  String get posChoiceBothHint =>
      'Dono chahiye? Pehle Marketplace chunein, phir Settings mein POS chalu karein.';

  @override
  String get posModeCheckLoading => 'Aapki dukaan taiyaar ho rahi hai…';

  @override
  String get posOnbTitle => 'POS setup';

  @override
  String posOnbStepOf(int current, int total) {
    return 'Step $current / $total';
  }

  @override
  String get posOnbStepShop => 'Dukaan ki jaankari';

  @override
  String get posOnbStepTax => 'Tax aur bhugtaan';

  @override
  String get posOnbStepCounter => 'Counter setup';

  @override
  String get posOnbStepPrices => 'Rate list';

  @override
  String get posOnbShopName => 'Dukaan ka naam';

  @override
  String get posOnbOwnerName => 'Maalik ka naam';

  @override
  String get posOnbAddress => 'Dukaan ka pata';

  @override
  String get posOnbCity => 'Shehar';

  @override
  String get posOnbState => 'Rajya (optional)';

  @override
  String get posOnbPincode => 'Pincode (optional)';

  @override
  String get posOnbGstSwitch => 'Meri dukaan GST mein registered hai';

  @override
  String get posOnbGstin => 'GSTIN (15 akshar)';

  @override
  String get posOnbUpi => 'UPI ID (optional)';

  @override
  String get posOnbUpiHint => 'jaise name@bank';

  @override
  String get posOnbInvoicePrefix => 'Invoice ki shuruaat';

  @override
  String get posOnbPrinter => 'Printer';

  @override
  String get posPrinterNone => 'Koi printer nahin';

  @override
  String get posPrinterSystem => 'Phone / system printer';

  @override
  String get posPrinter58 => 'Thermal 58 mm';

  @override
  String get posPrinter80 => 'Thermal 80 mm';

  @override
  String get posOnbOrderPrefix => 'Order number ki shuruaat';

  @override
  String get posOnbDeliveryDays => 'Aam delivery time (din)';

  @override
  String get posOnbPricesTitle => 'Apni rate list shuru karein';

  @override
  String get posOnbPricesStarter => 'Sample rate list use karein';

  @override
  String get posOnbPricesStarterBody =>
      'Hum aam kapde aur services sample rate ke saath jod denge. Kripya rate dekhkar badal lein.';

  @override
  String get posOnbPricesOwn => 'Main khud jodunga';

  @override
  String get posOnbPricesOwnBody =>
      'Khaali shuru karein aur apne kapde va rate khud jodein.';

  @override
  String get posNext => 'Aage';

  @override
  String get posBack => 'Peeche';

  @override
  String get posFinish => 'Setup poora karein';

  @override
  String get posSaving => 'Save ho raha hai…';

  @override
  String get posErrShopName => 'Apni dukaan ka naam likhein';

  @override
  String get posErrOwnerName => 'Maalik ka naam likhein';

  @override
  String get posErrAddress => 'Apni dukaan ka pata likhein';

  @override
  String get posErrCity => 'Apna shehar likhein';

  @override
  String get posErrPincode => 'Pincode 6 ankon ka hona chahiye';

  @override
  String get posErrGstin => 'Sahi 15 akshar ka GSTIN likhein';

  @override
  String get posErrUpi => 'UPI ID aisa hona chahiye: name@bank';

  @override
  String get posErrPrefix => '1 se 6 akshar ya ank likhein';

  @override
  String get posErrDays => '0 se 30 ke beech ki sankhya likhein';

  @override
  String get posDoneTitle => 'Aapki dukaan taiyaar hai!';

  @override
  String get posDoneBody => 'Home screen se apna pehla order book karein.';

  @override
  String posDoneStarterNote(int count) {
    return '$count sample kapde jode gaye hain. Kripya unke rate dekh lein.';
  }

  @override
  String get posDoneButton => 'POS kholein';

  @override
  String get posOnbOwnerOnlyTitle => 'Dukaan ke maalik se kahein';

  @override
  String get posOnbOwnerOnlyBody =>
      'POS setup dukaan ke maalik ko poora karna hoga.';

  @override
  String get posLogOut => 'Log out';

  @override
  String get posTabHome => 'Home';

  @override
  String get posTabOrder => 'Order';

  @override
  String get posTabSearch => 'Khojein';

  @override
  String get posTabExpense => 'Kharch';

  @override
  String get posTabReport => 'Report';

  @override
  String get posTabSetting => 'Setting';

  @override
  String get posComingSoonTitle => 'Jald aa raha hai';

  @override
  String get posComingSoonBody => 'POS ka yeh hissa taiyaar ho raha hai.';

  @override
  String posHomeWelcome(String shop) {
    return 'Swagat hai, $shop';
  }

  @override
  String get posHomeReady =>
      'Aapka POS taiyaar hai. Order booking, customers aur rate agle update mein aayenge.';

  @override
  String get posSettingsTitle => 'Setting';

  @override
  String get posSettingsShop => 'Dukaan';

  @override
  String get posHomeToday => 'Aaj';

  @override
  String get posTileRevenue => 'Aaj ki kamai';

  @override
  String get posTileCollection => 'Vasooli';

  @override
  String get posTileOrderRequests => 'Order request';

  @override
  String get posTileWashingToStore => 'Dhulai se store';

  @override
  String get posTileBooking => 'Booking';

  @override
  String get posTileDelivery => 'Delivery';

  @override
  String get posTileDelivered => 'Deliver hue';

  @override
  String get posTilePending => 'Baaki order';

  @override
  String get posQuickActions => 'Jaldi karein';

  @override
  String get posActionBook => 'Order book karein';

  @override
  String get posActionAddCustomer => 'Customer jodein';

  @override
  String get posActionAddPrice => 'Kapde ka rate jodein';

  @override
  String get posTasksTitle => 'Karne ke kaam';

  @override
  String get posTaskUnassignedPickups => 'Pickup ke liye captain chunein';

  @override
  String get posTaskUpcomingDeliveries => 'Delivery ka time aa gaya';

  @override
  String get posTaskUnassignedDeliveries => 'Delivery ke liye captain chunein';

  @override
  String get posTaskExpress => 'Express order';

  @override
  String get posTaskOrderRequests => 'Order request';

  @override
  String get posTaskCollectionDue => 'Vasoolne wali rakam';

  @override
  String get posPlanTitle => 'Aapka plan';

  @override
  String posPlanValidTo(String date) {
    return '$date tak valid';
  }

  @override
  String get posHomeLoadError => 'Aaj ke aankde nahi aa sake.';

  @override
  String get posRetry => 'Phir koshish karein';

  @override
  String get posHomeEmpty =>
      'Abhi koi order nahi. Shuru karne ke liye Order book karein dabayein.';

  @override
  String get posCancel => 'Cancel';

  @override
  String get posCustomerPick => 'Customer chunein';

  @override
  String get posCustomerSearchHint => 'Naam ya phone se khojein';

  @override
  String get posCustomerRecent => 'Haal ke customer';

  @override
  String get posCustomerNone => 'Koi customer nahi mila.';

  @override
  String get posCustomerAddNew => 'Naya customer jodein';

  @override
  String posCustomerAddWithPhone(String phone) {
    return '$phone ko naya customer jodein';
  }

  @override
  String get posCustomerLoadError => 'Customer nahi aa sake.';

  @override
  String posCustomerOrderCount(int count) {
    return '$count order';
  }

  @override
  String get posAddCustomerTitle => 'Customer jodein';

  @override
  String get posCustomerName => 'Customer ka naam';

  @override
  String get posCustomerPhone => 'Mobile number (10 digit)';

  @override
  String get posErrCustomerName => 'Customer ka naam likhein';

  @override
  String get posErrCustomerPhone => '10 digit ka mobile number likhein';

  @override
  String posCustomerAdded(String name) {
    return '$name jud gaye';
  }

  @override
  String get posBookTitle => 'Order book karein';

  @override
  String get posBookCustomer => 'Customer';

  @override
  String get posBookDeliveryDate => 'Delivery ki tarikh';

  @override
  String get posBookHomeDelivery => 'Ghar par delivery';

  @override
  String get posBookPickup => 'Pickup';

  @override
  String get posBookExpress => 'Express';

  @override
  String get posBookService => 'Service';

  @override
  String get posBookCategory => 'Category';

  @override
  String get posBookAll => 'Sabhi';

  @override
  String get posBookSearchGarment => 'Kapda khojein';

  @override
  String get posBookNoServices =>
      'Aapki rate list mein abhi koi service nahi hai. Pehle kapde ka rate jodein.';

  @override
  String get posBookNoGarments =>
      'Is service ke liye rate wala koi kapda nahi.';

  @override
  String posBookNoMatch(String query) {
    return '\"$query\" se koi kapda nahi mila.';
  }

  @override
  String get posBookCatalogueError => 'Aapki rate list nahi aa saki.';

  @override
  String get posBookSelected => 'Chune hue kapde';

  @override
  String get posBookCartEmpty => 'Jodne ke liye upar kapde par dabayein.';

  @override
  String posBookAddOne(String name) {
    return 'Ek $name aur jodein';
  }

  @override
  String posBookRemoveOne(String name) {
    return 'Ek $name kam karein';
  }

  @override
  String posBookRemoveLine(String name) {
    return '$name hatayein';
  }

  @override
  String get posBookChangePrice => 'Rate badlein';

  @override
  String get posBookItems => 'Kul piece';

  @override
  String get posBookCharge => 'Charge';

  @override
  String get posBookDiscount => 'Chhoot';

  @override
  String get posBookTax => 'Tax';

  @override
  String posBookTaxPercent(String percent) {
    return 'Tax ($percent%)';
  }

  @override
  String get posBookGrandTotal => 'Kul rakam';

  @override
  String get posBookCalculating => 'Hisaab laga rahe hain…';

  @override
  String get posBookQuoteError => 'Rakam nahi mil saki.';

  @override
  String get posBookExtras => 'Charge, chhoot aur GST';

  @override
  String get posBookChargesLabel => 'Charges';

  @override
  String get posBookDiscountsLabel => 'Discounts';

  @override
  String get posBookGstLabel => 'GST';

  @override
  String get posBookNoGst => 'GST nahi';

  @override
  String get posBookPayment => 'Payment';

  @override
  String get posPayCash => 'Cash';

  @override
  String get posPayOnline => 'Online';

  @override
  String get posPayLater => 'Baad mein';

  @override
  String get posPayNowNote => 'Poori rakam abhi mil rahi hai.';

  @override
  String get posPayLaterNote => 'Abhi payment nahi. Baad mein lein.';

  @override
  String get posBookRemarks => 'Remarks (optional)';

  @override
  String get posBookSave => 'Order save karein';

  @override
  String get posBookSaving => 'Save ho raha hai…';

  @override
  String get posBookNeedCustomer => 'Save karne ke liye customer chunein.';

  @override
  String get posBookNeedGarment => 'Kam se kam ek kapda jodein.';

  @override
  String get posBookWaitPrice => 'Rakam ka intezaar…';

  @override
  String get posBookSavedTitle => 'Order save ho gaya';

  @override
  String posBookSavedBody(String number, String name) {
    return '$name ka order $number';
  }

  @override
  String get posBookSavedTotal => 'Kul';

  @override
  String get posBookSavedPaid => 'Mile';

  @override
  String get posBookSavedBalance => 'Lena baaki';

  @override
  String get posBookViewOrder => 'Order dekhein';

  @override
  String get posBookAnother => 'Ek aur book karein';

  @override
  String get posBookClear => 'Saaf karein';

  @override
  String get posBookClearTitle => 'Yeh order saaf karein?';

  @override
  String get posBookClearBody => 'Customer aur kapde hat jayenge.';

  @override
  String get posBookDraftRestored =>
      'Aapka pichla bina save kiya order wapas aa gaya.';

  @override
  String posBookDropped(int count) {
    return '$count kapde hata diye gaye kyunki unka rate ab aapki list mein nahi hai.';
  }

  @override
  String get posAddPriceTitle => 'Kapde ka rate jodein';

  @override
  String get posEditPriceTitle => 'Rate badlein';

  @override
  String get posPriceGarment => 'Kapda';

  @override
  String get posPriceCategory => 'Category';

  @override
  String get posPriceService => 'Service';

  @override
  String get posPriceUnit => 'Unit';

  @override
  String get posPriceRate => 'Rate (₹)';

  @override
  String get posPriceAdd => 'Jodein';

  @override
  String get posPriceSave => 'Rate save karein';

  @override
  String get posPricePickOne => 'Chunein…';

  @override
  String get posPriceNone => 'Koi nahi';

  @override
  String get posPriceNewGarment => 'Naya kapda';

  @override
  String get posPriceNewCategory => 'Nayi category';

  @override
  String get posPriceNewService => 'Nayi service';

  @override
  String get posPriceCreateHint => 'Naam';

  @override
  String get posPriceCreate => 'Banayein';

  @override
  String get posPriceCreateTooltip => 'Naya banayein';

  @override
  String get posPriceErrGarment => 'Kapda chunein';

  @override
  String get posPriceErrService => 'Service chunein';

  @override
  String get posPriceErrRate => 'Rate likhein, jaise 80 ya 80.50';

  @override
  String get posPriceErrName => 'Naam likhein';

  @override
  String get posPriceSaved => 'Rate save ho gaya';

  @override
  String posPriceCurrent(String price) {
    return 'Abhi ka rate $price';
  }

  @override
  String get posUnitPiece => 'Piece';

  @override
  String get posUnitKg => 'Kilo';

  @override
  String get posUnitPair => 'Jodi';

  @override
  String get posUnitSqft => 'Square foot';

  @override
  String get posBookSubtotal => 'Rakam';

  @override
  String posBookQtySemantics(String name, String qty) {
    return '$name, matra $qty';
  }

  @override
  String posBookQtyDialogTitle(String unit) {
    return 'Matra daalein ($unit)';
  }

  @override
  String get posBookQtyInvalid => '0.1 se 9999 ke beech matra daalein';

  @override
  String get posBookQtyOk => 'Set karein';

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
  String get posOrdSelectAll => 'Sab chunein';

  @override
  String posOrdSelectedCount(int count) {
    return '$count chune gaye';
  }

  @override
  String get posOrdMoveNext => 'Agle step par le jaayein';

  @override
  String get posOrdSearchHint => 'Naam, phone ya order no. khojein';

  @override
  String get posOrdEmptyBooked =>
      'Koi booked order nahi. Jodne ke liye \"Order book karein\" dabayein.';

  @override
  String get posOrdEmptyInProcess => 'Abhi kuch bhi process mein nahi hai.';

  @override
  String get posOrdEmptyDone => 'Abhi koi order ready nahi hai.';

  @override
  String get posOrdEmptyFiltered =>
      'Koi order nahi mila. Filter ya search hataayein.';

  @override
  String get posOrdClearFilters => 'Filter hataayein';

  @override
  String get posOrdLoadError => 'Orders load nahi ho sake.';

  @override
  String get posOrdLoadMoreError =>
      'Aur load nahi ho saka. Phir koshish ke liye dabayein.';

  @override
  String posOrdItemsCount(int count) {
    return '$count items';
  }

  @override
  String posOrdBalanceDue(String amount) {
    return 'Baaki $amount';
  }

  @override
  String posOrdDue(String date) {
    return 'Delivery $date';
  }

  @override
  String get posOrdExpress => 'Express';

  @override
  String get posOrdHomeDelivery => 'Home Delivery';

  @override
  String get posOrdPickup => 'Pickup';

  @override
  String get posOrdWalkIn => 'Counter par';

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
  String get posPhaseOut => 'Delivery ke liye nikla';

  @override
  String get posPhaseDelivered => 'Delivered';

  @override
  String get posPhaseComplete => 'Order Complete';

  @override
  String get posPhaseCancelled => 'Cancelled';

  @override
  String get posFilterTitle => 'Orders filter karein';

  @override
  String get posFilterStatus => 'Kaun se orders';

  @override
  String get posFilterThisTab => 'Yeh tab';

  @override
  String get posFilterAllOrders => 'Sab orders';

  @override
  String get posFilterDeliveredOnly => 'Delivered';

  @override
  String get posFilterCancelledOnly => 'Cancelled';

  @override
  String get posFilterDates => 'Order ki date';

  @override
  String get posFilterFrom => 'Se';

  @override
  String get posFilterTo => 'Tak';

  @override
  String get posFilterAnyDate => 'Koi bhi date';

  @override
  String get posFilterDelivery => 'Customer tak kaise pahunche';

  @override
  String get posFilterAnyDelivery => 'Koi bhi';

  @override
  String get posFilterExpressOnly => 'Sirf express';

  @override
  String get posFilterDueOnly => 'Sirf baaki wale';

  @override
  String get posFilterApply => 'Orders dikhayein';

  @override
  String get posFilterReset => 'Hataayein';

  @override
  String posBulkTitle(int count) {
    return '$count orders agle step par le jaayein?';
  }

  @override
  String get posBulkBody =>
      'Har order ek step aage badhega: Booked → Processing → Ready → Delivered.';

  @override
  String get posBulkReadyNote =>
      'Jin orders ke kapde scan nahi hue, woh bhi ready maan liye jaayenge.';

  @override
  String get posBulkDueNote =>
      'Jin par baaki hai woh yahan deliver nahi honge — unhe ek-ek karke kholein.';

  @override
  String get posBulkGo => 'Orders aage badhayein';

  @override
  String posBulkDone(int count) {
    return '$count orders aage badh gaye.';
  }

  @override
  String posBulkPartial(int moved, int failed) {
    return '$moved aage badhe. $failed ko dekhna hoga — unhe ek-ek karke kholein.';
  }

  @override
  String get posBulkNone =>
      'Kuch bhi aage nahi badh saka. Orders ek-ek karke kholein.';

  @override
  String posBulkSkipDue(int count) {
    return 'Baaki wale $count orders aapke kholne ke liye chhode gaye.';
  }

  @override
  String get posOrdDetailTitle => 'Order ki jaankari';

  @override
  String get posOrdCall => 'Call';

  @override
  String get posOrdCallFailed => 'Phone nahi khul saka.';

  @override
  String get posNextStart => 'Processing shuru karein';

  @override
  String get posNextReady => 'Ready karein';

  @override
  String get posNextSendOut => 'Delivery par bhejein';

  @override
  String get posNextDeliver => 'Order deliver karein';

  @override
  String get posOrdFinished => 'Yeh order poora ho chuka hai.';

  @override
  String get posOrdCancelledNote => 'Yeh order cancel ho gaya tha.';

  @override
  String get posReadyAnywayTitle => 'Kapde abhi scan nahi hue';

  @override
  String get posReadyAnywayBody =>
      'Kuch kapde processing mein scan nahi hue hain. Phir bhi order ready karein?';

  @override
  String get posReadyAnywayYes => 'Phir bhi ready karein';

  @override
  String get posNotYet => 'Abhi nahi';

  @override
  String posDeliverDueTitle(String amount) {
    return '$amount abhi baaki hai';
  }

  @override
  String get posDeliverDueBody =>
      'Pehle payment lein, ya abhi deliver karein aur baad mein lein.';

  @override
  String get posCollectFirst => 'Pehle payment lein';

  @override
  String get posDeliverAnyway => 'Baaki ke saath deliver karein';

  @override
  String posOrdMoved(String status) {
    return 'Order ab \"$status\" hai.';
  }

  @override
  String get posOrdChanged =>
      'Yeh order kisi aur ne badal diya. Ise dobara load kar diya hai — dekhkar phir koshish karein.';

  @override
  String posProgressPercent(int percent) {
    return '$percent% poora';
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
  String get posActionsTitle => 'Turant kaam';

  @override
  String get posActPayNow => 'Pay Now';

  @override
  String get posActInvoice => 'Invoice dekhein';

  @override
  String get posActMiniInvoice => 'Mini Invoice';

  @override
  String get posActTag => 'Tags';

  @override
  String get posActEdit => 'Order badlein';

  @override
  String get posActCancel => 'Order cancel karein';

  @override
  String get posActAssign => 'Captain chunein';

  @override
  String get posInfoTitle => 'Order info';

  @override
  String get posInfoDelivery => 'Delivery';

  @override
  String get posInfoOrderNo => 'Order no.';

  @override
  String get posInfoInvoiceAmount => 'Bill ki raqam';

  @override
  String get posInfoPaid => 'Paid';

  @override
  String get posInfoBalance => 'Baaki';

  @override
  String get posInfoBookedOn => 'Booking';

  @override
  String get posInfoDeliveryDate => 'Delivery ki date';

  @override
  String get posInfoPickupCaptain => 'Pickup captain';

  @override
  String get posInfoDeliveryCaptain => 'Delivery captain';

  @override
  String get posInfoNotAssigned => 'Chuna nahi gaya';

  @override
  String get posInfoNotes => 'Remarks';

  @override
  String get posInfoCancelReason => 'Cancel karne ka kaaran';

  @override
  String get posPaymentsTitle => 'Mile payments';

  @override
  String get posPaymentsNone => 'Abhi tak koi payment nahi mila.';

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
  String get posGarmentsTitle => 'Kapde';

  @override
  String get posGarmentsNone => 'Is order mein koi kapda nahi.';

  @override
  String get posUnitReceived => 'Mila';

  @override
  String get posUnitProcessing => 'Process mein';

  @override
  String get posUnitReady => 'Ready';

  @override
  String get posUnitOut => 'Nikla';

  @override
  String get posUnitDelivered => 'Delivered';

  @override
  String get posUnitMissing => 'Gum';

  @override
  String get posUnitCancelled => 'Cancelled';

  @override
  String get posOrdLoadFailed => 'Yeh order load nahi ho saka.';

  @override
  String get posOrdLoadingHint => 'Order load ho raha hai…';

  @override
  String get posWhatsApp => 'WhatsApp';

  @override
  String get posWaOpenFailed => 'WhatsApp nahi khul saka.';

  @override
  String posWaMessageDue(String name, String number, String status,
      String total, String balance, String shop) {
    return 'Namaste $name, aapka order $number \"$status\" hai. Kul $total, baaki $balance. Dhanyavaad! — $shop';
  }

  @override
  String posWaMessagePaid(
      String name, String number, String status, String total, String shop) {
    return 'Namaste $name, aapka order $number \"$status\" hai. Kul $total, poora payment ho chuka hai. Dhanyavaad! — $shop';
  }

  @override
  String get posWaCustomerFallback => 'ji';

  @override
  String get posPayTitle => 'Payment lein';

  @override
  String get posPayBalance => 'Lene ke liye baaki';

  @override
  String get posPayAmount => 'Raqam (₹)';

  @override
  String get posPayFull => 'Poora baaki';

  @override
  String get posPayHow => 'Customer kaise payment kar raha hai?';

  @override
  String get posPayReference => 'Reference (optional)';

  @override
  String get posPayReferenceHint => 'jaise UPI transaction number';

  @override
  String posPayCollect(String amount) {
    return '$amount lein';
  }

  @override
  String get posPayErrZero => 'Raqam daalein.';

  @override
  String posPayErrOver(String amount) {
    return 'Yeh baaki $amount se zyada nahi ho sakta.';
  }

  @override
  String posPayDone(String amount) {
    return '$amount mil gaye.';
  }

  @override
  String get posPayCheckFirst =>
      'Payment ki pushti nahi ho saki. Order dobara load kiya hai — dobara lene se pehle baaki dekhein.';

  @override
  String get posPayNothingDue => 'Is order par kuch baaki nahi.';

  @override
  String get posCancelTitle => 'Yeh order cancel karein?';

  @override
  String get posCancelBody => 'Ise wapas nahi kiya ja sakta.';

  @override
  String get posCancelWhy => 'Cancel kyon kar rahe hain?';

  @override
  String get posCancelReasonMind => 'Customer ne mann badal liya';

  @override
  String get posCancelReasonMistake => 'Galti se book hua';

  @override
  String get posCancelReasonPrice => 'Daam ki dikkat';

  @override
  String get posCancelReasonOther => 'Koi aur kaaran';

  @override
  String get posCancelOtherHint => 'Kaaran likhein (kam se kam 3 akshar)';

  @override
  String get posCancelRefundNote =>
      'Agar customer pehle hi payment kar chuka hai, to paise khud lautayein — app refund nahi karta.';

  @override
  String get posCancelConfirm => 'Order cancel karein';

  @override
  String get posCancelKeep => 'Order rakhein';

  @override
  String get posCancelDone => 'Order cancel ho gaya.';

  @override
  String get posEditTitle => 'Order badlein';

  @override
  String get posEditItemsNote =>
      'Kapde badalne ke liye yeh order cancel karke naya book karein.';

  @override
  String get posEditSave => 'Badlav save karein';

  @override
  String get posEditSaved => 'Order update ho gaya.';

  @override
  String get posEditNothing => 'Kuch nahi badla.';

  @override
  String get posAssignTitle => 'Captain chunein';

  @override
  String get posAssignPickup => 'Pickup captain';

  @override
  String get posAssignDelivery => 'Delivery captain';

  @override
  String get posAssignKeep => 'Jaisa hai waisa rakhein';

  @override
  String get posAssignNone =>
      'Abhi koi captain nahi hai. Settings → Team mein jodein.';

  @override
  String get posAssignSave => 'Chunein';

  @override
  String get posAssignDone => 'Captain chun liya gaya.';

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
      'Invoice order deliver hone par banta hai. Abhi bill ke liye \"Mini Invoice\" use karein.';

  @override
  String get posInvoiceOpenMini => 'Mini Invoice kholein';

  @override
  String get posInvoiceFailed => 'Bill taiyaar nahi ho saka.';

  @override
  String get posOk => 'OK';

  @override
  String get posTagsTitle => 'Kapdon ke tags';

  @override
  String get posTagsEmpty => 'Is order ke koi tags nahi hain.';

  @override
  String get posTagsPrint => 'Tags print ya share karein';

  @override
  String get posTagsHint =>
      'Har kapde par ek tag lagayein. Har QR ke neeche code bhi likha hai.';

  @override
  String posTagsPdfTitle(String number) {
    return 'Order $number ke tags';
  }

  @override
  String get posTagsFailed => 'Tags taiyaar nahi ho sake.';

  @override
  String get posTileOpensOrders => 'Orders list khulti hai';

  @override
  String posOrdFiltered(String what) {
    return 'Dikha rahe hain: $what';
  }

  @override
  String get posNoPermission =>
      'Aapko yeh karne ki permission nahi hai. Shop owner se poochein.';

  @override
  String get posSearchHint => 'Order no., customer ka naam, phone ya tag';

  @override
  String get posSearchStart =>
      'Khojne ke liye kam se kam 2 akshar ya ank likhein.';

  @override
  String get posSearchRecent => 'Haal ki khojein';

  @override
  String get posSearchClearRecent => 'Hatayein';

  @override
  String posSearchNone(String q) {
    return '\"$q\" ke liye kuch nahi mila. Spelling check karein ya phone number try karein.';
  }

  @override
  String get posSearchFailed => 'Abhi search nahi ho paya.';

  @override
  String get posSearchCustomers => 'Customers';

  @override
  String get posSearchOrders => 'Orders';

  @override
  String get posSearchTags => 'Kapde ke tags';

  @override
  String get posSearchAllCustomers => 'Sabhi customers';

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
  String get posCustSearchHint => 'Naam ya phone se khojein';

  @override
  String get posCustEmpty =>
      'Abhi koi customer nahi. Order book karein ya customer jodein.';

  @override
  String posCustNoMatch(String q) {
    return '\"$q\" se koi customer nahi mila.';
  }

  @override
  String get posCustLoadError => 'Customers load nahi ho paye.';

  @override
  String posCustOrdersCount(int count, String spent) {
    return '$count orders · $spent';
  }

  @override
  String get posCustNewCustomer => 'Naya customer';

  @override
  String get posCustDuesTitle => 'Vasoolna hai';

  @override
  String get posCustNoDues => 'Kuch baaki nahi. Sab paid.';

  @override
  String posCustDueOrder(String number) {
    return 'Order $number';
  }

  @override
  String get posCustCollect => 'Baaki vasoolein';

  @override
  String get posCustCollectHint => 'Balance vasoolne ke liye order chunein.';

  @override
  String get posCustHistory => 'Order history';

  @override
  String get posCustNoOrders => 'Abhi koi order nahi.';

  @override
  String get posCustNotes => 'Notes';

  @override
  String get posCustAddresses => 'Pate';

  @override
  String get posCustCall => 'Call karein';

  @override
  String get posCustWhatsApp => 'WhatsApp';

  @override
  String get posCustNotFound => 'Yeh customer nahi mila.';

  @override
  String posCustOwes(String amount) {
    return 'Baaki $amount';
  }

  @override
  String posWaSheetTitle(String name) {
    return '$name ko message bhejein';
  }

  @override
  String get posWaOpenChat => 'Sirf chat kholein';

  @override
  String get posWaOpenChatBody =>
      'Ek chhota namaste. Aap kuch bhi likh sakte hain.';

  @override
  String posWaHello(String name, String shop) {
    return 'Namaste $name, main $shop se bol raha/rahi hoon.';
  }

  @override
  String posWaForOrder(String number) {
    return 'Order $number ke baare mein';
  }

  @override
  String get posWaNoOrder =>
      'Is customer ka abhi koi order nahi, isliye sirf saadi chat khul sakti hai.';

  @override
  String get posWaPaymentDue => 'Payment ki yaad dilayein';

  @override
  String get posWaPaymentDueBody => 'Baaki rakam dikhata hai.';

  @override
  String get posWaTemplatesFailed => 'Aapke saved messages load nahi ho paye.';

  @override
  String get posActionWhatsApp => 'WhatsApp';

  @override
  String get posExpTitle => 'Kharcha';

  @override
  String get posExpToday => 'Aaj';

  @override
  String get posExpThisMonth => 'Is mahine';

  @override
  String posExpSpent(String amount) {
    return 'Kharcha: $amount';
  }

  @override
  String get posExpAdd => 'Kharcha jodein';

  @override
  String get posExpEdit => 'Kharcha badlein';

  @override
  String get posExpCancel => 'Kharcha cancel karein';

  @override
  String get posExpEmpty =>
      'Is period mein koi kharcha nahi. Kuch chukayein to \"Kharcha jodein\" dabayein.';

  @override
  String get posExpLoadError => 'Kharche load nahi ho paye.';

  @override
  String get posExpName => 'Kis cheez ka kharcha?';

  @override
  String get posExpNameHint => 'jaise bijli ka bill';

  @override
  String get posExpAmount => 'Rakam (₹)';

  @override
  String get posExpCategory => 'Kharche ka prakaar';

  @override
  String get posExpMode => 'Payment ka tareeka';

  @override
  String get posExpDate => 'Tareekh';

  @override
  String get posExpNote => 'Note (optional)';

  @override
  String get posExpReason => 'Ise kyun badal rahe hain?';

  @override
  String get posExpCancelReason => 'Ise cancel kyun kar rahe hain?';

  @override
  String get posExpSave => 'Kharcha save karein';

  @override
  String get posExpSaved => 'Kharcha save ho gaya.';

  @override
  String get posExpCancelled => 'Kharcha cancel ho gaya.';

  @override
  String get posExpCancelledTag => 'Cancelled';

  @override
  String get posExpKeep => 'Rehne dein';

  @override
  String get posExpNameRequired => 'Likhein ki kharcha kis cheez ka tha.';

  @override
  String get posExpAmountInvalid => '250 ya 99.50 jaisi rakam likhein.';

  @override
  String get posExpReasonRequired => 'Kripya kaaran likhein.';

  @override
  String posExpBy(String category, String mode) {
    return '$category · $mode';
  }

  @override
  String get posCatRent => 'Kiraya';

  @override
  String get posCatSalary => 'Salary';

  @override
  String get posCatElectricity => 'Bijli';

  @override
  String get posCatWater => 'Paani';

  @override
  String get posCatDetergent => 'Detergent aur saamaan';

  @override
  String get posCatTransport => 'Dhulai/yatra';

  @override
  String get posCatRepair => 'Marammat';

  @override
  String get posCatTea => 'Chai-nashta';

  @override
  String get posCatOther => 'Anya';

  @override
  String get posExpModeCash => 'Cash';

  @override
  String get posExpModeUpi => 'UPI';

  @override
  String get posExpModeBank => 'Bank';

  @override
  String get posExpModeCard => 'Card';

  @override
  String get posExpModeOther => 'Anya';

  @override
  String get posDrawerTitle => 'Cash drawer';

  @override
  String get posDrawerClosed =>
      'Cash drawer band hai. Din shuru karte samay kholein.';

  @override
  String get posDrawerOpen => 'Cash drawer kholein';

  @override
  String get posDrawerClose => 'Cash drawer band karein';

  @override
  String posDrawerOpenSince(String time) {
    return '$time se khula hai';
  }

  @override
  String get posDrawerOpening => 'Shuru mein cash';

  @override
  String get posDrawerIn => 'Cash aaya';

  @override
  String get posDrawerOut => 'Cash gaya';

  @override
  String get posDrawerShould => 'Drawer mein hona chahiye';

  @override
  String get posDrawerOpeningQ => 'Drawer mein abhi kitna cash hai?';

  @override
  String get posDrawerOpenSave => 'Drawer kholein';

  @override
  String get posDrawerCounted => 'Aapne gina hua cash (₹)';

  @override
  String posDrawerExpected(String amount) {
    return 'Hona chahiye: $amount';
  }

  @override
  String get posDrawerMatch => 'Hisaab mil gaya. Kuch kam nahi hai.';

  @override
  String posDrawerShort(String amount) {
    return '$amount kam hai.';
  }

  @override
  String posDrawerExtra(String amount) {
    return '$amount zyada hai.';
  }

  @override
  String get posDrawerWhy => 'Farq kyun hai?';

  @override
  String get posDrawerApprover => 'Kisne manzoor kiya (naam)';

  @override
  String get posDrawerCloseSave => 'Drawer band karein';

  @override
  String get posDrawerOpened => 'Cash drawer khul gaya.';

  @override
  String get posDrawerClosedOk => 'Cash drawer band ho gaya.';

  @override
  String get posDrawerCountInvalid => 'Gina hua cash likhein, jaise 1250.';

  @override
  String get posDrawerNeedsWhy =>
      'Likhein ki farq kyun hai aur kisne manzoor kiya.';

  @override
  String get posDrawerPast => 'Pichhle drawers';

  @override
  String posDrawerPastLine(String counted, String diff) {
    return 'Gina $counted · $diff';
  }

  @override
  String get posDrawerDiffOk => 'hisaab mila';

  @override
  String posDrawerDiffShort(String amount) {
    return '$amount kam';
  }

  @override
  String posDrawerDiffExtra(String amount) {
    return '$amount zyada';
  }

  @override
  String get posMoneyNoAccess =>
      'Iske liye dukaan ke malik se permission maangein.';

  @override
  String get posRepTitle => 'Report';

  @override
  String get posRepToday => 'Aaj';

  @override
  String get posRep7Days => 'Pichhle 7 din';

  @override
  String get posRepMonth => 'Is mahine';

  @override
  String get posRepCustom => 'Tareekh chunein';

  @override
  String posRepPeriod(String from, String to) {
    return '$from se $to';
  }

  @override
  String get posRepBilled => 'Bill bana';

  @override
  String get posRepBilledHint => 'Book hue orders ka kul';

  @override
  String get posRepCollected => 'Vasoola';

  @override
  String get posRepCollectedHint => 'Is period mein mila paisa';

  @override
  String get posRepDues => 'Abhi vasoolna hai';

  @override
  String posRepDuesHint(int count) {
    return '$count orders poore paid nahi';
  }

  @override
  String get posRepSpent => 'Kharch hua';

  @override
  String posRepSpentHint(int count) {
    return '$count kharche';
  }

  @override
  String get posRepNet => 'Vasoola − kharch';

  @override
  String get posRepOrders => 'Orders';

  @override
  String posRepOrdersCount(int count) {
    return '$count orders book hue';
  }

  @override
  String get posRepStBooked => 'Booked';

  @override
  String get posRepStProcess => 'Process mein';

  @override
  String get posRepStReady => 'Ready';

  @override
  String get posRepStDelivered => 'Delivered';

  @override
  String get posRepStCancelled => 'Cancelled';

  @override
  String get posRepPayMix => 'Customers ne kaise chukaya';

  @override
  String get posRepNoPayments => 'Is period mein koi payment nahi.';

  @override
  String get posRepModeWallet => 'Wallet';

  @override
  String get posRepTopGarments => 'Sabse zyada book kapde';

  @override
  String posRepQty(String qty, String amount) {
    return '$qty · $amount';
  }

  @override
  String get posRepSpendBy => 'Kharche ka prakaar';

  @override
  String get posRepDaily => 'Din-ba-din';

  @override
  String posRepDayLine(String billed, String collected, String spent) {
    return 'Bill $billed · Vasoola $collected · Kharch $spent';
  }

  @override
  String get posRepExport => 'Sales file bhejein (CSV)';

  @override
  String get posRepExportHint =>
      'Excel ya Google Sheets mein khulti hai. Har order ki ek line.';

  @override
  String get posRepExportFailed => 'File taiyaar nahi ho payi.';

  @override
  String get posRepLoadError => 'Report load nahi ho payi.';

  @override
  String get posRepEmpty => 'Is period mein koi order ya kharcha nahi.';

  @override
  String get posRepRangeTooLong => 'Kripya adhiktam ek saal chunein.';

  @override
  String get posRepTabSummary => 'Saaransh';

  @override
  String get posRepTabInvoices => 'Invoices';

  @override
  String get posRepTabCollection => 'Vasooli';

  @override
  String get posRepTabExpense => 'Kharche';

  @override
  String get posRepTotalRevenue => 'Kul kamaai';

  @override
  String get posRepInvNo => 'Invoice no.';

  @override
  String get posRepAmount => 'Rakam';

  @override
  String get posRepStatus => 'Sthiti';

  @override
  String posRepPage(int n) {
    return 'Page $n';
  }

  @override
  String get posRepPrev => 'Pichhla';

  @override
  String get posRepNext => 'Agla';

  @override
  String get posRepNoInvoices => 'Is period mein koi invoice nahi.';

  @override
  String get posRepInvoicesFailed => 'Invoices load nahi ho paye.';

  @override
  String get posRepChartBilled => 'Har din ka bill';

  @override
  String get posRepChartCollected => 'Har din ki vasooli';

  @override
  String get posRepChartSpent => 'Har din ka kharch';

  @override
  String posRepChartHigh(String amount, String date) {
    return 'Sabse zyada: $amount, $date ko';
  }

  @override
  String get posRepChartNone => 'Abhi dikhane ke liye kuch nahi.';

  @override
  String get posCustProfile => 'Profile';

  @override
  String get posSetCustomers => 'Customers';

  @override
  String get posSetCustomersBody =>
      'Sabhi customers dekhein, call karein, baaki dekhein.';

  @override
  String get posSetPrices => 'Daam list';

  @override
  String get posSetPricesBody => 'Kapda jodein ya daam badlein.';

  @override
  String get posSetRules => 'Extra charges aur discount';

  @override
  String get posSetRulesBody => 'Jo booking mein chun sakte hain.';

  @override
  String get posSetRulesCharges => 'Extra charges';

  @override
  String get posSetRulesDiscounts => 'Discounts';

  @override
  String get posSetRulesNone =>
      'Abhi koi nahi. Yeh counter software ya website se jude hain.';

  @override
  String posSetRuleFlat(String amount) {
    return '$amount fixed';
  }

  @override
  String posSetRulePercent(String percent) {
    return 'Bill ka $percent%';
  }

  @override
  String get posSetMessages => 'WhatsApp messages';

  @override
  String get posSetMessagesBody => 'Customers ko bheje jaane wale messages.';

  @override
  String get posSetMessagesHint =>
      'Yeh shabd counter software ya website par badal sakte hain. Yahan bhi dikhenge.';

  @override
  String get posSetTeam => 'Team';

  @override
  String get posSetTeamBody => 'Aapki dukaan mein kaun kaam karta hai.';

  @override
  String get posSetTeamHint =>
      'Log jodne ya hatane ke liye counter software ya website use karein.';

  @override
  String get posSetRoleOwner => 'Malik';

  @override
  String get posSetRoleStaff => 'Counter staff';

  @override
  String get posSetRoleRider => 'Captain (pickup/delivery)';

  @override
  String get posSetInactive => 'Active nahi';

  @override
  String get posSetLanguage => 'Bhasha';

  @override
  String get posSetLoadFailed => 'Yeh load nahi ho paya.';

  @override
  String get posSetSectionShop => 'Meri dukaan';

  @override
  String get posSetSectionApp => 'Yeh app';
}
