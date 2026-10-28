import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../../../core/crypto/crypto_service.dart';
import '../../vault/domain/vault_entry.dart';

final class BackupService {
  BackupService(this.crypto);

  static const int formatVersion = 1;
  static final List<int> _aad = utf8.encode('cyvault:portable-backup:v1');
  final CryptoService crypto;

  Future<String> export(List<VaultEntry> entries, String passphrase) async {
    if (passphrase.length < 12) throw ArgumentError('Weak backup passphrase.');
    final salt = crypto.random.nextBytes(CryptoService.saltLength);
    final key = await crypto.deriveKey(passphrase, salt);
    final payload = <String, Object>{
      'schemaVersion': 1,
      'app': 'CyVault',
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'manifest': <String, Object>{'itemCount': entries.length},
      'items': entries.map((entry) => entry.toJson()).toList(growable: false),
    };
    final blob = await crypto.encrypt(
      utf8.encode(jsonEncode(payload)),
      key,
      associatedData: _aad,
    );
    return jsonEncode(<String, Object>{
      'format': 'cyvault-backup',
      'version': formatVersion,
      'kdf': <String, Object>{
        'name': 'PBKDF2-HMAC-SHA256',
        'iterations': CryptoService.kdfIterations,
        'salt': base64UrlEncode(salt),
      },
      'cipher': 'AES-256-GCM',
      'payload': blob.toJson(),
    });
  }

  Future<List<VaultEntry>> import(String container, String passphrase) async {
    try {
      final outer = jsonDecode(container) as Map<String, dynamic>;
      if (outer['format'] != 'cyvault-backup' ||
          outer['version'] != formatVersion ||
          outer['cipher'] != 'AES-256-GCM') {
        throw const FormatException('Unsupported backup.');
      }
      final kdf = outer['kdf'] as Map<String, dynamic>;
      if (kdf['name'] != 'PBKDF2-HMAC-SHA256') {
        throw const FormatException('Unsupported KDF.');
      }
      final iterations = kdf['iterations'] as int;
      if (iterations < 100000) throw const FormatException('Unsafe KDF.');
      final salt = base64Url.decode(kdf['salt'] as String);
      final key = await crypto.deriveKey(
        passphrase,
        salt,
        iterations: iterations,
      );
      final clear = await crypto.decrypt(
        EncryptedBlob.fromJson(outer['payload'] as Map<String, dynamic>),
        key,
        associatedData: _aad,
      );
      final payload = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
      if (payload['schemaVersion'] != 1 || payload['app'] != 'CyVault') {
        throw const FormatException('Unsupported payload.');
      }
      final rawItems = payload['items'] as List<dynamic>;
      final manifest = payload['manifest'] as Map<String, dynamic>;
      if (manifest['itemCount'] != rawItems.length) {
        throw const FormatException('Backup manifest mismatch.');
      }
      return rawItems
          .map((item) => VaultEntry.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
    } on SecretBoxAuthenticationError {
      throw const FormatException('Backup authentication failed.');
    }
  }
}
