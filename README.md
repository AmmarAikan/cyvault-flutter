# CyVault

CyVault is an offline-first, bilingual Flutter password vault and security
learning application. It is designed as a production-minded graduation project:
security decisions are explicit, sensitive fields are encrypted together, tests
exercise failure paths, and release steps do not pretend that a cloud service or
professional audit exists.

> CyVault is educational software and has not received an independent security
> audit. Do not rely on it as the only copy of critical credentials.

## Verified features

- Random 256-bit vault DEK wrapped by AES-256-GCM with a master-password KEK.
- PBKDF2-HMAC-SHA256 with a versioned 600,000-iteration envelope; a wrong
  password fails authenticated decryption before a session is opened.
- AES-256-GCM encrypted record payloads with fresh nonces and record identity as
  associated data. Titles, usernames, passwords, URLs, notes and tags are not
  plaintext database columns.
- Vault add/read/edit/delete, decrypted in-memory search, tags, favorites and
  sorting; password strength, reuse, stale and breach-risk analysis.
- Secure random password generation and timed clipboard clearing.
- Optional Pwned Passwords range lookup: only a five-character SHA-1 prefix is
  sent, padded responses are parsed locally, and the encrypted-session cache uses
  a keyed lookup rather than storing full SHA-1 hashes.
- Portable authenticated backup with its own passphrase/KDF and explicit
  skip/replace/duplicate conflict handling.
- Aggregate PDF security summary containing no titles, usernames, passwords,
  notes, hashes or keys.
- English and Arabic generated localization, RTL, Material 3, adaptive
  NavigationBar/NavigationRail, light/dark/system and compatible dynamic color.
- Background/inactivity/manual locking, optional post-password biometric
  confirmation, Android `FLAG_SECURE`, and iOS app-switcher/capture privacy
  overlay with documented platform limits.
- Drift schema v2 with a tested v1 migration, redacted event history, CI,
  Dependabot and manual signed AAB workflow.

Screenshots are intentionally not committed yet. Store-listing screenshots must
be captured from a real reviewed build and are tracked as a release task, not
represented by mockups.

## Quick start

```bash
source /root/.config/cyvault/env.sh
flutter pub get --enforce-lockfile
flutter gen-l10n
dart run build_runner build
flutter run
```

Quality gate:

```bash
./tool/verify.sh
```

The verified server build uses Flutter 3.47.8, Dart 3.13.7, JDK 17 and Android
SDK 36. The Android application ID is immutable: `com.ammaraikan.cyvault`.
iOS source is configured, but an IPA requires macOS, Xcode and Apple signing.

## Structure

```text
lib/app              bootstrap, providers, router and theme
lib/core             crypto, Drift, security lifecycle and settings
lib/features         feature-first domain/data/presentation code
lib/l10n             English/Arabic ARB and generated localizations
test                 security, persistence, privacy and widget tests
docs                 architecture, tutorials, security and release guides
.github/workflows    PR CI and manual signed Android release
```

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Security model](docs/SECURITY_MODEL.md) and [threat model](docs/THREAT_MODEL.md)
- [Testing evidence](docs/TESTING.md)
- [English user guide](docs/USER_GUIDE_EN.md) / [Arabic guide](docs/USER_GUIDE_AR.md)
- [Arabic demo guide](docs/DEMO_GUIDE_AR.md)
- [Development tutorial](docs/DEVELOPMENT_GUIDE.md)
- [Ubuntu setup](docs/UBUNTU_SERVER_SETUP.md) and [Windows source workflow](docs/WINDOWS_SOURCE_WORKFLOW.md)
- [Google Play guide](docs/GOOGLE_PLAY_RELEASE.md) and [roadmap](docs/ROADMAP.md)
- [Reference audit](docs/REFERENCE_AUDIT.md)

## License decision

This private educational repository is **all rights reserved**. No permission to
redistribute or create derivative works is granted by default. Package and
Flutter licenses remain available through the in-app Licenses screen. See
[LICENSE](LICENSE) and [SECURITY.md](SECURITY.md).
