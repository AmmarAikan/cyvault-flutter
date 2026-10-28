import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/dependencies.dart';
import 'app/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await AppDependencies.create();
  runApp(
    ProviderScope(
      overrides: [dependenciesProvider.overrideWithValue(dependencies)],
      child: const CyVaultApp(),
    ),
  );
}
