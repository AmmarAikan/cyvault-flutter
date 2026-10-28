import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/dependencies.dart';
import 'app/providers.dart';
import 'features/cloud_identity/data/cloud_identity.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late final CloudIdentity cloudIdentity;
  try {
    await Firebase.initializeApp();
    final firebaseIdentity = FirebaseCloudIdentity();
    await firebaseIdentity.initialize();
    cloudIdentity = firebaseIdentity;
  } catch (_) {
    // A cloud configuration or connectivity problem must never prevent access
    // to the local encrypted vault.
    cloudIdentity = UnavailableCloudIdentity();
  }
  final dependencies = await AppDependencies.create(cloudIdentity);
  runApp(
    ProviderScope(
      overrides: [dependenciesProvider.overrideWithValue(dependencies)],
      child: const CyVaultApp(),
    ),
  );
}
