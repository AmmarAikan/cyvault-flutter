import 'package:local_auth/local_auth.dart';

abstract interface class BiometricConfirmation {
  Future<bool> confirm();
}

final class LocalBiometricConfirmation implements BiometricConfirmation {
  LocalBiometricConfirmation([LocalAuthentication? authentication])
    : _authentication = authentication ?? LocalAuthentication();

  final LocalAuthentication _authentication;

  @override
  Future<bool> confirm() async {
    try {
      if (!await _authentication.isDeviceSupported()) return false;
      return await _authentication.authenticate(
        localizedReason: 'Confirm access to the unlocked CyVault session',
        biometricOnly: true,
        persistAcrossBackgrounding: false,
      );
    } catch (_) {
      return false;
    }
  }
}
