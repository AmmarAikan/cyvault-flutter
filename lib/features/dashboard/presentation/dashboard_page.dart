import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../app/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../reports/report_service.dart';
import '../domain/password_health.dart';

final class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final vault = ref.watch(vaultControllerProvider);
    final health = PasswordHealth.analyze(vault.entries);
    final cards = <(IconData, String, int)>[
      (Icons.lock_outline, strings.items, health.total),
      (Icons.warning_amber, strings.breached, health.breached),
      (
        Icons.repeat,
        strings.favorites,
        vault.entries.where((entry) => entry.favorite).length,
      ),
      (Icons.monitor_heart_outlined, strings.averageRisk, health.averageRisk),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text(strings.tagline, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 260,
            childAspectRatio: 1.7,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(card.$1),
                    const Spacer(),
                    Text(
                      '${card.$3}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(card.$2),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: () async {
            final data = await ReportService().build(health);
            await Printing.sharePdf(
              bytes: data,
              filename: 'cyvault-security-summary.pdf',
            );
          },
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: Text(strings.generateReport),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.school_outlined),
            title: Text(strings.educationalWarning),
            subtitle: Text(strings.privacySummary),
          ),
        ),
      ],
    );
  }
}
