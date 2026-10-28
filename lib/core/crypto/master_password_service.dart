import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'crypto_service.dart';

abstract interface class MetadataStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

final class SecureMetadataStore implements MetadataStore {
  SecureMetadataStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
}

final class MemoryMetadataStore implements MetadataStore {
  final Map<String, String> values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

final class MasterPasswordService {
  MasterPasswordService(this.crypto, this.store);

  static const String envelopeKey = 'cyvault.key-envelope';
  static const int envelopeVersion = 1;
  static final List<int> _aad = utf8.encode('cyvault:key-envelope:v1');

  final CryptoService crypto;
  final MetadataStore store;

  Future<bool> hasVault() async => (await store.read(envelopeKey)) != null;

  Future<Uint8List> setup(String password) async {
    if (await hasVault()) throw StateError('Vault already exists.');
    final dek = crypto.random.nextBytes(CryptoService.keyLength);
    await _storeWrappedDek(dek, password);
    return Uint8List.fromList(dek);
  }

  Future<Uint8List?> unlock(String password) async {
    final encoded = await store.read(envelopeKey);
    if (encoded == null) return null;
    try {
      final json = jsonDecode(encoded) as Map<String, dynamic>;
      if (json['version'] != envelopeVersion ||
          json['kdf'] != 'PBKDF2-HMAC-SHA256' ||
          json['cipher'] != 'AES-256-GCM') {
        return null;
      }
      final iterations = json['iterations'] as int;
      if (iterations < 100000) return null;
      final salt = base64Url.decode(json['salt'] as String);
      final kek = await crypto.deriveKey(
        password,
        salt,
        iterations: iterations,
      );
      return await crypto.decrypt(
        EncryptedBlob.fromJson(json['wrappedDek'] as Map<String, dynamic>),
        kek,
        associatedData: _aad,
      );
    } on SecretBoxAuthenticationError {
      return null;
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final dek = await unlock(oldPassword);
    if (dek == null) return false;
    await _storeWrappedDek(dek, newPassword);
    _wipe(dek);
    return true;
  }

  Future<void> _storeWrappedDek(Uint8List dek, String password) async {
    final salt = crypto.random.nextBytes(CryptoService.saltLength);
    final kek = await crypto.deriveKey(password, salt);
    final wrapped = await crypto.encrypt(dek, kek, associatedData: _aad);
    final envelope = <String, Object>{
      'version': envelopeVersion,
      'kdf': 'PBKDF2-HMAC-SHA256',
      'iterations': CryptoService.kdfIterations,
      'salt': base64UrlEncode(salt),
      'cipher': 'AES-256-GCM',
      'wrappedDek': wrapped.toJson(),
    };
    await store.write(envelopeKey, jsonEncode(envelope));
  }

  static void _wipe(Uint8List bytes) => bytes.fillRange(0, bytes.length, 0);
}
