import 'package:cyvault/app/router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('router guard keeps locked users out and unlocked users in', () {
    expect(authGuardRedirect(unlocked: false, location: '/home'), '/auth');
    expect(authGuardRedirect(unlocked: false, location: '/auth'), isNull);
    expect(authGuardRedirect(unlocked: true, location: '/auth'), '/home');
    expect(authGuardRedirect(unlocked: true, location: '/breach'), isNull);
  });
}
