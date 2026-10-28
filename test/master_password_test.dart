import 'package:cyvault/core/crypto/crypto_service.dart';
import 'package:cyvault/core/crypto/master_password_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('setup persists only envelope and wrong password is rejected', () async {
    final store = MemoryMetadataStore();
    final service = MasterPasswordService(CryptoService(), store);
    final original = await service.setup('correct horse battery staple');
    expect(original, hasLength(32));
    expect(store.values.keys, <String>[MasterPasswordService.envelopeKey]);
    expect(store.values.values.single, isNot(contains('correct horse')));
    expect(await service.unlock('wrong password value'), isNull);
    expect(await service.unlock('correct horse battery staple'), original);
  });

  test('password change rewraps the same DEK', () async {
    final service = MasterPasswordService(
      CryptoService(),
      MemoryMetadataStore(),
    );
    final original = await service.setup('first master phrase 123');
    expect(
      await service.changePassword(
        'first master phrase 123',
        'second master phrase 456',
      ),
      isTrue,
    );
    expect(await service.unlock('first master phrase 123'), isNull);
    expect(await service.unlock('second master phrase 456'), original);
  });
}
