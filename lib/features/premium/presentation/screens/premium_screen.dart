import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_links.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/services/purchase_service.dart';
import '../providers/purchase_providers.dart';

/// Premium subscription marketing page.
class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(userPreferencesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Pure Pantry Premium'),
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
                  'Unlimited meal plans and AI chat,\nvoice cooking, and family sharing.',
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
            subtitle: 'Free: 2 per week',
            isPremium: true,
          ),
          _FeatureRow(
            icon: Icons.chat,
            title: 'Unlimited AI Chat',
            subtitle: 'Free: 10 messages per week',
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
            subtitle: 'Share your pantry and lists',
            isPremium: true,
          ),
          _FeatureRow(
            icon: Icons.share,
            title: 'Share Recipes',
            subtitle: 'Export and send any recipe',
            isPremium: true,
          ),

          const SizedBox(height: 24),

          // Subscribe button
          prefsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (prefs) {
              if (prefs.isPremium) {
                return const _ActiveMemberSection();
              }
              return const _SubscribeSection();
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

/// Shown to existing subscribers, with a route to manage or cancel.
class _ActiveMemberSection extends StatelessWidget {
  const _ActiveMemberSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 20),
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
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.push(Routes.subscriptionManage),
          child: const Text('Manage subscription'),
        ),
      ],
    );
  }
}

class _SubscribeSection extends ConsumerWidget {
  const _SubscribeSection();

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
          case PurchaseVerificationPending():
            // The charge went through but the backend could not confirm it.
            // Access is deliberately not granted yet; the receipt is stored
            // and retried, so say so rather than implying failure.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Purchase received. We\'re confirming it with the store — '
                    'Premium unlocks automatically, usually within a minute.'),
                duration: Duration(seconds: 6),
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
          child: Text(
            'Restore Purchases',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14),
          ),
        ),
        const SizedBox(height: 16),
        const _SubscriptionDisclosure(),
      ],
    );
  }
}

/// Auto-renew terms and legal links.
///
/// Both stores reject paywalls that omit the renewal disclosure or do not link
/// to Terms and Privacy from the purchase screen itself.
class _SubscriptionDisclosure extends StatelessWidget {
  const _SubscriptionDisclosure();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      children: [
        Text(
          'Subscriptions renew automatically at the price and period shown '
          'above unless cancelled at least 24 hours before the end of the '
          'current period. Your account is charged for renewal within 24 '
          'hours of the end of the current period. You can manage or cancel '
          'your subscription in your store account settings at any time.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11.5, height: 1.45, color: muted),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegalLink(label: 'Terms of Use', url: AppLinks.terms),
            Text('  ·  ', style: TextStyle(fontSize: 12, color: muted)),
            _LegalLink(label: 'Privacy Policy', url: AppLinks.privacy),
          ],
        ),
      ],
    );
  }
}

class _LegalLink extends StatelessWidget {
  final String label;
  final String url;

  const _LegalLink({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ok = await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
        if (!ok && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open $url')),
          );
        }
      },
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.coral,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.coral,
        ),
      ),
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
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface)),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
