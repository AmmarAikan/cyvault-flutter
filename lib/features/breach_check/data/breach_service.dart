import 'dart:async';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:http/http.dart' as http;

enum BreachSource { network, cache, offline }

final class BreachResult {
  const BreachResult({required this.count, required this.source});

  final int count;
  final BreachSource source;
}

final class CachedBreachResult {
  const CachedBreachResult(this.count, this.checkedAt);

  final int count;
  final DateTime checkedAt;
}

abstract interface class BreachCache {
  Future<CachedBreachResult?> read(String fullHash);
  Future<void> write(String fullHash, int count);
}

final class BreachService {
  BreachService(
    this._client,
    this._cache, {
    this.timeout = const Duration(seconds: 8),
    this.cacheTtl = const Duration(days: 7),
  });

  final http.Client _client;
  final BreachCache _cache;
  final Duration timeout;
  final Duration cacheTtl;

  Future<BreachResult> check(String password, {required bool online}) async {
    final digest = await Sha1().hash(utf8.encode(password));
    final hash = _hex(digest.bytes);
    final cached = await _cache.read(hash);
    if (cached != null &&
        DateTime.now().toUtc().difference(cached.checkedAt) <= cacheTtl) {
      return BreachResult(count: cached.count, source: BreachSource.cache);
    }
    if (!online) {
      return const BreachResult(count: 0, source: BreachSource.offline);
    }

    final prefix = hash.substring(0, 5);
    final suffix = hash.substring(5);
    final response = await _client
        .get(
          Uri.https('api.pwnedpasswords.com', '/range/$prefix'),
          headers: const <String, String>{
            'Add-Padding': 'true',
            'User-Agent': 'CyVault/1.0 (educational password manager)',
          },
        )
        .timeout(timeout);
    if (response.statusCode != 200) {
      throw http.ClientException('Breach service unavailable.');
    }
    final count = parseRange(response.body, suffix);
    await _cache.write(hash, count);
    return BreachResult(count: count, source: BreachSource.network);
  }

  static int parseRange(String body, String suffix) {
    final target = suffix.toUpperCase();
    for (final line in const LineSplitter().convert(body)) {
      final separator = line.indexOf(':');
      if (separator < 1) continue;
      final candidate = line.substring(0, separator).trim().toUpperCase();
      if (candidate != target) continue;
      return int.tryParse(line.substring(separator + 1).trim()) ?? 0;
    }
    return 0;
  }

  static String _hex(List<int> bytes) => bytes
      .map((value) => value.toRadixString(16).padLeft(2, '0'))
      .join()
      .toUpperCase();
}
