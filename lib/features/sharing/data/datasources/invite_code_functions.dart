import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

/// Looks up and redeems invite codes through the `lookupInviteCode` and
/// `joinByInviteCode` Cloud Functions, the same way Smart Shopping Scanner
/// 1.2.0 does.
///
/// The server limits how many wrong codes an account can try, which direct
/// Firestore queries can't. Until the functions are deployed everywhere, the
/// sharing services fall back to the direct Firestore path whenever the
/// server can't answer (a `null` result).
class InviteCodeFunctions {
  InviteCodeFunctions(this._functions);

  final FirebaseFunctions _functions;

  /// Previews the shared space for [code], or returns null to fall back.
  ///
  /// [kind] is `list` or `pantry`.
  Future<Map<String, dynamic>?> lookup(String kind, String code) =>
      _call('lookupInviteCode', {'kind': kind, 'code': code});

  /// Joins the shared space for [code], or returns null to fall back.
  Future<Map<String, dynamic>?> join(
    String kind,
    String code, {
    required String displayName,
  }) =>
      _call('joinByInviteCode', {
        'kind': kind,
        'code': code,
        'displayName': displayName,
      });

  /// Throws [InviteCodeRefused] when the server refuses the code (invalid,
  /// expired, revoked or too many wrong attempts).
  Future<Map<String, dynamic>?> _call(
    String name,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _functions.httpsCallable(name).call<Object?>(data);
      final summary = result.data;
      return summary is Map ? _stringKeyed(summary) : null;
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case 'invalid-argument':
          throw const InviteCodeRefused('Invalid invite code.');
        case 'failed-precondition':
        case 'resource-exhausted':
          throw InviteCodeRefused(
              e.message ?? 'This invite code can’t be used.');
        default:
          // not-found means the function isn't deployed; the rest are
          // outages. The server never answers not-found for a bad code.
          debugPrint('[$name] falling back to Firestore: ${e.code}');
          return null;
      }
    } catch (e) {
      debugPrint('[$name] falling back to Firestore: $e');
      return null;
    }
  }

  static Map<String, dynamic> _stringKeyed(Map value) => value.map(
        (key, val) => MapEntry(
          key.toString(),
          val is Map ? _stringKeyed(val) : val,
        ),
      );
}

/// The server refused an invite code; [message] is shown to the user.
class InviteCodeRefused implements Exception {
  final String message;
  const InviteCodeRefused(this.message);
  @override
  String toString() => message;
}

/// A server timestamp in milliseconds since the epoch, as a [DateTime].
DateTime? millisToDateTime(Object? value) =>
    value is num ? DateTime.fromMillisecondsSinceEpoch(value.toInt()) : null;
