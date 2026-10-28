import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/security/security_lifecycle.dart';
import '../l10n/app_localizations.dart';
import 'providers.dart';
import 'router.dart';

final class CyVaultApp extends ConsumerWidget {
  const CyVaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final session = ref.watch(sessionProvider);
    final router = ref.watch(routerProvider);
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final ColorScheme light = settings.dynamicColor && lightDynamic != null
            ? lightDynamic
            : ColorScheme.fromSeed(seedColor: settings.seedColor);
        final ColorScheme dark = settings.dynamicColor && darkDynamic != null
            ? darkDynamic
            : ColorScheme.fromSeed(
                seedColor: settings.seedColor,
                brightness: Brightness.dark,
              );
        return SecurityLifecycle(
          session: session,
          settings: settings,
          child: MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context).appName,
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            locale: settings.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            themeMode: settings.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: light,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              cardTheme: const CardThemeData(margin: EdgeInsets.all(8)),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: dark,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              cardTheme: const CardThemeData(margin: EdgeInsets.all(8)),
            ),
          ),
        );
      },
    );
  }
}
