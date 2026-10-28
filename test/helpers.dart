import 'dart:typed_data';

import 'package:cyvault/core/crypto/crypto_service.dart';
import 'package:cyvault/features/breach_check/data/breach_service.dart';

final class DeterministicBytes implements RandomBytes {
  int counter = 0;

  @override
  Uint8List nextBytes(int length) => Uint8List.fromList(
    List<int>.generate(length, (index) => (counter++ + index) & 0xff),
  );
}

final class MemoryBreachCache implements BreachCache {
  final Map<String, CachedBreachResult> values = <String, CachedBreachResult>{};

  @override
  Future<CachedBreachResult?> read(String fullHash) async => values[fullHash];

  @override
  Future<void> write(String fullHash, int count) async {
    values[fullHash] = CachedBreachResult(count, DateTime.now().toUtc());
  }
}
