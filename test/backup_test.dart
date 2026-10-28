import 'dart:convert';

import 'package:cyvault/core/crypto/crypto_service.dart';
import 'package:cyvault/features/backup/data/backup_service.dart';
import 'package:cyvault/features/vault/domain/vault_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final entry = VaultEntry(
    id: 'item-1',
    title: 'Example',
    username: 'user@example.test',
    password: 'not-a-real-password',
    tags: const <String>['work', 'demo'],
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );

  test('portable backup round trips without exposing payload', () async {
    final service = BackupService(CryptoService());
    final container = await service.export(<VaultEntry>[
      entry,
    ], 'independent backup phrase');
    expect(container, isNot(contains(entry.password)));
    expect(container, isNot(contains(entry.username)));
    final restored = await service.import(
      container,
      'independent backup phrase',
    );
    expect(restored.single.toJson(), entry.toJson());
  });

  test('wrong password, tamper and unsupported version fail first', () async {
    final service = BackupService(CryptoService());
    final container = await service.export(<VaultEntry>[
      entry,
    ], 'independent backup phrase');
    await expectLater(
      service.import(container, 'incorrect backup phrase'),
      throwsFormatException,
    );
    final map = jsonDecode(container) as Map<String, dynamic>;
    map['version'] = 99;
    await expectLater(
      service.import(jsonEncode(map), 'independent backup phrase'),
      throwsFormatException,
    );
    final original = jsonDecode(container) as Map<String, dynamic>;
    final payload = original['payload'] as Map<String, dynamic>;
    payload['ciphertext'] = '${payload['ciphertext']}A';
    await expectLater(
      service.import(jsonEncode(original), 'independent backup phrase'),
      throwsA(anyOf(isA<FormatException>(), isA<Exception>())),
    );
  });
}
