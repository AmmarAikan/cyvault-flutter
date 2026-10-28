# Troubleshooting

- **Flutter not found:** source `/root/.config/cyvault/env.sh`; verify
  `/root/development/flutter/bin/flutter`.
- **Android licenses/SDK:** run `flutter doctor -v`; use the current
  `android --sdk="$ANDROID_HOME" sdk install ...` CLI. The legacy `sdkmanager`
  warning may come from Gradle tooling.
- **Gradle first build is slow:** it downloads platform/plugin/native SQLite
  artifacts into `/root/.gradle` and `/root/Android/Sdk`; do not copy them to
  Windows or commit them.
- **Generated code differs:** run `dart run build_runner build` and
  `flutter gen-l10n`, review and commit the intended generated diff.
- **Biometric unavailable:** configure a device credential/biometric; CyVault
  safely refuses the second step and never substitutes it for the master key.
- **Database authentication error:** do not reset/overwrite. Preserve the file,
  test a known-good encrypted backup and investigate as potential tamper/damage.
- **Arabic overflow:** reproduce with RTL and 200% text; use flexible/directional
  layout rather than shrinking or hard-coding LTR.
- **Signing failure:** confirm `android/key.properties` paths and GitHub secret
  names; never print or commit the key/passwords.
- **iOS:** run `flutter pub get`, CocoaPods and Xcode signing on macOS. Ubuntu
  cannot build or validate an IPA.
