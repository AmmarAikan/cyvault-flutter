import 'dart:async';

import 'package:flutter/material.dart';

import '../settings/app_settings.dart';
import 'vault_session.dart';

final class SecurityLifecycle extends StatefulWidget {
  const SecurityLifecycle({
    required this.session,
    required this.settings,
    required this.child,
    super.key,
  });

  final VaultSession session;
  final AppSettings settings;
  final Widget child;

  @override
  State<SecurityLifecycle> createState() => _SecurityLifecycleState();
}

final class _SecurityLifecycleState extends State<SecurityLifecycle>
    with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      widget.session.lockIfInactive(
        Duration(minutes: widget.settings.autoLockMinutes),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      widget.session.lock(LockReason.background);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: (_) => widget.session.registerInteraction(),
    child: widget.child,
  );
}
