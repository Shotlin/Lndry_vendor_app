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
}
