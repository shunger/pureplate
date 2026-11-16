import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ai_quota.dart';
import '../providers/quota_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

/// Shows how long the 14-day free trial has left, or that it has ended, before
/// the user tries an AI feature.
///
/// Renders nothing until the backend has reported usage at least once, and
/// nothing at all for premium subscribers.
class QuotaHint extends ConsumerWidget {
  final StateNotifierProvider<AiQuotaNotifier, AiQuotaStatus?> provider;

  /// Singular noun for one unit of usage, e.g. 'plan' or 'message'.
  final String unit;

  const QuotaHint({
    super.key,
    required this.provider,
    required this.unit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quota = ref.watch(provider);
    final premium =
        ref.watch(isPremiumProvider).whenOrNull(data: (v) => v) ?? false;
    if (quota == null || premium) return const SizedBox.shrink();

    // After the trial AI is Premium only; there is no free allowance. (An
    // older server's limited snapshot means the same thing now.)
    if (quota.trialEnded || (!quota.unlimited && !quota.isStale)) {
      return _Hint(
        icon: Icons.lock_outline,
        text: 'Your free trial has ended — upgrade to keep using AI ${unit}s',
        emphasis: true,
        onTap: () => context.push(Routes.premium),
      );
    }

    final trialEndsAt = quota.trialEndsAt;
    if (quota.isStale || trialEndsAt == null) return const SizedBox.shrink();

    final daysLeft = trialEndsAt.difference(DateTime.now()).inDays;
    return _Hint(
      icon: Icons.card_giftcard,
      text: daysLeft == 0
          ? 'Free trial ends today — unlimited ${unit}s until then'
          : 'Free trial — $daysLeft ${daysLeft == 1 ? 'day' : 'days'} of '
              'unlimited ${unit}s left',
      emphasis: false,
      onTap: () => context.push(Routes.premium),
    );
  }
}

class _Hint extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool emphasis;
  final VoidCallback onTap;

  const _Hint({
    required this.icon,
    required this.text,
    required this.emphasis,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = emphasis
        ? AppColors.coral
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: color,
                  fontWeight: emphasis ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
