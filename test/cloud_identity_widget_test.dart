import 'package:cyvault/app/providers.dart';
import 'package:cyvault/features/cloud_identity/data/cloud_identity.dart';
import 'package:cyvault/features/cloud_identity/presentation/cloud_account_card.dart';
import 'package:cyvault/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Google identity is presented as separate from the master password', (
    tester,
  ) async {
    final identity = _FakeCloudIdentity();
    addTearDown(identity.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          cloudIdentityProvider.overrideWithValue(identity),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: CloudAccountCard()),
        ),
      ),
    );

    expect(find.byKey(const ValueKey<String>('google-sign-in')), findsOneWidget);
    expect(find.textContaining('never replaces the master password'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('google-sign-in')));
    await tester.pump();

    expect(find.text('owner@example.test'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('google-sign-out')), findsOneWidget);
  });
}

final class _FakeCloudIdentity extends CloudIdentity {
  CloudIdentityStatus _status = CloudIdentityStatus.signedOut;
  CloudAccount? _account;

  @override
  CloudAccount? get account => _account;

  @override
  bool get lastOperationFailed => false;

  @override
  CloudIdentityStatus get status => _status;

  @override
  Future<bool> signInWithGoogle() async {
    _account = const CloudAccount(
      uid: 'test-user',
      email: 'owner@example.test',
    );
    _status = CloudIdentityStatus.signedIn;
    notifyListeners();
    return true;
  }

  @override
  Future<void> signOut() async {
    _account = null;
    _status = CloudIdentityStatus.signedOut;
    notifyListeners();
  }
}
