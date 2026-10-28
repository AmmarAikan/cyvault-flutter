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
/// import 'l10n/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CyVault'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your secrets, under your control'**
  String get tagline;

  /// No description provided for @createVault.
  ///
  /// In en, this message translates to:
  /// **'Create your vault'**
  String get createVault;

  /// No description provided for @unlockVault.
  ///
  /// In en, this message translates to:
  /// **'Unlock CyVault'**
  String get unlockVault;

  /// No description provided for @masterPassword.
  ///
  /// In en, this message translates to:
  /// **'Master password'**
  String get masterPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordMismatch;

  /// No description provided for @passwordTooWeak.
  ///
  /// In en, this message translates to:
  /// **'Use at least 12 characters with a varied phrase.'**
  String get passwordTooWeak;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is incorrect or the vault metadata is damaged.'**
  String get wrongPassword;

  /// No description provided for @securityNotice.
  ///
  /// In en, this message translates to:
  /// **'CyVault cannot recover a forgotten master password. Keep a separate encrypted backup.'**
  String get securityNotice;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @vault.
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get vault;

  /// No description provided for @generator.
  ///
  /// In en, this message translates to:
  /// **'Generator'**
  String get generator;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @breachCheck.
  ///
  /// In en, this message translates to:
  /// **'Breach check'**
  String get breachCheck;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @securityModel.
  ///
  /// In en, this message translates to:
  /// **'Security model'**
  String get securityModel;

  /// No description provided for @lock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lock;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @breached.
  ///
  /// In en, this message translates to:
  /// **'Breached'**
  String get breached;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @averageRisk.
  ///
  /// In en, this message translates to:
  /// **'Average risk'**
  String get averageRisk;

  /// No description provided for @emptyVault.
  ///
  /// In en, this message translates to:
  /// **'Your vault is empty'**
  String get emptyVault;

  /// No description provided for @emptyVaultHint.
  ///
  /// In en, this message translates to:
  /// **'Add the first encrypted login to begin.'**
  String get emptyVaultHint;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editItem;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username or email'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get url;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags (comma separated)'**
  String get tags;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search decrypted items'**
  String get search;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied temporarily'**
  String get copied;

  /// No description provided for @reveal.
  ///
  /// In en, this message translates to:
  /// **'Reveal'**
  String get reveal;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @checkNow.
  ///
  /// In en, this message translates to:
  /// **'Check now'**
  String get checkNow;

  /// No description provided for @onlineConsentRequired.
  ///
  /// In en, this message translates to:
  /// **'Enable online breach consent in Settings first.'**
  String get onlineConsentRequired;

  /// No description provided for @notFoundInBreach.
  ///
  /// In en, this message translates to:
  /// **'Not found in the queried breach corpus.'**
  String get notFoundInBreach;

  /// No description provided for @foundInBreach.
  ///
  /// In en, this message translates to:
  /// **'Found {count} times in the breach corpus.'**
  String foundInBreach(int count);

  /// No description provided for @offlineAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Offline strength analysis remains available. A prefix match alone is never treated as proof of breach.'**
  String get offlineAnalysis;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate password'**
  String get generate;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @uppercase.
  ///
  /// In en, this message translates to:
  /// **'Uppercase'**
  String get uppercase;

  /// No description provided for @lowercase.
  ///
  /// In en, this message translates to:
  /// **'Lowercase'**
  String get lowercase;

  /// No description provided for @digits.
  ///
  /// In en, this message translates to:
  /// **'Digits'**
  String get digits;

  /// No description provided for @symbols.
  ///
  /// In en, this message translates to:
  /// **'Symbols'**
  String get symbols;

  /// No description provided for @avoidAmbiguous.
  ///
  /// In en, this message translates to:
  /// **'Avoid ambiguous characters'**
  String get avoidAmbiguous;

  /// No description provided for @saveToVault.
  ///
  /// In en, this message translates to:
  /// **'Save to vault'**
  String get saveToVault;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @dynamicColor.
  ///
  /// In en, this message translates to:
  /// **'Use system dynamic color'**
  String get dynamicColor;

  /// No description provided for @onlineBreachConsent.
  ///
  /// In en, this message translates to:
  /// **'Allow k-anonymity breach checks'**
  String get onlineBreachConsent;

  /// No description provided for @biometricSecondStep.
  ///
  /// In en, this message translates to:
  /// **'Biometric second step'**
  String get biometricSecondStep;

  /// No description provided for @autoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock'**
  String get autoLock;

  /// No description provided for @oneMinute.
  ///
  /// In en, this message translates to:
  /// **'1 minute'**
  String get oneMinute;

  /// No description provided for @fiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get fiveMinutes;

  /// No description provided for @fifteenMinutes.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get fifteenMinutes;

  /// No description provided for @clipboardDelay.
  ///
  /// In en, this message translates to:
  /// **'Clipboard clear delay'**
  String get clipboardDelay;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export encrypted backup'**
  String get exportBackup;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import encrypted backup'**
  String get importBackup;

  /// No description provided for @backupPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Backup passphrase'**
  String get backupPassphrase;

  /// No description provided for @confirmBackupPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Confirm backup passphrase'**
  String get confirmBackupPassphrase;

  /// No description provided for @backupComplete.
  ///
  /// In en, this message translates to:
  /// **'Encrypted backup created.'**
  String get backupComplete;

  /// No description provided for @importComplete.
  ///
  /// In en, this message translates to:
  /// **'Backup authenticated and imported.'**
  String get importComplete;

  /// No description provided for @invalidBackup.
  ///
  /// In en, this message translates to:
  /// **'The backup password, format, or integrity check failed.'**
  String get invalidBackup;

  /// No description provided for @conflictPolicy.
  ///
  /// In en, this message translates to:
  /// **'Conflict handling'**
  String get conflictPolicy;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip existing'**
  String get skip;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace existing'**
  String get replace;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Import as copies'**
  String get duplicate;

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Share safe PDF summary'**
  String get generateReport;

  /// No description provided for @reportReady.
  ///
  /// In en, this message translates to:
  /// **'Security summary ready to share.'**
  String get reportReady;

  /// No description provided for @privacySummary.
  ///
  /// In en, this message translates to:
  /// **'CyVault is offline-first. Online password checks are optional and send only a five-character SHA-1 prefix to the Pwned Passwords range service.'**
  String get privacySummary;

  /// No description provided for @educationalWarning.
  ///
  /// In en, this message translates to:
  /// **'Production-minded educational software; not independently audited or certified.'**
  String get educationalWarning;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. No secret data was logged.'**
  String get errorGeneric;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortTitle.
  ///
  /// In en, this message translates to:
  /// **'Title A–Z'**
  String get sortTitle;

  /// No description provided for @sortRisk.
  ///
  /// In en, this message translates to:
  /// **'Highest risk'**
  String get sortRisk;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @securityEvents.
  ///
  /// In en, this message translates to:
  /// **'Security events'**
  String get securityEvents;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'No security events yet.'**
  String get noEvents;

  /// No description provided for @changeMasterPassword.
  ///
  /// In en, this message translates to:
  /// **'Change master password'**
  String get changeMasterPassword;

  /// No description provided for @currentMasterPassword.
  ///
  /// In en, this message translates to:
  /// **'Current master password'**
  String get currentMasterPassword;

  /// No description provided for @newMasterPassword.
  ///
  /// In en, this message translates to:
  /// **'New master password'**
  String get newMasterPassword;

  /// No description provided for @masterPasswordChanged.
  ///
  /// In en, this message translates to:
  /// **'Master password changed without re-encrypting records.'**
  String get masterPasswordChanged;

  /// No description provided for @eventUnlockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vault unlocked'**
  String get eventUnlockSuccess;

  /// No description provided for @eventUnlockFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed unlock'**
  String get eventUnlockFailure;

  /// No description provided for @eventManualLock.
  ///
  /// In en, this message translates to:
  /// **'Manual lock'**
  String get eventManualLock;

  /// No description provided for @eventBackgroundLock.
  ///
  /// In en, this message translates to:
  /// **'Background lock'**
  String get eventBackgroundLock;

  /// No description provided for @eventTimeoutLock.
  ///
  /// In en, this message translates to:
  /// **'Inactivity lock'**
  String get eventTimeoutLock;

  /// No description provided for @eventBackupExport.
  ///
  /// In en, this message translates to:
  /// **'Backup exported'**
  String get eventBackupExport;

  /// No description provided for @eventBackupImport.
  ///
  /// In en, this message translates to:
  /// **'Backup imported'**
  String get eventBackupImport;

  /// No description provided for @eventBreachCheck.
  ///
  /// In en, this message translates to:
  /// **'Breach check'**
  String get eventBreachCheck;

  /// No description provided for @eventMasterPasswordChange.
  ///
  /// In en, this message translates to:
  /// **'Master password changed'**
  String get eventMasterPasswordChange;
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
