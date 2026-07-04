import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/routing/route_names.dart';

/// Shows items expiring within 7 days. Tapping "Get recipes" navigates to
/// inventory suggestions. Drives the "leftover rescue" AI feature.
class ExpiringItemsCard extends ConsumerWidget {
  const ExpiringItemsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expiringAsync = ref.watch(expiringItemsProvider);

    return expiringAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();

        // Take up to 5 expiring items for display
        final displayItems = items.take(5).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.schedule,
                          color: AppColors.warning,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Use Soon',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            context.push(Routes.inventorySuggestions),
                        child: const Text(
                          'Get recipes',
                          style: TextStyle(
                            color: AppColors.coral,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...displayItems.map((item) {
                    final days = item.expiresAt != null
                        ? item.expiresAt!.difference(DateTime.now()).inDays
                        : null;
                    final label = days == null
                        ? ''
                        : days < 0
                            ? 'Expired'
                            : days == 0
                                ? 'Today'
                                : days == 1
                                    ? 'Tomorrow'
                                    : '$days days';
                    final isUrgent = days != null && days <= 1;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            label,
                            style: TextStyle(
                              color:
                                  isUrgent ? AppColors.error : AppColors.warning,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
