# Verified environment

Audit recorded on 2026-10-28 before project or toolchain changes.

## Server baseline

- OS: Ubuntu 24.04.4 LTS, kernel 6.8.0-147-generic, x86_64.
- CPU: 6 virtual AMD EPYC cores under KVM.
- Memory: 11 GiB RAM and 4 GiB swap.
- Initial free disk: approximately 49 GiB on the 193 GiB root filesystem.
- Initial tools: Git 2.43.0, GitHub CLI 2.45.0 and curl 8.5.0. Flutter,
  Dart, Java, Android SDK, unzip and zip were initially absent.
- GitHub CLI active account: `AmmarAikan`. Authentication output and tokens are
  intentionally not recorded.
- Windows SSH probe: `DESKTOP-EV5C2RJ` as the configured local user through the
  pinned `actit-windows` host alias. No credential material was read.
- `/dev/kvm` is unavailable, so no local Android emulator evidence is claimed.

## Installed and verified toolchain

- Flutter 3.47.8 stable, framework revision `737ba8f885`.
- Dart 3.13.7 and DevTools 2.60.0 bundled with Flutter.
- OpenJDK 17.0.20.1.
- Android command-line tools 23.0 (`android` CLI 1.1.16717390).
- Android SDK platform 36, build-tools 36.0.0 and platform-tools/ADB 37.0.1.
- All Android SDK licenses accepted; `flutter doctor -v` passes the Android
  toolchain. Chrome and Linux desktop warnings are out of project scope.

## Locations

- Flutter: `/root/development/flutter`
- Android SDK: `/root/Android/Sdk`
- Pub cache: `/root/.pub-cache`
- Gradle cache: `/root/.gradle`
- Environment file: `/root/.config/cyvault/env.sh`
- Project: `/root/workspaces/cyvault-flutter`

The environment file contains paths only. Source it with:

```bash
source /root/.config/cyvault/env.sh
```

Update SDKs deliberately after reviewing Flutter release notes, then rerun
`flutter doctor -v`, tests, analysis and both Android builds. Cache cleanup must
target only generated caches (`flutter clean`, specific stale Gradle caches) and
must never remove the source checkout.
