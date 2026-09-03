import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_links.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/services/purchase_service.dart';
import '../providers/purchase_providers.dart';

/// Subscription status and the route out to the store's management UI.
///
/// Cancellation and plan changes are handled by Apple and Google, never by us,
/// so this screen reports state and hands off.
class ManageSubscriptionScreen extends ConsumerWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(userPreferencesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Manage Subscription')),
      body: prefsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load your subscription: $e'),
          ),
        ),
        data: (prefs) {
          final expiresAt = prefs.subscriptionExpiresAt;
          final isActive = prefs.isPremium &&
              (expiresAt == null || expiresAt.isAfter(DateTime.now()));

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _StatusCard(
                isActive: isActive,
                planLabel: _planLabel(prefs.subscriptionPlan),
                expiresAt: expiresAt,
              ),
              const SizedBox(height: 24),

              if (isActive) ...[
                Text(
                  'Cancelling or switching plans is handled by '
                  '${_storeName()}.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _openStoreSubscriptions(context),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: Text('Manage in ${_storeName()}'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.push(Routes.premium),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('View Premium Plans'),
                  ),
                ),

              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () =>
                      ref.read(purchaseServiceProvider).restorePurchases(),
                  child: const Text('Restore Purchases'),
                ),
              ),

              const Divider(height: 40),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms of Use'),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () => _launch(context, AppLinks.terms),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () => _launch(context, AppLinks.privacy),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.mail_outline),
                title: const Text('Contact Support'),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () => _launch(context, AppLinks.support),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _planLabel(String? productId) {
    switch (productId) {
      case ProductIds.monthly:
        return 'Premium Monthly';
      case ProductIds.annual:
        return 'Premium Annual';
      default:
        return 'Premium';
    }
  }

  static String _storeName() =>
      Platform.isIOS ? 'the App Store' : 'Google Play';

  static Future<void> _openStoreSubscriptions(BuildContext context) {
    final url = Platform.isIOS
        ? AppLinks.appleSubscriptions
        : AppLinks.googleSubscriptions;
    return _launch(context, url);
  }

  static Future<void> _launch(BuildContext context, String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }
}

class _StatusCard extends StatelessWidget {
  final bool isActive;
  final String planLabel;
  final DateTime? expiresAt;

  const _StatusCard({
    required this.isActive,
    required this.planLabel,
    required this.expiresAt,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.success : AppColors.warning;
    final dateFormat = DateFormat.yMMMMd();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isActive ? Icons.check_circle : Icons.info_outline,
                color: color,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                isActive ? 'Active' : 'Not subscribed',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            planLabel,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          if (expiresAt != null) ...[
            const SizedBox(height: 4),
            Text(
              isActive
                  ? 'Renews or ends on ${dateFormat.format(expiresAt!)}'
                  : 'Ended on ${dateFormat.format(expiresAt!)}',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
