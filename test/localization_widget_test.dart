import 'package:cyvault/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Arabic uses RTL and survives enlarged text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: Text(
              AppLocalizations.of(context).securityNotice,
              key: const Key('localized-text'),
            ),
          ),
        ),
      ),
    );
    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('localized-text'))),
      ),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });
}
