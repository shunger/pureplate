import 'dart:convert';

/// Weekly AI usage, as reported by the backend.
///
/// Metering is owned by the server (`users/{uid}/quota/weekly`, written only by
/// Cloud Functions). This is a read-only snapshot returned alongside each
/// generatePlan/chatWithChef response so the app can show what is left *before*
/// the user hits the wall, instead of only surfacing the limit as an error.
class AiQuotaStatus {
  /// True for premium subscribers and users inside the free trial.
  final bool unlimited;
  final int used;
  final int limit;
  final int remaining;

  /// When the weekly counters reset.
  final DateTime resetAt;

  /// When the free trial ends, or null if it does not apply.
  final DateTime? trialEndsAt;

  const AiQuotaStatus({
    required this.unlimited,
    required this.used,
    required this.limit,
    required this.remaining,
    required this.resetAt,
    this.trialEndsAt,
  });

  /// True once this snapshot describes a week that has already ended.
  bool get isStale => DateTime.now().isAfter(resetAt);

  static AiQuotaStatus? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    final resetAtMs = (json['resetAt'] as num?)?.toInt();
    if (resetAtMs == null) return null;

    final trialEndsAtMs = (json['trialEndsAt'] as num?)?.toInt();

    return AiQuotaStatus(
      unlimited: json['unlimited'] as bool? ?? false,
      used: (json['used'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      remaining: (json['remaining'] as num?)?.toInt() ?? 0,
      resetAt: DateTime.fromMillisecondsSinceEpoch(resetAtMs),
      trialEndsAt: trialEndsAtMs != null
          ? DateTime.fromMillisecondsSinceEpoch(trialEndsAtMs)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'unlimited': unlimited,
        'used': used,
        'limit': limit,
        'remaining': remaining,
        'resetAt': resetAt.millisecondsSinceEpoch,
        'trialEndsAt': trialEndsAt?.millisecondsSinceEpoch,
      };

  String encode() => jsonEncode(toJson());

  static AiQuotaStatus? decode(String? raw) {
    if (raw == null) return null;
    try {
      return fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
