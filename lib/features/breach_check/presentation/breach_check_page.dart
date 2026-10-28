import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/security/screen_protection.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/domain/password_health.dart';

final class BreachCheckPage extends ConsumerStatefulWidget {
  const BreachCheckPage({super.key});

  @override
  ConsumerState<BreachCheckPage> createState() => _BreachCheckPageState();
}

final class _BreachCheckPageState extends ConsumerState<BreachCheckPage> {
  final _password = TextEditingController();
  bool _busy = false;
  String? _result;

  @override
  void initState() {
    super.initState();
    ScreenProtection.setSensitive(true);
  }

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    final strings = AppLocalizations.of(context);
    final online = ref.read(settingsProvider).onlineBreach;
    setState(() => _busy = true);
    try {
      final strength = PasswordHealth.scorePassword(_password.text);
      if (!online) {
        setState(() => _result = '${strings.offlineAnalysis}\n$strength/100');
        return;
      }
      final result = await ref
          .read(breachServiceProvider)
          .check(_password.text, online: true);
      await ref
          .read(dependenciesProvider)
          .database
          .recordSecurityEvent('breach_check');
      setState(
        () => _result = result.count > 0
            ? strings.foundInBreach(result.count)
            : strings.notFoundInBreach,
      );
    } catch (_) {
      setState(() => _result = strings.errorGeneric);
    } finally {
      _password.clear();
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.breachCheck)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(strings.privacySummary),
                const SizedBox(height: 16),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(labelText: strings.password),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _busy || _password.text.isEmpty ? _check : _check,
                  icon: const Icon(Icons.travel_explore),
                  label: Text(strings.checkNow),
                ),
                if (_result != null) ...<Widget>[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(_result!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
