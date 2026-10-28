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

  void _openSecondaryDestination(String routeName) {
    final router = GoRouter.of(context);
    final target = Uri.parse(router.namedLocation(routeName));
    if (router.routeInformationProvider.value.uri.path == target.path) return;
    router.pushNamed(routeName);
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
          drawer: wide
              ? null
              : CyVaultDrawer(
                  strings: strings,
                  onDestinationSelected: _openSecondaryDestination,
                ),
          body: Row(
            children: <Widget>[
              if (wide)
                WideNavigationPane(
                  strings: strings,
                  selectedIndex: _index,
                  onPrimaryDestinationSelected: (value) =>
                      setState(() => _index = value),
                  onSecondaryDestinationSelected: _openSecondaryDestination,
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

typedef SecondaryDestinationSelected = void Function(String routeName);

final class CyVaultDrawer extends StatelessWidget {
  const CyVaultDrawer({
    required this.strings,
    required this.onDestinationSelected,
    super.key,
  });

  final AppLocalizations strings;
  final SecondaryDestinationSelected onDestinationSelected;

  void _select(BuildContext context, String routeName) {
    final callback = onDestinationSelected;
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) => callback(routeName));
  }

  @override
  Widget build(BuildContext context) => Drawer(
    child: SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.shield),
            title: Text(strings.appName),
            subtitle: Text(strings.tagline),
          ),
          const Divider(),
          for (final destination in secondaryDestinations(strings))
            ListTile(
              key: ValueKey<String>('drawer-${destination.routeName}'),
              leading: Icon(destination.icon),
              title: Text(destination.label),
              minVerticalPadding: 12,
              onTap: () => _select(context, destination.routeName),
            ),
        ],
      ),
    ),
  );
}

final class WideNavigationPane extends StatelessWidget {
  const WideNavigationPane({
    required this.strings,
    required this.selectedIndex,
    required this.onPrimaryDestinationSelected,
    required this.onSecondaryDestinationSelected,
    super.key,
  });

  final AppLocalizations strings;
  final int selectedIndex;
  final ValueChanged<int> onPrimaryDestinationSelected;
  final SecondaryDestinationSelected onSecondaryDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final primary = <({IconData icon, IconData selectedIcon, String label})>[
      (
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: strings.dashboard,
      ),
      (
        icon: Icons.lock_outline,
        selectedIcon: Icons.lock,
        label: strings.vault,
      ),
      (
        icon: Icons.password_outlined,
        selectedIcon: Icons.password,
        label: strings.generator,
      ),
      (
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        label: strings.settings,
      ),
    ];
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: 224,
          child: SingleChildScrollView(
            key: const ValueKey<String>('wide-navigation-pane'),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              children: <Widget>[
                for (var index = 0; index < primary.length; index++)
                  ListTile(
                    key: ValueKey<String>('primary-$index'),
                    leading: Icon(
                      index == selectedIndex
                          ? primary[index].selectedIcon
                          : primary[index].icon,
                    ),
                    title: Text(primary[index].label),
                    selected: index == selectedIndex,
                    shape: const StadiumBorder(),
                    onTap: () => onPrimaryDestinationSelected(index),
                  ),
                const Divider(),
                for (final destination in secondaryDestinations(strings))
                  ListTile(
                    key: ValueKey<String>('wide-${destination.routeName}'),
                    leading: Icon(destination.icon),
                    title: Text(destination.label),
                    minVerticalPadding: 12,
                    onTap: () =>
                        onSecondaryDestinationSelected(destination.routeName),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<({IconData icon, String label, String routeName})> secondaryDestinations(
  AppLocalizations strings,
) => <({IconData icon, String label, String routeName})>[
  (icon: Icons.travel_explore, label: strings.breachCheck, routeName: 'breach'),
  (
    icon: Icons.policy_outlined,
    label: strings.securityModel,
    routeName: 'security',
  ),
  (icon: Icons.help_outline, label: strings.help, routeName: 'help'),
  (icon: Icons.info_outline, label: strings.about, routeName: 'about'),
];
