import 'dart:math';

abstract interface class RandomIndex {
  int nextInt(int max);
}

final class SecureRandomIndex implements RandomIndex {
  final Random _random = Random.secure();

  @override
  int nextInt(int max) => _random.nextInt(max);
}

final class GeneratorOptions {
  const GeneratorOptions({
    this.length = 20,
    this.uppercase = true,
    this.lowercase = true,
    this.digits = true,
    this.symbols = true,
    this.avoidAmbiguous = true,
  });

  final int length;
  final bool uppercase;
  final bool lowercase;
  final bool digits;
  final bool symbols;
  final bool avoidAmbiguous;
}

final class PasswordGenerator {
  PasswordGenerator({RandomIndex? random})
    : random = random ?? SecureRandomIndex();

  final RandomIndex random;

  static const _upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
  static const _lower = 'abcdefghijkmnopqrstuvwxyz';
  static const _digits = '23456789';
  static const _symbols = '!@#%&*+-=?_';

  String generate(GeneratorOptions options) {
    if (options.length < 8 || options.length > 128) {
      throw ArgumentError.value(options.length, 'length');
    }
    final groups = <String>[
      if (options.uppercase) _upper,
      if (options.lowercase) _lower,
      if (options.digits) _digits,
      if (options.symbols) _symbols,
    ];
    if (groups.isEmpty || options.length < groups.length) {
      throw ArgumentError('At least one feasible character class is required.');
    }
    final selected = <String>[
      for (final group in groups) group[random.nextInt(group.length)],
    ];
    final pool = groups.join();
    while (selected.length < options.length) {
      selected.add(pool[random.nextInt(pool.length)]);
    }
    for (var i = selected.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final value = selected[i];
      selected[i] = selected[j];
      selected[j] = value;
    }
    return selected.join();
  }
}
