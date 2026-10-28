import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class VaultRecords extends Table {
  TextColumn get id => text()();
  IntColumn get payloadVersion => integer().withDefault(const Constant(1))();
  TextColumn get nonce => text()();
  TextColumn get ciphertext => text()();
  TextColumn get authenticationTag => text()();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  IntColumn get riskScore => integer().withDefault(const Constant(0))();
  BoolColumn get breached => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

class BreachCacheEntries extends Table {
  TextColumn get keyedLookup => text()();
  IntColumn get count => integer()();
  DateTimeColumn get checkedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{keyedLookup};
}

class SecurityEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get details => text().nullable()();
}

@DriftDatabase(tables: <Type>[VaultRecords, BreachCacheEntries, SecurityEvents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(breachCacheEntries);
        await migrator.createTable(securityEvents);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA secure_delete = ON');
    },
  );

  Future<void> recordSecurityEvent(String kind, {String? details}) async {
    const allowed = <String>{
      'unlock_success',
      'unlock_failure',
      'manual_lock',
      'background_lock',
      'timeout_lock',
      'backup_export',
      'backup_import',
      'breach_check',
    };
    if (!allowed.contains(kind)) throw ArgumentError.value(kind, 'kind');
    await into(securityEvents).insert(
      SecurityEventsCompanion.insert(
        kind: kind,
        occurredAt: DateTime.now().toUtc(),
        details: Value(details),
      ),
    );
  }
}

QueryExecutor _openConnection() => LazyDatabase(() async {
  final directory = await getApplicationSupportDirectory();
  final file = File(p.join(directory.path, 'cyvault.sqlite'));
  return NativeDatabase.createInBackground(file);
});
