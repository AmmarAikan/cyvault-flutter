import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../vault/data/vault_repository.dart';

final class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<String?> _askPassphrase(BuildContext context) async {
    final strings = AppLocalizations.of(context);
    final first = TextEditingController();
    final second = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.backupPassphrase),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: first,
              obscureText: true,
              decoration: InputDecoration(labelText: strings.backupPassphrase),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: second,
              obscureText: true,
              decoration: InputDecoration(
                labelText: strings.confirmBackupPassphrase,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              first.text.length >= 12 && first.text == second.text
                  ? first.text
                  : null,
            ),
            child: Text(strings.continueLabel),
          ),
        ],
      ),
    );
    first.dispose();
    second.dispose();
    return result;
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final strings = AppLocalizations.of(context);
    final passphrase = await _askPassphrase(context);
    if (passphrase == null || !context.mounted) return;
    final dependencies = ref.read(dependenciesProvider);
    final content = await dependencies.backups.export(
      ref.read(vaultControllerProvider).entries,
      passphrase,
    );
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/cyvault-backup-${DateTime.now().millisecondsSinceEpoch}.cyvault',
    );
    await file.writeAsString(content, flush: true);
    await dependencies.database.recordSecurityEvent('backup_export');
    await SharePlus.instance.share(
      ShareParams(
        files: <XFile>[XFile(file.path)],
        text: strings.backupComplete,
      ),
    );
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final strings = AppLocalizations.of(context);
    final selection = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: <String>['cyvault'],
    );
    final path = selection?.path;
    if (path == null || !context.mounted) return;
    final passphrase = await _askPassphrase(context);
    if (passphrase == null || !context.mounted) return;
    final policy = await showDialog<ImportConflictPolicy>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(strings.conflictPolicy),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImportConflictPolicy.skip),
            child: Text(strings.skip),
          ),
          SimpleDialogOption(
            onPressed: () =>
                Navigator.pop(context, ImportConflictPolicy.replace),
            child: Text(strings.replace),
          ),
          SimpleDialogOption(
            onPressed: () =>
                Navigator.pop(context, ImportConflictPolicy.duplicate),
            child: Text(strings.duplicate),
          ),
        ],
      ),
    );
    if (policy == null) return;
    try {
      final dependencies = ref.read(dependenciesProvider);
      final entries = await dependencies.backups.import(
        await File(path).readAsString(),
        passphrase,
      );
      await ref.read(vaultRepositoryProvider).import(entries, policy);
      await ref.read(vaultControllerProvider).load();
      await dependencies.database.recordSecurityEvent('backup_import');
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(strings.importComplete)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(strings.invalidBackup)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        Text(strings.theme, style: Theme.of(context).textTheme.titleLarge),
        SegmentedButton<ThemeMode>(
          segments: <ButtonSegment<ThemeMode>>[
            ButtonSegment(value: ThemeMode.system, label: Text(strings.system)),
            ButtonSegment(value: ThemeMode.light, label: Text(strings.light)),
            ButtonSegment(value: ThemeMode.dark, label: Text(strings.dark)),
          ],
          selected: <ThemeMode>{settings.themeMode},
          onSelectionChanged: (values) => settings.setThemeMode(values.first),
        ),
        SwitchListTile(
          title: Text(strings.dynamicColor),
          value: settings.dynamicColor,
          onChanged: settings.setDynamicColor,
        ),
        ListTile(
          title: Text(strings.language),
          trailing: DropdownButton<String>(
            value: settings.locale?.languageCode ?? 'system',
            onChanged: (value) =>
                settings.setLocale(value == 'system' ? null : Locale(value!)),
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem(value: 'system', child: Text(strings.system)),
              DropdownMenuItem(value: 'en', child: Text(strings.english)),
              DropdownMenuItem(value: 'ar', child: Text(strings.arabic)),
            ],
          ),
        ),
        const Divider(),
        SwitchListTile(
          title: Text(strings.onlineBreachConsent),
          subtitle: Text(strings.privacySummary),
          value: settings.onlineBreach,
          onChanged: settings.setOnlineBreach,
        ),
        SwitchListTile(
          title: Text(strings.biometricSecondStep),
          value: settings.biometric,
          onChanged: settings.setBiometric,
        ),
        ListTile(
          title: Text(strings.autoLock),
          trailing: DropdownButton<int>(
            value: settings.autoLockMinutes,
            onChanged: (value) =>
                value == null ? null : settings.setAutoLockMinutes(value),
            items: <DropdownMenuItem<int>>[
              DropdownMenuItem(value: 1, child: Text(strings.oneMinute)),
              DropdownMenuItem(value: 5, child: Text(strings.fiveMinutes)),
              DropdownMenuItem(value: 15, child: Text(strings.fifteenMinutes)),
            ],
          ),
        ),
        ListTile(
          title: Text(strings.clipboardDelay),
          trailing: Text('${settings.clipboardSeconds}s'),
          subtitle: Slider(
            value: settings.clipboardSeconds.toDouble(),
            min: 10,
            max: 60,
            divisions: 5,
            onChanged: (value) => settings.setClipboardSeconds(value.round()),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.upload_file),
          title: Text(strings.exportBackup),
          onTap: () => _export(context, ref),
        ),
        ListTile(
          leading: const Icon(Icons.download),
          title: Text(strings.importBackup),
          onTap: () => _import(context, ref),
        ),
      ],
    );
  }
}
