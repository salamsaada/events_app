import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Royal Events'**
  String get appTitle;

  /// No description provided for @legacyOfExcellence.
  ///
  /// In en, this message translates to:
  /// **'The Legacy of Excellence'**
  String get legacyOfExcellence;

  /// No description provided for @pageWillBeAvailable.
  ///
  /// In en, this message translates to:
  /// **'This page will be available soon'**
  String get pageWillBeAvailable;

  /// No description provided for @authSecureAccess.
  ///
  /// In en, this message translates to:
  /// **'SECURE ACCESS'**
  String get authSecureAccess;

  /// No description provided for @authSecurityProtocol.
  ///
  /// In en, this message translates to:
  /// **'SECURITY PROTOCOL'**
  String get authSecurityProtocol;

  /// No description provided for @authPasswordRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Password\nRecovery'**
  String get authPasswordRecoveryTitle;

  /// No description provided for @authRecoveryDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered credentials to receive a secure access token via our concierge network.'**
  String get authRecoveryDescription;

  /// No description provided for @authEmailOrMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'EMAIL OR MOBILE NUMBER'**
  String get authEmailOrMobileNumber;

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get authSignInTitle;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to the gala.'**
  String get authWelcomeBack;

  /// No description provided for @authEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get authEmailAddress;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authDontHaveAccount;

  /// No description provided for @authCreateOne.
  ///
  /// In en, this message translates to:
  /// **'Create One'**
  String get authCreateOne;

  /// No description provided for @authCreateAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'CREATE\nACCOUNT'**
  String get authCreateAccountTitle;

  /// No description provided for @authCreateAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in your details to join the gala.'**
  String get authCreateAccountSubtitle;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @authEmailOrPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get authEmailOrPhoneNumber;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get authCreateAccountButton;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authAlreadyHaveAccount;

  /// No description provided for @authSignInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignInLink;

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'OR CONTINUE WITH'**
  String get authOrContinueWith;

  /// No description provided for @authRequestResetCode.
  ///
  /// In en, this message translates to:
  /// **'REQUEST RESET CODE'**
  String get authRequestResetCode;

  /// No description provided for @authReturnToLogin.
  ///
  /// In en, this message translates to:
  /// **'< RETURN TO LOGIN'**
  String get authReturnToLogin;

  /// No description provided for @selectionChooseDestination.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE YOUR DESTINATION'**
  String get selectionChooseDestination;

  /// No description provided for @selectionBeginJourney.
  ///
  /// In en, this message translates to:
  /// **'Begin Your Journey'**
  String get selectionBeginJourney;

  /// No description provided for @selectionUserTitle.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get selectionUserTitle;

  /// No description provided for @selectionUserDescription.
  ///
  /// In en, this message translates to:
  /// **'For guests seeking access to signature events.'**
  String get selectionUserDescription;

  /// No description provided for @selectionJoinTheGala.
  ///
  /// In en, this message translates to:
  /// **'JOIN THE GALA'**
  String get selectionJoinTheGala;

  /// No description provided for @selectionGuestExplorerTitle.
  ///
  /// In en, this message translates to:
  /// **'Guest Explorer'**
  String get selectionGuestExplorerTitle;

  /// No description provided for @selectionGuestExplorerDescription.
  ///
  /// In en, this message translates to:
  /// **'Just looking around? Browse our exclusive events collection without creating an account.'**
  String get selectionGuestExplorerDescription;

  /// No description provided for @selectionExploreAsGuest.
  ///
  /// In en, this message translates to:
  /// **'EXPLORE AS GUEST'**
  String get selectionExploreAsGuest;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @eventTypes.
  ///
  /// In en, this message translates to:
  /// **'Event Types'**
  String get eventTypes;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Membership'**
  String get subscription;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @renewalDate.
  ///
  /// In en, this message translates to:
  /// **'Renewal Date'**
  String get renewalDate;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @savedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get savedAddresses;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @previousOrders.
  ///
  /// In en, this message translates to:
  /// **'Previous Orders'**
  String get previousOrders;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'App Notifications'**
  String get pushNotifications;

  /// No description provided for @smsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Text Messages'**
  String get smsNotifications;

  /// No description provided for @nightMode.
  ///
  /// In en, this message translates to:
  /// **'Night Mode'**
  String get nightMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language: English'**
  String get language;

  /// No description provided for @biometric.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometric;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium Client - Elite'**
  String get premium;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for halls, staff, or planners...'**
  String get searchHint;

  /// No description provided for @featuredHall.
  ///
  /// In en, this message translates to:
  /// **'Featured Hall'**
  String get featuredHall;

  /// No description provided for @goldSuite.
  ///
  /// In en, this message translates to:
  /// **'Golden Suite'**
  String get goldSuite;

  /// No description provided for @hallDescription.
  ///
  /// In en, this message translates to:
  /// **'Enjoy architectural luxury and concierge services\ndesigned specifically for your upcoming\nhigh-level event.'**
  String get hallDescription;

  /// No description provided for @bookRequest.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookRequest;

  /// No description provided for @luxuryServices.
  ///
  /// In en, this message translates to:
  /// **'Luxury Services'**
  String get luxuryServices;

  /// No description provided for @selectedCarefully.
  ///
  /// In en, this message translates to:
  /// **'Carefully selected for your refined taste.'**
  String get selectedCarefully;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @individualServices.
  ///
  /// In en, this message translates to:
  /// **'Individual Services'**
  String get individualServices;

  /// No description provided for @flowerArrangement.
  ///
  /// In en, this message translates to:
  /// **'Flower arrangement, custom lighting, and\nelegant décor.'**
  String get flowerArrangement;

  /// No description provided for @weddingHalls.
  ///
  /// In en, this message translates to:
  /// **'Wedding Halls'**
  String get weddingHalls;

  /// No description provided for @historicalPalaces.
  ///
  /// In en, this message translates to:
  /// **'Historic palaces and modern architectural masterpieces.'**
  String get historicalPalaces;

  /// No description provided for @professionalStaff.
  ///
  /// In en, this message translates to:
  /// **'Professional Staff'**
  String get professionalStaff;

  /// No description provided for @serviceDescription.
  ///
  /// In en, this message translates to:
  /// **'Elite services, world-class chefs, and expert\nplanners.'**
  String get serviceDescription;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @activeOrders.
  ///
  /// In en, this message translates to:
  /// **'2 Active'**
  String get activeOrders;

  /// No description provided for @corporateDinner.
  ///
  /// In en, this message translates to:
  /// **'Corporate Event Dinner'**
  String get corporateDinner;

  /// No description provided for @scheduledDate.
  ///
  /// In en, this message translates to:
  /// **'Scheduled on Oct 24, 2023'**
  String get scheduledDate;

  /// No description provided for @lastConversations.
  ///
  /// In en, this message translates to:
  /// **'Last Conversations'**
  String get lastConversations;

  /// No description provided for @eliteMembership.
  ///
  /// In en, this message translates to:
  /// **'Elite Membership'**
  String get eliteMembership;

  /// No description provided for @eliteMembershipDesc.
  ///
  /// In en, this message translates to:
  /// **'Join our royal circle for booking priority\nand exclusive hall access.'**
  String get eliteMembershipDesc;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your work email'**
  String get emailPlaceholder;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNow;

  /// No description provided for @sarraHarbi.
  ///
  /// In en, this message translates to:
  /// **'Sarah Al-Harbi'**
  String get sarraHarbi;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'sarah@royal-events.com'**
  String get email;

  /// No description provided for @riyadh.
  ///
  /// In en, this message translates to:
  /// **'Riyadh'**
  String get riyadh;

  /// No description provided for @weddingsCompaniesEvents.
  ///
  /// In en, this message translates to:
  /// **'Weddings - Companies - Special Events'**
  String get weddingsCompaniesEvents;

  /// No description provided for @royalMembership.
  ///
  /// In en, this message translates to:
  /// **'Royal Membership'**
  String get royalMembership;

  /// No description provided for @renewalDateValue.
  ///
  /// In en, this message translates to:
  /// **'May 15, 2026'**
  String get renewalDateValue;

  /// No description provided for @balanceAmount.
  ///
  /// In en, this message translates to:
  /// **'4,800 SAR'**
  String get balanceAmount;

  /// No description provided for @yasmineDistrict.
  ///
  /// In en, this message translates to:
  /// **'Yasmine District, Riyadh'**
  String get yasmineDistrict;

  /// No description provided for @kingFahdRoad.
  ///
  /// In en, this message translates to:
  /// **'King Fahd Road, Riyadh'**
  String get kingFahdRoad;

  /// No description provided for @time1245.
  ///
  /// In en, this message translates to:
  /// **'12:45 PM'**
  String get time1245;

  /// No description provided for @marcusConcierge.
  ///
  /// In en, this message translates to:
  /// **'Marcus, Concierge'**
  String get marcusConcierge;

  /// No description provided for @menuCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'The catering menu for the event has been finalized...'**
  String get menuCompletedMessage;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @elenaFlowers.
  ///
  /// In en, this message translates to:
  /// **'Elena, Head of Flowers'**
  String get elenaFlowers;

  /// No description provided for @orchidProvidedMessage.
  ///
  /// In en, this message translates to:
  /// **'We have provided the white orchid you requested.'**
  String get orchidProvidedMessage;

  /// No description provided for @servicesCategoryFloralDesign.
  ///
  /// In en, this message translates to:
  /// **'Floral Design'**
  String get servicesCategoryFloralDesign;

  /// No description provided for @servicesCategoryPhotography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get servicesCategoryPhotography;

  /// No description provided for @servicesCategoryCatering.
  ///
  /// In en, this message translates to:
  /// **'Catering'**
  String get servicesCategoryCatering;

  /// No description provided for @servicesCategorySoundLight.
  ///
  /// In en, this message translates to:
  /// **'Sound & Light'**
  String get servicesCategorySoundLight;

  /// No description provided for @servicesCategoryCakesSweets.
  ///
  /// In en, this message translates to:
  /// **'Cakes & Sweets'**
  String get servicesCategoryCakesSweets;

  /// No description provided for @servicesCategoryDjMusic.
  ///
  /// In en, this message translates to:
  /// **'DJ & Music'**
  String get servicesCategoryDjMusic;

  /// No description provided for @servicesHeaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Tailored options crafted for your event style and guest experience.'**
  String get servicesHeaderDescription;

  /// No description provided for @servicesFloralDescription.
  ///
  /// In en, this message translates to:
  /// **'Elegant floral concepts, centerpiece styling, and entrance arrangements.'**
  String get servicesFloralDescription;

  /// No description provided for @servicesPhotographyDescription.
  ///
  /// In en, this message translates to:
  /// **'Capture the most meaningful moments with premium lenses and creative direction.'**
  String get servicesPhotographyDescription;

  /// No description provided for @servicesCateringDescription.
  ///
  /// In en, this message translates to:
  /// **'Refined menus, live stations, and flawless service for every guest.'**
  String get servicesCateringDescription;

  /// No description provided for @servicesSoundLightDescription.
  ///
  /// In en, this message translates to:
  /// **'Immersive lighting scenes and crystal-clear sound for every stage of your event.'**
  String get servicesSoundLightDescription;

  /// No description provided for @servicesCakesSweetsDescription.
  ///
  /// In en, this message translates to:
  /// **'Artistic cakes and signature desserts designed to match your celebration theme.'**
  String get servicesCakesSweetsDescription;

  /// No description provided for @servicesDjMusicDescription.
  ///
  /// In en, this message translates to:
  /// **'Curated playlists and dynamic DJ sets to keep the energy high all night.'**
  String get servicesDjMusicDescription;

  /// No description provided for @servicesStylesTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Styles'**
  String get servicesStylesTitle;

  /// No description provided for @servicesPackagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended Packages'**
  String get servicesPackagesTitle;

  /// No description provided for @servicesPackageEssential.
  ///
  /// In en, this message translates to:
  /// **'Essential'**
  String get servicesPackageEssential;

  /// No description provided for @servicesPackagePremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get servicesPackagePremium;

  /// No description provided for @servicesPackageSignature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get servicesPackageSignature;

  /// No description provided for @servicesHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get servicesHoursLabel;

  /// No description provided for @servicesItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'deliverables'**
  String get servicesItemsLabel;

  /// No description provided for @servicesBookAction.
  ///
  /// In en, this message translates to:
  /// **'Book This Service'**
  String get servicesBookAction;

  /// No description provided for @servicesBookingSent.
  ///
  /// In en, this message translates to:
  /// **'Your booking request has been sent successfully.'**
  String get servicesBookingSent;

  /// No description provided for @servicesStyleClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get servicesStyleClassic;

  /// No description provided for @servicesStyleLuxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get servicesStyleLuxury;

  /// No description provided for @servicesStyleGarden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get servicesStyleGarden;

  /// No description provided for @servicesStyleMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get servicesStyleMinimal;

  /// No description provided for @servicesStyleWedding.
  ///
  /// In en, this message translates to:
  /// **'Wedding'**
  String get servicesStyleWedding;

  /// No description provided for @servicesStyleOutdoor.
  ///
  /// In en, this message translates to:
  /// **'Outdoor'**
  String get servicesStyleOutdoor;

  /// No description provided for @servicesStyleStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get servicesStyleStudio;

  /// No description provided for @servicesStyleCinematic.
  ///
  /// In en, this message translates to:
  /// **'Cinematic'**
  String get servicesStyleCinematic;

  /// No description provided for @servicesStyleBuffet.
  ///
  /// In en, this message translates to:
  /// **'Buffet'**
  String get servicesStyleBuffet;

  /// No description provided for @servicesStylePlated.
  ///
  /// In en, this message translates to:
  /// **'Plated'**
  String get servicesStylePlated;

  /// No description provided for @servicesStyleLiveStations.
  ///
  /// In en, this message translates to:
  /// **'Live Stations'**
  String get servicesStyleLiveStations;

  /// No description provided for @servicesStyleDessertBar.
  ///
  /// In en, this message translates to:
  /// **'Dessert Bar'**
  String get servicesStyleDessertBar;

  /// No description provided for @servicesStyleAmbient.
  ///
  /// In en, this message translates to:
  /// **'Ambient'**
  String get servicesStyleAmbient;

  /// No description provided for @servicesStyleStage.
  ///
  /// In en, this message translates to:
  /// **'Stage Show'**
  String get servicesStyleStage;

  /// No description provided for @servicesStyleConcert.
  ///
  /// In en, this message translates to:
  /// **'Concert Mode'**
  String get servicesStyleConcert;

  /// No description provided for @servicesStyleSmartLighting.
  ///
  /// In en, this message translates to:
  /// **'Smart Lighting'**
  String get servicesStyleSmartLighting;

  /// No description provided for @servicesStyleClassicCakes.
  ///
  /// In en, this message translates to:
  /// **'Classic Cakes'**
  String get servicesStyleClassicCakes;

  /// No description provided for @servicesStyleModernDesigns.
  ///
  /// In en, this message translates to:
  /// **'Modern Designs'**
  String get servicesStyleModernDesigns;

  /// No description provided for @servicesStyleMiniDesserts.
  ///
  /// In en, this message translates to:
  /// **'Mini Desserts'**
  String get servicesStyleMiniDesserts;

  /// No description provided for @servicesStyleSignatureSweets.
  ///
  /// In en, this message translates to:
  /// **'Signature Sweets'**
  String get servicesStyleSignatureSweets;

  /// No description provided for @servicesStyleArabicMix.
  ///
  /// In en, this message translates to:
  /// **'Arabic Mix'**
  String get servicesStyleArabicMix;

  /// No description provided for @servicesStyleInternational.
  ///
  /// In en, this message translates to:
  /// **'International Hits'**
  String get servicesStyleInternational;

  /// No description provided for @servicesStyleLiveDj.
  ///
  /// In en, this message translates to:
  /// **'Live DJ'**
  String get servicesStyleLiveDj;

  /// No description provided for @servicesStyleCustomPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Custom Playlist'**
  String get servicesStyleCustomPlaylist;

  /// No description provided for @servicesPhotographyGallery.
  ///
  /// In en, this message translates to:
  /// **'Photography Gallery'**
  String get servicesPhotographyGallery;

  /// No description provided for @servicesCateringSampleMenu.
  ///
  /// In en, this message translates to:
  /// **'Sample Menus'**
  String get servicesCateringSampleMenu;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsNoItems.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up — no notifications.'**
  String get notificationsNoItems;

  /// No description provided for @notificationsClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get notificationsClear;

  /// No description provided for @notificationsMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get notificationsMarkRead;

  /// No description provided for @notificationsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get notificationsDelete;

  /// No description provided for @notificationsHourSuffix.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get notificationsHourSuffix;

  /// No description provided for @notificationReservationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Reservation update #{index}'**
  String notificationReservationUpdated(Object index);

  /// No description provided for @notificationNewMessage.
  ///
  /// In en, this message translates to:
  /// **'New message #{index}'**
  String notificationNewMessage(Object index);

  /// No description provided for @notificationReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder #{index}'**
  String notificationReminder(Object index);

  /// No description provided for @notificationBookingChanged.
  ///
  /// In en, this message translates to:
  /// **'Your booking time changed.'**
  String get notificationBookingChanged;

  /// No description provided for @notificationConciergeMessage.
  ///
  /// In en, this message translates to:
  /// **'A new message from concierge.'**
  String get notificationConciergeMessage;

  /// No description provided for @notificationUpcomingEvent.
  ///
  /// In en, this message translates to:
  /// **'Your upcoming event is almost here.'**
  String get notificationUpcomingEvent;

  /// No description provided for @servicesFloralGallery.
  ///
  /// In en, this message translates to:
  /// **'Floral Gallery'**
  String get servicesFloralGallery;

  /// No description provided for @servicesSoundLightPreview.
  ///
  /// In en, this message translates to:
  /// **'Sound & Lighting Preview'**
  String get servicesSoundLightPreview;

  /// No description provided for @servicesCakesGallery.
  ///
  /// In en, this message translates to:
  /// **'Cakes & Desserts'**
  String get servicesCakesGallery;

  /// No description provided for @servicesDjPreview.
  ///
  /// In en, this message translates to:
  /// **'DJ & Entertainment'**
  String get servicesDjPreview;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
