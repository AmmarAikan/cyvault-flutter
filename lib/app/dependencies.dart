import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/crypto/crypto_service.dart';
import '../core/crypto/master_password_service.dart';
import '../core/database/app_database.dart';
import '../core/security/biometric_service.dart';
import '../core/security/clipboard_guard.dart';
import '../core/security/vault_session.dart';
import '../core/settings/app_settings.dart';
import '../features/backup/data/backup_service.dart';

final class AppDependencies {
  AppDependencies._({
    required this.database,
    required this.crypto,
    required this.masterPasswords,
    required this.session,
    required this.settings,
    required this.biometrics,
    required this.clipboard,
    required this.backups,
    required this.httpClient,
  });

  @visibleForTesting
  factory AppDependencies.forTesting({
    required AppDatabase database,
    required CryptoService crypto,
    required MasterPasswordService masterPasswords,
    required VaultSession session,
    required AppSettings settings,
    required BiometricConfirmation biometrics,
    required ClipboardGuard clipboard,
    required BackupService backups,
    required http.Client httpClient,
  }) = AppDependencies._;

  final AppDatabase database;
  final CryptoService crypto;
  final MasterPasswordService masterPasswords;
  final VaultSession session;
  final AppSettings settings;
  final BiometricConfirmation biometrics;
  final ClipboardGuard clipboard;
  final BackupService backups;
  final http.Client httpClient;

  static Future<AppDependencies> create() async {
    final database = AppDatabase();
    final crypto = CryptoService();
    final masterPasswords = MasterPasswordService(
      crypto,
      SecureMetadataStore(),
    );
    final session = VaultSession(masterPasswords, database);
    await session.initialize();
    return AppDependencies._(
      database: database,
      crypto: crypto,
      masterPasswords: masterPasswords,
      session: session,
      settings: AppSettings(await SharedPreferences.getInstance()),
      biometrics: LocalBiometricConfirmation(),
      clipboard: ClipboardGuard(),
      backups: BackupService(crypto),
      httpClient: http.Client(),
    );
  }

  Future<void> dispose() async {
    clipboard.dispose();
    httpClient.close();
    session.dispose();
    settings.dispose();
    await database.close();
  }
}
