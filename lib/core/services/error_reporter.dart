import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Sends crashes and survivable problems to Firebase Crashlytics.
///
/// Only release builds report. Debug builds and unit tests never call
/// [init], so [nonFatal] does nothing there and no test touches Firebase.
///
/// Reports carry the error and stack trace only: never put invite codes,
/// item names or other user content in a [nonFatal] reason.
class ErrorReporter {
  ErrorReporter._();

  static FirebaseCrashlytics? _crashlytics;

  /// Call once after `Firebase.initializeApp`.
  static Future<void> init() async {
    try {
      final crashlytics = FirebaseCrashlytics.instance;
      await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
      if (kDebugMode) return;
      _crashlytics = crashlytics;
      // Uncaught Flutter framework errors, then uncaught async errors.
      FlutterError.onError = crashlytics.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        crashlytics.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (e) {
      debugPrint('[ErrorReporter] Crashlytics unavailable: $e');
    }
  }

  /// A problem the app recovered from but that likely broke something for
  /// the user, such as a sync listener that stayed refused after its
  /// retries or a join that failed. [reason] is a short fixed description.
  static void nonFatal(Object error, StackTrace? stack, String reason) {
    final crashlytics = _crashlytics;
    if (crashlytics == null) return;
    crashlytics
        .recordError(error, stack, reason: reason, fatal: false)
        .catchError((Object _) {});
  }
}
