import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/sharing/data/datasources/listener_retry.dart';

void main() {
  const step = Duration(milliseconds: 10);

  test('restarts after growing delays, up to the limit', () async {
    final retry = ListenerRetry(maxAttempts: 3, firstDelay: step);
    final watch = Stopwatch()..start();
    final restarts = <Duration>[];
    void fail() => retry.schedule('a', () {
          restarts.add(watch.elapsed);
          fail();
        });

    fail();
    await Future<void>.delayed(step * 12);

    expect(restarts, hasLength(3));
    // 1, 2 and 4 steps apart.
    expect(restarts[0], greaterThanOrEqualTo(step));
    expect(restarts[1] - restarts[0], greaterThanOrEqualTo(step * 2));
    expect(restarts[2] - restarts[1], greaterThanOrEqualTo(step * 4));
  });

  test('data resets the count; cancel stops a pending restart', () async {
    final retry = ListenerRetry(maxAttempts: 1, firstDelay: step);
    var restarts = 0;

    expect(retry.schedule('a', () => restarts++), isTrue);
    await Future<void>.delayed(step * 2);
    expect(retry.schedule('a', () => restarts++), isFalse);

    retry.succeeded('a');
    expect(retry.schedule('a', () => restarts++), isTrue);
    retry.cancel('a');
    await Future<void>.delayed(step * 3);

    expect(restarts, 1);
  });
}
