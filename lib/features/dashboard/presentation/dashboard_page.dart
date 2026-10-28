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
    final cards = <DashboardMetric>[
      DashboardMetric(
        icon: Icons.lock_outline,
        label: strings.items,
        value: health.total.toString(),
      ),
      DashboardMetric(
        icon: Icons.warning_amber,
        label: strings.breached,
        value: health.breached.toString(),
      ),
      DashboardMetric(
        icon: Icons.repeat,
        label: strings.favorites,
        value: vault.entries.where((entry) => entry.favorite).length.toString(),
      ),
      DashboardMetric(
        icon: Icons.monitor_heart_outlined,
        label: strings.averageRisk,
        value: health.averageRisk.toString(),
      ),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text(strings.tagline, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        DashboardMetrics(metrics: cards),
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

@immutable
final class DashboardMetric {
  const DashboardMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

final class DashboardMetrics extends StatelessWidget {
  const DashboardMetrics({required this.metrics, super.key});

  final List<DashboardMetric> metrics;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const spacing = 8.0;
      final textScale = MediaQuery.textScalerOf(context).scale(1);
      final preferredCardWidth = textScale >= 1.8
          ? 240.0
          : textScale >= 1.3
          ? 210.0
          : 190.0;
      final columns =
          ((constraints.maxWidth + spacing) / (preferredCardWidth + spacing))
              .floor()
              .clamp(1, 4);
      final cardWidth =
          (constraints.maxWidth - spacing * (columns - 1)) / columns;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: <Widget>[
          for (var index = 0; index < metrics.length; index++)
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                key: ValueKey<String>('dashboard-metric-$index'),
                metric: metrics[index],
              ),
            ),
        ],
      );
    },
  );
}

final class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric, super.key});

  final DashboardMetric metric;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '${metric.label}: ${metric.value}',
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(metric.icon),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  metric.value,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(metric.label),
          ],
        ),
      ),
    ),
  );
}
