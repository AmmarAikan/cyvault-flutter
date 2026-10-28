import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/security/screen_protection.dart';
import '../../../core/security/vault_session.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/presentation/dashboard_page.dart';
import '../../generator/presentation/generator_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../../vault/presentation/vault_page.dart';

final class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

final class _MainShellState extends ConsumerState<MainShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    ScreenProtection.setSensitive(true);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final pages = <Widget>[
      const DashboardPage(),
      const VaultPage(),
      const GeneratorPage(),
      const SettingsPage(),
    ];
    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: const Icon(Icons.dashboard_outlined),
        selectedIcon: const Icon(Icons.dashboard),
        label: strings.dashboard,
      ),
      NavigationDestination(
        icon: const Icon(Icons.lock_outline),
        selectedIcon: const Icon(Icons.lock),
        label: strings.vault,
      ),
      NavigationDestination(
        icon: const Icon(Icons.password_outlined),
        selectedIcon: const Icon(Icons.password),
        label: strings.generator,
      ),
      NavigationDestination(
        icon: const Icon(Icons.settings_outlined),
        selectedIcon: const Icon(Icons.settings),
        label: strings.settings,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        return Scaffold(
          appBar: AppBar(
            title: Text(destinations[_index].label),
            actions: <Widget>[
              IconButton(
                tooltip: strings.lock,
                onPressed: () =>
                    ref.read(sessionProvider).lock(LockReason.manual),
                icon: const Icon(Icons.lock_outline),
              ),
            ],
          ),
          drawer: wide ? null : _SecondaryDrawer(strings: strings),
          body: Row(
            children: <Widget>[
              if (wide)
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: (value) =>
                      setState(() => _index = value),
                  labelType: NavigationRailLabelType.all,
                  destinations: destinations
                      .map(
                        (item) => NavigationRailDestination(
                          icon: item.icon,
                          selectedIcon: item.selectedIcon,
                          label: Text(item.label),
                        ),
                      )
                      .toList(growable: false),
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _SecondaryMenu(strings: strings),
                    ),
                  ),
                ),
              Expanded(
                child: IndexedStack(index: _index, children: pages),
              ),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: (value) =>
                      setState(() => _index = value),
                  destinations: destinations,
                ),
        );
      },
    );
  }
}

final class _SecondaryDrawer extends StatelessWidget {
  const _SecondaryDrawer({required this.strings});
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) => Drawer(
    child: SafeArea(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.shield),
            title: Text(strings.appName),
            subtitle: Text(strings.tagline),
          ),
          const Divider(),
          _SecondaryMenu(strings: strings),
        ],
      ),
    ),
  );
}

final class _SecondaryMenu extends StatelessWidget {
  const _SecondaryMenu({required this.strings});
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      IconButton(
        tooltip: strings.breachCheck,
        onPressed: () => context.pushNamed('breach'),
        icon: const Icon(Icons.travel_explore),
      ),
      IconButton(
        tooltip: strings.securityModel,
        onPressed: () => context.pushNamed('security'),
        icon: const Icon(Icons.policy_outlined),
      ),
      IconButton(
        tooltip: strings.help,
        onPressed: () => context.pushNamed('help'),
        icon: const Icon(Icons.help_outline),
      ),
      IconButton(
        tooltip: strings.about,
        onPressed: () => context.pushNamed('about'),
        icon: const Icon(Icons.info_outline),
      ),
    ],
  );
}
