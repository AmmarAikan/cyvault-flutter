import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../core/security/vault_session.dart';
import '../core/settings/app_settings.dart';
import '../features/breach_check/data/breach_service.dart';
import '../features/breach_check/data/drift_breach_cache.dart';
import '../features/cloud_identity/data/cloud_identity.dart';
import '../features/vault/data/vault_repository.dart';
import '../features/vault/presentation/vault_controller.dart';
import 'dependencies.dart';

final dependenciesProvider = Provider<AppDependencies>(
  (ref) => throw UnimplementedError('AppDependencies must be overridden.'),
);

final sessionProvider = ChangeNotifierProvider<VaultSession>(
  (ref) => ref.watch(dependenciesProvider).session,
);

final settingsProvider = ChangeNotifierProvider<AppSettings>(
  (ref) => ref.watch(dependenciesProvider).settings,
);

final cloudIdentityProvider = ChangeNotifierProvider<CloudIdentity>(
  (ref) => ref.watch(dependenciesProvider).cloudIdentity,
);

final vaultRepositoryProvider = Provider<VaultRepository>((ref) {
  final dependencies = ref.watch(dependenciesProvider);
  return VaultRepository(
    dependencies.database,
    dependencies.crypto,
    () => ref.read(sessionProvider).keyBytes,
  );
});

final vaultControllerProvider = ChangeNotifierProvider<VaultController>((ref) {
  final session = ref.watch(sessionProvider);
  final controller = VaultController(ref.watch(vaultRepositoryProvider));
  void handleSession() {
    if (session.isUnlocked) {
      unawaited(controller.load());
    } else {
      controller.clear();
    }
  }

  session.addListener(handleSession);
  ref.onDispose(() {
    session.removeListener(handleSession);
    controller.dispose();
  });
  handleSession();
  return controller;
});

final breachServiceProvider = Provider<BreachService>((ref) {
  final dependencies = ref.watch(dependenciesProvider);
  return BreachService(
    dependencies.httpClient,
    DriftBreachCache(
      dependencies.database,
      () => ref.read(sessionProvider).keyBytes,
    ),
  );
});
