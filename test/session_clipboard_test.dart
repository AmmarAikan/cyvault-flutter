import 'package:cyvault/core/crypto/crypto_service.dart';
import 'package:cyvault/core/crypto/master_password_service.dart';
import 'package:cyvault/core/database/app_database.dart';
import 'package:cyvault/core/security/clipboard_guard.dart';
import 'package:cyvault/core/security/vault_session.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

final class FakeClipboard implements ClipboardPort {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String value) async => this.value = value;
}

void main() {
  test('session rejects wrong password and locks after inactivity', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    var now = DateTime.utc(2026, 1, 1);
    final session = VaultSession(
      MasterPasswordService(CryptoService(), MemoryMetadataStore()),
      database,
      now: () => now,
      delay: (_) async {},
    );
    await session.initialize();
    expect(await session.setup('correct master phrase'), isTrue);
    await session.lock(LockReason.manual);
    expect(await session.unlock('incorrect phrase value'), isFalse);
    expect(await session.unlock('correct master phrase'), isTrue);
    now = now.add(const Duration(minutes: 2));
    expect(await session.lockIfInactive(const Duration(minutes: 1)), isTrue);
    expect(session.isUnlocked, isFalse);
    await database.close();
  });

  test('clipboard clears only if the copied value is still present', () async {
    final clipboard = FakeClipboard();
    final guard = ClipboardGuard(clipboard: clipboard);
    await guard.copyTemporarily(
      'temporary secret',
      const Duration(milliseconds: 2),
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(clipboard.value, '');
    await guard.copyTemporarily(
      'another secret',
      const Duration(milliseconds: 2),
    );
    clipboard.value = 'user replaced it';
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(clipboard.value, 'user replaced it');
    guard.dispose();
  });
}
