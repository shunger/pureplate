import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/ai_quota.dart';

/// Caches the last quota snapshot the backend sent, so the remaining-usage
/// hint survives an app restart rather than reappearing only after the next
/// generation — which is the very call it is meant to warn about.
class AiQuotaNotifier extends StateNotifier<AiQuotaStatus?> {
  final String _storageKey;

  AiQuotaNotifier(this._storageKey) : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = AiQuotaStatus.decode(prefs.getString(_storageKey));

    // A snapshot from a finished week says nothing about the current one.
    if (cached == null || cached.isStale) return;

    state = cached;
  }

  Future<void> update(AiQuotaStatus? quota) async {
    state = quota;

    final prefs = await SharedPreferences.getInstance();
    if (quota == null) {
      await prefs.remove(_storageKey);
    } else {
      await prefs.setString(_storageKey, quota.encode());
    }
  }
}

/// Remaining weekly meal-plan generations.
final planQuotaProvider =
    StateNotifierProvider<AiQuotaNotifier, AiQuotaStatus?>((ref) {
  return AiQuotaNotifier('ai_quota_plan');
});

/// Remaining weekly AI chat messages.
final chatQuotaProvider =
    StateNotifierProvider<AiQuotaNotifier, AiQuotaStatus?>((ref) {
  return AiQuotaNotifier('ai_quota_chat');
});
