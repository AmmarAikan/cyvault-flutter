# Read-only reference audit

The Windows references were inspected over the configured SSH connection in
UTF-8. Only small source, configuration and documentation files were read;
build output, caches, archives, binaries and assets were excluded. No reference
file was changed or copied into CyVault.

## Earlier CyVault attempts

The attempts establish useful product intent, but are not safe foundations:

- Unlock derives and stores a key for every supplied password and returns
  success without authenticating an existing key envelope. A wrong password is
  therefore accepted until record decryption happens later.
- Several snapshots are incomplete, while the most complete snapshot contains
  Dart code outside its class and a malformed model declaration.
- Vault titles and usernames are stored in plaintext. Tags are serialized with
  Dart `List.toString()` and parsed heuristically instead of using JSON.
- All significant packages use `any`; Provider and GetX are mixed; one weak
  generator test is the only meaningful automated test observed.
- The offline breach method returns `null`; another design treats a five-digit
  prefix count as if it identified a password. The cache stores a full SHA-1 in
  plaintext and has no enforced TTL.
- Export encrypts database rows with the current session key. It has no
  dedicated backup passphrase, portable versioned KDF envelope, whole-container
  validation, transactional conflict policy, or corruption/version tests.
- The schema and UI include placeholders, inconsistent nullability and no
  reliable forward-migration test suite.

CyVault replaces these patterns with an authenticated wrapped random DEK,
versioned AES-GCM envelopes, encrypted record payloads, Drift migrations, a
dedicated portable backup KDF, one Riverpod state model, one go_router routing
model, privacy-correct breach checks and security-focused tests.

## Previous student project

The student project demonstrates Material 3 theming, Provider-backed theme
persistence with SharedPreferences, Sqflite CRUD, HTTP calls, a custom drawer,
splash/animation packages and several Arabic-oriented screens. Those are useful
learning milestones.

CyVault advances the engineering baseline with coherent feature-first
architecture, authenticated encryption and key separation, explicit migrations,
generated English/Arabic localization with RTL tests, adaptive and accessible
navigation, lifecycle locking, dependency injection, CI/release engineering,
threat modeling, privacy boundaries and a larger automated test matrix. Its
branding, assets, UI and code are original; none of the student's code or media
is reused.
