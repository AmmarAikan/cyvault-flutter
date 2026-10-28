import 'package:flutter/services.dart';

final class ScreenProtection {
  static const MethodChannel _channel = MethodChannel('cyvault/security');

  static Future<void> setSensitive(bool sensitive) async {
    try {
      await _channel.invokeMethod<void>('setSensitive', sensitive);
    } on MissingPluginException {
      // Host-side widget tests have no platform implementation.
    }
  }
}
