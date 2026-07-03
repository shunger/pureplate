import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';

/// Shows items expiring within 3 days. Tapping navigates to pantry filtered
/// by expiring items. Drives the "leftover rescue" AI feature.
class ExpiringItemsCard extends ConsumerWidget {
  const ExpiringItemsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Wire to actual expiringItemsProvider.
    // final expiring = ref.watch(expiringItemsProvider);

    // Placeholder — replace with real data.
    final expiringItems = [
      ('Chicken Breast', 1, 'Tomorrow'),
      ('Bell Peppers', 3, '2 days'),
      ('Greek Yogurt', 1, '3 days'),
    ];

    if (expiringItems.isEmpty) return const SizedBox.shrink();

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
                    onPressed: () {
                      // TODO: Navigate to AI inventory suggestions
                      // with these items pre-populated.
                    },
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
              ...expiringItems.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          item.$1,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.$3,
                          style: TextStyle(
                            color: item.$3 == 'Tomorrow'
                                ? AppColors.error
                                : AppColors.warning,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
