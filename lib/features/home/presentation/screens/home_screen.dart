import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/pantry_summary_card.dart';
import '../widgets/whats_for_dinner_button.dart';
import '../widgets/meal_suggestion_card.dart';
import '../widgets/expiring_items_card.dart';
import '../widgets/todays_meal_card.dart';
import '../widgets/quick_actions_row.dart';

/// Main dashboard — the first thing users see.
///
/// Layout:
/// - Greeting + date
/// - "What's for dinner?" AI button (hero element)
/// - Today's meal card (if plan exists)
/// - Pantry summary (items count, expiring soon)
/// - Expiring items alert (if any)
/// - Quick actions row (scan, add item, browse recipes)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Greeting header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formattedDate(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.push(Routes.settings),
                      icon: Icon(
                        Icons.settings_outlined,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // "What's for dinner?" hero button
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: WhatsForDinnerButton(),
              ),
            ),

            // Breakfast + Lunch
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    MealSuggestionCard(
                      mealType: 'breakfast',
                      label: 'Breakfast',
                      icon: Icons.wb_sunny_outlined,
                      color: AppColors.sage,
                      colorDark: AppColors.sageDark,
                    ),
                    const SizedBox(width: 8),
                    MealSuggestionCard(
                      mealType: 'lunch',
                      label: 'Lunch',
                      icon: Icons.lunch_dining_outlined,
                      color: AppColors.info,
                      colorDark: const Color(0xFF1E88E5),
                    ),
                  ],
                ),
              ),
            ),

            // Dessert + Snack quick buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: Row(
                  children: [
                    MealSuggestionCard(
                      mealType: 'dessert',
                      label: 'Dessert',
                      icon: Icons.cake_outlined,
                      color: AppColors.coralLight,
                      colorDark: AppColors.coral,
                      compact: true,
                    ),
                    const SizedBox(width: 8),
                    MealSuggestionCard(
                      mealType: 'snack',
                      label: 'Snacks',
                      icon: Icons.cookie_outlined,
                      color: AppColors.warning,
                      colorDark: const Color(0xFFEF6C00),
                      compact: true,
                    ),
                  ],
                ),
              ),
            ),

            // Today's meal (if a plan exists for today)
            const SliverToBoxAdapter(
              child: TodaysMealCard(),
            ),

            // Pantry summary
            const SliverToBoxAdapter(
              child: PantrySummaryCard(),
            ),

            // Expiring items warning
            const SliverToBoxAdapter(
              child: ExpiringItemsCard(),
            ),

            // Quick actions
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: QuickActionsRow(),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _formattedDate() {
    final now = DateTime.now();
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }
}
