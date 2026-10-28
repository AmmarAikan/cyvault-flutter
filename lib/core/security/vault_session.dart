import 'dart:async';

import 'package:flutter/foundation.dart';

import '../crypto/master_password_service.dart';
import '../database/app_database.dart';

typedef Now = DateTime Function();
typedef Delay = Future<void> Function(Duration duration);

enum LockReason { manual, background, timeout }

final class VaultSession extends ChangeNotifier {
  VaultSession(this._masterPasswords, this._database, {Now? now, Delay? delay})
    : _now = now ?? DateTime.now,
      _delay = delay ?? Future<void>.delayed;

  final MasterPasswordService _masterPasswords;
  final AppDatabase _database;
  final Now _now;
  final Delay _delay;

  Uint8List? _key;
  bool _hasVault = false;
  bool _busy = false;
  int _failedAttempts = 0;
  DateTime _lastInteraction = DateTime.now();

  bool get isUnlocked => _key != null;
  bool get hasVault => _hasVault;
  bool get busy => _busy;
  int get failedAttempts => _failedAttempts;
  Uint8List? get keyBytes => _key == null ? null : Uint8List.fromList(_key!);

  Future<void> initialize() async {
    _hasVault = await _masterPasswords.hasVault();
    _lastInteraction = _now();
    notifyListeners();
  }

  Future<bool> setup(String password) async {
    if (_hasVault || password.length < 12) return false;
    _setBusy(true);
    try {
      _key = await _masterPasswords.setup(password);
      _hasVault = true;
      _failedAttempts = 0;
      _lastInteraction = _now();
      await _database.recordSecurityEvent(
        'unlock_success',
        details: 'initial_setup',
      );
      notifyListeners();
      return true;
    } finally {
      _setBusy(false);
    }
  }

  Future<bool> unlock(String password) async {
    if (!_hasVault || _busy) return false;
    _setBusy(true);
    try {
      if (_failedAttempts >= 3) {
        final seconds = (1 << (_failedAttempts - 3)).clamp(1, 16);
        await _delay(Duration(seconds: seconds));
      }
      final candidate = await _masterPasswords.unlock(password);
      if (candidate == null) {
        _failedAttempts++;
        await _database.recordSecurityEvent('unlock_failure');
        notifyListeners();
        return false;
      }
      _wipe();
      _key = candidate;
      _failedAttempts = 0;
      _lastInteraction = _now();
      await _database.recordSecurityEvent('unlock_success');
      notifyListeners();
      return true;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> lock(LockReason reason) async {
    if (!isUnlocked) return;
    _wipe();
    final event = switch (reason) {
      LockReason.manual => 'manual_lock',
      LockReason.background => 'background_lock',
      LockReason.timeout => 'timeout_lock',
    };
    await _database.recordSecurityEvent(event);
    notifyListeners();
  }

  void registerInteraction() => _lastInteraction = _now();

  Future<bool> lockIfInactive(Duration duration) async {
    if (!isUnlocked || _now().difference(_lastInteraction) < duration) {
      return false;
    }
    await lock(LockReason.timeout);
    return true;
  }

  void _setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void _wipe() {
    _key?.fillRange(0, _key!.length, 0);
    _key = null;
  }

  @override
  void dispose() {
    _wipe();
    super.dispose();
  }
}
