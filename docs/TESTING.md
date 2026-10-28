# Testing

Verified on Ubuntu on 2026-10-28:

- `dart format --output=none --set-exit-if-changed .`: pass.
- `flutter analyze --fatal-infos`: pass, zero issues.
- `flutter test --coverage`: 23 tests pass.
- Security/domain line coverage: 91.00% (364/400), gate 80%.
- `flutter build apk --debug`: pass.

The focused gate includes crypto, master-password/session, backup, breach range
parsing, generator/health and encrypted repository code. Generated localization,
Drift output, platform bridges and large presentation widgets are excluded from
the percentage but still compile/analyze and have targeted widget tests.

Automated cases cover crypto round trips, wrong key, tamper, nonce uniqueness,
AAD mismatch, correct/wrong/change master password, backup round trip/wrong
passphrase/tamper/version, conflict policies, generator validation, risk/reuse,
HIBP privacy/padding/noise/cache/timeout/offline, encrypted CRUD, v1 migration,
inactivity lock, clipboard conditional clear, route guard, Arabic RTL and 200%
text, plus the setup→add→decrypt→lock→unlock→export→import happy path. UI
regressions cover the phone drawer and Dashboard metrics at widths 320, 360,
393, 412, 600, 760 and 1024 in English and Arabic at 100%, 130% and 200% text
scales. Dashboard coverage runs in portrait and short landscape viewports with
long localized labels and large metric values, and explicitly fails on any
Flutter layout exception.

Manual release matrix still requires Android and iOS physical devices: biometric
success/cancel/lockout, lifecycle transitions, screenshot behavior, file/share
providers, clipboard UI, screen sizes, accessibility services and corrupted
on-device storage. iOS build/signing requires macOS/Xcode.
