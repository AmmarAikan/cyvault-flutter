import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import 'breach_service.dart';

final class DriftBreachCache implements BreachCache {
  DriftBreachCache(this.database, this.keyBytes);

  final AppDatabase database;
  final Uint8List? Function() keyBytes;

  Future<String> _lookup(String fullHash) async {
    final key = keyBytes();
    if (key == null) throw StateError('Vault is locked.');
    final mac = await Hmac.sha256().calculateMac(
      utf8.encode(fullHash),
      secretKey: SecretKey(key),
    );
    return base64UrlEncode(mac.bytes);
  }

  @override
  Future<CachedBreachResult?> read(String fullHash) async {
    final lookup = await _lookup(fullHash);
    final row = await (database.select(
      database.breachCacheEntries,
    )..where((table) => table.keyedLookup.equals(lookup))).getSingleOrNull();
    return row == null ? null : CachedBreachResult(row.count, row.checkedAt);
  }

  @override
  Future<void> write(String fullHash, int count) async {
    final lookup = await _lookup(fullHash);
    await database
        .into(database.breachCacheEntries)
        .insertOnConflictUpdate(
          BreachCacheEntriesCompanion.insert(
            keyedLookup: lookup,
            count: count,
            checkedAt: DateTime.now().toUtc(),
          ),
        );
  }
}
