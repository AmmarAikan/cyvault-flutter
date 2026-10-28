import 'dart:async';

import 'package:flutter/services.dart';

abstract interface class ClipboardPort {
  Future<String?> read();
  Future<void> write(String value);
}

final class SystemClipboardPort implements ClipboardPort {
  @override
  Future<String?> read() async => (await Clipboard.getData('text/plain'))?.text;

  @override
  Future<void> write(String value) =>
      Clipboard.setData(ClipboardData(text: value));
}

final class ClipboardGuard {
  ClipboardGuard({ClipboardPort? clipboard})
    : clipboard = clipboard ?? SystemClipboardPort();

  final ClipboardPort clipboard;
  Timer? _timer;

  Future<void> copyTemporarily(String secret, Duration duration) async {
    _timer?.cancel();
    await clipboard.write(secret);
    _timer = Timer(duration, () async {
      if (await clipboard.read() == secret) await clipboard.write('');
    });
  }

  void dispose() => _timer?.cancel();
}
