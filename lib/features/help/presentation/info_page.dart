import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

enum InfoKind { help, security, about }

final class InfoPage extends StatelessWidget {
  const InfoPage({required this.kind, super.key});
  final InfoKind kind;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final title = switch (kind) {
      InfoKind.help => strings.help,
      InfoKind.security => strings.securityModel,
      InfoKind.about => strings.about,
    };
    final content = switch (kind) {
      InfoKind.help =>
        '${strings.securityNotice}\n\n${strings.offlineAnalysis}',
      InfoKind.security =>
        '${strings.privacySummary}\n\n${strings.educationalWarning}',
      InfoKind.about =>
        '${strings.appName}\n${strings.tagline}\n\n${strings.educationalWarning}',
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Icon(
                Icons.shield_outlined,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(content, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => showLicensePage(
                  context: context,
                  applicationName: strings.appName,
                  applicationVersion: '1.0.0',
                ),
                icon: const Icon(Icons.description_outlined),
                label: Text(
                  MaterialLocalizations.of(context).viewLicensesButtonLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
