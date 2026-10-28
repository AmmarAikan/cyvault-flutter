import 'dart:io';
import 'dart:typed_data';

import 'package:cyvault/core/crypto/crypto_service.dart';
import 'package:cyvault/core/database/app_database.dart';
import 'package:cyvault/features/vault/data/vault_repository.dart';
import 'package:cyvault/features/vault/domain/vault_entry.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  late AppDatabase database;
  late VaultRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = VaultRepository(
      database,
      CryptoService(),
      () => Uint8List.fromList(List<int>.generate(32, (index) => index)),
    );
  });

  tearDown(() => database.close());

  test('CRUD encrypts every sensitive field at rest', () async {
    final entry = await repository.create(
      title: 'Private bank',
      username: 'owner@example.test',
      password: 'sample-only-secret',
      url: 'https://example.test',
      notes: 'private note',
      tags: const <String>['finance'],
    );
    final row = await database.select(database.vaultRecords).getSingle();
    final atRest = <String>[
      row.nonce,
      row.ciphertext,
      row.authenticationTag,
    ].join();
    expect(atRest, isNot(contains('Private bank')));
    expect(atRest, isNot(contains('owner@example.test')));
    expect(atRest, isNot(contains('sample-only-secret')));
    expect((await repository.byId(entry.id))?.toJson(), entry.toJson());
    final updated = entry.copyWith(title: 'Updated', favorite: true);
    await repository.save(updated);
    expect((await repository.byId(entry.id))?.title, 'Updated');
    await repository.delete(entry.id);
    expect(await repository.all(), isEmpty);
  });

  test(
    'import conflict policies skip, replace and duplicate transactionally',
    () async {
      final original = await repository.create(
        title: 'Original',
        password: 'one',
      );
      final incoming = original.copyWith(title: 'Incoming');
      expect(
        await repository.import(<VaultEntry>[
          incoming,
        ], ImportConflictPolicy.skip),
        0,
      );
      expect((await repository.byId(original.id))?.title, 'Original');
      expect(
        await repository.import(<VaultEntry>[
          incoming,
        ], ImportConflictPolicy.replace),
        1,
      );
      expect((await repository.byId(original.id))?.title, 'Incoming');
      expect(
        await repository.import(<VaultEntry>[
          incoming,
        ], ImportConflictPolicy.duplicate),
        1,
      );
      expect(await repository.all(), hasLength(2));
    },
  );

  test(
    'migrates a version-one fixture forward without deleting records',
    () async {
      await database.close();
      final directory = await Directory.systemTemp.createTemp(
        'cyvault-migration-',
      );
      final file = File('${directory.path}/fixture.sqlite');
      final raw = sqlite.sqlite3.open(file.path);
      raw.execute('''
      CREATE TABLE vault_records (
        id TEXT NOT NULL PRIMARY KEY,
        payload_version INTEGER NOT NULL DEFAULT 1,
        nonce TEXT NOT NULL,
        ciphertext TEXT NOT NULL,
        authentication_tag TEXT NOT NULL,
        favorite INTEGER NOT NULL DEFAULT 0,
        risk_score INTEGER NOT NULL DEFAULT 0,
        breached INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      );
      PRAGMA user_version = 1;
    ''');
      raw.close();
      final migrated = AppDatabase.forTesting(NativeDatabase(file));
      expect(await migrated.select(migrated.breachCacheEntries).get(), isEmpty);
      expect(await migrated.select(migrated.securityEvents).get(), isEmpty);
      await migrated.close();
      await directory.delete(recursive: true);
    },
  );
}
