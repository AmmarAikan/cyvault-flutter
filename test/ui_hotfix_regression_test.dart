import 'package:cyvault/features/dashboard/presentation/dashboard_page.dart';
import 'package:cyvault/features/shell/presentation/main_shell.dart';
import 'package:cyvault/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _widths = <double>[320, 360, 393, 412, 600, 760, 1024];
const _textScales = <double>[1, 1.3, 2];
const _locales = <Locale>[Locale('en'), Locale('ar')];

void main() {
  group('secondary navigation regression', () {
    testWidgets('phone drawer keeps every localized label visible', (
      tester,
    ) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      tester.view.devicePixelRatio = 1;

      for (final width in _widths) {
        for (final locale in _locales) {
          for (final scale in _textScales) {
            tester.view.physicalSize = Size(width, 800);
            final scaffoldKey = GlobalKey<ScaffoldState>();
            await tester.pumpWidget(
              _localizedApp(
                locale: locale,
                textScale: scale,
                home: Builder(
                  builder: (context) => Scaffold(
                    key: scaffoldKey,
                    drawer: CyVaultDrawer(
                      strings: AppLocalizations.of(context),
                      onDestinationSelected: (_) {},
                    ),
                  ),
                ),
              ),
            );
            scaffoldKey.currentState!.openDrawer();
            await tester.pumpAndSettle();

            final strings = lookupAppLocalizations(locale);
            expect(find.text(strings.breachCheck), findsOneWidget);
            expect(find.text(strings.securityModel), findsOneWidget);
            expect(find.text(strings.help), findsOneWidget);
            expect(find.text(strings.about), findsOneWidget);
            expect(tester.takeException(), isNull);

            Navigator.of(tester.element(find.byType(CyVaultDrawer))).pop();
            await tester.pumpAndSettle();
          }
        }
      }
    });

    testWidgets('drawer closes before dispatching navigation', (tester) async {
      tester.view.physicalSize = const Size(393, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      final scaffoldKey = GlobalKey<ScaffoldState>();
      String? selectedRoute;

      await tester.pumpWidget(
        _localizedApp(
          locale: const Locale('en'),
          textScale: 1,
          home: Builder(
            builder: (context) => Scaffold(
              key: scaffoldKey,
              drawer: CyVaultDrawer(
                strings: AppLocalizations.of(context),
                onDestinationSelected: (route) {
                  expect(scaffoldKey.currentState!.isDrawerOpen, isFalse);
                  selectedRoute = route;
                },
              ),
            ),
          ),
        ),
      );
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey<String>('drawer-help')));
      await tester.pumpAndSettle();

      expect(selectedRoute, 'help');
      expect(scaffoldKey.currentState!.isDrawerOpen, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('wide navigation has visible primary and secondary labels', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      for (final width in <double>[760, 1024]) {
        for (final locale in _locales) {
          for (final scale in _textScales) {
            tester.view.physicalSize = Size(width, 800);
            await tester.pumpWidget(
              _localizedApp(
                locale: locale,
                textScale: scale,
                home: Scaffold(
                  body: Builder(
                    builder: (context) => WideNavigationPane(
                      strings: AppLocalizations.of(context),
                      selectedIndex: 0,
                      onPrimaryDestinationSelected: (_) {},
                      onSecondaryDestinationSelected: (_) {},
                    ),
                  ),
                ),
              ),
            );

            final strings = lookupAppLocalizations(locale);
            expect(find.text(strings.dashboard), findsOneWidget);
            expect(find.text(strings.vault), findsOneWidget);
            expect(find.text(strings.generator), findsOneWidget);
            expect(find.text(strings.settings), findsOneWidget);
            expect(find.text(strings.breachCheck), findsOneWidget);
            expect(find.text(strings.securityModel), findsOneWidget);
            expect(find.text(strings.help), findsOneWidget);
            expect(find.text(strings.about), findsOneWidget);
            expect(tester.takeException(), isNull);
          }
        }
      }
    });
  });

  group('dashboard metric regression', () {
    testWidgets('metrics never overflow the required visual matrix', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      for (final height in <double>[360, 800]) {
        for (final width in _widths) {
          for (final locale in _locales) {
            for (final scale in _textScales) {
              tester.view.physicalSize = Size(width, height);
              await tester.pumpWidget(
                _localizedApp(
                  locale: locale,
                  textScale: scale,
                  home: Scaffold(
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: DashboardMetrics(
                        metrics: _longMetrics(locale.languageCode),
                      ),
                    ),
                  ),
                ),
              );

              for (var index = 0; index < 4; index++) {
                expect(
                  find.byKey(ValueKey<String>('dashboard-metric-$index')),
                  findsOneWidget,
                );
              }
              expect(tester.takeException(), isNull);
            }
          }
        }
      }
    });
  });
}

Widget _localizedApp({
  required Locale locale,
  required double textScale,
  required Widget home,
}) => MaterialApp(
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: home,
);

List<DashboardMetric> _longMetrics(String languageCode) {
  final labels = languageCode == 'ar'
      ? const <String>[
          'إجمالي عناصر الخزنة المشفرة المحفوظة بأمان',
          'كلمات المرور التي ظهرت في تسريبات مؤكدة سابقًا',
          'العناصر المفضلة التي تحتاج إلى مراجعة دورية',
          'متوسط مستوى المخاطر الأمني لجميع العناصر',
        ]
      : const <String>[
          'Total encrypted vault entries stored securely',
          'Passwords confirmed in previously known breaches',
          'Favorite entries that need a periodic review',
          'Average security risk across every vault entry',
        ];
  return <DashboardMetric>[
    for (var index = 0; index < labels.length; index++)
      DashboardMetric(
        icon: Icons.shield_outlined,
        label: labels[index],
        value: '${index + 1}2345678901234567890',
      ),
  ];
}
