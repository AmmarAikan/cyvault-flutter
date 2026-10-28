import 'dart:async';

import 'package:cyvault/features/breach_check/data/breach_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'helpers.dart';

void main() {
  const suffix = '1E4C9B93F3F0682250B6CF8331B7EE68FD8';

  test('sends only prefix with padding and parses noisy response', () async {
    late http.Request captured;
    final client = MockClient((request) async {
      captured = request;
      return http.Response(
        '00000000000000000000000000000000000:0\r\n$suffix:42\r\n',
        200,
      );
    });
    final result = await BreachService(
      client,
      MemoryBreachCache(),
    ).check('password', online: true);
    expect(result.count, 42);
    expect(captured.url.path, '/range/5BAA6');
    expect(captured.headers['Add-Padding'], 'true');
    expect(captured.url.path, isNot(contains(suffix)));
    expect(captured.url.path, isNot(contains('password')));
    expect(captured.url.query, isEmpty);
    expect(BreachService.parseRange('noise\n$suffix:9\n', suffix), 9);
  });

  test('offline does not call network and cached result is reused', () async {
    var calls = 0;
    final client = MockClient((request) async {
      calls++;
      return http.Response('$suffix:7', 200);
    });
    final cache = MemoryBreachCache();
    final service = BreachService(client, cache);
    final offline = await service.check('offline-only', online: false);
    expect(offline.source, BreachSource.offline);
    expect(calls, 0);
    await service.check('password', online: true);
    final cached = await service.check('password', online: true);
    expect(cached.source, BreachSource.cache);
    expect(calls, 1);
  });

  test('timeout propagates without leaking password', () async {
    final completer = Completer<http.Response>();
    final service = BreachService(
      MockClient((request) => completer.future),
      MemoryBreachCache(),
      timeout: const Duration(milliseconds: 1),
    );
    await expectLater(
      service.check('private test phrase', online: true),
      throwsA(isA<TimeoutException>()),
    );
  });
}
