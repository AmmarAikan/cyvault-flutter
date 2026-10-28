import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../data/cloud_identity.dart';

final class CloudAccountCard extends ConsumerWidget {
  const CloudAccountCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final identity = ref.watch(cloudIdentityProvider);
    final account = identity.account;
    final busy = identity.status == CloudIdentityStatus.signingIn;
    final unavailable = identity.status == CloudIdentityStatus.unavailable;

    final String subtitle;
    if (unavailable) {
      subtitle = strings.googleAccountUnavailable;
    } else if (account != null) {
      subtitle = account.email.isEmpty
          ? strings.googleAccountConnected
          : account.email;
    } else {
      subtitle = strings.googleAccountPurpose;
    }

    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.cloud_outlined),
              title: Text(strings.googleAccount),
              subtitle: Text(subtitle),
            ),
            if (identity.lastOperationFailed)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  strings.googleSignInFailed,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            if (account == null)
              OutlinedButton.icon(
                key: const ValueKey<String>('google-sign-in'),
                onPressed: busy || unavailable
                    ? null
                    : () async {
                        final success = await identity.signInWithGoogle();
                        if (!success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(strings.googleSignInFailed)),
                          );
                        }
                      },
                icon: busy
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.login),
                label: Text(strings.signInWithGoogle),
              )
            else
              OutlinedButton.icon(
                key: const ValueKey<String>('google-sign-out'),
                onPressed: () => identity.signOut(),
                icon: const Icon(Icons.logout),
                label: Text(strings.signOutGoogle),
              ),
            const SizedBox(height: 8),
            Text(
              strings.googleAccountSecurityNotice,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
