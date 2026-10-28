import 'package:cyvault/features/dashboard/domain/password_health.dart';
import 'package:cyvault/features/generator/domain/password_generator.dart';
import 'package:cyvault/features/vault/domain/vault_entry.dart';
import 'package:flutter_test/flutter_test.dart';

final class SequenceRandom implements RandomIndex {
  int value = 0;
  @override
  int nextInt(int max) => value++ % max;
}

void main() {
  test('generator enforces length, classes and impossible options', () {
    final generator = PasswordGenerator(random: SequenceRandom());
    final password = generator.generate(const GeneratorOptions(length: 24));
    expect(password, hasLength(24));
    expect(password, matches('[A-Z]'));
    expect(password, matches('[a-z]'));
    expect(password, matches('[0-9]'));
    expect(password, matches(r'[^A-Za-z0-9]'));
    expect(
      () => generator.generate(
        const GeneratorOptions(
          uppercase: false,
          lowercase: false,
          digits: false,
          symbols: false,
        ),
      ),
      throwsArgumentError,
    );
  });

  test('health detects reused, stale and breached entries in memory', () {
    VaultEntry item(String id, {int? breach, required DateTime updated}) =>
        VaultEntry(
          id: id,
          title: id,
          password: 'same secret',
          riskScore: 60,
          breachCount: breach,
          createdAt: updated,
          updatedAt: updated,
        );
    final health = PasswordHealth.analyze(<VaultEntry>[
      item('a', breach: 4, updated: DateTime.utc(2020)),
      item('b', updated: DateTime.utc(2026)),
    ], now: DateTime.utc(2026, 10, 28));
    expect(health.reused, 2);
    expect(health.breached, 1);
    expect(health.stale, 1);
    expect(health.averageRisk, 60);
  });
}
