import 'dart:async';

/// Restarts Firestore listeners that fail, with growing delays.
///
/// Right after a list or pantry is shared or joined, the local cache already
/// shows the user as a member, so its items listener starts before the
/// server has saved that membership. The server refuses it
/// (permission-denied), and Firestore ends a listener for good after an
/// error. Trying again a moment later picks it up once the write has landed.
class ListenerRetry {
  ListenerRetry({
    this.maxAttempts = 5,
    this.firstDelay = const Duration(seconds: 1),
  });

  final int maxAttempts;
  final Duration firstDelay;
  final _attempts = <String, int>{};
  final _timers = <String, Timer>{};

  /// Runs [restart] for [id] after the next delay (1s, 2s, 4s, ...), unless
  /// [maxAttempts] restarts have already failed. Returns whether one was
  /// scheduled.
  bool schedule(String id, void Function() restart) {
    final attempt = (_attempts[id] ?? 0) + 1;
    if (attempt > maxAttempts) return false;
    _attempts[id] = attempt;
    _timers.remove(id)?.cancel();
    _timers[id] = Timer(firstDelay * (1 << (attempt - 1)), () {
      _timers.remove(id);
      restart();
    });
    return true;
  }

  /// The listener for [id] delivered data: later failures start over.
  void succeeded(String id) => _attempts.remove(id);

  /// Stops any pending restart for [id], e.g. when its listener is removed.
  void cancel(String id) {
    _timers.remove(id)?.cancel();
    _attempts.remove(id);
  }

  void cancelAll() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _attempts.clear();
  }
}
