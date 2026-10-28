import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cyvault/core/crypto/crypto_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('CryptoService', () {
    test('round trips with unique nonces and known inputs', () async {
      final crypto = CryptoService(random: DeterministicBytes());
      final key = SecretKeyData(List<int>.generate(32, (index) => index));
      final first = await crypto.encrypt(
        Uint8List.fromList(<int>[1, 2, 3, 4]),
        key,
        associatedData: <int>[9],
      );
      final second = await crypto.encrypt(
        Uint8List.fromList(<int>[1, 2, 3, 4]),
        key,
        associatedData: <int>[9],
      );
      expect(first.nonce, isNot(second.nonce));
      expect(await crypto.decrypt(first, key, associatedData: <int>[9]), <int>[
        1,
        2,
        3,
        4,
      ]);
    });

    test('rejects wrong key, tamper and associated-data mismatch', () async {
      final crypto = CryptoService();
      final key = SecretKeyData(List<int>.filled(32, 1));
      final wrong = SecretKeyData(List<int>.filled(32, 2));
      final blob = await crypto.encrypt(
        <int>[7, 8, 9],
        key,
        associatedData: <int>[4],
      );
      await expectLater(
        crypto.decrypt(blob, wrong, associatedData: <int>[4]),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
      final tampered = EncryptedBlob(
        nonce: blob.nonce,
        ciphertext: Uint8List.fromList(blob.ciphertext)..[0] ^= 1,
        mac: blob.mac,
      );
      await expectLater(
        crypto.decrypt(tampered, key, associatedData: <int>[4]),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
      await expectLater(
        crypto.decrypt(blob, key, associatedData: <int>[5]),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
    });
  });
}
