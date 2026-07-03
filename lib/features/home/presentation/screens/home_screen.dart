import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../widgets/pantry_summary_card.dart';
import '../widgets/whats_for_dinner_button.dart';
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
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Greeting header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formattedDate(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // "What's for dinner?" hero button
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: WhatsForDinnerButton(),
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
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
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
