import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/crypto/crypto_service.dart';
import '../../../core/database/app_database.dart';
import '../domain/vault_entry.dart';

enum ImportConflictPolicy { skip, replace, duplicate }

final class VaultRepository {
  VaultRepository(this.database, this.crypto, this.keyBytes);

  final AppDatabase database;
  final CryptoService crypto;
  final Uint8List? Function() keyBytes;
  final Uuid _uuid = const Uuid();

  SecretKeyData _key() {
    final bytes = keyBytes();
    if (bytes == null) throw StateError('Vault is locked.');
    return SecretKeyData(bytes);
  }

  List<int> _aad(String id, int version) =>
      utf8.encode('cyvault:record:$version:$id');

  Future<List<VaultEntry>> all() async {
    final rows =
        await (database.select(database.vaultRecords)
              ..orderBy(<OrderingTerm Function(VaultRecords)>[
                (table) => OrderingTerm.desc(table.updatedAt),
              ]))
            .get();
    final entries = <VaultEntry>[];
    for (final row in rows) {
      entries.add(await _decrypt(row));
    }
    return entries;
  }

  Future<VaultEntry?> byId(String id) async {
    final row = await (database.select(
      database.vaultRecords,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _decrypt(row);
  }

  Future<VaultEntry> save(VaultEntry entry) async {
    final normalized = entry.copyWith(
      title: entry.title.trim(),
      tags: entry.tags
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toSet()
          .toList(),
      updatedAt: DateTime.now().toUtc(),
    );
    if (normalized.title.isEmpty) throw ArgumentError('Title is required.');
    await _write(normalized);
    return normalized;
  }

  Future<VaultEntry> create({
    required String title,
    required String password,
    String username = '',
    String url = '',
    String notes = '',
    List<String> tags = const <String>[],
    bool favorite = false,
    int riskScore = 0,
  }) async {
    final now = DateTime.now().toUtc();
    final entry = VaultEntry(
      id: _uuid.v4(),
      title: title,
      username: username,
      password: password,
      url: url,
      notes: notes,
      tags: tags,
      favorite: favorite,
      riskScore: riskScore,
      createdAt: now,
      updatedAt: now,
    );
    return save(entry);
  }

  Future<void> delete(String id) => (database.delete(
    database.vaultRecords,
  )..where((table) => table.id.equals(id))).go();

  Future<int> import(
    List<VaultEntry> entries,
    ImportConflictPolicy policy,
  ) => database.transaction(() async {
    var imported = 0;
    for (final source in entries) {
      final exists = await (database.select(
        database.vaultRecords,
      )..where((table) => table.id.equals(source.id))).getSingleOrNull();
      if (exists != null && policy == ImportConflictPolicy.skip) continue;
      final entry = exists != null && policy == ImportConflictPolicy.duplicate
          ? source.copyWith(id: _uuid.v4(), updatedAt: DateTime.now().toUtc())
          : source;
      await _write(entry);
      imported++;
    }
    return imported;
  });

  Future<void> _write(VaultEntry entry) async {
    const version = 1;
    final blob = await crypto.encrypt(
      utf8.encode(entry.encodePayload()),
      _key(),
      associatedData: _aad(entry.id, version),
    );
    await database
        .into(database.vaultRecords)
        .insertOnConflictUpdate(
          VaultRecordsCompanion.insert(
            id: entry.id,
            payloadVersion: const Value(version),
            nonce: base64UrlEncode(blob.nonce),
            ciphertext: base64UrlEncode(blob.ciphertext),
            authenticationTag: base64UrlEncode(blob.mac),
            favorite: Value(entry.favorite),
            riskScore: Value(entry.riskScore.clamp(0, 100)),
            breached: Value(entry.breached),
            createdAt: entry.createdAt.toUtc(),
            updatedAt: entry.updatedAt.toUtc(),
          ),
        );
  }

  Future<VaultEntry> _decrypt(VaultRecord row) async {
    final clear = await crypto.decrypt(
      EncryptedBlob(
        nonce: base64Url.decode(row.nonce),
        ciphertext: base64Url.decode(row.ciphertext),
        mac: base64Url.decode(row.authenticationTag),
      ),
      _key(),
      associatedData: _aad(row.id, row.payloadVersion),
    );
    final map = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
    final entry = VaultEntry.fromJson(map);
    if (entry.id != row.id) {
      throw const FormatException('Record identity mismatch.');
    }
    return entry;
  }
}
