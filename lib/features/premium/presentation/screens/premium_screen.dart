import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/database_providers.dart';
import '../../data/services/purchase_service.dart';
import '../providers/purchase_providers.dart';

/// Premium subscription marketing page.
class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(userPreferencesProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('PurePlate Premium'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Hero section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.coral, AppColors.coralDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.coral.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.workspace_premium,
                    size: 56, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'Unlock Premium',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlimited meal plans, advanced features,\nand family sharing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Feature comparison
          Text('What you get',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _FeatureRow(
            icon: Icons.auto_awesome,
            title: 'Unlimited Meal Plans',
            subtitle: 'Free: 2/week',
            isPremium: true,
          ),
          _FeatureRow(
            icon: Icons.chat,
            title: 'AI Chat Planning',
            subtitle: 'Conversational meal planning',
            isPremium: true,
          ),
          _FeatureRow(
            icon: Icons.restaurant,
            title: 'Advanced Cooking Mode',
            subtitle: 'Voice guidance & timers',
            isPremium: true,
          ),
          _FeatureRow(
            icon: Icons.family_restroom,
            title: 'Family Sharing',
            subtitle: 'Share pantry with family',
            isPremium: true,
          ),
          _FeatureRow(
            icon: Icons.analytics_outlined,
            title: 'Spending Insights',
            subtitle: 'Budget tracking & reports',
            isPremium: true,
          ),
          _FeatureRow(
            icon: Icons.block,
            title: 'No Ads',
            subtitle: 'Ad-free experience',
            isPremium: true,
          ),

          const SizedBox(height: 24),

          // Subscribe button
          prefsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (prefs) {
              if (prefs.isPremium) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.success, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'You\'re a Premium member!',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return _SubscribeSection();
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SubscribeSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(availableProductsProvider);
    final purchaseState = ref.watch(purchaseStateProvider);

    // Listen for purchase state changes to show feedback.
    ref.listen<AsyncValue<PurchaseState>>(purchaseStateProvider,
        (prev, next) {
      next.whenData((state) {
        switch (state) {
          case PurchaseSuccess():
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Premium activated!'),
                backgroundColor: AppColors.success,
              ),
            );
          case PurchaseError(:final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          default:
            break;
        }
      });
    });

    final isProcessing = purchaseState.whenOrNull(
          data: (state) =>
              state is PurchasePurchasing || state is PurchaseRestoring,
        ) ??
        false;

    return Column(
      children: [
        productsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isProcessing
                  ? null
                  : () => ref.invalidate(availableProductsProvider),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              child: const Text('Retry Loading'),
            ),
          ),
          data: (products) {
            if (products.isEmpty) {
              return SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isProcessing
                      ? null
                      : () => ref.invalidate(availableProductsProvider),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Subscribe'),
                ),
              );
            }

            return Column(
              children: products.map((product) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isProcessing
                          ? null
                          : () => ref
                              .read(purchaseServiceProvider)
                              .purchaseSubscription(product),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      child: isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text('${product.title} — ${product.price}'),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: isProcessing
              ? null
              : () => ref.read(purchaseServiceProvider).restorePurchases(),
          child: const Text(
            'Restore Purchases',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isPremium;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.coral.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.coral),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (isPremium)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coral,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
