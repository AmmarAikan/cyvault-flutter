import '../../vault/domain/vault_entry.dart';

final class PasswordHealth {
  const PasswordHealth({
    required this.total,
    required this.breached,
    required this.reused,
    required this.stale,
    required this.averageRisk,
  });

  final int total;
  final int breached;
  final int reused;
  final int stale;
  final int averageRisk;

  static PasswordHealth analyze(List<VaultEntry> entries, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final counts = <String, int>{};
    for (final entry in entries) {
      counts.update(entry.password, (value) => value + 1, ifAbsent: () => 1);
    }
    final reused = entries.where((entry) => counts[entry.password]! > 1).length;
    final stale = entries
        .where((entry) => current.difference(entry.updatedAt).inDays >= 365)
        .length;
    final average = entries.isEmpty
        ? 0
        : entries.fold<int>(0, (sum, item) => sum + item.riskScore) ~/
              entries.length;
    return PasswordHealth(
      total: entries.length,
      breached: entries.where((entry) => entry.breached).length,
      reused: reused,
      stale: stale,
      averageRisk: average,
    );
  }

  static int scorePassword(String password) {
    var score = 0;
    if (password.length >= 12) score += 25;
    if (password.length >= 18) score += 20;
    if (RegExp('[a-z]').hasMatch(password)) score += 15;
    if (RegExp('[A-Z]').hasMatch(password)) score += 15;
    if (RegExp('[0-9]').hasMatch(password)) score += 10;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score += 15;
    final weak = RegExp(
      r'(password|qwerty|12345|letmein)',
      caseSensitive: false,
    );
    if (weak.hasMatch(password)) score -= 50;
    return score.clamp(0, 100);
  }
}
