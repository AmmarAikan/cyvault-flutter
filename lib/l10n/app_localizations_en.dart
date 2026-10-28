// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CyVault';

  @override
  String get tagline => 'Your secrets, under your control';

  @override
  String get createVault => 'Create your vault';

  @override
  String get unlockVault => 'Unlock CyVault';

  @override
  String get masterPassword => 'Master password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get continueLabel => 'Continue';

  @override
  String get unlock => 'Unlock';

  @override
  String get passwordMismatch => 'Passwords do not match.';

  @override
  String get passwordTooWeak =>
      'Use at least 12 characters with a varied phrase.';

  @override
  String get wrongPassword =>
      'The password is incorrect or the vault metadata is damaged.';

  @override
  String get securityNotice =>
      'CyVault cannot recover a forgotten master password. Keep a separate encrypted backup.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get vault => 'Vault';

  @override
  String get generator => 'Generator';

  @override
  String get settings => 'Settings';

  @override
  String get breachCheck => 'Breach check';

  @override
  String get help => 'Help';

  @override
  String get about => 'About';

  @override
  String get securityModel => 'Security model';

  @override
  String get lock => 'Lock';

  @override
  String get items => 'Items';

  @override
  String get breached => 'Breached';

  @override
  String get favorites => 'Favorites';

  @override
  String get averageRisk => 'Average risk';

  @override
  String get emptyVault => 'Your vault is empty';

  @override
  String get emptyVaultHint => 'Add the first encrypted login to begin.';

  @override
  String get addItem => 'Add item';

  @override
  String get editItem => 'Edit item';

  @override
  String get title => 'Title';

  @override
  String get username => 'Username or email';

  @override
  String get password => 'Password';

  @override
  String get url => 'Website';

  @override
  String get notes => 'Notes';

  @override
  String get tags => 'Tags (comma separated)';

  @override
  String get favorite => 'Favorite';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get search => 'Search decrypted items';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied temporarily';

  @override
  String get reveal => 'Reveal';

  @override
  String get hide => 'Hide';

  @override
  String get checkNow => 'Check now';

  @override
  String get onlineConsentRequired =>
      'Enable online breach consent in Settings first.';

  @override
  String get notFoundInBreach => 'Not found in the queried breach corpus.';

  @override
  String foundInBreach(int count) {
    return 'Found $count times in the breach corpus.';
  }

  @override
  String get offlineAnalysis =>
      'Offline strength analysis remains available. A prefix match alone is never treated as proof of breach.';

  @override
  String get generate => 'Generate password';

  @override
  String get length => 'Length';

  @override
  String get uppercase => 'Uppercase';

  @override
  String get lowercase => 'Lowercase';

  @override
  String get digits => 'Digits';

  @override
  String get symbols => 'Symbols';

  @override
  String get avoidAmbiguous => 'Avoid ambiguous characters';

  @override
  String get saveToVault => 'Save to vault';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get dynamicColor => 'Use system dynamic color';

  @override
  String get onlineBreachConsent => 'Allow k-anonymity breach checks';

  @override
  String get biometricSecondStep => 'Biometric second step';

  @override
  String get autoLock => 'Auto-lock';

  @override
  String get oneMinute => '1 minute';

  @override
  String get fiveMinutes => '5 minutes';

  @override
  String get fifteenMinutes => '15 minutes';

  @override
  String get clipboardDelay => 'Clipboard clear delay';

  @override
  String get exportBackup => 'Export encrypted backup';

  @override
  String get importBackup => 'Import encrypted backup';

  @override
  String get backupPassphrase => 'Backup passphrase';

  @override
  String get confirmBackupPassphrase => 'Confirm backup passphrase';

  @override
  String get backupComplete => 'Encrypted backup created.';

  @override
  String get importComplete => 'Backup authenticated and imported.';

  @override
  String get invalidBackup =>
      'The backup password, format, or integrity check failed.';

  @override
  String get conflictPolicy => 'Conflict handling';

  @override
  String get skip => 'Skip existing';

  @override
  String get replace => 'Replace existing';

  @override
  String get duplicate => 'Import as copies';

  @override
  String get generateReport => 'Share safe PDF summary';

  @override
  String get reportReady => 'Security summary ready to share.';

  @override
  String get privacySummary =>
      'CyVault is offline-first. Online password checks are optional and send only a five-character SHA-1 prefix to the Pwned Passwords range service.';

  @override
  String get educationalWarning =>
      'Production-minded educational software; not independently audited or certified.';

  @override
  String get loading => 'Loading…';

  @override
  String get retry => 'Retry';

  @override
  String get errorGeneric => 'Something went wrong. No secret data was logged.';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortTitle => 'Title A–Z';

  @override
  String get sortRisk => 'Highest risk';

  @override
  String get all => 'All';

  @override
  String get securityEvents => 'Security events';

  @override
  String get noEvents => 'No security events yet.';

  @override
  String get changeMasterPassword => 'Change master password';

  @override
  String get currentMasterPassword => 'Current master password';

  @override
  String get newMasterPassword => 'New master password';

  @override
  String get masterPasswordChanged =>
      'Master password changed without re-encrypting records.';

  @override
  String get eventUnlockSuccess => 'Vault unlocked';

  @override
  String get eventUnlockFailure => 'Failed unlock';

  @override
  String get eventManualLock => 'Manual lock';

  @override
  String get eventBackgroundLock => 'Background lock';

  @override
  String get eventTimeoutLock => 'Inactivity lock';

  @override
  String get eventBackupExport => 'Backup exported';

  @override
  String get eventBackupImport => 'Backup imported';

  @override
  String get eventBreachCheck => 'Breach check';

  @override
  String get eventMasterPasswordChange => 'Master password changed';
}
