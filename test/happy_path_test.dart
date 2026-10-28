import 'package:cyvault/core/crypto/crypto_service.dart';
import 'package:cyvault/core/crypto/master_password_service.dart';
import 'package:cyvault/core/database/app_database.dart';
import 'package:cyvault/core/security/vault_session.dart';
import 'package:cyvault/features/backup/data/backup_service.dart';
import 'package:cyvault/features/vault/data/vault_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'setup, add, reveal, lock, unlock, export and import happy path',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final crypto = CryptoService();
      final session = VaultSession(
        MasterPasswordService(crypto, MemoryMetadataStore()),
        database,
        delay: (_) async {},
      );
      await session.initialize();
      expect(await session.setup('graduation demonstration phrase'), isTrue);
      final repository = VaultRepository(
        database,
        crypto,
        () => session.keyBytes,
      );
      final saved = await repository.create(
        title: 'Demo account',
        username: 'student@example.test',
        password: 'generated-demo-value',
      );
      expect(
        (await repository.byId(saved.id))?.password,
        'generated-demo-value',
      );
      final backup = await BackupService(crypto)
          .export(await repository.all(), 'portable demonstration phrase');
      await session.lock(LockReason.manual);
      expect(session.keyBytes, isNull);
      expect(await session.unlock('graduation demonstration phrase'), isTrue);
      final restored = await BackupService(crypto)
          .import(backup, 'portable demonstration phrase');
      expect(restored.single.title, 'Demo account');
      expect(
        await repository.import(restored, ImportConflictPolicy.duplicate),
        1,
      );
      expect(await repository.all(), hasLength(2));
      final raw = await database.select(database.vaultRecords).get();
      expect(
        raw.map((row) => row.ciphertext).join(),
        isNot(contains('generated-demo-value')),
      );
      session.dispose();
      await database.close();
    },
  );
}
