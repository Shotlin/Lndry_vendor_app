import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale.fromSubtags(languageCode: 'hi', scriptCode: 'Latn')
  ];

  /// Generic OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// Generic Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Generic retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// Reject an order
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get commonReject;

  /// Accept an order
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get commonAccept;

  /// Exit the app confirmation button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get commonExit;

  /// App name shown on splash screen
  ///
  /// In en, this message translates to:
  /// **'LNDRY Vendor'**
  String get splashAppName;

  /// Tagline shown on splash screen
  ///
  /// In en, this message translates to:
  /// **'Partner Portal'**
  String get splashTagline;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcomeBack;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to manage your laundry operations'**
  String get authLoginSubtitle;

  /// No description provided for @authMobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get authMobileNumberLabel;

  /// No description provided for @authMobileNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get authMobileNumberRequired;

  /// No description provided for @authMobileNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit mobile number'**
  String get authMobileNumberInvalid;

  /// No description provided for @authGetOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get authGetOtpButton;

  /// No description provided for @authVerifyMobile.
  ///
  /// In en, this message translates to:
  /// **'Verify Mobile'**
  String get authVerifyMobile;

  /// No description provided for @authOtpSubtitleWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP code sent to {phone}'**
  String authOtpSubtitleWithPhone(String phone);

  /// No description provided for @authOtpSubtitleGeneric.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to your mobile'**
  String get authOtpSubtitleGeneric;

  /// No description provided for @authDemoOtpLabel.
  ///
  /// In en, this message translates to:
  /// **'Demo OTP: '**
  String get authDemoOtpLabel;

  /// No description provided for @authOtpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get authOtpCodeLabel;

  /// No description provided for @authOtpRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP code'**
  String get authOtpRequired;

  /// No description provided for @authOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit code'**
  String get authOtpInvalid;

  /// No description provided for @authVerifyCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get authVerifyCodeButton;

  /// No description provided for @authResendPrompt.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? '**
  String get authResendPrompt;

  /// No description provided for @authResendCountdownPrefix.
  ///
  /// In en, this message translates to:
  /// **'Resend code in '**
  String get authResendCountdownPrefix;

  /// No description provided for @authResendOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get authResendOtpButton;

  /// No description provided for @authResendCountdownSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String authResendCountdownSeconds(int seconds);

  /// No description provided for @dashboardTodayClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'Today is marked closed'**
  String get dashboardTodayClosedTitle;

  /// No description provided for @dashboardTodayClosedMessage.
  ///
  /// In en, this message translates to:
  /// **'Today is set as a non-working day in your Working Hours schedule, so your store stays closed to customers regardless of this switch. Update Working Hours & Slots to open today.'**
  String get dashboardTodayClosedMessage;

  /// No description provided for @dashboardOpenWorkingHoursButton.
  ///
  /// In en, this message translates to:
  /// **'Open Working Hours'**
  String get dashboardOpenWorkingHoursButton;

  /// No description provided for @dashboardCloseStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Close Your Store?'**
  String get dashboardCloseStoreTitle;

  /// No description provided for @dashboardOpenStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Your Store?'**
  String get dashboardOpenStoreTitle;

  /// No description provided for @dashboardCloseStoreMessage.
  ///
  /// In en, this message translates to:
  /// **'Customers will not be able to place new orders while your store is closed.'**
  String get dashboardCloseStoreMessage;

  /// No description provided for @dashboardOpenStoreMessage.
  ///
  /// In en, this message translates to:
  /// **'Your store will be visible to customers and they can place new orders.'**
  String get dashboardOpenStoreMessage;

  /// No description provided for @dashboardCloseStoreButton.
  ///
  /// In en, this message translates to:
  /// **'Close Store'**
  String get dashboardCloseStoreButton;

  /// No description provided for @dashboardOpenStoreButton.
  ///
  /// In en, this message translates to:
  /// **'Open Store'**
  String get dashboardOpenStoreButton;

  /// No description provided for @dashboardStoreNowOpen.
  ///
  /// In en, this message translates to:
  /// **'Store is now OPEN'**
  String get dashboardStoreNowOpen;

  /// No description provided for @dashboardStoreNowClosed.
  ///
  /// In en, this message translates to:
  /// **'Store is now CLOSED'**
  String get dashboardStoreNowClosed;

  /// No description provided for @dashboardActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed: {error}'**
  String dashboardActionFailed(String error);

  /// No description provided for @dashboardLaundryPartnerFallback.
  ///
  /// In en, this message translates to:
  /// **'Laundry Partner'**
  String get dashboardLaundryPartnerFallback;

  /// No description provided for @dashboardOpenBadge.
  ///
  /// In en, this message translates to:
  /// **'OPEN'**
  String get dashboardOpenBadge;

  /// No description provided for @dashboardClosedBadge.
  ///
  /// In en, this message translates to:
  /// **'CLOSED'**
  String get dashboardClosedBadge;

  /// No description provided for @dashboardApprovedBadge.
  ///
  /// In en, this message translates to:
  /// **'APPROVED'**
  String get dashboardApprovedBadge;

  /// No description provided for @dashboardAvgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get dashboardAvgRating;

  /// No description provided for @dashboardTotalReviews.
  ///
  /// In en, this message translates to:
  /// **'Total Reviews'**
  String get dashboardTotalReviews;

  /// No description provided for @dashboardAvgTurnaround.
  ///
  /// In en, this message translates to:
  /// **'Avg Turnaround'**
  String get dashboardAvgTurnaround;

  /// No description provided for @dashboardHoursValue.
  ///
  /// In en, this message translates to:
  /// **'{hours} hrs'**
  String dashboardHoursValue(String hours);

  /// No description provided for @dashboardTodaysOperations.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Operations'**
  String get dashboardTodaysOperations;

  /// No description provided for @dashboardTodaysRevenue.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Revenue'**
  String get dashboardTodaysRevenue;

  /// No description provided for @dashboardPendingOrders.
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get dashboardPendingOrders;

  /// No description provided for @dashboardProcessingOrders.
  ///
  /// In en, this message translates to:
  /// **'Processing Orders'**
  String get dashboardProcessingOrders;

  /// No description provided for @dashboardReadyPacked.
  ///
  /// In en, this message translates to:
  /// **'Ready / Packed'**
  String get dashboardReadyPacked;

  /// No description provided for @dashboardFailedLoadStats.
  ///
  /// In en, this message translates to:
  /// **'Failed to load statistics'**
  String get dashboardFailedLoadStats;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Catalogue'**
  String get dashboardCatalogue;

  /// No description provided for @dashboardSlots.
  ///
  /// In en, this message translates to:
  /// **'Slots'**
  String get dashboardSlots;

  /// No description provided for @dashboardAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get dashboardAnalytics;

  /// No description provided for @dashboardHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get dashboardHelp;

  /// No description provided for @dashboardNewIncomingOrders.
  ///
  /// In en, this message translates to:
  /// **'New Incoming Orders'**
  String get dashboardNewIncomingOrders;

  /// No description provided for @dashboardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get dashboardViewAll;

  /// No description provided for @dashboardAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get dashboardAllCaughtUp;

  /// No description provided for @dashboardNoPendingOrders.
  ///
  /// In en, this message translates to:
  /// **'No pending orders at the moment.'**
  String get dashboardNoPendingOrders;

  /// No description provided for @dashboardFailedLoadOrders.
  ///
  /// In en, this message translates to:
  /// **'Failed to load orders'**
  String get dashboardFailedLoadOrders;

  /// No description provided for @dashboardOrderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String dashboardOrderIdLabel(String id);

  /// No description provided for @dashboardOrderItemsSummary.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, one{1 item} other{{count} items}} • {names}'**
  String dashboardOrderItemsSummary(int count, String names);

  /// No description provided for @dashboardOrderAccepted.
  ///
  /// In en, this message translates to:
  /// **'Order accepted!'**
  String get dashboardOrderAccepted;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsNotificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsSection;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settingsPushNotifications;

  /// No description provided for @settingsPushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts for new orders, payouts & updates'**
  String get settingsPushNotificationsSubtitle;

  /// No description provided for @settingsSoundAlerts.
  ///
  /// In en, this message translates to:
  /// **'Sound Alerts'**
  String get settingsSoundAlerts;

  /// No description provided for @settingsSoundAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play sound on new order arrival'**
  String get settingsSoundAlertsSubtitle;

  /// No description provided for @settingsOperationsSection.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get settingsOperationsSection;

  /// No description provided for @settingsAutoAcceptOrders.
  ///
  /// In en, this message translates to:
  /// **'Auto-Accept Orders'**
  String get settingsAutoAcceptOrders;

  /// No description provided for @settingsAutoAcceptOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically accept orders when capacity is available'**
  String get settingsAutoAcceptOrdersSubtitle;

  /// No description provided for @settingsSupportLegalSection.
  ///
  /// In en, this message translates to:
  /// **'Support & Legal'**
  String get settingsSupportLegalSection;

  /// No description provided for @settingsPartnerHelpdesk.
  ///
  /// In en, this message translates to:
  /// **'Partner Helpdesk'**
  String get settingsPartnerHelpdesk;

  /// No description provided for @settingsPartnerHelpdeskSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get support from the LNDRY partner team'**
  String get settingsPartnerHelpdeskSubtitle;

  /// No description provided for @settingsConnectingHelpdesk.
  ///
  /// In en, this message translates to:
  /// **'Connecting to partner helpdesk…'**
  String get settingsConnectingHelpdesk;

  /// No description provided for @settingsTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service & SLA'**
  String get settingsTermsOfService;

  /// No description provided for @settingsOpeningTerms.
  ///
  /// In en, this message translates to:
  /// **'Opening Terms of Service…'**
  String get settingsOpeningTerms;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsOpeningPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Opening Privacy Policy…'**
  String get settingsOpeningPrivacy;

  /// No description provided for @settingsFooter.
  ///
  /// In en, this message translates to:
  /// **'LNDRY Vendor App • Version {version}\n© 2026 LNDRY Technologies Pvt. Ltd.'**
  String settingsFooter(String version);

  /// No description provided for @routerExitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit Application?'**
  String get routerExitAppTitle;

  /// No description provided for @routerExitAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit LNDRY Vendor?'**
  String get routerExitAppMessage;

  /// No description provided for @routerPageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get routerPageNotFound;

  /// No description provided for @routerUnknownRoute.
  ///
  /// In en, this message translates to:
  /// **'Unknown route'**
  String get routerUnknownRoute;

  /// No description provided for @routerGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get routerGoHome;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @orderStatusPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get orderStatusPaymentPending;

  /// No description provided for @orderStatusPaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get orderStatusPaymentFailed;

  /// No description provided for @orderStatusWaitingForVendorConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Vendor Confirmation'**
  String get orderStatusWaitingForVendorConfirmation;

  /// No description provided for @orderStatusVendorAccepted.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get orderStatusVendorAccepted;

  /// No description provided for @orderStatusPickupAssigned.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get orderStatusPickupAssigned;

  /// No description provided for @orderStatusGoingForPickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup Partner Coming'**
  String get orderStatusGoingForPickup;

  /// No description provided for @orderStatusPickupOtpVerified.
  ///
  /// In en, this message translates to:
  /// **'Picked Up'**
  String get orderStatusPickupOtpVerified;

  /// No description provided for @orderStatusPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked Up'**
  String get orderStatusPickedUp;

  /// No description provided for @orderStatusReceivedAtVendor.
  ///
  /// In en, this message translates to:
  /// **'At Partner'**
  String get orderStatusReceivedAtVendor;

  /// No description provided for @orderStatusReconciliationPending.
  ///
  /// In en, this message translates to:
  /// **'Re-evaluation Submitted — Waiting for Customer Approval'**
  String get orderStatusReconciliationPending;

  /// No description provided for @orderStatusReconciliationDisputed.
  ///
  /// In en, this message translates to:
  /// **'Customer Disputed Re-evaluation'**
  String get orderStatusReconciliationDisputed;

  /// No description provided for @orderStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get orderStatusProcessing;

  /// No description provided for @orderStatusPacked.
  ///
  /// In en, this message translates to:
  /// **'Packed'**
  String get orderStatusPacked;

  /// No description provided for @orderStatusDeliveryAssigned.
  ///
  /// In en, this message translates to:
  /// **'Out for Delivery'**
  String get orderStatusDeliveryAssigned;

  /// No description provided for @orderStatusOutForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Out for Delivery'**
  String get orderStatusOutForDelivery;

  /// No description provided for @orderStatusDeliveryOtpVerified.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDeliveryOtpVerified;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusVendorRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected by Vendor'**
  String get orderStatusVendorRejected;

  /// No description provided for @orderStatusAutoRejected.
  ///
  /// In en, this message translates to:
  /// **'Auto-Rejected'**
  String get orderStatusAutoRejected;

  /// No description provided for @orderStatusCustomerCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCustomerCancelled;

  /// No description provided for @orderStatusAdminCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusAdminCancelled;

  /// No description provided for @orderStatusRefundPending.
  ///
  /// In en, this message translates to:
  /// **'Refund Pending'**
  String get orderStatusRefundPending;

  /// No description provided for @orderStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get orderStatusRefunded;

  /// No description provided for @ordersPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Operational Orders'**
  String get ordersPageTitle;

  /// No description provided for @ordersTabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get ordersTabPending;

  /// No description provided for @ordersTabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get ordersTabActive;

  /// No description provided for @ordersTabReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ordersTabReady;

  /// No description provided for @ordersTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get ordersTabHistory;

  /// No description provided for @ordersEmptyPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'No pending orders'**
  String get ordersEmptyPendingTitle;

  /// No description provided for @ordersEmptyPendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up! New orders will show up here.'**
  String get ordersEmptyPendingSubtitle;

  /// No description provided for @ordersEmptyActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'No active orders'**
  String get ordersEmptyActiveTitle;

  /// No description provided for @ordersEmptyActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Orders currently being processed or picked up will appear here.'**
  String get ordersEmptyActiveSubtitle;

  /// No description provided for @ordersEmptyReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'No ready orders'**
  String get ordersEmptyReadyTitle;

  /// No description provided for @ordersEmptyReadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Packed orders and those out for delivery will show here.'**
  String get ordersEmptyReadySubtitle;

  /// No description provided for @ordersEmptyHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'No order history'**
  String get ordersEmptyHistoryTitle;

  /// No description provided for @ordersEmptyHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Completed and cancelled orders will appear in your history.'**
  String get ordersEmptyHistorySubtitle;

  /// No description provided for @ordersPickupTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup: {time}'**
  String ordersPickupTimeLabel(String time);

  /// No description provided for @ordersCreatedTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Created: {time}'**
  String ordersCreatedTimeLabel(String time);

  /// No description provided for @ordersReconcileReceiptsButton.
  ///
  /// In en, this message translates to:
  /// **'Reconcile Receipts'**
  String get ordersReconcileReceiptsButton;

  /// No description provided for @ordersStartWashingButton.
  ///
  /// In en, this message translates to:
  /// **'Start Washing'**
  String get ordersStartWashingButton;

  /// No description provided for @ordersUpdateStageButton.
  ///
  /// In en, this message translates to:
  /// **'Update Stage'**
  String get ordersUpdateStageButton;

  /// No description provided for @ordersMarkPackedButton.
  ///
  /// In en, this message translates to:
  /// **'Mark Packed & Ready'**
  String get ordersMarkPackedButton;

  /// No description provided for @ordersUpdateProcessingStageTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Processing Stage'**
  String get ordersUpdateProcessingStageTitle;

  /// No description provided for @ordersStageWashing.
  ///
  /// In en, this message translates to:
  /// **'Washing'**
  String get ordersStageWashing;

  /// No description provided for @ordersStageDrying.
  ///
  /// In en, this message translates to:
  /// **'Drying'**
  String get ordersStageDrying;

  /// No description provided for @ordersStageIroning.
  ///
  /// In en, this message translates to:
  /// **'Ironing'**
  String get ordersStageIroning;

  /// No description provided for @ordersOrderAcceptedSnack.
  ///
  /// In en, this message translates to:
  /// **'Order accepted'**
  String get ordersOrderAcceptedSnack;

  /// No description provided for @ordersOrderRejectedSnack.
  ///
  /// In en, this message translates to:
  /// **'Order rejected'**
  String get ordersOrderRejectedSnack;

  /// No description provided for @ordersErrorSnack.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String ordersErrorSnack(String error);

  /// No description provided for @ordersStageUpdatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Stage updated to {stage}'**
  String ordersStageUpdatedSnack(String stage);

  /// No description provided for @orderDetailsPerKg.
  ///
  /// In en, this message translates to:
  /// **'Per kg'**
  String get orderDetailsPerKg;

  /// No description provided for @orderDetailsPerSqFt.
  ///
  /// In en, this message translates to:
  /// **'Per sq ft'**
  String get orderDetailsPerSqFt;

  /// No description provided for @orderDetailsPerItem.
  ///
  /// In en, this message translates to:
  /// **'Per item'**
  String get orderDetailsPerItem;

  /// No description provided for @orderDetailsChooseServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a service'**
  String get orderDetailsChooseServiceTitle;

  /// No description provided for @orderDetailsMoveServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Move to a different service'**
  String get orderDetailsMoveServiceTitle;

  /// No description provided for @orderDetailsAddServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a service'**
  String get orderDetailsAddServiceTitle;

  /// No description provided for @orderDetailsQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get orderDetailsQuantityLabel;

  /// No description provided for @orderDetailsAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get orderDetailsAddButton;

  /// No description provided for @orderDetailsPhotoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Photo upload failed: {error}'**
  String orderDetailsPhotoUploadFailed(String error);

  /// No description provided for @orderDetailsPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one photo is required'**
  String get orderDetailsPhotoRequired;

  /// No description provided for @orderDetailsSubmittedForApproval.
  ///
  /// In en, this message translates to:
  /// **'Submitted for customer approval'**
  String get orderDetailsSubmittedForApproval;

  /// No description provided for @orderDetailsReconciliationFailed.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation failed: {error}'**
  String orderDetailsReconciliationFailed(String error);

  /// No description provided for @orderDetailsReconcileSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reconcile Order items'**
  String get orderDetailsReconcileSheetTitle;

  /// No description provided for @orderDetailsReconcileSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will be sent to the customer for approval before processing continues.'**
  String get orderDetailsReconcileSheetSubtitle;

  /// No description provided for @orderDetailsEstQuantity.
  ///
  /// In en, this message translates to:
  /// **'Est: {quantity}'**
  String orderDetailsEstQuantity(String quantity);

  /// No description provided for @orderDetailsMovedFrom.
  ///
  /// In en, this message translates to:
  /// **'Moved from {from} → {to}'**
  String orderDetailsMovedFrom(String from, String to);

  /// No description provided for @orderDetailsChangeServiceAgain.
  ///
  /// In en, this message translates to:
  /// **'Change service again'**
  String get orderDetailsChangeServiceAgain;

  /// No description provided for @orderDetailsMoveServicePrompt.
  ///
  /// In en, this message translates to:
  /// **'Not the right service? Move it'**
  String get orderDetailsMoveServicePrompt;

  /// No description provided for @orderDetailsAddServiceButton.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get orderDetailsAddServiceButton;

  /// No description provided for @orderDetailsAdjustmentNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Adjustment Note / Reason'**
  String get orderDetailsAdjustmentNoteLabel;

  /// No description provided for @orderDetailsAdjustmentNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1 shirt added, dirty collar notes'**
  String get orderDetailsAdjustmentNoteHint;

  /// No description provided for @orderDetailsPhotoEvidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo evidence (required)'**
  String get orderDetailsPhotoEvidenceLabel;

  /// No description provided for @orderDetailsSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit for Customer Approval'**
  String get orderDetailsSubmitButton;

  /// No description provided for @orderDetailsRejectOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Order'**
  String get orderDetailsRejectOrderTitle;

  /// No description provided for @orderDetailsRejectionReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get orderDetailsRejectionReasonLabel;

  /// No description provided for @orderDetailsRejectionReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Shop capacity exceeded today'**
  String get orderDetailsRejectionReasonHint;

  /// No description provided for @orderDetailsConfirmRejectButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reject'**
  String get orderDetailsConfirmRejectButton;

  /// No description provided for @orderDetailsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetailsPageTitle;

  /// No description provided for @orderDetailsAwaitingApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Awaiting customer approval'**
  String get orderDetailsAwaitingApprovalTitle;

  /// No description provided for @orderDetailsAwaitingApprovalBody.
  ///
  /// In en, this message translates to:
  /// **'The customer is reviewing your proposed total change. Processing is paused until they respond.'**
  String get orderDetailsAwaitingApprovalBody;

  /// No description provided for @orderDetailsDisputedTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer rejected the proposed total'**
  String get orderDetailsDisputedTitle;

  /// No description provided for @orderDetailsDisputedBody.
  ///
  /// In en, this message translates to:
  /// **'Call the customer to resolve this, then resubmit the reconciliation with corrected items/photos.'**
  String get orderDetailsDisputedBody;

  /// No description provided for @orderDetailsLifecycleStepper.
  ///
  /// In en, this message translates to:
  /// **'Lifecycle Stepper'**
  String get orderDetailsLifecycleStepper;

  /// No description provided for @orderDetailsCustomerDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer details'**
  String get orderDetailsCustomerDetails;

  /// No description provided for @orderDetailsCustomerFallback.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get orderDetailsCustomerFallback;

  /// No description provided for @orderDetailsCustomerNote.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String orderDetailsCustomerNote(String note);

  /// No description provided for @orderDetailsGarmentItems.
  ///
  /// In en, this message translates to:
  /// **'Garment Items'**
  String get orderDetailsGarmentItems;

  /// No description provided for @orderDetailsReconcileCountButton.
  ///
  /// In en, this message translates to:
  /// **'Reconcile count'**
  String get orderDetailsReconcileCountButton;

  /// No description provided for @orderDetailsQuantityValue.
  ///
  /// In en, this message translates to:
  /// **'Quantity: {quantity}'**
  String orderDetailsQuantityValue(String quantity);

  /// No description provided for @orderDetailsSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get orderDetailsSubtotal;

  /// No description provided for @orderDetailsGstTaxes.
  ///
  /// In en, this message translates to:
  /// **'GST / Taxes'**
  String get orderDetailsGstTaxes;

  /// No description provided for @orderDetailsPlatformFee.
  ///
  /// In en, this message translates to:
  /// **'Platform fee'**
  String get orderDetailsPlatformFee;

  /// No description provided for @orderDetailsDeliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery fee'**
  String get orderDetailsDeliveryFee;

  /// No description provided for @orderDetailsHandlingFee.
  ///
  /// In en, this message translates to:
  /// **'Handling fee'**
  String get orderDetailsHandlingFee;

  /// No description provided for @orderDetailsTotalPayable.
  ///
  /// In en, this message translates to:
  /// **'Total Payable'**
  String get orderDetailsTotalPayable;

  /// No description provided for @orderDetailsServiceFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get orderDetailsServiceFee;

  /// No description provided for @orderDetailsLndryCommission.
  ///
  /// In en, this message translates to:
  /// **'LNDRY Commission ({rate}%)'**
  String orderDetailsLndryCommission(String rate);

  /// No description provided for @orderDetailsLndryCommissionFlat.
  ///
  /// In en, this message translates to:
  /// **'LNDRY Commission'**
  String get orderDetailsLndryCommissionFlat;

  /// No description provided for @orderDetailsGstOnCommission.
  ///
  /// In en, this message translates to:
  /// **'GST on Commission ({rate}%)'**
  String orderDetailsGstOnCommission(String rate);

  /// No description provided for @orderDetailsVendorPayout.
  ///
  /// In en, this message translates to:
  /// **'You\'ll Receive'**
  String get orderDetailsVendorPayout;

  /// No description provided for @orderDetailsPickupRiderLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup Rider'**
  String get orderDetailsPickupRiderLabel;

  /// No description provided for @orderDetailsDeliveryRiderLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Rider'**
  String get orderDetailsDeliveryRiderLabel;

  /// No description provided for @orderDetailsAssignRiderHint.
  ///
  /// In en, this message translates to:
  /// **'Choose who handles this order'**
  String get orderDetailsAssignRiderHint;

  /// No description provided for @orderDetailsAssignRiderButton.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get orderDetailsAssignRiderButton;

  /// No description provided for @orderDetailsAssignRiderTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign Rider'**
  String get orderDetailsAssignRiderTitle;

  /// No description provided for @orderDetailsNoActiveRiders.
  ///
  /// In en, this message translates to:
  /// **'No active riders yet. Add one from Rider Management.'**
  String get orderDetailsNoActiveRiders;

  /// No description provided for @orderDetailsRiderAssignedSnack.
  ///
  /// In en, this message translates to:
  /// **'Rider assigned'**
  String get orderDetailsRiderAssignedSnack;

  /// No description provided for @orderDetailsBroadcastButton.
  ///
  /// In en, this message translates to:
  /// **'Broadcast to All Riders'**
  String get orderDetailsBroadcastButton;

  /// No description provided for @orderDetailsBroadcastSnack.
  ///
  /// In en, this message translates to:
  /// **'Broadcast sent to active riders'**
  String get orderDetailsBroadcastSnack;

  /// No description provided for @orderDetailsAssignedToRider.
  ///
  /// In en, this message translates to:
  /// **'Assigned to {name}'**
  String orderDetailsAssignedToRider(String name);

  /// No description provided for @orderDetailsOfferPendingBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Offer sent to all riders — awaiting acceptance'**
  String get orderDetailsOfferPendingBroadcast;

  /// No description provided for @orderDetailsOfferPendingSingle.
  ///
  /// In en, this message translates to:
  /// **'Offered to {name} — awaiting response'**
  String orderDetailsOfferPendingSingle(String name);

  /// No description provided for @orderDetailsReassignButton.
  ///
  /// In en, this message translates to:
  /// **'Reassign'**
  String get orderDetailsReassignButton;

  /// No description provided for @jobOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'New Job Offer!'**
  String get jobOfferTitle;

  /// No description provided for @jobOfferOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{orderNumber}'**
  String jobOfferOrderNumber(String orderNumber);

  /// No description provided for @jobOfferAcceptButton.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get jobOfferAcceptButton;

  /// No description provided for @jobOfferAcceptedSnack.
  ///
  /// In en, this message translates to:
  /// **'Job accepted — check My Jobs'**
  String get jobOfferAcceptedSnack;

  /// No description provided for @jobOfferUnavailableSnack.
  ///
  /// In en, this message translates to:
  /// **'Too late — someone else already took this job'**
  String get jobOfferUnavailableSnack;

  /// No description provided for @jobOfferNotNowButton.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get jobOfferNotNowButton;

  /// No description provided for @jobOfferCountdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Auto re-offers in {time}'**
  String jobOfferCountdownLabel(String time);

  /// No description provided for @jobOfferExpiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Re-offering now…'**
  String get jobOfferExpiredLabel;

  /// No description provided for @orderDetailsCustomerReview.
  ///
  /// In en, this message translates to:
  /// **'Customer Review'**
  String get orderDetailsCustomerReview;

  /// No description provided for @orderDetailsVendorRating.
  ///
  /// In en, this message translates to:
  /// **'Vendor rating'**
  String get orderDetailsVendorRating;

  /// No description provided for @orderDetailsDeliveryRating.
  ///
  /// In en, this message translates to:
  /// **'Delivery rating'**
  String get orderDetailsDeliveryRating;

  /// No description provided for @orderDetailsSubmittedReevaluation.
  ///
  /// In en, this message translates to:
  /// **'Submitted Re-evaluation'**
  String get orderDetailsSubmittedReevaluation;

  /// No description provided for @orderDetailsNewServiceAdded.
  ///
  /// In en, this message translates to:
  /// **'New service added'**
  String get orderDetailsNewServiceAdded;

  /// No description provided for @orderDetailsMovedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Moved: {from} → {to}'**
  String orderDetailsMovedGeneric(String from, String to);

  /// No description provided for @orderDetailsItemFallback.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get orderDetailsItemFallback;

  /// No description provided for @orderDetailsPreviousTotal.
  ///
  /// In en, this message translates to:
  /// **'Previous total'**
  String get orderDetailsPreviousTotal;

  /// No description provided for @orderDetailsFinalEvaluatedAmount.
  ///
  /// In en, this message translates to:
  /// **'Final Evaluated Amount'**
  String get orderDetailsFinalEvaluatedAmount;

  /// No description provided for @orderDetailsAdjustmentNoteHeader.
  ///
  /// In en, this message translates to:
  /// **'Adjustment Note'**
  String get orderDetailsAdjustmentNoteHeader;

  /// No description provided for @orderDetailsPhotoEvidenceHeader.
  ///
  /// In en, this message translates to:
  /// **'Photo Evidence'**
  String get orderDetailsPhotoEvidenceHeader;

  /// No description provided for @orderDetailsStageWaiting.
  ///
  /// In en, this message translates to:
  /// **'WAITING'**
  String get orderDetailsStageWaiting;

  /// No description provided for @orderDetailsStageAccepted.
  ///
  /// In en, this message translates to:
  /// **'ACCEPTED'**
  String get orderDetailsStageAccepted;

  /// No description provided for @orderDetailsStageReceived.
  ///
  /// In en, this message translates to:
  /// **'RECEIVED'**
  String get orderDetailsStageReceived;

  /// No description provided for @orderDetailsStageCustomerApproval.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER APPROVAL'**
  String get orderDetailsStageCustomerApproval;

  /// No description provided for @orderDetailsStageProcessing.
  ///
  /// In en, this message translates to:
  /// **'PROCESSING'**
  String get orderDetailsStageProcessing;

  /// No description provided for @orderDetailsStagePacked.
  ///
  /// In en, this message translates to:
  /// **'PACKED'**
  String get orderDetailsStagePacked;

  /// No description provided for @orderDetailsStageDelivered.
  ///
  /// In en, this message translates to:
  /// **'DELIVERED'**
  String get orderDetailsStageDelivered;

  /// No description provided for @orderDetailsRejectOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Reject Order'**
  String get orderDetailsRejectOrderButton;

  /// No description provided for @orderDetailsAcceptOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Accept Order'**
  String get orderDetailsAcceptOrderButton;

  /// No description provided for @orderDetailsMarkReceivedButton.
  ///
  /// In en, this message translates to:
  /// **'Mark as Received'**
  String get orderDetailsMarkReceivedButton;

  /// No description provided for @orderDetailsReconcileItemsButton.
  ///
  /// In en, this message translates to:
  /// **'Reconcile items'**
  String get orderDetailsReconcileItemsButton;

  /// No description provided for @orderDetailsStartProcessingButton.
  ///
  /// In en, this message translates to:
  /// **'Start Processing'**
  String get orderDetailsStartProcessingButton;

  /// No description provided for @orderDetailsWaitingApprovalStatus.
  ///
  /// In en, this message translates to:
  /// **'Waiting for customer approval'**
  String get orderDetailsWaitingApprovalStatus;

  /// No description provided for @orderDetailsResubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Resubmit Reconciliation'**
  String get orderDetailsResubmitButton;

  /// No description provided for @orderDetailsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading details: {error}'**
  String orderDetailsErrorLoading(String error);

  /// No description provided for @orderDetailsOtherCategoryFallback.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get orderDetailsOtherCategoryFallback;

  /// No description provided for @serviceCategoryWash.
  ///
  /// In en, this message translates to:
  /// **'Wash'**
  String get serviceCategoryWash;

  /// No description provided for @serviceCategoryIron.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get serviceCategoryIron;

  /// No description provided for @serviceCategoryWashAndIron.
  ///
  /// In en, this message translates to:
  /// **'Wash & Iron'**
  String get serviceCategoryWashAndIron;

  /// No description provided for @serviceCategoryDryClean.
  ///
  /// In en, this message translates to:
  /// **'Dry Clean'**
  String get serviceCategoryDryClean;

  /// No description provided for @serviceCategoryFold.
  ///
  /// In en, this message translates to:
  /// **'Fold'**
  String get serviceCategoryFold;

  /// No description provided for @serviceCategoryPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get serviceCategoryPremium;

  /// No description provided for @slotsSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get slotsSunday;

  /// No description provided for @slotsMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get slotsMonday;

  /// No description provided for @slotsTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get slotsTuesday;

  /// No description provided for @slotsWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get slotsWednesday;

  /// No description provided for @slotsThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get slotsThursday;

  /// No description provided for @slotsFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get slotsFriday;

  /// No description provided for @slotsSaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get slotsSaturday;

  /// No description provided for @servicesStatusPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get servicesStatusPendingReview;

  /// No description provided for @servicesStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get servicesStatusRejected;

  /// No description provided for @servicesStatusLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get servicesStatusLive;

  /// No description provided for @servicesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalogue & Services'**
  String get servicesPageTitle;

  /// No description provided for @servicesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Services Yet'**
  String get servicesEmptyTitle;

  /// No description provided for @servicesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Service\" to pick a category, choose subcategories and set your prices.'**
  String get servicesEmptySubtitle;

  /// No description provided for @servicesRejectedReason.
  ///
  /// In en, this message translates to:
  /// **'Rejected: {reason}'**
  String servicesRejectedReason(String reason);

  /// No description provided for @servicesPriceAdjustedByAdmin.
  ///
  /// In en, this message translates to:
  /// **'Price adjusted by admin: {reason}'**
  String servicesPriceAdjustedByAdmin(String reason);

  /// No description provided for @servicesFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load services: {error}'**
  String servicesFailedToLoad(String error);

  /// No description provided for @servicesAddServiceButton.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get servicesAddServiceButton;

  /// No description provided for @servicesPickCategorySnack.
  ///
  /// In en, this message translates to:
  /// **'Please pick a category'**
  String get servicesPickCategorySnack;

  /// No description provided for @servicesTurnOnSubcategorySnack.
  ///
  /// In en, this message translates to:
  /// **'Turn on at least one subcategory to offer'**
  String get servicesTurnOnSubcategorySnack;

  /// No description provided for @servicesEnterPriceSnack.
  ///
  /// In en, this message translates to:
  /// **'Enter a price greater than ₹0 for every activated subcategory'**
  String get servicesEnterPriceSnack;

  /// No description provided for @servicesSubmittedForReview.
  ///
  /// In en, this message translates to:
  /// **'Submitted for admin review'**
  String get servicesSubmittedForReview;

  /// No description provided for @servicesFailedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String servicesFailedToSave(String error);

  /// No description provided for @servicesEditServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get servicesEditServiceTitle;

  /// No description provided for @servicesRejectedByAdminNote.
  ///
  /// In en, this message translates to:
  /// **'Rejected by admin: {reason}\nMake changes and save to resubmit for review.'**
  String servicesRejectedByAdminNote(String reason);

  /// No description provided for @servicesServiceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get servicesServiceNameLabel;

  /// No description provided for @servicesServiceNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Premium Laundry Services'**
  String get servicesServiceNameHint;

  /// No description provided for @servicesNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get servicesNameRequired;

  /// No description provided for @servicesDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get servicesDescriptionLabel;

  /// No description provided for @servicesDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Quick turnaround, doorstep pickup'**
  String get servicesDescriptionHint;

  /// No description provided for @servicesDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get servicesDescriptionRequired;

  /// No description provided for @servicesCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get servicesCategoryLabel;

  /// No description provided for @servicesCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Category is required'**
  String get servicesCategoryRequired;

  /// No description provided for @servicesSubcategoriesHeader.
  ///
  /// In en, this message translates to:
  /// **'Subcategories'**
  String get servicesSubcategoriesHeader;

  /// No description provided for @servicesSubcategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick what you want to offer from this category and set your own price. Unit is fixed by admin.'**
  String get servicesSubcategoriesSubtitle;

  /// No description provided for @servicesFailedToLoadSubcategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {error}'**
  String servicesFailedToLoadSubcategories(String error);

  /// No description provided for @servicesNoSubcategoriesPublished.
  ///
  /// In en, this message translates to:
  /// **'Admin hasn\'t published any subcategories here yet.'**
  String get servicesNoSubcategoriesPublished;

  /// No description provided for @servicesSaveSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Save & Submit for Review'**
  String get servicesSaveSubmitButton;

  /// No description provided for @servicesUnitPer.
  ///
  /// In en, this message translates to:
  /// **'Unit: per {unit}'**
  String servicesUnitPer(String unit);

  /// No description provided for @servicesDemoPriceReferenceOnly.
  ///
  /// In en, this message translates to:
  /// **'Demo price: ₹{price}/{unit} — reference only'**
  String servicesDemoPriceReferenceOnly(String price, String unit);

  /// No description provided for @servicesPriceAdjustedHeader.
  ///
  /// In en, this message translates to:
  /// **'Price adjusted by admin'**
  String get servicesPriceAdjustedHeader;

  /// No description provided for @servicesYourPricePer.
  ///
  /// In en, this message translates to:
  /// **'Your price per {unit}'**
  String servicesYourPricePer(String unit);

  /// No description provided for @pricingEnterPriceSnack.
  ///
  /// In en, this message translates to:
  /// **'Enter a price greater than ₹0 for every activated subcategory.'**
  String get pricingEnterPriceSnack;

  /// No description provided for @pricingPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Garment Pricing Rates'**
  String get pricingPageTitle;

  /// No description provided for @pricingCreateServiceFirst.
  ///
  /// In en, this message translates to:
  /// **'Please create a laundry service offering first to configure custom pricing rates.'**
  String get pricingCreateServiceFirst;

  /// No description provided for @pricingFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load pricing: {error}'**
  String pricingFailedToLoad(String error);

  /// No description provided for @pricingErrorLoadingServices.
  ///
  /// In en, this message translates to:
  /// **'Error loading services: {error}'**
  String pricingErrorLoadingServices(String error);

  /// No description provided for @pricingSaveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get pricingSaveChangesButton;

  /// No description provided for @pricingNoSubcategoriesPublished.
  ///
  /// In en, this message translates to:
  /// **'Admin hasn\'t published any subcategories for this service yet.'**
  String get pricingNoSubcategoriesPublished;

  /// No description provided for @pricingUnitBillingPer.
  ///
  /// In en, this message translates to:
  /// **'Unit billing: per {unit}'**
  String pricingUnitBillingPer(String unit);

  /// No description provided for @pricingDemoPriceChargeWhatYouLike.
  ///
  /// In en, this message translates to:
  /// **'Demo price: ₹{price}/{unit} — you can charge whatever you like'**
  String pricingDemoPriceChargeWhatYouLike(String price, String unit);

  /// No description provided for @pricingPricesSaved.
  ///
  /// In en, this message translates to:
  /// **'Prices saved'**
  String get pricingPricesSaved;

  /// No description provided for @pricingFailedToSavePrices.
  ///
  /// In en, this message translates to:
  /// **'Failed to save prices: {error}'**
  String pricingFailedToSavePrices(String error);

  /// No description provided for @inventoryPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Operational Supplies'**
  String get inventoryPageTitle;

  /// No description provided for @inventoryAddSupplyItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Supply Item'**
  String get inventoryAddSupplyItemTitle;

  /// No description provided for @inventoryItemNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get inventoryItemNameLabel;

  /// No description provided for @inventoryItemNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Collar Scrub'**
  String get inventoryItemNameHint;

  /// No description provided for @inventoryRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get inventoryRequiredField;

  /// No description provided for @inventoryInitialQtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial Qty'**
  String get inventoryInitialQtyLabel;

  /// No description provided for @inventoryMinLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Min Limit'**
  String get inventoryMinLimitLabel;

  /// No description provided for @inventoryUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get inventoryUnitLabel;

  /// No description provided for @inventoryUnitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Liters, Bags, Cans'**
  String get inventoryUnitHint;

  /// No description provided for @inventoryAddItemButton.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get inventoryAddItemButton;

  /// No description provided for @inventoryItemAddedSnack.
  ///
  /// In en, this message translates to:
  /// **'Item added to inventory'**
  String get inventoryItemAddedSnack;

  /// No description provided for @inventoryLowStockWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Warning'**
  String get inventoryLowStockWarningTitle;

  /// No description provided for @inventoryLowStockWarningBody.
  ///
  /// In en, this message translates to:
  /// **'{count} supplies are running low. Please order soon.'**
  String inventoryLowStockWarningBody(int count);

  /// No description provided for @inventoryQuantityOfThreshold.
  ///
  /// In en, this message translates to:
  /// **'{qty} / {threshold} {unit} (Min limit)'**
  String inventoryQuantityOfThreshold(
      String qty, String threshold, String unit);

  /// No description provided for @inventoryOutBadge.
  ///
  /// In en, this message translates to:
  /// **'OUT'**
  String get inventoryOutBadge;

  /// No description provided for @inventoryLowBadge.
  ///
  /// In en, this message translates to:
  /// **'LOW'**
  String get inventoryLowBadge;

  /// No description provided for @slotsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Working Hours & Slots'**
  String get slotsPageTitle;

  /// No description provided for @slotsCapacityRequestedSnack.
  ///
  /// In en, this message translates to:
  /// **'Capacity change requested — pending admin approval'**
  String get slotsCapacityRequestedSnack;

  /// No description provided for @slotsFailedToUpdateCapacity.
  ///
  /// In en, this message translates to:
  /// **'Failed to update capacity: {error}'**
  String slotsFailedToUpdateCapacity(String error);

  /// No description provided for @slotsFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Failed: {error}'**
  String slotsFailedGeneric(String error);

  /// No description provided for @slotsSlotDeletedSnack.
  ///
  /// In en, this message translates to:
  /// **'Slot deleted'**
  String get slotsSlotDeletedSnack;

  /// No description provided for @slotsClosingAfterOpening.
  ///
  /// In en, this message translates to:
  /// **'Closing time must be after opening time.'**
  String get slotsClosingAfterOpening;

  /// No description provided for @slotsOperationalWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Operational Working Hours'**
  String get slotsOperationalWorkingHours;

  /// No description provided for @slotsToLabel.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get slotsToLabel;

  /// No description provided for @slotsClosedLabel.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get slotsClosedLabel;

  /// No description provided for @slotsErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String slotsErrorGeneric(String error);

  /// No description provided for @slotsDailyCapacityLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily Capacity Limit'**
  String get slotsDailyCapacityLimit;

  /// No description provided for @slotsPendingRequestNotice.
  ///
  /// In en, this message translates to:
  /// **'Request to change to {limit} orders/day is pending review.'**
  String slotsPendingRequestNotice(String limit);

  /// No description provided for @slotsMaxOrdersPerDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Orders per Day'**
  String get slotsMaxOrdersPerDayLabel;

  /// No description provided for @slotsMaxOrdersHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 20'**
  String get slotsMaxOrdersHint;

  /// No description provided for @slotsRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get slotsRequiredField;

  /// No description provided for @slotsUpdateRequestButton.
  ///
  /// In en, this message translates to:
  /// **'Update request'**
  String get slotsUpdateRequestButton;

  /// No description provided for @slotsUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get slotsUpdateButton;

  /// No description provided for @slotsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading: {error}'**
  String slotsErrorLoading(String error);

  /// No description provided for @slotsWeeklySlotsSchedule.
  ///
  /// In en, this message translates to:
  /// **'Weekly Slots Schedule'**
  String get slotsWeeklySlotsSchedule;

  /// No description provided for @slotsNoCustomSlots.
  ///
  /// In en, this message translates to:
  /// **'No custom slots configured. Tap \"+\" to add working hours.'**
  String get slotsNoCustomSlots;

  /// No description provided for @slotsMaxOrdersBadge.
  ///
  /// In en, this message translates to:
  /// **'Max {count} orders'**
  String slotsMaxOrdersBadge(String count);

  /// No description provided for @slotsEditPickupTimeSlotTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Pickup Time Slot'**
  String get slotsEditPickupTimeSlotTitle;

  /// No description provided for @slotsAddPickupTimeSlotTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Pickup Time Slot'**
  String get slotsAddPickupTimeSlotTitle;

  /// No description provided for @slotsDayOfWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Day of Week'**
  String get slotsDayOfWeekLabel;

  /// No description provided for @slotsStartTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get slotsStartTimeLabel;

  /// No description provided for @slotsStartTimeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 09:00'**
  String get slotsStartTimeHint;

  /// No description provided for @slotsEndTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get slotsEndTimeLabel;

  /// No description provided for @slotsEndTimeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 12:00'**
  String get slotsEndTimeHint;

  /// No description provided for @slotsMaxOrdersLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Orders Limit'**
  String get slotsMaxOrdersLimitLabel;

  /// No description provided for @slotsMaxOrdersLimitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5'**
  String get slotsMaxOrdersLimitHint;

  /// No description provided for @slotsInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get slotsInvalidNumber;

  /// No description provided for @slotsUpdateSlotButton.
  ///
  /// In en, this message translates to:
  /// **'Update Slot'**
  String get slotsUpdateSlotButton;

  /// No description provided for @slotsSaveSlotButton.
  ///
  /// In en, this message translates to:
  /// **'Save Slot'**
  String get slotsSaveSlotButton;

  /// No description provided for @slotsSlotUpdatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Slot updated successfully'**
  String get slotsSlotUpdatedSnack;

  /// No description provided for @slotsPickupSlotAddedSnack.
  ///
  /// In en, this message translates to:
  /// **'Pickup slot added'**
  String get slotsPickupSlotAddedSnack;

  /// No description provided for @slotsDayClosedError.
  ///
  /// In en, this message translates to:
  /// **'The selected day is closed under Working Hours.'**
  String get slotsDayClosedError;

  /// No description provided for @slotsOutsideWorkingHoursError.
  ///
  /// In en, this message translates to:
  /// **'Slot times must be within operational working hours ({open} to {close}).'**
  String slotsOutsideWorkingHoursError(String open, String close);

  /// No description provided for @slotsOverlapError.
  ///
  /// In en, this message translates to:
  /// **'This slot overlaps with an existing slot: {start} - {end} on {day}.'**
  String slotsOverlapError(String start, String end, String day);

  /// No description provided for @analyticsWeekSegment.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get analyticsWeekSegment;

  /// No description provided for @analyticsMonthSegment.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get analyticsMonthSegment;

  /// No description provided for @analyticsFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load analytics'**
  String get analyticsFailedToLoad;

  /// No description provided for @analyticsTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get analyticsTotalRevenue;

  /// No description provided for @analyticsOrdersDeliveredSub.
  ///
  /// In en, this message translates to:
  /// **'{count} orders delivered'**
  String analyticsOrdersDeliveredSub(int count);

  /// No description provided for @analyticsAvgTicketSize.
  ///
  /// In en, this message translates to:
  /// **'Avg Ticket Size'**
  String get analyticsAvgTicketSize;

  /// No description provided for @analyticsPerCompletedOrderSub.
  ///
  /// In en, this message translates to:
  /// **'per completed order'**
  String get analyticsPerCompletedOrderSub;

  /// No description provided for @analyticsFulfillmentRate.
  ///
  /// In en, this message translates to:
  /// **'Fulfillment Rate'**
  String get analyticsFulfillmentRate;

  /// No description provided for @analyticsOfTotalOrdersSub.
  ///
  /// In en, this message translates to:
  /// **'of {count} total orders'**
  String analyticsOfTotalOrdersSub(int count);

  /// No description provided for @analyticsTotalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get analyticsTotalOrders;

  /// No description provided for @analyticsInSelectedPeriodSub.
  ///
  /// In en, this message translates to:
  /// **'in selected period'**
  String get analyticsInSelectedPeriodSub;

  /// No description provided for @analyticsOrderVolumeLastNDays.
  ///
  /// In en, this message translates to:
  /// **'Order Volume (Last {days} Days)'**
  String analyticsOrderVolumeLastNDays(int days);

  /// No description provided for @analyticsNoOrdersRecorded.
  ///
  /// In en, this message translates to:
  /// **'No orders recorded in this period.'**
  String get analyticsNoOrdersRecorded;

  /// No description provided for @analyticsCategoryRevenueShare.
  ///
  /// In en, this message translates to:
  /// **'Category Revenue Share'**
  String get analyticsCategoryRevenueShare;

  /// No description provided for @analyticsNoDeliveredOrders.
  ///
  /// In en, this message translates to:
  /// **'No delivered orders in this period.'**
  String get analyticsNoDeliveredOrders;

  /// No description provided for @analyticsSlaCustomerRetention.
  ///
  /// In en, this message translates to:
  /// **'SLA & Customer Retention'**
  String get analyticsSlaCustomerRetention;

  /// No description provided for @analyticsOnTimeDelivery.
  ///
  /// In en, this message translates to:
  /// **'On-Time Delivery'**
  String get analyticsOnTimeDelivery;

  /// No description provided for @analyticsRepeatCustomers.
  ///
  /// In en, this message translates to:
  /// **'Repeat Customers'**
  String get analyticsRepeatCustomers;

  /// No description provided for @employeesEditStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Staff Member'**
  String get employeesEditStaffTitle;

  /// No description provided for @employeesInviteStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite Staff Member'**
  String get employeesInviteStaffTitle;

  /// No description provided for @employeesFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get employeesFullNameLabel;

  /// No description provided for @employeesFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. John Doe'**
  String get employeesFullNameHint;

  /// No description provided for @employeesNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get employeesNameRequired;

  /// No description provided for @employeesEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get employeesEmailLabel;

  /// No description provided for @employeesEmailHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. johndoe@lndry.com'**
  String get employeesEmailHint;

  /// No description provided for @employeesEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get employeesEmailRequired;

  /// No description provided for @employeesEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get employeesEmailInvalid;

  /// No description provided for @employeesPhoneOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number (Optional)'**
  String get employeesPhoneOptionalLabel;

  /// No description provided for @employeesPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 9876543210'**
  String get employeesPhoneHint;

  /// No description provided for @employeesShopRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop Role'**
  String get employeesShopRoleLabel;

  /// No description provided for @employeesRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'Vendor Owner (Admin)'**
  String get employeesRoleOwner;

  /// No description provided for @employeesRoleStaff.
  ///
  /// In en, this message translates to:
  /// **'Vendor Staff'**
  String get employeesRoleStaff;

  /// No description provided for @employeesPermissionsHeader.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get employeesPermissionsHeader;

  /// No description provided for @employeesPermReadOrders.
  ///
  /// In en, this message translates to:
  /// **'Read Orders'**
  String get employeesPermReadOrders;

  /// No description provided for @employeesPermProcessOrders.
  ///
  /// In en, this message translates to:
  /// **'Process & Confirm Orders'**
  String get employeesPermProcessOrders;

  /// No description provided for @employeesPermManageCatalog.
  ///
  /// In en, this message translates to:
  /// **'Manage Services & Pricing'**
  String get employeesPermManageCatalog;

  /// No description provided for @employeesPermManageEmployees.
  ///
  /// In en, this message translates to:
  /// **'Manage Employees'**
  String get employeesPermManageEmployees;

  /// No description provided for @employeesSaveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get employeesSaveChangesButton;

  /// No description provided for @employeesInviteStaffButton.
  ///
  /// In en, this message translates to:
  /// **'Invite Staff'**
  String get employeesInviteStaffButton;

  /// No description provided for @employeesStaffUpdatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Staff record updated'**
  String get employeesStaffUpdatedSnack;

  /// No description provided for @employeesInvitationSentSnack.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent'**
  String get employeesInvitationSentSnack;

  /// No description provided for @employeesResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password for {name}'**
  String employeesResetPasswordTitle(String name);

  /// No description provided for @employeesNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get employeesNewPasswordLabel;

  /// No description provided for @employeesNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters with 1 letter & 1 digit'**
  String get employeesNewPasswordHint;

  /// No description provided for @employeesPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password too short'**
  String get employeesPasswordTooShort;

  /// No description provided for @employeesPasswordUpdatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get employeesPasswordUpdatedSnack;

  /// No description provided for @employeesResetFailedSnack.
  ///
  /// In en, this message translates to:
  /// **'Reset failed: {error}'**
  String employeesResetFailedSnack(String error);

  /// No description provided for @employeesRemoveStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Staff Member'**
  String get employeesRemoveStaffTitle;

  /// No description provided for @employeesRemoveStaffConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from this shop?'**
  String employeesRemoveStaffConfirm(String name);

  /// No description provided for @employeesConfirmRemoveButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Remove'**
  String get employeesConfirmRemoveButton;

  /// No description provided for @employeesStaffRemovedSnack.
  ///
  /// In en, this message translates to:
  /// **'Staff member removed'**
  String get employeesStaffRemovedSnack;

  /// No description provided for @employeesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop Employees'**
  String get employeesPageTitle;

  /// No description provided for @employeesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Employees Found'**
  String get employeesEmptyTitle;

  /// No description provided for @employeesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite staff to assist you in managing laundry intake, status updates, and dispatch.'**
  String get employeesEmptySubtitle;

  /// No description provided for @employeesOwnerBadge.
  ///
  /// In en, this message translates to:
  /// **'OWNER'**
  String get employeesOwnerBadge;

  /// No description provided for @employeesStaffBadge.
  ///
  /// In en, this message translates to:
  /// **'STAFF'**
  String get employeesStaffBadge;

  /// No description provided for @employeesResetPassButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Pass'**
  String get employeesResetPassButton;

  /// No description provided for @employeesSavePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get employeesSavePasswordButton;

  /// No description provided for @employeesPermissionsButton.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get employeesPermissionsButton;

  /// No description provided for @employeesFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load employees: {error}'**
  String employeesFailedToLoad(String error);

  /// No description provided for @riderManagementAddRiderTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Rider'**
  String get riderManagementAddRiderTitle;

  /// No description provided for @riderManagementAddRiderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The rider logs in with this phone number, the same way you do.'**
  String get riderManagementAddRiderSubtitle;

  /// No description provided for @riderManagementFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Rahul Sen'**
  String get riderManagementFullNameHint;

  /// No description provided for @riderManagementPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get riderManagementPhoneLabel;

  /// No description provided for @riderManagementPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get riderManagementPhoneInvalid;

  /// No description provided for @riderManagementRiderAddedSnack.
  ///
  /// In en, this message translates to:
  /// **'Rider added'**
  String get riderManagementRiderAddedSnack;

  /// No description provided for @riderManagementRemoveRiderTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Rider'**
  String get riderManagementRemoveRiderTitle;

  /// No description provided for @riderManagementRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name}?'**
  String riderManagementRemoveConfirm(String name);

  /// No description provided for @riderManagementPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Rider Management'**
  String get riderManagementPageTitle;

  /// No description provided for @riderManagementEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Riders Yet'**
  String get riderManagementEmptyTitle;

  /// No description provided for @riderManagementEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your own delivery riders — they log in with their phone and only see their assigned pickups and deliveries.'**
  String get riderManagementEmptySubtitle;

  /// No description provided for @riderManagementFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load riders: {error}'**
  String riderManagementFailedToLoad(String error);

  /// No description provided for @riderMyJobsTitleWithVendor.
  ///
  /// In en, this message translates to:
  /// **'{vendor} — My Jobs'**
  String riderMyJobsTitleWithVendor(String vendor);

  /// No description provided for @riderMyJobsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Jobs'**
  String get riderMyJobsTitle;

  /// No description provided for @riderNoJobsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Jobs Right Now'**
  String get riderNoJobsTitle;

  /// No description provided for @riderNoJobsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pickup and delivery jobs assigned to you will show up here.'**
  String get riderNoJobsSubtitle;

  /// No description provided for @riderFailedToLoadJobs.
  ///
  /// In en, this message translates to:
  /// **'Failed to load jobs: {error}'**
  String riderFailedToLoadJobs(String error);

  /// No description provided for @riderPickupBadge.
  ///
  /// In en, this message translates to:
  /// **'PICKUP'**
  String get riderPickupBadge;

  /// No description provided for @riderDeliveryBadge.
  ///
  /// In en, this message translates to:
  /// **'DELIVERY'**
  String get riderDeliveryBadge;

  /// No description provided for @riderInProgressBadge.
  ///
  /// In en, this message translates to:
  /// **'IN PROGRESS'**
  String get riderInProgressBadge;

  /// No description provided for @riderOtpEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get riderOtpEnterCode;

  /// No description provided for @riderOtpPickupConfirmedSnack.
  ///
  /// In en, this message translates to:
  /// **'Pickup confirmed'**
  String get riderOtpPickupConfirmedSnack;

  /// No description provided for @riderOtpDeliveryConfirmedSnack.
  ///
  /// In en, this message translates to:
  /// **'Delivery confirmed'**
  String get riderOtpDeliveryConfirmedSnack;

  /// No description provided for @riderOtpInvalidExpired.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired code. Please try again.'**
  String get riderOtpInvalidExpired;

  /// No description provided for @riderConfirmPickupTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Pickup'**
  String get riderConfirmPickupTitle;

  /// No description provided for @riderConfirmDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delivery'**
  String get riderConfirmDeliveryTitle;

  /// No description provided for @riderOtpPrompt.
  ///
  /// In en, this message translates to:
  /// **'Ask the customer for the code shown in their app, then enter it below.'**
  String get riderOtpPrompt;

  /// No description provided for @riderNoLocationSnack.
  ///
  /// In en, this message translates to:
  /// **'No location available for this address'**
  String get riderNoLocationSnack;

  /// No description provided for @riderCouldNotOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Could not open Google Maps'**
  String get riderCouldNotOpenMaps;

  /// No description provided for @riderCouldNotStartPickup.
  ///
  /// In en, this message translates to:
  /// **'Could not start pickup: {error}'**
  String riderCouldNotStartPickup(String error);

  /// No description provided for @riderCouldNotStartDelivery.
  ///
  /// In en, this message translates to:
  /// **'Could not start delivery: {error}'**
  String riderCouldNotStartDelivery(String error);

  /// No description provided for @riderCancelPickupNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Cancel pickup is not available yet.'**
  String get riderCancelPickupNotAvailable;

  /// No description provided for @riderJobDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Detail'**
  String get riderJobDetailTitle;

  /// No description provided for @riderFailedToLoadJob.
  ///
  /// In en, this message translates to:
  /// **'Failed to load job: {error}'**
  String riderFailedToLoadJob(String error);

  /// No description provided for @riderItemsHeader.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get riderItemsHeader;

  /// No description provided for @riderNavigateButton.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get riderNavigateButton;

  /// No description provided for @riderPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending – {amount}'**
  String riderPaymentPending(String amount);

  /// No description provided for @riderFullPaymentCompleted.
  ///
  /// In en, this message translates to:
  /// **'Full Payment Completed'**
  String get riderFullPaymentCompleted;

  /// No description provided for @riderRefreshPaymentTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh payment status'**
  String get riderRefreshPaymentTooltip;

  /// No description provided for @riderCustomerPaymentPendingSnack.
  ///
  /// In en, this message translates to:
  /// **'Customer payment is still pending. Delivery cannot be completed.'**
  String get riderCustomerPaymentPendingSnack;

  /// No description provided for @riderStartPickupButton.
  ///
  /// In en, this message translates to:
  /// **'Start Pickup'**
  String get riderStartPickupButton;

  /// No description provided for @riderStartDeliveryButton.
  ///
  /// In en, this message translates to:
  /// **'Start Delivery'**
  String get riderStartDeliveryButton;

  /// No description provided for @riderPickUpButton.
  ///
  /// In en, this message translates to:
  /// **'Pick Up'**
  String get riderPickUpButton;

  /// No description provided for @riderMarkDeliveredButton.
  ///
  /// In en, this message translates to:
  /// **'Mark Delivered'**
  String get riderMarkDeliveredButton;

  /// No description provided for @riderCancelPickupButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel Pickup'**
  String get riderCancelPickupButton;

  /// No description provided for @riderConfirmWeightCountTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Weight & Count'**
  String get riderConfirmWeightCountTitle;

  /// No description provided for @riderWeighRecountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Weigh and recount the customer\'s items now — this corrects their rough estimate before pickup is confirmed.'**
  String get riderWeighRecountPrompt;

  /// No description provided for @riderWeightAreaBasedHeader.
  ///
  /// In en, this message translates to:
  /// **'Weight / Area Based'**
  String get riderWeightAreaBasedHeader;

  /// No description provided for @riderEnterExactUnit.
  ///
  /// In en, this message translates to:
  /// **'Enter exact {unit}'**
  String riderEnterExactUnit(String unit);

  /// No description provided for @riderPieceBasedHeader.
  ///
  /// In en, this message translates to:
  /// **'Piece Based'**
  String get riderPieceBasedHeader;

  /// No description provided for @riderFailedSaveMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Failed to save measurements: {error}'**
  String riderFailedSaveMeasurements(String error);

  /// No description provided for @riderSaveContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get riderSaveContinueButton;

  /// No description provided for @riderWeightBasedItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight-based items ({items})'**
  String riderWeightBasedItemsLabel(String items);

  /// No description provided for @riderMaxPhotosPerItem.
  ///
  /// In en, this message translates to:
  /// **'Maximum {max} photos per item.'**
  String riderMaxPhotosPerItem(String max);

  /// No description provided for @riderFailedSavePhotos.
  ///
  /// In en, this message translates to:
  /// **'Failed to save photos: {error}'**
  String riderFailedSavePhotos(String error);

  /// No description provided for @riderGarmentConditionPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Garment Condition Photos'**
  String get riderGarmentConditionPhotosTitle;

  /// No description provided for @riderPhotographEachItemPrompt.
  ///
  /// In en, this message translates to:
  /// **'Photograph each item before pickup — this protects both you and the customer if there\'s ever a damage dispute.'**
  String get riderPhotographEachItemPrompt;

  /// No description provided for @riderPhotosCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count}/{max} photos · 1 required, rest optional'**
  String riderPhotosCountLabel(String count, String max);

  /// No description provided for @riderSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get riderSaveButton;

  /// No description provided for @riderCollectBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Collect Balance'**
  String get riderCollectBalanceTitle;

  /// No description provided for @riderBalanceDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance Due'**
  String get riderBalanceDueLabel;

  /// No description provided for @riderPaymentMethodCod.
  ///
  /// In en, this message translates to:
  /// **'Payment method: Cash on Delivery'**
  String get riderPaymentMethodCod;

  /// No description provided for @riderPaymentMethodOnline.
  ///
  /// In en, this message translates to:
  /// **'Payment method: Online'**
  String get riderPaymentMethodOnline;

  /// No description provided for @riderNoBalanceDueBanner.
  ///
  /// In en, this message translates to:
  /// **'No balance due for this order.'**
  String get riderNoBalanceDueBanner;

  /// No description provided for @riderCustomerPaysOnlineBanner.
  ///
  /// In en, this message translates to:
  /// **'The customer pays this balance online in their own app. No action needed from you.'**
  String get riderCustomerPaysOnlineBanner;

  /// No description provided for @riderCashCollectionRecordedBanner.
  ///
  /// In en, this message translates to:
  /// **'Cash collection recorded.'**
  String get riderCashCollectionRecordedBanner;

  /// No description provided for @riderFailedRecordCashCollection.
  ///
  /// In en, this message translates to:
  /// **'Failed to record cash collection: {error}'**
  String riderFailedRecordCashCollection(String error);

  /// No description provided for @riderConfirmCashCollectedButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm {amount} Cash Collected'**
  String riderConfirmCashCollectedButton(String amount);

  /// No description provided for @riderContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get riderContinueButton;

  /// No description provided for @riderDeliveryPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Photo'**
  String get riderDeliveryPhotoTitle;

  /// No description provided for @riderOptionalPhotoPrompt.
  ///
  /// In en, this message translates to:
  /// **'Optionally photograph the handover as delivery proof. This step can be skipped.'**
  String get riderOptionalPhotoPrompt;

  /// No description provided for @riderTakePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get riderTakePhotoLabel;

  /// No description provided for @riderFailedSavePhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to save photo: {error}'**
  String riderFailedSavePhoto(String error);

  /// No description provided for @riderSkipContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Skip & Continue'**
  String get riderSkipContinueButton;

  /// No description provided for @notificationsJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notificationsJustNow;

  /// No description provided for @notificationsMinsAgo.
  ///
  /// In en, this message translates to:
  /// **'{mins} mins ago'**
  String notificationsMinsAgo(int mins);

  /// No description provided for @notificationsHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours,plural, one{1 hr ago} other{{hours} hrs ago}}'**
  String notificationsHoursAgo(int hours);

  /// No description provided for @notificationsDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days,plural, one{1 day ago} other{{days} days ago}}'**
  String notificationsDaysAgo(int days);

  /// No description provided for @notificationsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsPageTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications: {error}'**
  String notificationsFailedToLoad(String error);

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Notifications Yet'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Operational push updates, payout alerts, and admin pricing notes will appear here.'**
  String get notificationsEmptySubtitle;

  /// No description provided for @profileUpdatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSnack;

  /// No description provided for @profileCropLogoTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Logo'**
  String get profileCropLogoTitle;

  /// No description provided for @profileCropBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Banner Image'**
  String get profileCropBannerTitle;

  /// No description provided for @profileLogoUpdatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Logo updated'**
  String get profileLogoUpdatedSnack;

  /// No description provided for @profileBannerUpdatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Banner image updated'**
  String get profileBannerUpdatedSnack;

  /// No description provided for @profileFailedUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image: {error}'**
  String profileFailedUploadImage(String error);

  /// No description provided for @profileLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your vendor account?'**
  String get profileLogoutConfirm;

  /// No description provided for @profilePublishedSnack.
  ///
  /// In en, this message translates to:
  /// **'Published to marketplace — customers can now discover you.'**
  String get profilePublishedSnack;

  /// No description provided for @profileFailedToPublish.
  ///
  /// In en, this message translates to:
  /// **'Failed to publish: {error}'**
  String profileFailedToPublish(String error);

  /// No description provided for @profilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profilePageTitle;

  /// No description provided for @profileBestFitNote.
  ///
  /// In en, this message translates to:
  /// **'Best fit — logo: 500×500px square. Banner: 780×1080px portrait. Matches exactly how customers see your shop, so nothing gets stretched or cropped oddly.'**
  String get profileBestFitNote;

  /// No description provided for @profileEditBusinessDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Business Details'**
  String get profileEditBusinessDetails;

  /// No description provided for @profileBusinessNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get profileBusinessNameLabel;

  /// No description provided for @profileRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get profileRequiredField;

  /// No description provided for @profileBusinessEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Email'**
  String get profileBusinessEmailLabel;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profileBusinessDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Description'**
  String get profileBusinessDescriptionLabel;

  /// No description provided for @profileAddressLine1Label.
  ///
  /// In en, this message translates to:
  /// **'Address Line 1'**
  String get profileAddressLine1Label;

  /// No description provided for @profileCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profileCityLabel;

  /// No description provided for @profileStateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get profileStateLabel;

  /// No description provided for @profilePincodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get profilePincodeLabel;

  /// No description provided for @profileVerifiedPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified Phone (cannot change)'**
  String get profileVerifiedPhoneLabel;

  /// No description provided for @profileNotSetValue.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get profileNotSetValue;

  /// No description provided for @profileAddressFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileAddressFieldLabel;

  /// No description provided for @profileAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccountSection;

  /// No description provided for @profileNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View order alerts and updates'**
  String get profileNotificationsSubtitle;

  /// No description provided for @profileSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App preferences and theme'**
  String get profileSettingsSubtitle;

  /// No description provided for @profileBusinessSection.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get profileBusinessSection;

  /// No description provided for @profileCatalogueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick categories, activate subcategories, set your prices'**
  String get profileCatalogueSubtitle;

  /// No description provided for @profilePublishLabel.
  ///
  /// In en, this message translates to:
  /// **'Publish to Marketplace'**
  String get profilePublishLabel;

  /// No description provided for @profilePublishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make your shop discoverable to customers'**
  String get profilePublishSubtitle;

  /// No description provided for @profileStaffLabel.
  ///
  /// In en, this message translates to:
  /// **'Staff Management'**
  String get profileStaffLabel;

  /// No description provided for @profileStaffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add and manage employees'**
  String get profileStaffSubtitle;

  /// No description provided for @profileRiderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add and manage your delivery riders'**
  String get profileRiderSubtitle;

  /// No description provided for @profileSlotsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup Slots'**
  String get profileSlotsLabel;

  /// No description provided for @profileSlotsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage availability and capacity'**
  String get profileSlotsSubtitle;

  /// No description provided for @profileInventoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Inventory & Supplies'**
  String get profileInventoryLabel;

  /// No description provided for @profileInventorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track laundry supplies and stock'**
  String get profileInventorySubtitle;

  /// No description provided for @profileSupportSection.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profileSupportSection;

  /// No description provided for @profileHelpLabel.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get profileHelpLabel;

  /// No description provided for @profileHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get assistance from our partner team'**
  String get profileHelpSubtitle;

  /// No description provided for @profileAboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About LNDRY'**
  String get profileAboutLabel;

  /// No description provided for @profileAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version {version} • © 2026 LNDRY Technologies'**
  String profileAboutSubtitle(String version);

  /// No description provided for @onboardingStepBusinessDetails.
  ///
  /// In en, this message translates to:
  /// **'Business Details'**
  String get onboardingStepBusinessDetails;

  /// No description provided for @onboardingStepOwnerBank.
  ///
  /// In en, this message translates to:
  /// **'Owner & Bank Details'**
  String get onboardingStepOwnerBank;

  /// No description provided for @onboardingStepLocation.
  ///
  /// In en, this message translates to:
  /// **'Shop Location'**
  String get onboardingStepLocation;

  /// No description provided for @onboardingStepRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius & Capacity'**
  String get onboardingStepRadius;

  /// No description provided for @onboardingStepDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get onboardingStepDocuments;

  /// No description provided for @onboardingStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get onboardingStepReview;

  /// No description provided for @onboardingLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your application. Please try again.'**
  String get onboardingLoadError;

  /// No description provided for @onboardingUploadAllDocuments.
  ///
  /// In en, this message translates to:
  /// **'Please upload all required documents before submitting.'**
  String get onboardingUploadAllDocuments;

  /// No description provided for @onboardingUploadDocumentsToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please upload all required documents to continue.'**
  String get onboardingUploadDocumentsToContinue;

  /// No description provided for @onboardingVendorApplicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Vendor Application'**
  String get onboardingVendorApplicationTitle;

  /// No description provided for @onboardingApplicationSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Submitted'**
  String get onboardingApplicationSubmittedTitle;

  /// No description provided for @onboardingApplicationSubmittedBody.
  ///
  /// In en, this message translates to:
  /// **'Your application is pending review by our team. We will notify you once it is approved.'**
  String get onboardingApplicationSubmittedBody;

  /// No description provided for @onboardingLogOutButton.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get onboardingLogOutButton;

  /// No description provided for @onboardingStepOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}: {title}'**
  String onboardingStepOfTotal(int current, int total, String title);

  /// No description provided for @onboardingCorrectionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Correction needed'**
  String get onboardingCorrectionNeeded;

  /// No description provided for @onboardingCorrectionOnlyFlaggedEditable.
  ///
  /// In en, this message translates to:
  /// **'Only the sections above are editable — everything else is locked as you originally submitted it.'**
  String get onboardingCorrectionOnlyFlaggedEditable;

  /// No description provided for @onboardingBusinessNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get onboardingBusinessNameLabel;

  /// No description provided for @onboardingBusinessNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sparkle Laundry Co.'**
  String get onboardingBusinessNameHint;

  /// No description provided for @onboardingBusinessNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Business name is required'**
  String get onboardingBusinessNameRequired;

  /// No description provided for @onboardingDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Tell customers what your shop specializes in'**
  String get onboardingDescriptionHint;

  /// No description provided for @onboardingGstLabel.
  ///
  /// In en, this message translates to:
  /// **'GST Number (optional)'**
  String get onboardingGstLabel;

  /// No description provided for @onboardingPanLabel.
  ///
  /// In en, this message translates to:
  /// **'PAN Number (optional)'**
  String get onboardingPanLabel;

  /// No description provided for @onboardingOwnerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get onboardingOwnerNameLabel;

  /// No description provided for @onboardingOwnerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name of the shop owner'**
  String get onboardingOwnerNameHint;

  /// No description provided for @onboardingOwnerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Owner name is required'**
  String get onboardingOwnerNameRequired;

  /// No description provided for @onboardingEmailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get onboardingEmailOptionalLabel;

  /// No description provided for @onboardingBankDetailsOptionalHeader.
  ///
  /// In en, this message translates to:
  /// **'Bank Details (optional)'**
  String get onboardingBankDetailsOptionalHeader;

  /// No description provided for @onboardingBankAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank Account Number'**
  String get onboardingBankAccountLabel;

  /// No description provided for @onboardingIfscLabel.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get onboardingIfscLabel;

  /// No description provided for @onboardingBankNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get onboardingBankNameLabel;

  /// No description provided for @onboardingAccountHolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get onboardingAccountHolderLabel;

  /// No description provided for @onboardingDetectingLocation.
  ///
  /// In en, this message translates to:
  /// **'Detecting…'**
  String get onboardingDetectingLocation;

  /// No description provided for @onboardingUseCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get onboardingUseCurrentLocation;

  /// No description provided for @onboardingAddressLine1Hint.
  ///
  /// In en, this message translates to:
  /// **'Shop / building name'**
  String get onboardingAddressLine1Hint;

  /// No description provided for @onboardingAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get onboardingAddressRequired;

  /// No description provided for @onboardingAddressLine2Label.
  ///
  /// In en, this message translates to:
  /// **'Address Line 2 (optional)'**
  String get onboardingAddressLine2Label;

  /// No description provided for @onboardingPincodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Pincode is required'**
  String get onboardingPincodeRequired;

  /// No description provided for @onboardingPincodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 6-digit pincode'**
  String get onboardingPincodeInvalid;

  /// No description provided for @onboardingDetectedCoords.
  ///
  /// In en, this message translates to:
  /// **'Detected: {lat}, {lng}'**
  String onboardingDetectedCoords(String lat, String lng);

  /// No description provided for @onboardingRadiusQuestion.
  ///
  /// In en, this message translates to:
  /// **'How far should we look for customers around your shop?'**
  String get onboardingRadiusQuestion;

  /// No description provided for @onboardingKmValue.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String onboardingKmValue(String km);

  /// No description provided for @onboardingCapacityQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many orders can you handle per day?'**
  String get onboardingCapacityQuestion;

  /// No description provided for @onboardingCustomLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get onboardingCustomLabel;

  /// No description provided for @onboardingUploadDocumentsPrompt.
  ///
  /// In en, this message translates to:
  /// **'Upload the following to complete your application.'**
  String get onboardingUploadDocumentsPrompt;

  /// No description provided for @onboardingOwnerIdentityTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner Identity'**
  String get onboardingOwnerIdentityTitle;

  /// No description provided for @onboardingShopPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop Photo'**
  String get onboardingShopPhotoTitle;

  /// No description provided for @onboardingServiceListTitle.
  ///
  /// In en, this message translates to:
  /// **'Service List (PDF)'**
  String get onboardingServiceListTitle;

  /// No description provided for @onboardingReplaceButton.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get onboardingReplaceButton;

  /// No description provided for @onboardingUploadButton.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get onboardingUploadButton;

  /// No description provided for @onboardingUploadedLabel.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get onboardingUploadedLabel;

  /// No description provided for @onboardingReviewPrompt.
  ///
  /// In en, this message translates to:
  /// **'Review your details before submitting.'**
  String get onboardingReviewPrompt;

  /// No description provided for @onboardingReviewOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get onboardingReviewOwner;

  /// No description provided for @onboardingReviewServiceRadius.
  ///
  /// In en, this message translates to:
  /// **'Service radius'**
  String get onboardingReviewServiceRadius;

  /// No description provided for @onboardingReviewDailyCapacity.
  ///
  /// In en, this message translates to:
  /// **'Daily capacity'**
  String get onboardingReviewDailyCapacity;

  /// No description provided for @onboardingOrdersPerDay.
  ///
  /// In en, this message translates to:
  /// **'{count} orders/day'**
  String onboardingOrdersPerDay(int count);

  /// No description provided for @onboardingReviewOwnerIdentity.
  ///
  /// In en, this message translates to:
  /// **'Owner identity'**
  String get onboardingReviewOwnerIdentity;

  /// No description provided for @onboardingReviewShopPhoto.
  ///
  /// In en, this message translates to:
  /// **'Shop photo'**
  String get onboardingReviewShopPhoto;

  /// No description provided for @onboardingReviewServiceList.
  ///
  /// In en, this message translates to:
  /// **'Service list'**
  String get onboardingReviewServiceList;

  /// No description provided for @onboardingMissingLabel.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get onboardingMissingLabel;

  /// No description provided for @onboardingBackButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBackButton;

  /// No description provided for @onboardingSubmitApplicationButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get onboardingSubmitApplicationButton;

  /// No description provided for @onboardingNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNextButton;

  /// No description provided for @helpFaq1Q.
  ///
  /// In en, this message translates to:
  /// **'How do I accept an order?'**
  String get helpFaq1Q;

  /// No description provided for @helpFaq1A.
  ///
  /// In en, this message translates to:
  /// **'When a new order arrives, it appears in your Dashboard under \"New Incoming Orders\". Tap \"Accept\" to confirm it, or \"Reject\" if you are unable to fulfil it. Accepted orders move to the Active tab in Orders.'**
  String get helpFaq1A;

  /// No description provided for @helpFaq2Q.
  ///
  /// In en, this message translates to:
  /// **'How do payouts work?'**
  String get helpFaq2Q;

  /// No description provided for @helpFaq2A.
  ///
  /// In en, this message translates to:
  /// **'LNDRY processes vendor payouts every 7 days. After deducting the platform fee (₹15 per order) and GST, the remaining amount is transferred to your registered bank account via NEFT/IMPS.'**
  String get helpFaq2A;

  /// No description provided for @helpFaq3Q.
  ///
  /// In en, this message translates to:
  /// **'How do I change my working hours?'**
  String get helpFaq3Q;

  /// No description provided for @helpFaq3A.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Pickup Slots (or Quick Actions → Slots on Dashboard). Here you can add, edit, or remove time slots for each day of the week. You can also enable/disable individual slots.'**
  String get helpFaq3A;

  /// No description provided for @helpFaq4Q.
  ///
  /// In en, this message translates to:
  /// **'How do I contact the customer?'**
  String get helpFaq4Q;

  /// No description provided for @helpFaq4A.
  ///
  /// In en, this message translates to:
  /// **'Open the Order Details page for the specific order. You will see the customer\'s name and a \"Call Customer\" button that dials them directly. Note: the customer\'s full phone number is masked for privacy until the order is accepted.'**
  String get helpFaq4A;

  /// No description provided for @helpFaq5Q.
  ///
  /// In en, this message translates to:
  /// **'What does \"Pending\" status mean?'**
  String get helpFaq5Q;

  /// No description provided for @helpFaq5A.
  ///
  /// In en, this message translates to:
  /// **'Pending orders are new orders placed by customers that are waiting for your acceptance. You have a time window to accept or reject them. After the window expires, they are auto-rejected.'**
  String get helpFaq5A;

  /// No description provided for @helpFaq6Q.
  ///
  /// In en, this message translates to:
  /// **'How do I update garment prices?'**
  String get helpFaq6Q;

  /// No description provided for @helpFaq6A.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Profile → Garment Pricing or use the Catalogue tab. Select a service, then add/edit/delete individual garment rates. Changes take effect immediately for new orders.'**
  String get helpFaq6A;

  /// No description provided for @helpFaq7Q.
  ///
  /// In en, this message translates to:
  /// **'Can I manage multiple employees?'**
  String get helpFaq7Q;

  /// No description provided for @helpFaq7A.
  ///
  /// In en, this message translates to:
  /// **'Yes. Go to Profile → Staff Management. You can add employees, assign roles (Manager, Washer, Ironer, Packer), set permissions, toggle their active status, and reset their passwords.'**
  String get helpFaq7A;

  /// No description provided for @helpFaq8Q.
  ///
  /// In en, this message translates to:
  /// **'What is the platform fee?'**
  String get helpFaq8Q;

  /// No description provided for @helpFaq8A.
  ///
  /// In en, this message translates to:
  /// **'LNDRY charges a platform fee of ₹15 per order for connecting you with customers, payment processing, and operational support. GST at 18% applies on the platform fee only.'**
  String get helpFaq8A;

  /// No description provided for @helpTicketCreatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Support ticket created! We will respond within 24 hours.'**
  String get helpTicketCreatedSnack;

  /// No description provided for @helpFailedCreateTicket.
  ///
  /// In en, this message translates to:
  /// **'Failed to create ticket: {error}'**
  String helpFailedCreateTicket(String error);

  /// No description provided for @helpCreateSupportTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Support Ticket'**
  String get helpCreateSupportTicketTitle;

  /// No description provided for @helpCategoryOrderIssue.
  ///
  /// In en, this message translates to:
  /// **'Order Issue'**
  String get helpCategoryOrderIssue;

  /// No description provided for @helpCategoryPayout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get helpCategoryPayout;

  /// No description provided for @helpCategoryTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical'**
  String get helpCategoryTechnical;

  /// No description provided for @helpCategoryAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get helpCategoryAccount;

  /// No description provided for @helpCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get helpCategoryOther;

  /// No description provided for @helpSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get helpSubjectLabel;

  /// No description provided for @helpSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'Brief description of your issue'**
  String get helpSubjectHint;

  /// No description provided for @helpDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Provide more details about your issue...'**
  String get helpDescriptionHint;

  /// No description provided for @helpDescriptionTooShort.
  ///
  /// In en, this message translates to:
  /// **'Please provide more details'**
  String get helpDescriptionTooShort;

  /// No description provided for @helpSubmitTicketButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Ticket'**
  String get helpSubmitTicketButton;

  /// No description provided for @helpTabContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get helpTabContact;

  /// No description provided for @helpTabFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get helpTabFaq;

  /// No description provided for @helpTabTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get helpTabTickets;

  /// No description provided for @helpPartnerSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'LNDRY Partner Support'**
  String get helpPartnerSupportTitle;

  /// No description provided for @helpPartnerSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We are here to help! Reach us through any channel below.\nAvailable Mon–Sat, 9 AM – 7 PM IST.'**
  String get helpPartnerSupportSubtitle;

  /// No description provided for @helpReachUsHeader.
  ///
  /// In en, this message translates to:
  /// **'Reach Us'**
  String get helpReachUsHeader;

  /// No description provided for @helpCallSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Call Support'**
  String get helpCallSupportTitle;

  /// No description provided for @helpCallSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'+91 1800-123-5678 (Toll Free)'**
  String get helpCallSupportSubtitle;

  /// No description provided for @helpCallNowAction.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get helpCallNowAction;

  /// No description provided for @helpCallingSnack.
  ///
  /// In en, this message translates to:
  /// **'Calling LNDRY Support...'**
  String get helpCallingSnack;

  /// No description provided for @helpEmailSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get helpEmailSupportTitle;

  /// No description provided for @helpSendEmailAction.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get helpSendEmailAction;

  /// No description provided for @helpOpeningEmailSnack.
  ///
  /// In en, this message translates to:
  /// **'Opening email client...'**
  String get helpOpeningEmailSnack;

  /// No description provided for @helpWhatsappSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Support'**
  String get helpWhatsappSupportTitle;

  /// No description provided for @helpOpenWhatsappAction.
  ///
  /// In en, this message translates to:
  /// **'Open WhatsApp'**
  String get helpOpenWhatsappAction;

  /// No description provided for @helpOpeningWhatsappSnack.
  ///
  /// In en, this message translates to:
  /// **'Opening WhatsApp...'**
  String get helpOpeningWhatsappSnack;

  /// No description provided for @helpCreateTicketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your issue with a ticket ID'**
  String get helpCreateTicketSubtitle;

  /// No description provided for @helpCreateTicketAction.
  ///
  /// In en, this message translates to:
  /// **'Create Ticket'**
  String get helpCreateTicketAction;

  /// No description provided for @helpResponseTimesHeader.
  ///
  /// In en, this message translates to:
  /// **'Response Times'**
  String get helpResponseTimesHeader;

  /// No description provided for @helpPhoneWhatsappLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone / WhatsApp'**
  String get helpPhoneWhatsappLabel;

  /// No description provided for @helpImmediateValue.
  ///
  /// In en, this message translates to:
  /// **'Immediate'**
  String get helpImmediateValue;

  /// No description provided for @helpLessThan4Hours.
  ///
  /// In en, this message translates to:
  /// **'< 4 hours'**
  String get helpLessThan4Hours;

  /// No description provided for @helpSupportTicketLabel.
  ///
  /// In en, this message translates to:
  /// **'Support Ticket'**
  String get helpSupportTicketLabel;

  /// No description provided for @helpLessThan24Hours.
  ///
  /// In en, this message translates to:
  /// **'< 24 hours'**
  String get helpLessThan24Hours;

  /// No description provided for @helpCantFindAnswer.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find your answer? Create a support ticket.'**
  String get helpCantFindAnswer;

  /// No description provided for @helpCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get helpCreateAction;

  /// No description provided for @helpFailedToLoadTickets.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tickets'**
  String get helpFailedToLoadTickets;

  /// No description provided for @helpNoTicketsYet.
  ///
  /// In en, this message translates to:
  /// **'No tickets yet'**
  String get helpNoTicketsYet;

  /// No description provided for @helpNoTicketsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a ticket and we will respond within 24 hours.'**
  String get helpNoTicketsSubtitle;

  /// No description provided for @helpCreateNewTicketButton.
  ///
  /// In en, this message translates to:
  /// **'Create New Ticket'**
  String get helpCreateNewTicketButton;

  /// No description provided for @helpYourTicketsHeader.
  ///
  /// In en, this message translates to:
  /// **'Your Tickets'**
  String get helpYourTicketsHeader;

  /// No description provided for @helpStatusReplied.
  ///
  /// In en, this message translates to:
  /// **'Replied'**
  String get helpStatusReplied;

  /// No description provided for @helpStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get helpStatusOpen;

  /// No description provided for @helpStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get helpStatusClosed;

  /// No description provided for @ticketYouLabel.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get ticketYouLabel;

  /// No description provided for @ticketSupportTeamLabel.
  ///
  /// In en, this message translates to:
  /// **'Support Team'**
  String get ticketSupportTeamLabel;

  /// No description provided for @ticketWaitingForReplyBanner.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a reply from our support team. We usually respond within 24 hours.'**
  String get ticketWaitingForReplyBanner;

  /// No description provided for @ticketAreYouSatisfied.
  ///
  /// In en, this message translates to:
  /// **'Are you satisfied with this response?'**
  String get ticketAreYouSatisfied;

  /// No description provided for @ticketYesButton.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get ticketYesButton;

  /// No description provided for @ticketNoButton.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get ticketNoButton;

  /// No description provided for @ticketRateExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate your support experience'**
  String get ticketRateExperience;

  /// No description provided for @ticketSubmitRatingButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get ticketSubmitRatingButton;

  /// No description provided for @ticketWhatWouldYouAsk.
  ///
  /// In en, this message translates to:
  /// **'What would you like to ask?'**
  String get ticketWhatWouldYouAsk;

  /// No description provided for @ticketTypeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get ticketTypeMessageHint;

  /// No description provided for @ticketSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get ticketSendButton;

  /// No description provided for @ticketThanksForFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get ticketThanksForFeedback;

  /// No description provided for @ticketFailedSubmitRating.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit rating: {error}'**
  String ticketFailedSubmitRating(String error);

  /// No description provided for @ticketMessageSentSnack.
  ///
  /// In en, this message translates to:
  /// **'Your message was sent to our support team.'**
  String get ticketMessageSentSnack;

  /// No description provided for @ticketFailedToSend.
  ///
  /// In en, this message translates to:
  /// **'Failed to send: {error}'**
  String ticketFailedToSend(String error);

  /// No description provided for @ticketYourRatingHeader.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get ticketYourRatingHeader;

  /// No description provided for @ticketClosedByTeamBanner.
  ///
  /// In en, this message translates to:
  /// **'This ticket has been closed by our support team.'**
  String get ticketClosedByTeamBanner;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'hi':
      {
        switch (locale.scriptCode) {
          case 'Latn':
            return AppLocalizationsHiLatn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
