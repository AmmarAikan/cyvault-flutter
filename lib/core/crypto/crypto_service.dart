import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

abstract interface class RandomBytes {
  Uint8List nextBytes(int length);
}

final class SecureRandomBytes implements RandomBytes {
  final Random _random = Random.secure();

  @override
  Uint8List nextBytes(int length) => Uint8List.fromList(
    List<int>.generate(length, (_) => _random.nextInt(256)),
  );
}

final class EncryptedBlob {
  const EncryptedBlob({
    required this.nonce,
    required this.ciphertext,
    required this.mac,
  });

  final Uint8List nonce;
  final Uint8List ciphertext;
  final Uint8List mac;

  Map<String, Object> toJson() => <String, Object>{
    'nonce': base64UrlEncode(nonce),
    'ciphertext': base64UrlEncode(ciphertext),
    'tag': base64UrlEncode(mac),
  };

  factory EncryptedBlob.fromJson(Map<String, dynamic> json) => EncryptedBlob(
    nonce: base64Url.decode(json['nonce'] as String),
    ciphertext: base64Url.decode(json['ciphertext'] as String),
    mac: base64Url.decode(json['tag'] as String),
  );
}

final class CryptoService {
  CryptoService({RandomBytes? random}) : random = random ?? SecureRandomBytes();

  static const int kdfIterations = 600000;
  static const int saltLength = 16;
  static const int nonceLength = 12;
  static const int keyLength = 32;

  final RandomBytes random;
  final AesGcm _aes = AesGcm.with256bits();

  Future<SecretKeyData> deriveKey(
    String passphrase,
    Uint8List salt, {
    int iterations = kdfIterations,
  }) async {
    if (passphrase.isEmpty || salt.length < saltLength || iterations < 100000) {
      throw ArgumentError('Invalid KDF input.');
    }
    final key = await Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: keyLength * 8,
    ).deriveKey(secretKey: SecretKey(utf8.encode(passphrase)), nonce: salt);
    return SecretKeyData(await key.extractBytes());
  }

  Future<EncryptedBlob> encrypt(
    List<int> cleartext,
    SecretKey key, {
    required List<int> associatedData,
  }) async {
    final nonce = random.nextBytes(nonceLength);
    final box = await _aes.encrypt(
      cleartext,
      secretKey: key,
      nonce: nonce,
      aad: associatedData,
    );
    return EncryptedBlob(
      nonce: nonce,
      ciphertext: Uint8List.fromList(box.cipherText),
      mac: Uint8List.fromList(box.mac.bytes),
    );
  }

  Future<Uint8List> decrypt(
    EncryptedBlob blob,
    SecretKey key, {
    required List<int> associatedData,
  }) async {
    if (blob.nonce.length != nonceLength || blob.mac.length != 16) {
      throw const FormatException('Invalid encrypted envelope.');
    }
    final clear = await _aes.decrypt(
      SecretBox(blob.ciphertext, nonce: blob.nonce, mac: Mac(blob.mac)),
      secretKey: key,
      aad: associatedData,
    );
    return Uint8List.fromList(clear);
  }
}
