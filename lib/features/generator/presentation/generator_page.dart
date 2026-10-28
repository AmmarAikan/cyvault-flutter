import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/domain/password_health.dart';
import '../domain/password_generator.dart';

final class GeneratorPage extends ConsumerStatefulWidget {
  const GeneratorPage({super.key});

  @override
  ConsumerState<GeneratorPage> createState() => _GeneratorPageState();
}

final class _GeneratorPageState extends ConsumerState<GeneratorPage> {
  final PasswordGenerator _generator = PasswordGenerator();
  double _length = 20;
  bool _upper = true;
  bool _lower = true;
  bool _digits = true;
  bool _symbols = true;
  bool _ambiguous = true;
  String _password = '';

  void _generate() {
    try {
      setState(() {
        _password = _generator.generate(
          GeneratorOptions(
            length: _length.round(),
            uppercase: _upper,
            lowercase: _lower,
            digits: _digits,
            symbols: _symbols,
            avoidAmbiguous: _ambiguous,
          ),
        );
      });
    } on ArgumentError {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).errorGeneric)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                SelectableText(
                  _password.isEmpty ? '••••••••••••••••••••' : _password,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontFamily: 'monospace'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text('${strings.length}: ${_length.round()}'),
                Slider(
                  value: _length,
                  min: 8,
                  max: 64,
                  divisions: 56,
                  label: '${_length.round()}',
                  onChanged: (value) => setState(() => _length = value),
                ),
                SwitchListTile(
                  title: Text(strings.uppercase),
                  value: _upper,
                  onChanged: (value) => setState(() => _upper = value),
                ),
                SwitchListTile(
                  title: Text(strings.lowercase),
                  value: _lower,
                  onChanged: (value) => setState(() => _lower = value),
                ),
                SwitchListTile(
                  title: Text(strings.digits),
                  value: _digits,
                  onChanged: (value) => setState(() => _digits = value),
                ),
                SwitchListTile(
                  title: Text(strings.symbols),
                  value: _symbols,
                  onChanged: (value) => setState(() => _symbols = value),
                ),
                SwitchListTile(
                  title: Text(strings.avoidAmbiguous),
                  value: _ambiguous,
                  onChanged: (value) => setState(() => _ambiguous = value),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _generate,
                        icon: const Icon(Icons.casino_outlined),
                        label: Text(strings.generate),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: strings.copy,
                      onPressed: _password.isEmpty
                          ? null
                          : () async {
                              final messenger = ScaffoldMessenger.of(context);
                              final settings = ref.read(settingsProvider);
                              await ref
                                  .read(dependenciesProvider)
                                  .clipboard
                                  .copyTemporarily(
                                    _password,
                                    Duration(
                                      seconds: settings.clipboardSeconds,
                                    ),
                                  );
                              if (!mounted) return;
                              messenger.showSnackBar(
                                SnackBar(content: Text(strings.copied)),
                              );
                            },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _password.isEmpty
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await ref
                              .read(vaultControllerProvider)
                              .add(
                                title: strings.generator,
                                password: _password,
                                riskScore:
                                    100 -
                                    PasswordHealth.scorePassword(_password),
                                tags: <String>[strings.generator],
                              );
                          if (!mounted) return;
                          messenger.showSnackBar(
                            SnackBar(content: Text(strings.save)),
                          );
                        },
                  icon: const Icon(Icons.save_outlined),
                  label: Text(strings.saveToVault),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
