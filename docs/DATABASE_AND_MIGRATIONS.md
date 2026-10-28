# Database and migrations

Drift schema version 2 contains:

- `vault_records`: ID, encrypted payload envelope, non-sensitive operational
  metadata and timestamps. No sensitive searchable columns.
- `breach_cache_entries`: HMAC-keyed lookup, count and timestamp.
- `security_events`: fixed event kind, time and optional redacted detail.

SQLite enables foreign keys and `secure_delete`. OS Android cloud backup is
disabled because database and secure metadata must be restored together; use the
portable encrypted export instead.

## Adding a migration

1. Change the table definition and increment `schemaVersion` exactly once.
2. Add an ordered `if (from < N)` block to `onUpgrade`; use a transaction for
   multi-step transforms and never discard an old column before validation.
3. Run `dart run build_runner build` and review the generated diff.
4. Add a raw older-schema fixture test, open it through `AppDatabase`, verify
   preserved rows/constraints and test failure recovery.
5. Update this file, the encrypted payload version if its JSON changes, backup
   compatibility and release notes.

Lists/maps use real JSON inside authenticated ciphertext. Never migrate by
calling `toString()`, never reset the database on error, and never mutate a
record whose ciphertext fails authentication.
