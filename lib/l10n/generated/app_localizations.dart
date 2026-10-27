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

  /// Accessible label for the button that opens the customer's phone number in the device dialer
  ///
  /// In en, this message translates to:
  /// **'Call customer'**
  String get commonCallCustomer;

  /// Shown when the device cannot open its default phone dialer
  ///
  /// In en, this message translates to:
  /// **'Could not open the phone dialer. Please try again.'**
  String get commonCouldNotOpenDialer;

  /// App name shown on splash screen
  ///
  /// In en, this message translates to:
  /// **'Lndry Partner'**
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
  /// **'Lndry Partner • Version {version}\n© 2026 LNDRY Technologies Pvt. Ltd.'**
  String settingsFooter(String version);

  /// No description provided for @routerExitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit Application?'**
  String get routerExitAppTitle;

  /// No description provided for @routerExitAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit Lndry Partner?'**
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

  /// No description provided for @orderDetailsProblemReportRequired.
  ///
  /// In en, this message translates to:
  /// **'Report to Re-evaluation on at least one item before submitting'**
  String get orderDetailsProblemReportRequired;

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

  /// No description provided for @orderDetailsPhotoEvidenceOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Additional photo evidence (optional — already covered by your re-evaluation report below)'**
  String get orderDetailsPhotoEvidenceOptionalLabel;

  /// No description provided for @orderDetailsReportProblemButton.
  ///
  /// In en, this message translates to:
  /// **'Report to Re-evaluation'**
  String get orderDetailsReportProblemButton;

  /// No description provided for @orderDetailsReportProblemTitle.
  ///
  /// In en, this message translates to:
  /// **'Report to Re-evaluation'**
  String get orderDetailsReportProblemTitle;

  /// No description provided for @orderDetailsProblemTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'What\'s the problem?'**
  String get orderDetailsProblemTypeLabel;

  /// No description provided for @orderDetailsProblemOtherOption.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get orderDetailsProblemOtherOption;

  /// No description provided for @orderDetailsProblemCustomMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Describe the problem'**
  String get orderDetailsProblemCustomMessageLabel;

  /// No description provided for @orderDetailsProblemCustomMessageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Zipper broken on this item'**
  String get orderDetailsProblemCustomMessageHint;

  /// No description provided for @orderDetailsProblemPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo evidence (1-3 required)'**
  String get orderDetailsProblemPhotoLabel;

  /// No description provided for @orderDetailsProblemRemoveButton.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get orderDetailsProblemRemoveButton;

  /// No description provided for @orderDetailsProblemSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Report'**
  String get orderDetailsProblemSaveButton;

  /// No description provided for @orderDetailsReportedProblemsHeader.
  ///
  /// In en, this message translates to:
  /// **'Re-evaluation Reports'**
  String get orderDetailsReportedProblemsHeader;

  /// No description provided for @orderDetailsProblemForItem.
  ///
  /// In en, this message translates to:
  /// **'For: {item}'**
  String orderDetailsProblemForItem(String item);

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
  /// **'Pickup Captain'**
  String get orderDetailsPickupRiderLabel;

  /// No description provided for @orderDetailsDeliveryRiderLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Captain'**
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
  /// **'Assign Captain'**
  String get orderDetailsAssignRiderTitle;

  /// No description provided for @orderDetailsNoActiveRiders.
  ///
  /// In en, this message translates to:
  /// **'No active captains yet. Add one from Captain Management.'**
  String get orderDetailsNoActiveRiders;

  /// No description provided for @orderDetailsRiderAssignedSnack.
  ///
  /// In en, this message translates to:
  /// **'Captain assigned'**
  String get orderDetailsRiderAssignedSnack;

  /// No description provided for @orderDetailsBroadcastButton.
  ///
  /// In en, this message translates to:
  /// **'Broadcast to All Captains'**
  String get orderDetailsBroadcastButton;

  /// No description provided for @orderDetailsBroadcastSnack.
  ///
  /// In en, this message translates to:
  /// **'Broadcast sent to active captains'**
  String get orderDetailsBroadcastSnack;

  /// No description provided for @orderDetailsAssignedToRider.
  ///
  /// In en, this message translates to:
  /// **'Assigned to {name}'**
  String orderDetailsAssignedToRider(String name);

  /// No description provided for @orderDetailsOfferPendingBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Offer sent to all captains — awaiting acceptance'**
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
  /// **'Add Captain'**
  String get riderManagementAddRiderTitle;

  /// No description provided for @riderManagementAddRiderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The captain logs in with this phone number, the same way you do.'**
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
  /// **'Enter a valid 10-digit mobile number.'**
  String get riderManagementPhoneInvalid;

  /// No description provided for @riderManagementRiderAddedSnack.
  ///
  /// In en, this message translates to:
  /// **'Captain added'**
  String get riderManagementRiderAddedSnack;

  /// No description provided for @riderManagementRemoveRiderTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Captain'**
  String get riderManagementRemoveRiderTitle;

  /// No description provided for @riderManagementRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name}?'**
  String riderManagementRemoveConfirm(String name);

  /// No description provided for @riderManagementPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Captain Management'**
  String get riderManagementPageTitle;

  /// No description provided for @riderManagementEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Captains Yet'**
  String get riderManagementEmptyTitle;

  /// No description provided for @riderManagementEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your own delivery captains — they log in with their phone and only see their assigned pickups and deliveries.'**
  String get riderManagementEmptySubtitle;

  /// No description provided for @riderManagementFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load captains: {error}'**
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
  /// **'Add and manage your delivery captains'**
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

  /// No description provided for @employeesAddStaffButton.
  ///
  /// In en, this message translates to:
  /// **'Add Staff'**
  String get employeesAddStaffButton;

  /// No description provided for @employeesPhoneRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get employeesPhoneRequiredLabel;

  /// No description provided for @employeesPhoneRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit phone number — staff sign in with it'**
  String get employeesPhoneRequiredError;

  /// No description provided for @employeesPermissionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Select at least one permission'**
  String get employeesPermissionsRequired;

  /// No description provided for @employeesPermissionsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the permission list'**
  String get employeesPermissionsLoadFailed;

  /// No description provided for @employeesPermissionsHint.
  ///
  /// In en, this message translates to:
  /// **'Only the sections you switch on will open for this staff member.'**
  String get employeesPermissionsHint;

  /// No description provided for @employeesStaffOnlyNote.
  ///
  /// In en, this message translates to:
  /// **'Staff sign in to the main Partner app. Captains are added under Captain Management.'**
  String get employeesStaffOnlyNote;

  /// No description provided for @permModuleOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get permModuleOrders;

  /// No description provided for @permOrdersView.
  ///
  /// In en, this message translates to:
  /// **'View orders'**
  String get permOrdersView;

  /// No description provided for @permOrdersAcceptReject.
  ///
  /// In en, this message translates to:
  /// **'Accept / reject new orders'**
  String get permOrdersAcceptReject;

  /// No description provided for @permOrdersProcess.
  ///
  /// In en, this message translates to:
  /// **'Processing & status updates'**
  String get permOrdersProcess;

  /// No description provided for @permOrdersReevaluate.
  ///
  /// In en, this message translates to:
  /// **'Re-evaluation'**
  String get permOrdersReevaluate;

  /// No description provided for @permOrdersAssignCaptain.
  ///
  /// In en, this message translates to:
  /// **'Assign / broadcast to captains'**
  String get permOrdersAssignCaptain;

  /// No description provided for @permModuleCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Catalogue & pricing'**
  String get permModuleCatalogue;

  /// No description provided for @permCatalogueView.
  ///
  /// In en, this message translates to:
  /// **'View services & pricing'**
  String get permCatalogueView;

  /// No description provided for @permCatalogueManage.
  ///
  /// In en, this message translates to:
  /// **'Manage services & pricing'**
  String get permCatalogueManage;

  /// No description provided for @permModuleInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get permModuleInventory;

  /// No description provided for @permInventoryView.
  ///
  /// In en, this message translates to:
  /// **'View inventory'**
  String get permInventoryView;

  /// No description provided for @permInventoryManage.
  ///
  /// In en, this message translates to:
  /// **'Manage inventory'**
  String get permInventoryManage;

  /// No description provided for @permModuleSlots.
  ///
  /// In en, this message translates to:
  /// **'Pickup slots'**
  String get permModuleSlots;

  /// No description provided for @permSlotsView.
  ///
  /// In en, this message translates to:
  /// **'View pickup slots'**
  String get permSlotsView;

  /// No description provided for @permSlotsManage.
  ///
  /// In en, this message translates to:
  /// **'Manage pickup slots & capacity'**
  String get permSlotsManage;

  /// No description provided for @permModuleAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get permModuleAnalytics;

  /// No description provided for @permAnalyticsView.
  ///
  /// In en, this message translates to:
  /// **'View analytics'**
  String get permAnalyticsView;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the server. Check your internet connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorServerBusy.
  ///
  /// In en, this message translates to:
  /// **'The server is busy right now. Please try again in a moment.'**
  String get errorServerBusy;

  /// No description provided for @inventoryLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your supplies.'**
  String get inventoryLoadFailed;

  /// No description provided for @inventoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No supplies yet'**
  String get inventoryEmptyTitle;

  /// No description provided for @inventoryEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first supply item.'**
  String get inventoryEmptySubtitle;

  /// No description provided for @notifOffBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off, so you may miss new orders and job offers.'**
  String get notifOffBannerMessage;

  /// No description provided for @notifOffBannerAction.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get notifOffBannerAction;

  /// No description provided for @ordersAssistedBadge.
  ///
  /// In en, this message translates to:
  /// **'Assisted Booking'**
  String get ordersAssistedBadge;

  /// No description provided for @ordersAssistedSummary.
  ///
  /// In en, this message translates to:
  /// **'Service selection required'**
  String get ordersAssistedSummary;

  /// No description provided for @ordersAssistedPriceTbd.
  ///
  /// In en, this message translates to:
  /// **'To be evaluated'**
  String get ordersAssistedPriceTbd;

  /// No description provided for @orderDetailsAssistedTitle.
  ///
  /// In en, this message translates to:
  /// **'Assisted Booking / Service Selection Required'**
  String get orderDetailsAssistedTitle;

  /// No description provided for @orderDetailsAssistedBody.
  ///
  /// In en, this message translates to:
  /// **'The customer chose \"Book With Expert Check\", so no services or price were selected. Once the garments reach you, inspect them and choose the right services with quantity or weight using \"Choose Services\". The customer approves the price before processing starts.'**
  String get orderDetailsAssistedBody;

  /// No description provided for @orderDetailsAssistedChooseServices.
  ///
  /// In en, this message translates to:
  /// **'Choose Services'**
  String get orderDetailsAssistedChooseServices;

  /// No description provided for @orderDetailsAssistedNoServicesYet.
  ///
  /// In en, this message translates to:
  /// **'No services selected yet. Inspect the garments and choose the services.'**
  String get orderDetailsAssistedNoServicesYet;

  /// No description provided for @orderDetailsAssistedSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose services'**
  String get orderDetailsAssistedSheetTitle;

  /// No description provided for @orderDetailsAssistedSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a service for each type of garment, with quantity or weight. This is sent to the customer for approval before processing continues. Photos are optional.'**
  String get orderDetailsAssistedSheetSubtitle;

  /// No description provided for @orderDetailsAssistedAddServiceRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least one service to send for approval.'**
  String get orderDetailsAssistedAddServiceRequired;

  /// No description provided for @loginSessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please log in again to continue.'**
  String get loginSessionEnded;

  /// POS mode: posModeMarketplace
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get posModeMarketplace;

  /// POS mode: posModePos
  ///
  /// In en, this message translates to:
  /// **'POS (Counter)'**
  String get posModePos;

  /// POS mode: posAppModeTitle
  ///
  /// In en, this message translates to:
  /// **'App mode'**
  String get posAppModeTitle;

  /// POS mode: posAppModeSubtitle
  ///
  /// In en, this message translates to:
  /// **'Choose what you want to use right now.'**
  String get posAppModeSubtitle;

  /// POS mode: posAppModeSwitched
  ///
  /// In en, this message translates to:
  /// **'Switched to {mode}'**
  String posAppModeSwitched(String mode);

  /// POS mode: posAppModeNotAllowed
  ///
  /// In en, this message translates to:
  /// **'That mode is not available for your shop.'**
  String get posAppModeNotAllowed;

  /// POS mode: posGetPosTitle
  ///
  /// In en, this message translates to:
  /// **'Get POS for my shop'**
  String get posGetPosTitle;

  /// POS mode: posGetPosSubtitle
  ///
  /// In en, this message translates to:
  /// **'Make bills and keep customer records for walk-in customers.'**
  String get posGetPosSubtitle;

  /// POS mode: posFinishSetupTitle
  ///
  /// In en, this message translates to:
  /// **'Finish POS setup'**
  String get posFinishSetupTitle;

  /// POS mode: posFinishSetupSubtitle
  ///
  /// In en, this message translates to:
  /// **'You are only a few steps away from using POS.'**
  String get posFinishSetupSubtitle;

  /// POS mode: posChoiceTitle
  ///
  /// In en, this message translates to:
  /// **'What do you need?'**
  String get posChoiceTitle;

  /// POS mode: posChoiceSubtitle
  ///
  /// In en, this message translates to:
  /// **'Pick one to start. You can add the other later.'**
  String get posChoiceSubtitle;

  /// POS mode: posChoiceMarketplaceTitle
  ///
  /// In en, this message translates to:
  /// **'Get customers'**
  String get posChoiceMarketplaceTitle;

  /// POS mode: posChoiceMarketplaceBody
  ///
  /// In en, this message translates to:
  /// **'Get orders from the LNDRY customer app. Needs shop details and documents.'**
  String get posChoiceMarketplaceBody;

  /// POS mode: posChoicePosTitle
  ///
  /// In en, this message translates to:
  /// **'Run my shop (POS)'**
  String get posChoicePosTitle;

  /// POS mode: posChoicePosBody
  ///
  /// In en, this message translates to:
  /// **'Make bills, keep customer records and track your money at the counter. Ready in about 3 minutes.'**
  String get posChoicePosBody;

  /// POS mode: posChoiceBothHint
  ///
  /// In en, this message translates to:
  /// **'Want both? Start with Marketplace, then turn on POS later in Settings.'**
  String get posChoiceBothHint;

  /// POS mode: posModeCheckLoading
  ///
  /// In en, this message translates to:
  /// **'Getting your shop ready…'**
  String get posModeCheckLoading;

  /// POS mode: posOnbTitle
  ///
  /// In en, this message translates to:
  /// **'Set up POS'**
  String get posOnbTitle;

  /// POS mode: posOnbStepOf
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String posOnbStepOf(int current, int total);

  /// POS mode: posOnbStepShop
  ///
  /// In en, this message translates to:
  /// **'Shop details'**
  String get posOnbStepShop;

  /// POS mode: posOnbStepTax
  ///
  /// In en, this message translates to:
  /// **'Tax & payments'**
  String get posOnbStepTax;

  /// POS mode: posOnbStepCounter
  ///
  /// In en, this message translates to:
  /// **'Counter setup'**
  String get posOnbStepCounter;

  /// POS mode: posOnbStepPrices
  ///
  /// In en, this message translates to:
  /// **'Price list'**
  String get posOnbStepPrices;

  /// POS mode: posOnbShopName
  ///
  /// In en, this message translates to:
  /// **'Shop name'**
  String get posOnbShopName;

  /// POS mode: posOnbOwnerName
  ///
  /// In en, this message translates to:
  /// **'Owner name'**
  String get posOnbOwnerName;

  /// POS mode: posOnbAddress
  ///
  /// In en, this message translates to:
  /// **'Shop address'**
  String get posOnbAddress;

  /// POS mode: posOnbCity
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get posOnbCity;

  /// POS mode: posOnbState
  ///
  /// In en, this message translates to:
  /// **'State (optional)'**
  String get posOnbState;

  /// POS mode: posOnbPincode
  ///
  /// In en, this message translates to:
  /// **'Pincode (optional)'**
  String get posOnbPincode;

  /// POS mode: posOnbGstSwitch
  ///
  /// In en, this message translates to:
  /// **'My shop is GST registered'**
  String get posOnbGstSwitch;

  /// POS mode: posOnbGstin
  ///
  /// In en, this message translates to:
  /// **'GSTIN (15 characters)'**
  String get posOnbGstin;

  /// POS mode: posOnbUpi
  ///
  /// In en, this message translates to:
  /// **'UPI ID (optional)'**
  String get posOnbUpi;

  /// POS mode: posOnbUpiHint
  ///
  /// In en, this message translates to:
  /// **'like name@bank'**
  String get posOnbUpiHint;

  /// POS mode: posOnbInvoicePrefix
  ///
  /// In en, this message translates to:
  /// **'Invoice prefix'**
  String get posOnbInvoicePrefix;

  /// POS mode: posOnbPrinter
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get posOnbPrinter;

  /// POS mode: posPrinterNone
  ///
  /// In en, this message translates to:
  /// **'No printer'**
  String get posPrinterNone;

  /// POS mode: posPrinterSystem
  ///
  /// In en, this message translates to:
  /// **'Phone / system printer'**
  String get posPrinterSystem;

  /// POS mode: posPrinter58
  ///
  /// In en, this message translates to:
  /// **'Thermal 58 mm'**
  String get posPrinter58;

  /// POS mode: posPrinter80
  ///
  /// In en, this message translates to:
  /// **'Thermal 80 mm'**
  String get posPrinter80;

  /// POS mode: posOnbOrderPrefix
  ///
  /// In en, this message translates to:
  /// **'Order numbers start with'**
  String get posOnbOrderPrefix;

  /// POS mode: posOnbDeliveryDays
  ///
  /// In en, this message translates to:
  /// **'Usual delivery time (days)'**
  String get posOnbDeliveryDays;

  /// POS mode: posOnbPricesTitle
  ///
  /// In en, this message translates to:
  /// **'Start your price list'**
  String get posOnbPricesTitle;

  /// POS mode: posOnbPricesStarter
  ///
  /// In en, this message translates to:
  /// **'Use the sample price list'**
  String get posOnbPricesStarter;

  /// POS mode: posOnbPricesStarterBody
  ///
  /// In en, this message translates to:
  /// **'We add common garments and services with sample prices. Please check and change the prices.'**
  String get posOnbPricesStarterBody;

  /// POS mode: posOnbPricesOwn
  ///
  /// In en, this message translates to:
  /// **'I will add my own'**
  String get posOnbPricesOwn;

  /// POS mode: posOnbPricesOwnBody
  ///
  /// In en, this message translates to:
  /// **'Start empty and add your garments and prices yourself.'**
  String get posOnbPricesOwnBody;

  /// POS mode: posNext
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get posNext;

  /// POS mode: posBack
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get posBack;

  /// POS mode: posFinish
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get posFinish;

  /// POS mode: posSaving
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get posSaving;

  /// POS mode: posErrShopName
  ///
  /// In en, this message translates to:
  /// **'Enter your shop name'**
  String get posErrShopName;

  /// POS mode: posErrOwnerName
  ///
  /// In en, this message translates to:
  /// **'Enter the owner name'**
  String get posErrOwnerName;

  /// POS mode: posErrAddress
  ///
  /// In en, this message translates to:
  /// **'Enter your shop address'**
  String get posErrAddress;

  /// POS mode: posErrCity
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get posErrCity;

  /// POS mode: posErrPincode
  ///
  /// In en, this message translates to:
  /// **'Pincode must be 6 digits'**
  String get posErrPincode;

  /// POS mode: posErrGstin
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 15-character GSTIN'**
  String get posErrGstin;

  /// POS mode: posErrUpi
  ///
  /// In en, this message translates to:
  /// **'UPI ID should look like name@bank'**
  String get posErrUpi;

  /// POS mode: posErrPrefix
  ///
  /// In en, this message translates to:
  /// **'Use 1 to 6 letters or numbers'**
  String get posErrPrefix;

  /// POS mode: posErrDays
  ///
  /// In en, this message translates to:
  /// **'Enter a number from 0 to 30'**
  String get posErrDays;

  /// POS mode: posDoneTitle
  ///
  /// In en, this message translates to:
  /// **'Your shop is ready!'**
  String get posDoneTitle;

  /// POS mode: posDoneBody
  ///
  /// In en, this message translates to:
  /// **'Book your first order from the Home screen.'**
  String get posDoneBody;

  /// POS mode: posDoneStarterNote
  ///
  /// In en, this message translates to:
  /// **'{count} sample garments were added. Please check their prices.'**
  String posDoneStarterNote(int count);

  /// POS mode: posDoneButton
  ///
  /// In en, this message translates to:
  /// **'Open POS'**
  String get posDoneButton;

  /// POS mode: posOnbOwnerOnlyTitle
  ///
  /// In en, this message translates to:
  /// **'Ask the shop owner'**
  String get posOnbOwnerOnlyTitle;

  /// POS mode: posOnbOwnerOnlyBody
  ///
  /// In en, this message translates to:
  /// **'POS setup must be finished by the shop owner.'**
  String get posOnbOwnerOnlyBody;

  /// POS mode: posLogOut
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get posLogOut;

  /// POS mode: posTabHome
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get posTabHome;

  /// POS mode: posTabOrder
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get posTabOrder;

  /// POS mode: posTabSearch
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get posTabSearch;

  /// POS mode: posTabExpense
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get posTabExpense;

  /// POS mode: posTabReport
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get posTabReport;

  /// POS mode: posTabSetting
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get posTabSetting;

  /// POS mode: posComingSoonTitle
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get posComingSoonTitle;

  /// POS mode: posComingSoonBody
  ///
  /// In en, this message translates to:
  /// **'This part of POS is being built.'**
  String get posComingSoonBody;

  /// POS mode: posHomeWelcome
  ///
  /// In en, this message translates to:
  /// **'Welcome, {shop}'**
  String posHomeWelcome(String shop);

  /// POS mode: posHomeReady
  ///
  /// In en, this message translates to:
  /// **'Your POS is ready. Booking orders, customers and prices arrive in the next update.'**
  String get posHomeReady;

  /// POS mode: posSettingsTitle
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get posSettingsTitle;

  /// POS mode: posSettingsShop
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get posSettingsShop;

  /// POS mode: posHomeToday
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get posHomeToday;

  /// POS mode: posTileRevenue
  ///
  /// In en, this message translates to:
  /// **'Today Revenue'**
  String get posTileRevenue;

  /// POS mode: posTileCollection
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get posTileCollection;

  /// POS mode: posTileOrderRequests
  ///
  /// In en, this message translates to:
  /// **'Order Request'**
  String get posTileOrderRequests;

  /// POS mode: posTileWashingToStore
  ///
  /// In en, this message translates to:
  /// **'Washing to Store'**
  String get posTileWashingToStore;

  /// POS mode: posTileBooking
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get posTileBooking;

  /// POS mode: posTileDelivery
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get posTileDelivery;

  /// POS mode: posTileDelivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get posTileDelivered;

  /// POS mode: posTilePending
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get posTilePending;

  /// POS mode: posQuickActions
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get posQuickActions;

  /// POS mode: posActionBook
  ///
  /// In en, this message translates to:
  /// **'Book Order'**
  String get posActionBook;

  /// POS mode: posActionAddCustomer
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get posActionAddCustomer;

  /// POS mode: posActionAddPrice
  ///
  /// In en, this message translates to:
  /// **'Add Garment Price'**
  String get posActionAddPrice;

  /// POS mode: posTasksTitle
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get posTasksTitle;

  /// POS mode: posTaskUnassignedPickups
  ///
  /// In en, this message translates to:
  /// **'Pickups to assign'**
  String get posTaskUnassignedPickups;

  /// POS mode: posTaskUpcomingDeliveries
  ///
  /// In en, this message translates to:
  /// **'Deliveries due'**
  String get posTaskUpcomingDeliveries;

  /// POS mode: posTaskUnassignedDeliveries
  ///
  /// In en, this message translates to:
  /// **'Deliveries to assign'**
  String get posTaskUnassignedDeliveries;

  /// POS mode: posTaskExpress
  ///
  /// In en, this message translates to:
  /// **'Express orders'**
  String get posTaskExpress;

  /// POS mode: posTaskOrderRequests
  ///
  /// In en, this message translates to:
  /// **'Order requests'**
  String get posTaskOrderRequests;

  /// POS mode: posTaskCollectionDue
  ///
  /// In en, this message translates to:
  /// **'Money to collect'**
  String get posTaskCollectionDue;

  /// POS mode: posPlanTitle
  ///
  /// In en, this message translates to:
  /// **'Your plan'**
  String get posPlanTitle;

  /// POS mode: posPlanValidTo
  ///
  /// In en, this message translates to:
  /// **'Valid till {date}'**
  String posPlanValidTo(String date);

  /// POS mode: posHomeLoadError
  ///
  /// In en, this message translates to:
  /// **'Could not load today\'s numbers.'**
  String get posHomeLoadError;

  /// POS mode: posRetry
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get posRetry;

  /// POS mode: posHomeEmpty
  ///
  /// In en, this message translates to:
  /// **'No orders yet. Tap Book Order to start.'**
  String get posHomeEmpty;

  /// POS mode: posCancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get posCancel;

  /// POS mode: posCustomerPick
  ///
  /// In en, this message translates to:
  /// **'Choose customer'**
  String get posCustomerPick;

  /// POS mode: posCustomerSearchHint
  ///
  /// In en, this message translates to:
  /// **'Search name or phone'**
  String get posCustomerSearchHint;

  /// POS mode: posCustomerRecent
  ///
  /// In en, this message translates to:
  /// **'Recent customers'**
  String get posCustomerRecent;

  /// POS mode: posCustomerNone
  ///
  /// In en, this message translates to:
  /// **'No customer found.'**
  String get posCustomerNone;

  /// POS mode: posCustomerAddNew
  ///
  /// In en, this message translates to:
  /// **'Add new customer'**
  String get posCustomerAddNew;

  /// POS mode: posCustomerAddWithPhone
  ///
  /// In en, this message translates to:
  /// **'Add {phone} as a new customer'**
  String posCustomerAddWithPhone(String phone);

  /// POS mode: posCustomerLoadError
  ///
  /// In en, this message translates to:
  /// **'Could not load customers.'**
  String get posCustomerLoadError;

  /// POS mode: posCustomerOrderCount
  ///
  /// In en, this message translates to:
  /// **'{count} orders'**
  String posCustomerOrderCount(int count);

  /// POS mode: posAddCustomerTitle
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get posAddCustomerTitle;

  /// POS mode: posCustomerName
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get posCustomerName;

  /// POS mode: posCustomerPhone
  ///
  /// In en, this message translates to:
  /// **'Mobile number (10 digits)'**
  String get posCustomerPhone;

  /// POS mode: posErrCustomerName
  ///
  /// In en, this message translates to:
  /// **'Enter the customer\'s name'**
  String get posErrCustomerName;

  /// POS mode: posErrCustomerPhone
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit mobile number'**
  String get posErrCustomerPhone;

  /// POS mode: posCustomerAdded
  ///
  /// In en, this message translates to:
  /// **'{name} added'**
  String posCustomerAdded(String name);

  /// POS mode: posBookTitle
  ///
  /// In en, this message translates to:
  /// **'Book Order'**
  String get posBookTitle;

  /// POS mode: posBookCustomer
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get posBookCustomer;

  /// POS mode: posBookDeliveryDate
  ///
  /// In en, this message translates to:
  /// **'Delivery date'**
  String get posBookDeliveryDate;

  /// POS mode: posBookHomeDelivery
  ///
  /// In en, this message translates to:
  /// **'Home Delivery'**
  String get posBookHomeDelivery;

  /// POS mode: posBookPickup
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get posBookPickup;

  /// POS mode: posBookExpress
  ///
  /// In en, this message translates to:
  /// **'Express'**
  String get posBookExpress;

  /// POS mode: posBookService
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get posBookService;

  /// POS mode: posBookCategory
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get posBookCategory;

  /// POS mode: posBookAll
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get posBookAll;

  /// POS mode: posBookSearchGarment
  ///
  /// In en, this message translates to:
  /// **'Search garment'**
  String get posBookSearchGarment;

  /// POS mode: posBookNoServices
  ///
  /// In en, this message translates to:
  /// **'Your price list has no services yet. Add a garment price first.'**
  String get posBookNoServices;

  /// POS mode: posBookNoGarments
  ///
  /// In en, this message translates to:
  /// **'No garments with a price for this service.'**
  String get posBookNoGarments;

  /// POS mode: posBookNoMatch
  ///
  /// In en, this message translates to:
  /// **'No garment matches \"{query}\".'**
  String posBookNoMatch(String query);

  /// POS mode: posBookCatalogueError
  ///
  /// In en, this message translates to:
  /// **'Could not load your price list.'**
  String get posBookCatalogueError;

  /// POS mode: posBookSelected
  ///
  /// In en, this message translates to:
  /// **'Selected Garments'**
  String get posBookSelected;

  /// POS mode: posBookCartEmpty
  ///
  /// In en, this message translates to:
  /// **'Tap a garment above to add it.'**
  String get posBookCartEmpty;

  /// POS mode: posBookAddOne
  ///
  /// In en, this message translates to:
  /// **'Add one {name}'**
  String posBookAddOne(String name);

  /// POS mode: posBookRemoveOne
  ///
  /// In en, this message translates to:
  /// **'Remove one {name}'**
  String posBookRemoveOne(String name);

  /// POS mode: posBookRemoveLine
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String posBookRemoveLine(String name);

  /// POS mode: posBookChangePrice
  ///
  /// In en, this message translates to:
  /// **'Change price'**
  String get posBookChangePrice;

  /// POS mode: posBookItems
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get posBookItems;

  /// POS mode: posBookCharge
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get posBookCharge;

  /// POS mode: posBookDiscount
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get posBookDiscount;

  /// POS mode: posBookTax
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get posBookTax;

  /// POS mode: posBookTaxPercent
  ///
  /// In en, this message translates to:
  /// **'Tax ({percent}%)'**
  String posBookTaxPercent(String percent);

  /// POS mode: posBookGrandTotal
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get posBookGrandTotal;

  /// POS mode: posBookCalculating
  ///
  /// In en, this message translates to:
  /// **'Calculating…'**
  String get posBookCalculating;

  /// POS mode: posBookQuoteError
  ///
  /// In en, this message translates to:
  /// **'Could not get the price.'**
  String get posBookQuoteError;

  /// POS mode: posBookExtras
  ///
  /// In en, this message translates to:
  /// **'Charges, discount & GST'**
  String get posBookExtras;

  /// POS mode: posBookChargesLabel
  ///
  /// In en, this message translates to:
  /// **'Charges'**
  String get posBookChargesLabel;

  /// POS mode: posBookDiscountsLabel
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get posBookDiscountsLabel;

  /// POS mode: posBookGstLabel
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get posBookGstLabel;

  /// POS mode: posBookNoGst
  ///
  /// In en, this message translates to:
  /// **'No GST'**
  String get posBookNoGst;

  /// POS mode: posBookPayment
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get posBookPayment;

  /// POS mode: posPayCash
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get posPayCash;

  /// POS mode: posPayOnline
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get posPayOnline;

  /// POS mode: posPayLater
  ///
  /// In en, this message translates to:
  /// **'Pay Later'**
  String get posPayLater;

  /// POS mode: posPayNowNote
  ///
  /// In en, this message translates to:
  /// **'The full amount is received now.'**
  String get posPayNowNote;

  /// POS mode: posPayLaterNote
  ///
  /// In en, this message translates to:
  /// **'No payment now. Collect it later.'**
  String get posPayLaterNote;

  /// POS mode: posBookRemarks
  ///
  /// In en, this message translates to:
  /// **'Remarks (optional)'**
  String get posBookRemarks;

  /// POS mode: posBookSave
  ///
  /// In en, this message translates to:
  /// **'Save Order'**
  String get posBookSave;

  /// POS mode: posBookSaving
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get posBookSaving;

  /// POS mode: posBookNeedCustomer
  ///
  /// In en, this message translates to:
  /// **'Choose a customer to save.'**
  String get posBookNeedCustomer;

  /// POS mode: posBookNeedGarment
  ///
  /// In en, this message translates to:
  /// **'Add at least one garment.'**
  String get posBookNeedGarment;

  /// POS mode: posBookWaitPrice
  ///
  /// In en, this message translates to:
  /// **'Waiting for the price…'**
  String get posBookWaitPrice;

  /// POS mode: posBookSavedTitle
  ///
  /// In en, this message translates to:
  /// **'Order saved'**
  String get posBookSavedTitle;

  /// POS mode: posBookSavedBody
  ///
  /// In en, this message translates to:
  /// **'Order {number} for {name}'**
  String posBookSavedBody(String number, String name);

  /// POS mode: posBookSavedTotal
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get posBookSavedTotal;

  /// POS mode: posBookSavedPaid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get posBookSavedPaid;

  /// POS mode: posBookSavedBalance
  ///
  /// In en, this message translates to:
  /// **'To collect'**
  String get posBookSavedBalance;

  /// POS mode: posBookViewOrder
  ///
  /// In en, this message translates to:
  /// **'View Order'**
  String get posBookViewOrder;

  /// POS mode: posBookAnother
  ///
  /// In en, this message translates to:
  /// **'Book Another'**
  String get posBookAnother;

  /// POS mode: posBookClear
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get posBookClear;

  /// POS mode: posBookClearTitle
  ///
  /// In en, this message translates to:
  /// **'Clear this order?'**
  String get posBookClearTitle;

  /// POS mode: posBookClearBody
  ///
  /// In en, this message translates to:
  /// **'The customer and garments will be removed.'**
  String get posBookClearBody;

  /// POS mode: posBookDraftRestored
  ///
  /// In en, this message translates to:
  /// **'Your last unsaved order was restored.'**
  String get posBookDraftRestored;

  /// POS mode: posBookDropped
  ///
  /// In en, this message translates to:
  /// **'{count} garments were removed because their price is no longer in your list.'**
  String posBookDropped(int count);

  /// POS mode: posAddPriceTitle
  ///
  /// In en, this message translates to:
  /// **'Add Garment Price'**
  String get posAddPriceTitle;

  /// POS mode: posEditPriceTitle
  ///
  /// In en, this message translates to:
  /// **'Change price'**
  String get posEditPriceTitle;

  /// POS mode: posPriceGarment
  ///
  /// In en, this message translates to:
  /// **'Garment'**
  String get posPriceGarment;

  /// POS mode: posPriceCategory
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get posPriceCategory;

  /// POS mode: posPriceService
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get posPriceService;

  /// POS mode: posPriceUnit
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get posPriceUnit;

  /// POS mode: posPriceRate
  ///
  /// In en, this message translates to:
  /// **'Price (₹)'**
  String get posPriceRate;

  /// POS mode: posPriceAdd
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get posPriceAdd;

  /// POS mode: posPriceSave
  ///
  /// In en, this message translates to:
  /// **'Save price'**
  String get posPriceSave;

  /// POS mode: posPricePickOne
  ///
  /// In en, this message translates to:
  /// **'Choose…'**
  String get posPricePickOne;

  /// POS mode: posPriceNone
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get posPriceNone;

  /// POS mode: posPriceNewGarment
  ///
  /// In en, this message translates to:
  /// **'New garment'**
  String get posPriceNewGarment;

  /// POS mode: posPriceNewCategory
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get posPriceNewCategory;

  /// POS mode: posPriceNewService
  ///
  /// In en, this message translates to:
  /// **'New service'**
  String get posPriceNewService;

  /// POS mode: posPriceCreateHint
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get posPriceCreateHint;

  /// POS mode: posPriceCreate
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get posPriceCreate;

  /// POS mode: posPriceCreateTooltip
  ///
  /// In en, this message translates to:
  /// **'Create new'**
  String get posPriceCreateTooltip;

  /// POS mode: posPriceErrGarment
  ///
  /// In en, this message translates to:
  /// **'Choose a garment'**
  String get posPriceErrGarment;

  /// POS mode: posPriceErrService
  ///
  /// In en, this message translates to:
  /// **'Choose a service'**
  String get posPriceErrService;

  /// POS mode: posPriceErrRate
  ///
  /// In en, this message translates to:
  /// **'Enter a price like 80 or 80.50'**
  String get posPriceErrRate;

  /// POS mode: posPriceErrName
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get posPriceErrName;

  /// POS mode: posPriceSaved
  ///
  /// In en, this message translates to:
  /// **'Price saved'**
  String get posPriceSaved;

  /// POS mode: posPriceCurrent
  ///
  /// In en, this message translates to:
  /// **'Current price {price}'**
  String posPriceCurrent(String price);

  /// POS mode: posUnitPiece
  ///
  /// In en, this message translates to:
  /// **'Piece'**
  String get posUnitPiece;

  /// POS mode: posUnitKg
  ///
  /// In en, this message translates to:
  /// **'Kilogram'**
  String get posUnitKg;

  /// POS mode: posUnitPair
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get posUnitPair;

  /// POS mode: posUnitSqft
  ///
  /// In en, this message translates to:
  /// **'Square foot'**
  String get posUnitSqft;

  /// POS mode: posBookSubtotal
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get posBookSubtotal;

  /// POS mode: posBookQtySemantics
  ///
  /// In en, this message translates to:
  /// **'{name}, quantity {qty}'**
  String posBookQtySemantics(String name, String qty);

  /// POS mode: posBookQtyDialogTitle
  ///
  /// In en, this message translates to:
  /// **'Enter quantity ({unit})'**
  String posBookQtyDialogTitle(String unit);

  /// POS mode: posBookQtyInvalid
  ///
  /// In en, this message translates to:
  /// **'Enter an amount from 0.1 to 9999'**
  String get posBookQtyInvalid;

  /// POS mode: posBookQtyOk
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get posBookQtyOk;

  /// POS mode: posBookBill
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get posBookBill;

  /// POS mode: posOrdersTitle
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get posOrdersTitle;

  /// POS mode: posOrdTabBooked
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get posOrdTabBooked;

  /// POS mode: posOrdTabInProcess
  ///
  /// In en, this message translates to:
  /// **'In Process'**
  String get posOrdTabInProcess;

  /// POS mode: posOrdTabDone
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get posOrdTabDone;

  /// POS mode: posOrdFilter
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get posOrdFilter;

  /// POS mode: posOrdSelectAll
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get posOrdSelectAll;

  /// POS mode: posOrdSelectedCount
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String posOrdSelectedCount(int count);

  /// POS mode: posOrdMoveNext
  ///
  /// In en, this message translates to:
  /// **'Move to next step'**
  String get posOrdMoveNext;

  /// POS mode: posOrdSearchHint
  ///
  /// In en, this message translates to:
  /// **'Search name, phone or order no.'**
  String get posOrdSearchHint;

  /// POS mode: posOrdEmptyBooked
  ///
  /// In en, this message translates to:
  /// **'No booked orders. Tap Book Order to add one.'**
  String get posOrdEmptyBooked;

  /// POS mode: posOrdEmptyInProcess
  ///
  /// In en, this message translates to:
  /// **'Nothing is being processed right now.'**
  String get posOrdEmptyInProcess;

  /// POS mode: posOrdEmptyDone
  ///
  /// In en, this message translates to:
  /// **'No orders are ready right now.'**
  String get posOrdEmptyDone;

  /// POS mode: posOrdEmptyFiltered
  ///
  /// In en, this message translates to:
  /// **'No orders match. Clear the filter or the search.'**
  String get posOrdEmptyFiltered;

  /// POS mode: posOrdClearFilters
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get posOrdClearFilters;

  /// POS mode: posOrdLoadError
  ///
  /// In en, this message translates to:
  /// **'Could not load the orders.'**
  String get posOrdLoadError;

  /// POS mode: posOrdLoadMoreError
  ///
  /// In en, this message translates to:
  /// **'Could not load more. Tap to try again.'**
  String get posOrdLoadMoreError;

  /// POS mode: posOrdItemsCount
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 item} other{{count} items}}'**
  String posOrdItemsCount(int count);

  /// POS mode: posOrdBalanceDue
  ///
  /// In en, this message translates to:
  /// **'Balance {amount}'**
  String posOrdBalanceDue(String amount);

  /// POS mode: posOrdDue
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String posOrdDue(String date);

  /// POS mode: posOrdExpress
  ///
  /// In en, this message translates to:
  /// **'Express'**
  String get posOrdExpress;

  /// POS mode: posOrdHomeDelivery
  ///
  /// In en, this message translates to:
  /// **'Home Delivery'**
  String get posOrdHomeDelivery;

  /// POS mode: posOrdPickup
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get posOrdPickup;

  /// POS mode: posOrdWalkIn
  ///
  /// In en, this message translates to:
  /// **'At counter'**
  String get posOrdWalkIn;

  /// POS mode: posPayStatusPaid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get posPayStatusPaid;

  /// POS mode: posPayStatusPart
  ///
  /// In en, this message translates to:
  /// **'Part paid'**
  String get posPayStatusPart;

  /// POS mode: posPayStatusUnpaid
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get posPayStatusUnpaid;

  /// POS mode: posPhaseBooked
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get posPhaseBooked;

  /// POS mode: posPhaseProcessing
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get posPhaseProcessing;

  /// POS mode: posPhaseReady
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get posPhaseReady;

  /// POS mode: posPhaseOut
  ///
  /// In en, this message translates to:
  /// **'Out for delivery'**
  String get posPhaseOut;

  /// POS mode: posPhaseDelivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get posPhaseDelivered;

  /// POS mode: posPhaseComplete
  ///
  /// In en, this message translates to:
  /// **'Order Complete'**
  String get posPhaseComplete;

  /// POS mode: posPhaseCancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get posPhaseCancelled;

  /// POS mode: posFilterTitle
  ///
  /// In en, this message translates to:
  /// **'Filter orders'**
  String get posFilterTitle;

  /// POS mode: posFilterStatus
  ///
  /// In en, this message translates to:
  /// **'Which orders'**
  String get posFilterStatus;

  /// POS mode: posFilterThisTab
  ///
  /// In en, this message translates to:
  /// **'This tab'**
  String get posFilterThisTab;

  /// POS mode: posFilterAllOrders
  ///
  /// In en, this message translates to:
  /// **'All orders'**
  String get posFilterAllOrders;

  /// POS mode: posFilterDeliveredOnly
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get posFilterDeliveredOnly;

  /// POS mode: posFilterCancelledOnly
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get posFilterCancelledOnly;

  /// POS mode: posFilterDates
  ///
  /// In en, this message translates to:
  /// **'Order date'**
  String get posFilterDates;

  /// POS mode: posFilterFrom
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get posFilterFrom;

  /// POS mode: posFilterTo
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get posFilterTo;

  /// POS mode: posFilterAnyDate
  ///
  /// In en, this message translates to:
  /// **'Any date'**
  String get posFilterAnyDate;

  /// POS mode: posFilterDelivery
  ///
  /// In en, this message translates to:
  /// **'How it reaches the customer'**
  String get posFilterDelivery;

  /// POS mode: posFilterAnyDelivery
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get posFilterAnyDelivery;

  /// POS mode: posFilterExpressOnly
  ///
  /// In en, this message translates to:
  /// **'Express only'**
  String get posFilterExpressOnly;

  /// POS mode: posFilterDueOnly
  ///
  /// In en, this message translates to:
  /// **'Balance due only'**
  String get posFilterDueOnly;

  /// POS mode: posFilterApply
  ///
  /// In en, this message translates to:
  /// **'Show orders'**
  String get posFilterApply;

  /// POS mode: posFilterReset
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get posFilterReset;

  /// POS mode: posBulkTitle
  ///
  /// In en, this message translates to:
  /// **'Move {count} orders to the next step?'**
  String posBulkTitle(int count);

  /// POS mode: posBulkBody
  ///
  /// In en, this message translates to:
  /// **'Each order moves one step: Booked → Processing → Ready → Delivered.'**
  String get posBulkBody;

  /// POS mode: posBulkReadyNote
  ///
  /// In en, this message translates to:
  /// **'Orders whose garments were not scanned are marked ready anyway.'**
  String get posBulkReadyNote;

  /// POS mode: posBulkDueNote
  ///
  /// In en, this message translates to:
  /// **'Orders with a balance due are NOT delivered here — open them one by one.'**
  String get posBulkDueNote;

  /// POS mode: posBulkGo
  ///
  /// In en, this message translates to:
  /// **'Move orders'**
  String get posBulkGo;

  /// POS mode: posBulkDone
  ///
  /// In en, this message translates to:
  /// **'{count} orders moved.'**
  String posBulkDone(int count);

  /// POS mode: posBulkPartial
  ///
  /// In en, this message translates to:
  /// **'{moved} moved. {failed} need a closer look — open them one by one.'**
  String posBulkPartial(int moved, int failed);

  /// POS mode: posBulkNone
  ///
  /// In en, this message translates to:
  /// **'Nothing could be moved. Open the orders one by one.'**
  String get posBulkNone;

  /// POS mode: posBulkSkipDue
  ///
  /// In en, this message translates to:
  /// **'{count} with a balance due were left for you to open.'**
  String posBulkSkipDue(int count);

  /// POS mode: posOrdDetailTitle
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get posOrdDetailTitle;

  /// POS mode: posOrdCall
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get posOrdCall;

  /// POS mode: posOrdCallFailed
  ///
  /// In en, this message translates to:
  /// **'Could not open the phone.'**
  String get posOrdCallFailed;

  /// POS mode: posNextStart
  ///
  /// In en, this message translates to:
  /// **'Start Processing'**
  String get posNextStart;

  /// POS mode: posNextReady
  ///
  /// In en, this message translates to:
  /// **'Mark Ready'**
  String get posNextReady;

  /// POS mode: posNextSendOut
  ///
  /// In en, this message translates to:
  /// **'Send for Delivery'**
  String get posNextSendOut;

  /// POS mode: posNextDeliver
  ///
  /// In en, this message translates to:
  /// **'Deliver Order'**
  String get posNextDeliver;

  /// POS mode: posOrdFinished
  ///
  /// In en, this message translates to:
  /// **'This order is finished.'**
  String get posOrdFinished;

  /// POS mode: posOrdCancelledNote
  ///
  /// In en, this message translates to:
  /// **'This order was cancelled.'**
  String get posOrdCancelledNote;

  /// POS mode: posReadyAnywayTitle
  ///
  /// In en, this message translates to:
  /// **'Garments not scanned yet'**
  String get posReadyAnywayTitle;

  /// POS mode: posReadyAnywayBody
  ///
  /// In en, this message translates to:
  /// **'Some garments have not been scanned through processing. Mark the order ready anyway?'**
  String get posReadyAnywayBody;

  /// POS mode: posReadyAnywayYes
  ///
  /// In en, this message translates to:
  /// **'Mark ready anyway'**
  String get posReadyAnywayYes;

  /// POS mode: posNotYet
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get posNotYet;

  /// POS mode: posDeliverDueTitle
  ///
  /// In en, this message translates to:
  /// **'{amount} is still due'**
  String posDeliverDueTitle(String amount);

  /// POS mode: posDeliverDueBody
  ///
  /// In en, this message translates to:
  /// **'Collect the payment first, or deliver now and collect later.'**
  String get posDeliverDueBody;

  /// POS mode: posCollectFirst
  ///
  /// In en, this message translates to:
  /// **'Collect payment first'**
  String get posCollectFirst;

  /// POS mode: posDeliverAnyway
  ///
  /// In en, this message translates to:
  /// **'Deliver with balance due'**
  String get posDeliverAnyway;

  /// POS mode: posOrdMoved
  ///
  /// In en, this message translates to:
  /// **'Order moved to {status}.'**
  String posOrdMoved(String status);

  /// POS mode: posOrdChanged
  ///
  /// In en, this message translates to:
  /// **'This order was changed by someone else. It has been reloaded — please check and try again.'**
  String get posOrdChanged;

  /// POS mode: posProgressPercent
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String posProgressPercent(int percent);

  /// POS mode: posStageBooked
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get posStageBooked;

  /// POS mode: posStageProcessed
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get posStageProcessed;

  /// POS mode: posStageDone
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get posStageDone;

  /// POS mode: posStageDelivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get posStageDelivered;

  /// POS mode: posStageComplete
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get posStageComplete;

  /// POS mode: posActionsTitle
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get posActionsTitle;

  /// POS mode: posActPayNow
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get posActPayNow;

  /// POS mode: posActInvoice
  ///
  /// In en, this message translates to:
  /// **'View Invoice'**
  String get posActInvoice;

  /// POS mode: posActMiniInvoice
  ///
  /// In en, this message translates to:
  /// **'Mini Invoice'**
  String get posActMiniInvoice;

  /// POS mode: posActTag
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get posActTag;

  /// POS mode: posActEdit
  ///
  /// In en, this message translates to:
  /// **'Edit Order'**
  String get posActEdit;

  /// POS mode: posActCancel
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get posActCancel;

  /// POS mode: posActAssign
  ///
  /// In en, this message translates to:
  /// **'Assign Captain'**
  String get posActAssign;

  /// POS mode: posInfoTitle
  ///
  /// In en, this message translates to:
  /// **'Order info'**
  String get posInfoTitle;

  /// POS mode: posInfoDelivery
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get posInfoDelivery;

  /// POS mode: posInfoOrderNo
  ///
  /// In en, this message translates to:
  /// **'Order no.'**
  String get posInfoOrderNo;

  /// POS mode: posInfoInvoiceAmount
  ///
  /// In en, this message translates to:
  /// **'Invoice amount'**
  String get posInfoInvoiceAmount;

  /// POS mode: posInfoPaid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get posInfoPaid;

  /// POS mode: posInfoBalance
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get posInfoBalance;

  /// POS mode: posInfoBookedOn
  ///
  /// In en, this message translates to:
  /// **'Booked on'**
  String get posInfoBookedOn;

  /// POS mode: posInfoDeliveryDate
  ///
  /// In en, this message translates to:
  /// **'Delivery date'**
  String get posInfoDeliveryDate;

  /// POS mode: posInfoPickupCaptain
  ///
  /// In en, this message translates to:
  /// **'Pickup captain'**
  String get posInfoPickupCaptain;

  /// POS mode: posInfoDeliveryCaptain
  ///
  /// In en, this message translates to:
  /// **'Delivery captain'**
  String get posInfoDeliveryCaptain;

  /// POS mode: posInfoNotAssigned
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get posInfoNotAssigned;

  /// POS mode: posInfoNotes
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get posInfoNotes;

  /// POS mode: posInfoCancelReason
  ///
  /// In en, this message translates to:
  /// **'Reason for cancelling'**
  String get posInfoCancelReason;

  /// POS mode: posPaymentsTitle
  ///
  /// In en, this message translates to:
  /// **'Payments received'**
  String get posPaymentsTitle;

  /// POS mode: posPaymentsNone
  ///
  /// In en, this message translates to:
  /// **'No payment received yet.'**
  String get posPaymentsNone;

  /// POS mode: posModeCash
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get posModeCash;

  /// POS mode: posModeOnline
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get posModeOnline;

  /// POS mode: posModeCard
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get posModeCard;

  /// POS mode: posModeBank
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get posModeBank;

  /// POS mode: posModeWallet
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get posModeWallet;

  /// POS mode: posGarmentsTitle
  ///
  /// In en, this message translates to:
  /// **'Garments'**
  String get posGarmentsTitle;

  /// POS mode: posGarmentsNone
  ///
  /// In en, this message translates to:
  /// **'No garments on this order.'**
  String get posGarmentsNone;

  /// POS mode: posUnitReceived
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get posUnitReceived;

  /// POS mode: posUnitProcessing
  ///
  /// In en, this message translates to:
  /// **'In process'**
  String get posUnitProcessing;

  /// POS mode: posUnitReady
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get posUnitReady;

  /// POS mode: posUnitOut
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get posUnitOut;

  /// POS mode: posUnitDelivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get posUnitDelivered;

  /// POS mode: posUnitMissing
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get posUnitMissing;

  /// POS mode: posUnitCancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get posUnitCancelled;

  /// POS mode: posOrdLoadFailed
  ///
  /// In en, this message translates to:
  /// **'Could not load this order.'**
  String get posOrdLoadFailed;

  /// POS mode: posOrdLoadingHint
  ///
  /// In en, this message translates to:
  /// **'Loading the order…'**
  String get posOrdLoadingHint;

  /// POS mode: posWhatsApp
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get posWhatsApp;

  /// POS mode: posWaOpenFailed
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp.'**
  String get posWaOpenFailed;

  /// POS mode: posWaMessageDue
  ///
  /// In en, this message translates to:
  /// **'Hello {name}, your order {number} is {status}. Total {total}, balance {balance}. Thank you! — {shop}'**
  String posWaMessageDue(String name, String number, String status,
      String total, String balance, String shop);

  /// POS mode: posWaMessagePaid
  ///
  /// In en, this message translates to:
  /// **'Hello {name}, your order {number} is {status}. Total {total}, fully paid. Thank you! — {shop}'**
  String posWaMessagePaid(
      String name, String number, String status, String total, String shop);

  /// POS mode: posWaCustomerFallback
  ///
  /// In en, this message translates to:
  /// **'there'**
  String get posWaCustomerFallback;

  /// POS mode: posPayTitle
  ///
  /// In en, this message translates to:
  /// **'Collect payment'**
  String get posPayTitle;

  /// POS mode: posPayBalance
  ///
  /// In en, this message translates to:
  /// **'Balance to collect'**
  String get posPayBalance;

  /// POS mode: posPayAmount
  ///
  /// In en, this message translates to:
  /// **'Amount (₹)'**
  String get posPayAmount;

  /// POS mode: posPayFull
  ///
  /// In en, this message translates to:
  /// **'Full balance'**
  String get posPayFull;

  /// POS mode: posPayHow
  ///
  /// In en, this message translates to:
  /// **'How is the customer paying?'**
  String get posPayHow;

  /// POS mode: posPayReference
  ///
  /// In en, this message translates to:
  /// **'Reference (optional)'**
  String get posPayReference;

  /// POS mode: posPayReferenceHint
  ///
  /// In en, this message translates to:
  /// **'e.g. UPI transaction number'**
  String get posPayReferenceHint;

  /// POS mode: posPayCollect
  ///
  /// In en, this message translates to:
  /// **'Collect {amount}'**
  String posPayCollect(String amount);

  /// POS mode: posPayErrZero
  ///
  /// In en, this message translates to:
  /// **'Enter an amount.'**
  String get posPayErrZero;

  /// POS mode: posPayErrOver
  ///
  /// In en, this message translates to:
  /// **'It cannot be more than the balance {amount}.'**
  String posPayErrOver(String amount);

  /// POS mode: posPayDone
  ///
  /// In en, this message translates to:
  /// **'{amount} collected.'**
  String posPayDone(String amount);

  /// POS mode: posPayCheckFirst
  ///
  /// In en, this message translates to:
  /// **'We could not confirm that payment. The order was reloaded — check the balance before collecting again.'**
  String get posPayCheckFirst;

  /// POS mode: posPayNothingDue
  ///
  /// In en, this message translates to:
  /// **'Nothing is due on this order.'**
  String get posPayNothingDue;

  /// POS mode: posCancelTitle
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get posCancelTitle;

  /// POS mode: posCancelBody
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get posCancelBody;

  /// POS mode: posCancelWhy
  ///
  /// In en, this message translates to:
  /// **'Why is it being cancelled?'**
  String get posCancelWhy;

  /// POS mode: posCancelReasonMind
  ///
  /// In en, this message translates to:
  /// **'Customer changed their mind'**
  String get posCancelReasonMind;

  /// POS mode: posCancelReasonMistake
  ///
  /// In en, this message translates to:
  /// **'Booked by mistake'**
  String get posCancelReasonMistake;

  /// POS mode: posCancelReasonPrice
  ///
  /// In en, this message translates to:
  /// **'Price problem'**
  String get posCancelReasonPrice;

  /// POS mode: posCancelReasonOther
  ///
  /// In en, this message translates to:
  /// **'Other reason'**
  String get posCancelReasonOther;

  /// POS mode: posCancelOtherHint
  ///
  /// In en, this message translates to:
  /// **'Write the reason (3 letters or more)'**
  String get posCancelOtherHint;

  /// POS mode: posCancelRefundNote
  ///
  /// In en, this message translates to:
  /// **'If the customer already paid, give the money back yourself — the app does not refund.'**
  String get posCancelRefundNote;

  /// POS mode: posCancelConfirm
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get posCancelConfirm;

  /// POS mode: posCancelKeep
  ///
  /// In en, this message translates to:
  /// **'Keep the order'**
  String get posCancelKeep;

  /// POS mode: posCancelDone
  ///
  /// In en, this message translates to:
  /// **'Order cancelled.'**
  String get posCancelDone;

  /// POS mode: posEditTitle
  ///
  /// In en, this message translates to:
  /// **'Edit order'**
  String get posEditTitle;

  /// POS mode: posEditItemsNote
  ///
  /// In en, this message translates to:
  /// **'To change the garments, cancel this order and book a new one.'**
  String get posEditItemsNote;

  /// POS mode: posEditSave
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get posEditSave;

  /// POS mode: posEditSaved
  ///
  /// In en, this message translates to:
  /// **'Order updated.'**
  String get posEditSaved;

  /// POS mode: posEditNothing
  ///
  /// In en, this message translates to:
  /// **'Nothing was changed.'**
  String get posEditNothing;

  /// POS mode: posAssignTitle
  ///
  /// In en, this message translates to:
  /// **'Assign captain'**
  String get posAssignTitle;

  /// POS mode: posAssignPickup
  ///
  /// In en, this message translates to:
  /// **'Pickup captain'**
  String get posAssignPickup;

  /// POS mode: posAssignDelivery
  ///
  /// In en, this message translates to:
  /// **'Delivery captain'**
  String get posAssignDelivery;

  /// POS mode: posAssignKeep
  ///
  /// In en, this message translates to:
  /// **'Keep as it is'**
  String get posAssignKeep;

  /// POS mode: posAssignNone
  ///
  /// In en, this message translates to:
  /// **'You have no captains yet. Add one in Settings → Team.'**
  String get posAssignNone;

  /// POS mode: posAssignSave
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get posAssignSave;

  /// POS mode: posAssignDone
  ///
  /// In en, this message translates to:
  /// **'Captain assigned.'**
  String get posAssignDone;

  /// POS mode: posInvoiceTitle
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get posInvoiceTitle;

  /// POS mode: posMiniTitle
  ///
  /// In en, this message translates to:
  /// **'Mini bill'**
  String get posMiniTitle;

  /// POS mode: posPaper58
  ///
  /// In en, this message translates to:
  /// **'58 mm'**
  String get posPaper58;

  /// POS mode: posPaper80
  ///
  /// In en, this message translates to:
  /// **'80 mm'**
  String get posPaper80;

  /// POS mode: posPaperLabel
  ///
  /// In en, this message translates to:
  /// **'Paper size'**
  String get posPaperLabel;

  /// POS mode: posInvoiceLater
  ///
  /// In en, this message translates to:
  /// **'The invoice is created when the order is delivered. Use Mini Invoice for a bill now.'**
  String get posInvoiceLater;

  /// POS mode: posInvoiceOpenMini
  ///
  /// In en, this message translates to:
  /// **'Open Mini Invoice'**
  String get posInvoiceOpenMini;

  /// POS mode: posInvoiceFailed
  ///
  /// In en, this message translates to:
  /// **'Could not prepare the bill.'**
  String get posInvoiceFailed;

  /// POS mode: posOk
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get posOk;

  /// POS mode: posTagsTitle
  ///
  /// In en, this message translates to:
  /// **'Garment tags'**
  String get posTagsTitle;

  /// POS mode: posTagsEmpty
  ///
  /// In en, this message translates to:
  /// **'This order has no tags.'**
  String get posTagsEmpty;

  /// POS mode: posTagsPrint
  ///
  /// In en, this message translates to:
  /// **'Print or share tags'**
  String get posTagsPrint;

  /// POS mode: posTagsHint
  ///
  /// In en, this message translates to:
  /// **'Stick one tag on each garment. The code is also written under each QR.'**
  String get posTagsHint;

  /// POS mode: posTagsPdfTitle
  ///
  /// In en, this message translates to:
  /// **'Tags for order {number}'**
  String posTagsPdfTitle(String number);

  /// POS mode: posTagsFailed
  ///
  /// In en, this message translates to:
  /// **'Could not prepare the tags.'**
  String get posTagsFailed;

  /// POS mode: posTileOpensOrders
  ///
  /// In en, this message translates to:
  /// **'Opens the orders list'**
  String get posTileOpensOrders;

  /// POS mode: posOrdFiltered
  ///
  /// In en, this message translates to:
  /// **'Showing: {what}'**
  String posOrdFiltered(String what);

  /// POS mode: posNoPermission
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to do this. Ask the shop owner.'**
  String get posNoPermission;

  /// POS mode: posSearchHint
  ///
  /// In en, this message translates to:
  /// **'Order no., customer name, phone or tag'**
  String get posSearchHint;

  /// POS mode: posSearchStart
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 letters or numbers to search.'**
  String get posSearchStart;

  /// POS mode: posSearchRecent
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get posSearchRecent;

  /// POS mode: posSearchClearRecent
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get posSearchClearRecent;

  /// POS mode: posSearchNone
  ///
  /// In en, this message translates to:
  /// **'Nothing found for \"{q}\". Check the spelling or try the phone number.'**
  String posSearchNone(String q);

  /// POS mode: posSearchFailed
  ///
  /// In en, this message translates to:
  /// **'Could not search right now.'**
  String get posSearchFailed;

  /// POS mode: posSearchCustomers
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get posSearchCustomers;

  /// POS mode: posSearchOrders
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get posSearchOrders;

  /// POS mode: posSearchTags
  ///
  /// In en, this message translates to:
  /// **'Garment tags'**
  String get posSearchTags;

  /// POS mode: posSearchAllCustomers
  ///
  /// In en, this message translates to:
  /// **'All customers'**
  String get posSearchAllCustomers;

  /// POS mode: posSearchOrderLine
  ///
  /// In en, this message translates to:
  /// **'{total} · {date}'**
  String posSearchOrderLine(String total, String date);

  /// POS mode: posSearchTagLine
  ///
  /// In en, this message translates to:
  /// **'Tag {code} · {state}'**
  String posSearchTagLine(String code, String state);

  /// POS mode: posCustTitle
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get posCustTitle;

  /// POS mode: posCustSearchHint
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone'**
  String get posCustSearchHint;

  /// POS mode: posCustEmpty
  ///
  /// In en, this message translates to:
  /// **'No customers yet. Book an order or add a customer.'**
  String get posCustEmpty;

  /// POS mode: posCustNoMatch
  ///
  /// In en, this message translates to:
  /// **'No customer matches \"{q}\".'**
  String posCustNoMatch(String q);

  /// POS mode: posCustLoadError
  ///
  /// In en, this message translates to:
  /// **'Could not load customers.'**
  String get posCustLoadError;

  /// POS mode: posCustOrdersCount
  ///
  /// In en, this message translates to:
  /// **'{count} orders · {spent}'**
  String posCustOrdersCount(int count, String spent);

  /// POS mode: posCustNewCustomer
  ///
  /// In en, this message translates to:
  /// **'New customer'**
  String get posCustNewCustomer;

  /// POS mode: posCustDuesTitle
  ///
  /// In en, this message translates to:
  /// **'To collect'**
  String get posCustDuesTitle;

  /// POS mode: posCustNoDues
  ///
  /// In en, this message translates to:
  /// **'Nothing is due. All paid.'**
  String get posCustNoDues;

  /// POS mode: posCustDueOrder
  ///
  /// In en, this message translates to:
  /// **'Order {number}'**
  String posCustDueOrder(String number);

  /// POS mode: posCustCollect
  ///
  /// In en, this message translates to:
  /// **'Collect dues'**
  String get posCustCollect;

  /// POS mode: posCustCollectHint
  ///
  /// In en, this message translates to:
  /// **'Choose an order to collect its balance.'**
  String get posCustCollectHint;

  /// POS mode: posCustHistory
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get posCustHistory;

  /// POS mode: posCustNoOrders
  ///
  /// In en, this message translates to:
  /// **'No orders yet.'**
  String get posCustNoOrders;

  /// POS mode: posCustNotes
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get posCustNotes;

  /// POS mode: posCustAddresses
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get posCustAddresses;

  /// POS mode: posCustCall
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get posCustCall;

  /// POS mode: posCustWhatsApp
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get posCustWhatsApp;

  /// POS mode: posCustNotFound
  ///
  /// In en, this message translates to:
  /// **'This customer was not found.'**
  String get posCustNotFound;

  /// POS mode: posCustOwes
  ///
  /// In en, this message translates to:
  /// **'Owes {amount}'**
  String posCustOwes(String amount);

  /// POS mode: posWaSheetTitle
  ///
  /// In en, this message translates to:
  /// **'Message {name}'**
  String posWaSheetTitle(String name);

  /// POS mode: posWaOpenChat
  ///
  /// In en, this message translates to:
  /// **'Just open the chat'**
  String get posWaOpenChat;

  /// POS mode: posWaOpenChatBody
  ///
  /// In en, this message translates to:
  /// **'A short hello. You can type anything.'**
  String get posWaOpenChatBody;

  /// POS mode: posWaHello
  ///
  /// In en, this message translates to:
  /// **'Hello {name}, this is {shop}.'**
  String posWaHello(String name, String shop);

  /// POS mode: posWaForOrder
  ///
  /// In en, this message translates to:
  /// **'About order {number}'**
  String posWaForOrder(String number);

  /// POS mode: posWaNoOrder
  ///
  /// In en, this message translates to:
  /// **'This customer has no order yet, so only a plain chat is possible.'**
  String get posWaNoOrder;

  /// POS mode: posWaPaymentDue
  ///
  /// In en, this message translates to:
  /// **'Payment reminder'**
  String get posWaPaymentDue;

  /// POS mode: posWaPaymentDueBody
  ///
  /// In en, this message translates to:
  /// **'Shows the balance still to pay.'**
  String get posWaPaymentDueBody;

  /// POS mode: posWaTemplatesFailed
  ///
  /// In en, this message translates to:
  /// **'Could not load your saved messages.'**
  String get posWaTemplatesFailed;

  /// POS mode: posActionWhatsApp
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get posActionWhatsApp;

  /// POS mode: posExpTitle
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get posExpTitle;

  /// POS mode: posExpToday
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get posExpToday;

  /// POS mode: posExpThisMonth
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get posExpThisMonth;

  /// POS mode: posExpSpent
  ///
  /// In en, this message translates to:
  /// **'Spent: {amount}'**
  String posExpSpent(String amount);

  /// POS mode: posExpAdd
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get posExpAdd;

  /// POS mode: posExpEdit
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get posExpEdit;

  /// POS mode: posExpCancel
  ///
  /// In en, this message translates to:
  /// **'Cancel expense'**
  String get posExpCancel;

  /// POS mode: posExpEmpty
  ///
  /// In en, this message translates to:
  /// **'No expenses in this period. Tap Add Expense when you pay for something.'**
  String get posExpEmpty;

  /// POS mode: posExpLoadError
  ///
  /// In en, this message translates to:
  /// **'Could not load expenses.'**
  String get posExpLoadError;

  /// POS mode: posExpName
  ///
  /// In en, this message translates to:
  /// **'What was it for?'**
  String get posExpName;

  /// POS mode: posExpNameHint
  ///
  /// In en, this message translates to:
  /// **'e.g. Electricity bill'**
  String get posExpNameHint;

  /// POS mode: posExpAmount
  ///
  /// In en, this message translates to:
  /// **'Amount (₹)'**
  String get posExpAmount;

  /// POS mode: posExpCategory
  ///
  /// In en, this message translates to:
  /// **'Type of expense'**
  String get posExpCategory;

  /// POS mode: posExpMode
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get posExpMode;

  /// POS mode: posExpDate
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get posExpDate;

  /// POS mode: posExpNote
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get posExpNote;

  /// POS mode: posExpReason
  ///
  /// In en, this message translates to:
  /// **'Why are you changing it?'**
  String get posExpReason;

  /// POS mode: posExpCancelReason
  ///
  /// In en, this message translates to:
  /// **'Why is it cancelled?'**
  String get posExpCancelReason;

  /// POS mode: posExpSave
  ///
  /// In en, this message translates to:
  /// **'Save Expense'**
  String get posExpSave;

  /// POS mode: posExpSaved
  ///
  /// In en, this message translates to:
  /// **'Expense saved.'**
  String get posExpSaved;

  /// POS mode: posExpCancelled
  ///
  /// In en, this message translates to:
  /// **'Expense cancelled.'**
  String get posExpCancelled;

  /// POS mode: posExpCancelledTag
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get posExpCancelledTag;

  /// POS mode: posExpKeep
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get posExpKeep;

  /// POS mode: posExpNameRequired
  ///
  /// In en, this message translates to:
  /// **'Write what the expense was for.'**
  String get posExpNameRequired;

  /// POS mode: posExpAmountInvalid
  ///
  /// In en, this message translates to:
  /// **'Enter an amount like 250 or 99.50.'**
  String get posExpAmountInvalid;

  /// POS mode: posExpReasonRequired
  ///
  /// In en, this message translates to:
  /// **'Please write a reason.'**
  String get posExpReasonRequired;

  /// POS mode: posExpBy
  ///
  /// In en, this message translates to:
  /// **'{category} · {mode}'**
  String posExpBy(String category, String mode);

  /// POS mode: posCatRent
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get posCatRent;

  /// POS mode: posCatSalary
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get posCatSalary;

  /// POS mode: posCatElectricity
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get posCatElectricity;

  /// POS mode: posCatWater
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get posCatWater;

  /// POS mode: posCatDetergent
  ///
  /// In en, this message translates to:
  /// **'Detergent & supplies'**
  String get posCatDetergent;

  /// POS mode: posCatTransport
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get posCatTransport;

  /// POS mode: posCatRepair
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get posCatRepair;

  /// POS mode: posCatTea
  ///
  /// In en, this message translates to:
  /// **'Tea & snacks'**
  String get posCatTea;

  /// POS mode: posCatOther
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get posCatOther;

  /// POS mode: posExpModeCash
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get posExpModeCash;

  /// POS mode: posExpModeUpi
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get posExpModeUpi;

  /// POS mode: posExpModeBank
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get posExpModeBank;

  /// POS mode: posExpModeCard
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get posExpModeCard;

  /// POS mode: posExpModeOther
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get posExpModeOther;

  /// POS mode: posDrawerTitle
  ///
  /// In en, this message translates to:
  /// **'Cash drawer'**
  String get posDrawerTitle;

  /// POS mode: posDrawerClosed
  ///
  /// In en, this message translates to:
  /// **'The cash drawer is closed. Open it when you start the day.'**
  String get posDrawerClosed;

  /// POS mode: posDrawerOpen
  ///
  /// In en, this message translates to:
  /// **'Open cash drawer'**
  String get posDrawerOpen;

  /// POS mode: posDrawerClose
  ///
  /// In en, this message translates to:
  /// **'Close cash drawer'**
  String get posDrawerClose;

  /// POS mode: posDrawerOpenSince
  ///
  /// In en, this message translates to:
  /// **'Open since {time}'**
  String posDrawerOpenSince(String time);

  /// POS mode: posDrawerOpening
  ///
  /// In en, this message translates to:
  /// **'Cash you started with'**
  String get posDrawerOpening;

  /// POS mode: posDrawerIn
  ///
  /// In en, this message translates to:
  /// **'Cash received'**
  String get posDrawerIn;

  /// POS mode: posDrawerOut
  ///
  /// In en, this message translates to:
  /// **'Cash paid out'**
  String get posDrawerOut;

  /// POS mode: posDrawerShould
  ///
  /// In en, this message translates to:
  /// **'Cash that should be in the drawer'**
  String get posDrawerShould;

  /// POS mode: posDrawerOpeningQ
  ///
  /// In en, this message translates to:
  /// **'How much cash is in the drawer now?'**
  String get posDrawerOpeningQ;

  /// POS mode: posDrawerOpenSave
  ///
  /// In en, this message translates to:
  /// **'Open drawer'**
  String get posDrawerOpenSave;

  /// POS mode: posDrawerCounted
  ///
  /// In en, this message translates to:
  /// **'Cash you counted (₹)'**
  String get posDrawerCounted;

  /// POS mode: posDrawerExpected
  ///
  /// In en, this message translates to:
  /// **'Should be: {amount}'**
  String posDrawerExpected(String amount);

  /// POS mode: posDrawerMatch
  ///
  /// In en, this message translates to:
  /// **'It matches. Nothing is missing.'**
  String get posDrawerMatch;

  /// POS mode: posDrawerShort
  ///
  /// In en, this message translates to:
  /// **'{amount} less than it should be.'**
  String posDrawerShort(String amount);

  /// POS mode: posDrawerExtra
  ///
  /// In en, this message translates to:
  /// **'{amount} more than it should be.'**
  String posDrawerExtra(String amount);

  /// POS mode: posDrawerWhy
  ///
  /// In en, this message translates to:
  /// **'Why is it different?'**
  String get posDrawerWhy;

  /// POS mode: posDrawerApprover
  ///
  /// In en, this message translates to:
  /// **'Approved by (name)'**
  String get posDrawerApprover;

  /// POS mode: posDrawerCloseSave
  ///
  /// In en, this message translates to:
  /// **'Close drawer'**
  String get posDrawerCloseSave;

  /// POS mode: posDrawerOpened
  ///
  /// In en, this message translates to:
  /// **'Cash drawer opened.'**
  String get posDrawerOpened;

  /// POS mode: posDrawerClosedOk
  ///
  /// In en, this message translates to:
  /// **'Cash drawer closed.'**
  String get posDrawerClosedOk;

  /// POS mode: posDrawerCountInvalid
  ///
  /// In en, this message translates to:
  /// **'Enter the cash you counted, like 1250.'**
  String get posDrawerCountInvalid;

  /// POS mode: posDrawerNeedsWhy
  ///
  /// In en, this message translates to:
  /// **'Write why it is different and who approved it.'**
  String get posDrawerNeedsWhy;

  /// POS mode: posDrawerPast
  ///
  /// In en, this message translates to:
  /// **'Earlier drawers'**
  String get posDrawerPast;

  /// POS mode: posDrawerPastLine
  ///
  /// In en, this message translates to:
  /// **'Counted {counted} · {diff}'**
  String posDrawerPastLine(String counted, String diff);

  /// POS mode: posDrawerDiffOk
  ///
  /// In en, this message translates to:
  /// **'matched'**
  String get posDrawerDiffOk;

  /// POS mode: posDrawerDiffShort
  ///
  /// In en, this message translates to:
  /// **'{amount} short'**
  String posDrawerDiffShort(String amount);

  /// POS mode: posDrawerDiffExtra
  ///
  /// In en, this message translates to:
  /// **'{amount} extra'**
  String posDrawerDiffExtra(String amount);

  /// POS mode: posMoneyNoAccess
  ///
  /// In en, this message translates to:
  /// **'Ask the shop owner to give you access to this.'**
  String get posMoneyNoAccess;

  /// POS mode: posRepTitle
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get posRepTitle;

  /// POS mode: posRepToday
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get posRepToday;

  /// POS mode: posRep7Days
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get posRep7Days;

  /// POS mode: posRepMonth
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get posRepMonth;

  /// POS mode: posRepCustom
  ///
  /// In en, this message translates to:
  /// **'Pick dates'**
  String get posRepCustom;

  /// POS mode: posRepPeriod
  ///
  /// In en, this message translates to:
  /// **'{from} to {to}'**
  String posRepPeriod(String from, String to);

  /// POS mode: posRepBilled
  ///
  /// In en, this message translates to:
  /// **'Billed'**
  String get posRepBilled;

  /// POS mode: posRepBilledHint
  ///
  /// In en, this message translates to:
  /// **'Total of the orders booked'**
  String get posRepBilledHint;

  /// POS mode: posRepCollected
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get posRepCollected;

  /// POS mode: posRepCollectedHint
  ///
  /// In en, this message translates to:
  /// **'Money received in this period'**
  String get posRepCollectedHint;

  /// POS mode: posRepDues
  ///
  /// In en, this message translates to:
  /// **'Still to collect'**
  String get posRepDues;

  /// POS mode: posRepDuesHint
  ///
  /// In en, this message translates to:
  /// **'{count} orders not fully paid'**
  String posRepDuesHint(int count);

  /// POS mode: posRepSpent
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get posRepSpent;

  /// POS mode: posRepSpentHint
  ///
  /// In en, this message translates to:
  /// **'{count} expenses'**
  String posRepSpentHint(int count);

  /// POS mode: posRepNet
  ///
  /// In en, this message translates to:
  /// **'Collected minus spent'**
  String get posRepNet;

  /// POS mode: posRepOrders
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get posRepOrders;

  /// POS mode: posRepOrdersCount
  ///
  /// In en, this message translates to:
  /// **'{count} orders booked'**
  String posRepOrdersCount(int count);

  /// POS mode: posRepStBooked
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get posRepStBooked;

  /// POS mode: posRepStProcess
  ///
  /// In en, this message translates to:
  /// **'In process'**
  String get posRepStProcess;

  /// POS mode: posRepStReady
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get posRepStReady;

  /// POS mode: posRepStDelivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get posRepStDelivered;

  /// POS mode: posRepStCancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get posRepStCancelled;

  /// POS mode: posRepPayMix
  ///
  /// In en, this message translates to:
  /// **'How customers paid'**
  String get posRepPayMix;

  /// POS mode: posRepNoPayments
  ///
  /// In en, this message translates to:
  /// **'No payments in this period.'**
  String get posRepNoPayments;

  /// POS mode: posRepModeWallet
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get posRepModeWallet;

  /// POS mode: posRepTopGarments
  ///
  /// In en, this message translates to:
  /// **'Most booked garments'**
  String get posRepTopGarments;

  /// POS mode: posRepQty
  ///
  /// In en, this message translates to:
  /// **'{qty} · {amount}'**
  String posRepQty(String qty, String amount);

  /// POS mode: posRepSpendBy
  ///
  /// In en, this message translates to:
  /// **'Spending by type'**
  String get posRepSpendBy;

  /// POS mode: posRepDaily
  ///
  /// In en, this message translates to:
  /// **'Day by day'**
  String get posRepDaily;

  /// POS mode: posRepDayLine
  ///
  /// In en, this message translates to:
  /// **'Billed {billed} · Collected {collected} · Spent {spent}'**
  String posRepDayLine(String billed, String collected, String spent);

  /// POS mode: posRepExport
  ///
  /// In en, this message translates to:
  /// **'Share sales file (CSV)'**
  String get posRepExport;

  /// POS mode: posRepExportHint
  ///
  /// In en, this message translates to:
  /// **'Opens in Excel or Google Sheets. One row for each order.'**
  String get posRepExportHint;

  /// POS mode: posRepExportFailed
  ///
  /// In en, this message translates to:
  /// **'Could not prepare the file.'**
  String get posRepExportFailed;

  /// POS mode: posRepLoadError
  ///
  /// In en, this message translates to:
  /// **'Could not load the report.'**
  String get posRepLoadError;

  /// POS mode: posRepEmpty
  ///
  /// In en, this message translates to:
  /// **'No orders or expenses in this period.'**
  String get posRepEmpty;

  /// POS mode: posRepRangeTooLong
  ///
  /// In en, this message translates to:
  /// **'Please pick at most one year.'**
  String get posRepRangeTooLong;

  /// POS mode: posRepTabSummary
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get posRepTabSummary;

  /// POS mode: posRepTabInvoices
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get posRepTabInvoices;

  /// POS mode: posRepTabCollection
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get posRepTabCollection;

  /// POS mode: posRepTabExpense
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get posRepTabExpense;

  /// POS mode: posRepTotalRevenue
  ///
  /// In en, this message translates to:
  /// **'Total revenue'**
  String get posRepTotalRevenue;

  /// POS mode: posRepInvNo
  ///
  /// In en, this message translates to:
  /// **'Invoice no.'**
  String get posRepInvNo;

  /// POS mode: posRepAmount
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get posRepAmount;

  /// POS mode: posRepStatus
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get posRepStatus;

  /// POS mode: posRepPage
  ///
  /// In en, this message translates to:
  /// **'Page {n}'**
  String posRepPage(int n);

  /// POS mode: posRepPrev
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get posRepPrev;

  /// POS mode: posRepNext
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get posRepNext;

  /// POS mode: posRepNoInvoices
  ///
  /// In en, this message translates to:
  /// **'No invoices in this period.'**
  String get posRepNoInvoices;

  /// POS mode: posRepInvoicesFailed
  ///
  /// In en, this message translates to:
  /// **'Could not load the invoices.'**
  String get posRepInvoicesFailed;

  /// POS mode: posRepChartBilled
  ///
  /// In en, this message translates to:
  /// **'Billed each day'**
  String get posRepChartBilled;

  /// POS mode: posRepChartCollected
  ///
  /// In en, this message translates to:
  /// **'Collected each day'**
  String get posRepChartCollected;

  /// POS mode: posRepChartSpent
  ///
  /// In en, this message translates to:
  /// **'Spent each day'**
  String get posRepChartSpent;

  /// POS mode: posRepChartHigh
  ///
  /// In en, this message translates to:
  /// **'Highest: {amount} on {date}'**
  String posRepChartHigh(String amount, String date);

  /// POS mode: posRepChartNone
  ///
  /// In en, this message translates to:
  /// **'Nothing to draw yet.'**
  String get posRepChartNone;

  /// POS mode: posCustProfile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get posCustProfile;

  /// POS mode: posSetCustomers
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get posSetCustomers;

  /// POS mode: posSetCustomersBody
  ///
  /// In en, this message translates to:
  /// **'See everyone, call them, see what they owe.'**
  String get posSetCustomersBody;

  /// POS mode: posSetPrices
  ///
  /// In en, this message translates to:
  /// **'Price list'**
  String get posSetPrices;

  /// POS mode: posSetPricesBody
  ///
  /// In en, this message translates to:
  /// **'Add a garment or change a price.'**
  String get posSetPricesBody;

  /// POS mode: posSetRules
  ///
  /// In en, this message translates to:
  /// **'Extra charges and discounts'**
  String get posSetRules;

  /// POS mode: posSetRulesBody
  ///
  /// In en, this message translates to:
  /// **'The ones you can pick while booking.'**
  String get posSetRulesBody;

  /// POS mode: posSetRulesCharges
  ///
  /// In en, this message translates to:
  /// **'Extra charges'**
  String get posSetRulesCharges;

  /// POS mode: posSetRulesDiscounts
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get posSetRulesDiscounts;

  /// POS mode: posSetRulesNone
  ///
  /// In en, this message translates to:
  /// **'None yet. They are added on the counter software or the website.'**
  String get posSetRulesNone;

  /// POS mode: posSetRuleFlat
  ///
  /// In en, this message translates to:
  /// **'{amount} flat'**
  String posSetRuleFlat(String amount);

  /// POS mode: posSetRulePercent
  ///
  /// In en, this message translates to:
  /// **'{percent}% of the bill'**
  String posSetRulePercent(String percent);

  /// POS mode: posSetMessages
  ///
  /// In en, this message translates to:
  /// **'WhatsApp messages'**
  String get posSetMessages;

  /// POS mode: posSetMessagesBody
  ///
  /// In en, this message translates to:
  /// **'The messages sent to customers.'**
  String get posSetMessagesBody;

  /// POS mode: posSetMessagesHint
  ///
  /// In en, this message translates to:
  /// **'You can change these words on the counter software or the website. They show here too.'**
  String get posSetMessagesHint;

  /// POS mode: posSetTeam
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get posSetTeam;

  /// POS mode: posSetTeamBody
  ///
  /// In en, this message translates to:
  /// **'Who works in your shop.'**
  String get posSetTeamBody;

  /// POS mode: posSetTeamHint
  ///
  /// In en, this message translates to:
  /// **'To add or remove people, use the counter software or the website.'**
  String get posSetTeamHint;

  /// POS mode: posSetRoleOwner
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get posSetRoleOwner;

  /// POS mode: posSetRoleStaff
  ///
  /// In en, this message translates to:
  /// **'Counter staff'**
  String get posSetRoleStaff;

  /// POS mode: posSetRoleRider
  ///
  /// In en, this message translates to:
  /// **'Captain (pickup / delivery)'**
  String get posSetRoleRider;

  /// POS mode: posSetInactive
  ///
  /// In en, this message translates to:
  /// **'Not active'**
  String get posSetInactive;

  /// POS mode: posSetLanguage
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get posSetLanguage;

  /// POS mode: posSetLoadFailed
  ///
  /// In en, this message translates to:
  /// **'Could not load this.'**
  String get posSetLoadFailed;

  /// POS mode: posSetSectionShop
  ///
  /// In en, this message translates to:
  /// **'My shop'**
  String get posSetSectionShop;

  /// POS mode: posSetSectionApp
  ///
  /// In en, this message translates to:
  /// **'This app'**
  String get posSetSectionApp;

  /// POS mode: posEditItemsTitle
  ///
  /// In en, this message translates to:
  /// **'Garments & services'**
  String get posEditItemsTitle;

  /// POS mode: posEditAddItem
  ///
  /// In en, this message translates to:
  /// **'Add garment or service'**
  String get posEditAddItem;

  /// POS mode: posEditAddTitle
  ///
  /// In en, this message translates to:
  /// **'Add to this order'**
  String get posEditAddTitle;

  /// POS mode: posEditNoneForService
  ///
  /// In en, this message translates to:
  /// **'No priced garments for this service.'**
  String get posEditNoneForService;

  /// POS mode: posEditKeepOne
  ///
  /// In en, this message translates to:
  /// **'Keep at least one garment on the order.'**
  String get posEditKeepOne;

  /// POS mode: posEditNewTotal
  ///
  /// In en, this message translates to:
  /// **'New total'**
  String get posEditNewTotal;

  /// POS mode: posEditWasTotal
  ///
  /// In en, this message translates to:
  /// **'Was {amount}'**
  String posEditWasTotal(String amount);

  /// POS mode: posEditMore
  ///
  /// In en, this message translates to:
  /// **'+{amount} more to pay'**
  String posEditMore(String amount);

  /// POS mode: posEditLess
  ///
  /// In en, this message translates to:
  /// **'{amount} less'**
  String posEditLess(String amount);

  /// POS mode: posEditPriceFailed
  ///
  /// In en, this message translates to:
  /// **'Could not work out the new price.'**
  String get posEditPriceFailed;

  /// POS mode: posEditLocked
  ///
  /// In en, this message translates to:
  /// **'Garments can only be changed before processing starts.'**
  String get posEditLocked;

  /// POS mode: posEditDone
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get posEditDone;
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
