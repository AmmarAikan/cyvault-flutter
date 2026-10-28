import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/domain/password_health.dart';
import '../domain/vault_entry.dart';
import 'vault_controller.dart';

final class VaultPage extends ConsumerWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final controller = ref.watch(vaultControllerProvider);
    if (controller.loading && controller.entries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.error != null && controller.entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(strings.errorGeneric),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: controller.load,
              child: Text(strings.retry),
            ),
          ],
        ),
      );
    }
    return Stack(
      children: <Widget>[
        CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              sliver: SliverToBoxAdapter(
                child: SearchBar(
                  hintText: strings.search,
                  leading: const Icon(Icons.search),
                  onChanged: controller.search,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: <Widget>[
                    FilterChip(
                      label: Text(strings.favorites),
                      selected: controller.favoritesOnly,
                      onSelected: controller.setFavorites,
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<VaultSort>(
                      value: controller.sort,
                      onChanged: (value) =>
                          value == null ? null : controller.setSort(value),
                      items: <DropdownMenuItem<VaultSort>>[
                        DropdownMenuItem(
                          value: VaultSort.newest,
                          child: Text(strings.sortNewest),
                        ),
                        DropdownMenuItem(
                          value: VaultSort.title,
                          child: Text(strings.sortTitle),
                        ),
                        DropdownMenuItem(
                          value: VaultSort.risk,
                          child: Text(strings.sortRisk),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String?>(
                      value: controller.selectedTag,
                      hint: Text(strings.tags),
                      onChanged: controller.setTag,
                      items: <DropdownMenuItem<String?>>[
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(strings.all),
                        ),
                        ...controller.tags.map(
                          (tag) => DropdownMenuItem<String?>(
                            value: tag,
                            child: Text(tag),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (controller.visibleEntries.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.lock_outline, size: 64),
                      const SizedBox(height: 12),
                      Text(
                        strings.emptyVault,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(strings.emptyVaultHint),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 96),
                sliver: SliverList.builder(
                  itemCount: controller.visibleEntries.length,
                  itemBuilder: (context, index) {
                    final entry = controller.visibleEntries[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            entry.breached ? Icons.warning_amber : Icons.key,
                          ),
                        ),
                        title: Text(
                          entry.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          entry.username.isEmpty
                              ? entry.tags.join(' • ')
                              : entry.username,
                          maxLines: 1,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (entry.favorite)
                              const Icon(Icons.star, size: 20),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () => showDialog<void>(
                          context: context,
                          builder: (_) => _VaultDetailDialog(entry: entry),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        PositionedDirectional(
          end: 20,
          bottom: 20,
          child: FloatingActionButton.extended(
            heroTag: 'add-vault-item',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const _VaultFormDialog(),
            ),
            icon: const Icon(Icons.add),
            label: Text(strings.addItem),
          ),
        ),
      ],
    );
  }
}

final class _VaultFormDialog extends ConsumerStatefulWidget {
  const _VaultFormDialog({this.entry});
  final VaultEntry? entry;

  @override
  ConsumerState<_VaultFormDialog> createState() => _VaultFormDialogState();
}

final class _VaultFormDialogState extends ConsumerState<_VaultFormDialog> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _username;
  late final TextEditingController _password;
  late final TextEditingController _url;
  late final TextEditingController _notes;
  late final TextEditingController _tags;
  late bool _favorite;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _title = TextEditingController(text: entry?.title);
    _username = TextEditingController(text: entry?.username);
    _password = TextEditingController(text: entry?.password);
    _url = TextEditingController(text: entry?.url);
    _notes = TextEditingController(text: entry?.notes);
    _tags = TextEditingController(text: entry?.tags.join(', '));
    _favorite = entry?.favorite ?? false;
  }

  @override
  void dispose() {
    for (final controller in <TextEditingController>[
      _title,
      _username,
      _password,
      _url,
      _notes,
      _tags,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final tags = _tags.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    final controller = ref.read(vaultControllerProvider);
    if (widget.entry == null) {
      await controller.add(
        title: _title.text,
        username: _username.text,
        password: _password.text,
        url: _url.text,
        notes: _notes.text,
        tags: tags,
        favorite: _favorite,
        riskScore: 100 - PasswordHealth.scorePassword(_password.text),
      );
    } else {
      await controller.save(
        widget.entry!.copyWith(
          title: _title.text,
          username: _username.text,
          password: _password.text,
          url: _url.text,
          notes: _notes.text,
          tags: tags,
          favorite: _favorite,
          riskScore: 100 - PasswordHealth.scorePassword(_password.text),
          clearBreachCount: widget.entry!.password != _password.text,
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.entry == null ? strings.addItem : strings.editItem),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _title,
                  decoration: InputDecoration(labelText: strings.title),
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) ? strings.title : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _username,
                  decoration: InputDecoration(labelText: strings.username),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(labelText: strings.password),
                  obscureText: true,
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? strings.password : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _url,
                  decoration: InputDecoration(labelText: strings.url),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notes,
                  decoration: InputDecoration(labelText: strings.notes),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tags,
                  decoration: InputDecoration(labelText: strings.tags),
                ),
                SwitchListTile(
                  value: _favorite,
                  onChanged: (value) => setState(() => _favorite = value),
                  title: Text(strings.favorite),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: Text(strings.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(strings.save),
        ),
      ],
    );
  }
}

final class _VaultDetailDialog extends ConsumerStatefulWidget {
  const _VaultDetailDialog({required this.entry});
  final VaultEntry entry;

  @override
  ConsumerState<_VaultDetailDialog> createState() => _VaultDetailDialogState();
}

final class _VaultDetailDialogState extends ConsumerState<_VaultDetailDialog> {
  bool _revealed = false;
  bool _checking = false;

  Future<void> _copy() async {
    final settings = ref.read(settingsProvider);
    await ref
        .read(dependenciesProvider)
        .clipboard
        .copyTemporarily(
          widget.entry.password,
          Duration(seconds: settings.clipboardSeconds),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).copied)),
      );
    }
  }

  Future<void> _check() async {
    final settings = ref.read(settingsProvider);
    final strings = AppLocalizations.of(context);
    if (!settings.onlineBreach) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(strings.onlineConsentRequired)));
      return;
    }
    setState(() => _checking = true);
    try {
      final result = await ref
          .read(breachServiceProvider)
          .check(widget.entry.password, online: true);
      await ref
          .read(vaultControllerProvider)
          .save(
            widget.entry.copyWith(
              breachCount: result.count,
              riskScore: result.count > 0 ? 100 : widget.entry.riskScore,
            ),
          );
      await ref
          .read(dependenciesProvider)
          .database
          .recordSecurityEvent('breach_check');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.count > 0
                  ? strings.foundInBreach(result.count)
                  : strings.notFoundInBreach,
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(strings.errorGeneric)));
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.entry.title),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.entry.username.isNotEmpty)
              SelectableText(widget.entry.username),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _revealed ? widget.entry.password : '••••••••••••',
                    semanticsLabel: _revealed ? null : strings.password,
                  ),
                ),
                IconButton(
                  tooltip: _revealed ? strings.hide : strings.reveal,
                  onPressed: () => setState(() => _revealed = !_revealed),
                  icon: Icon(
                    _revealed ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                IconButton(
                  tooltip: strings.copy,
                  onPressed: _copy,
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
            if (widget.entry.url.isNotEmpty) Text(widget.entry.url),
            if (widget.entry.notes.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Text(widget.entry.notes),
            ],
            if (widget.entry.tags.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                children: widget.entry.tags
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        TextButton.icon(
          onPressed: _checking ? null : _check,
          icon: const Icon(Icons.travel_explore),
          label: Text(strings.checkNow),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await showDialog<void>(
              context: context,
              builder: (_) => _VaultFormDialog(entry: widget.entry),
            );
          },
          child: Text(strings.editItem),
        ),
        TextButton(
          onPressed: () async {
            await ref.read(vaultControllerProvider).delete(widget.entry.id);
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(strings.delete),
        ),
      ],
    );
  }
}
