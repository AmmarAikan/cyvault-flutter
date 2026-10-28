# Development guide

## Add a feature

Create `lib/features/<name>/{domain,data,presentation}` only where each layer is
needed. Put pure rules in domain, I/O behind interfaces in data, and widgets in
presentation. Register dependencies in `app/providers.dart`; do not introduce a
second state manager.

## Add a route

Add one named `GoRoute` in `app/router.dart`. The global redirect guard protects
it automatically. Add a pure guard test and ensure sensitive routes enable the
platform protection channel.

## Add state/provider

Use a Riverpod Provider or the existing ChangeNotifier pattern. Decrypted data
must clear on `VaultSession` lock; avoid globals and never persist plaintext to
make a feature convenient.

## Add a migration

Follow `DATABASE_AND_MIGRATIONS.md`, regenerate Drift, and commit the generated
file with an older fixture test.

## Add translation

Add the same key/placeholders to `app_en.arb` and `app_ar.arb`, run
`flutter gen-l10n`, use `AppLocalizations.of(context)`, then test RTL and large
text. Do not put visible production copy directly in a widget.

## Add a test

Inject random, clock, HTTP, clipboard and storage abstractions. Use synthetic
values. Assert negative paths and privacy (what was *not* sent/stored/logged),
then run `./tool/verify.sh`.
