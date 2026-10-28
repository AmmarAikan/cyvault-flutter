# Google Play release guide

Policies and target requirements change. Re-check the official [Play policy
center](https://play.google.com/about/developer-content-policy/), [target API
requirements](https://support.google.com/googleplay/android-developer/answer/11926878),
and [Play Console help](https://support.google.com/googleplay/android-developer/)
immediately before every submission; this guide deliberately does not invent a
future target API or testing-duration requirement.

## Identity and versioning

The immutable application ID is `com.ammaraikan.cyvault`. Do not change it after
creating the Play app. `pubspec.yaml` uses `version: major.minor.patch+build`;
Android maps these to `versionName` and monotonically increasing `versionCode`.
Increment both intentionally for releases.

## Create the app and signing

1. Create an app in [Play Console](https://play.google.com/console/), choose the
   default language/name and declare app/game, free/paid accurately.
2. Enroll in [Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756).
   Google protects the app-signing key; you retain a separate upload key.
3. Generate an upload key offline, for example:

   ```bash
   keytool -genkeypair -v -keystore cyvault-upload.jks -alias upload \
     -keyalg RSA -keysize 4096 -validity 10000
   ```

   Use strong unique passwords, make encrypted offline backups and record key
   ownership. Never put this file or passwords in Git, chat, logs or artifacts.
4. Base64-encode the keystore without printing it and add protected GitHub
   environment secrets: `KEYSTORE_BASE64`, `KEY_ALIAS`, `KEY_PASSWORD`, and
   `STORE_PASSWORD`. Restrict environment reviewers.
5. Manually run **Signed Android release**. It creates an AAB, tester APK and
   SHA-256 checksums as short-retention artifacts. Verify the artifact digest and
   signing certificate before upload. The local unsigned/debug-key release is
   never uploadable.

## Build and verify

For a controlled local signing environment, create ignored
`android/key.properties`, then run `flutter build appbundle --release`. Inspect
with `bundletool`/Play Console, confirm package/version/certificate and test the
Play-generated APK through an internal track. Official Flutter guidance:
[Build and release Android](https://docs.flutter.dev/deployment/android).

## Store and declarations

Prepare original assets: 512px icon, feature graphic, reviewed phone/tablet
screenshots and accurate Arabic/English short/full descriptions. Do not use
placeholder screenshots. Host the reviewed privacy policy at a stable public
HTTPS URL.

Complete every Console section truthfully:

- App category/contact and store listing in both languages.
- Data safety consistent with `PRIVACY_POLICY_TEMPLATE.md` and actual package
  behavior/dependencies; re-audit before answering.
- Content rating questionnaire, target audience/children considerations, app
  access instructions, ads declaration and any applicable encryption/data/export
  declarations. Seek qualified guidance where jurisdiction requires it.
- Permissions review: justify only declared INTERNET/biometric use; no broad
  storage permission is intended.

## Testing and rollout

1. Upload to internal testing, invite controlled testers and test install/update,
   backup picker, biometrics, RTL, accessibility and offline/online transitions.
2. Follow the *current* closed/open testing requirements shown for this specific
   developer account; requirements can differ by account type/date/country.
3. Review the pre-launch report, automated device results, security warnings and
   dependency notices. Resolve crashes/ANRs and policy issues rather than waive
   them without evidence.
4. Promote through staged production rollout. Monitor Play vitals, crash/ANR
   rate, reviews and breach API failures. Pause rollout on regression.
5. Google Play cannot downgrade users. For rollback, stop rollout and ship a
   corrected build with a higher version code; database migrations must remain
   forward-safe and backup-compatible.

## Pre-release checklist

- [ ] Re-check current target API, policy and account testing requirements.
- [ ] CI green; real-device Android matrix completed; no debug signing.
- [ ] Version/build incremented; changelog and translations reviewed.
- [ ] AAB package/certificate/checksum verified; upload key backed up.
- [ ] Secret/dependency scans triaged; crypto/storage updates manually reviewed.
- [ ] Privacy policy hosted; Data safety and all declarations match behavior.
- [ ] Store assets/descriptions are original, final and bilingual.
- [ ] Internal/pre-launch results reviewed; staged rollout/monitoring owner named.
