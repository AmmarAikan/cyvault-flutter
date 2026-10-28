# Ubuntu server setup

The verified inventory and versions are in `VERIFIED_ENVIRONMENT.md`.

Tools installed on Ubuntu only:

- Flutter `/root/development/flutter`
- Android SDK `/root/Android/Sdk`
- OpenJDK 17 `/usr/lib/jvm/java-17-openjdk-amd64`
- Pub `/root/.pub-cache` and Gradle `/root/.gradle` caches

The idempotent path environment is `/root/.config/cyvault/env.sh` and is sourced
from `/root/.bashrc`. It contains no credential. Android Studio is not required.

Before an upgrade, read Flutter/Android release notes and preserve the lockfile.
Afterward run `flutter doctor -v`, `flutter pub outdated`, `./tool/verify.sh` and
review Android target requirements. Never update crypto/storage dependencies via
automatic merge.

Safe disk inspection: `du -sh /root/.gradle /root/.pub-cache build`. Prefer
`flutter clean` inside this exact project. Remove only confirmed generated stale
caches; never recursively target `/root`, `/root/workspaces`, the Git checkout,
Android licenses or SDKs in active use.

No `/dev/kvm` was available, so no emulator was created and no device-test claim
is made.
