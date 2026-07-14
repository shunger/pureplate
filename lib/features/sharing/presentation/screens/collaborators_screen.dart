import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/firestore_pantry_sharing_service.dart';
import '../providers/sharing_providers.dart';

/// Shows shared pantry info, collaborator list, and invite code management.
class CollaboratorsScreen extends ConsumerWidget {
  final String firestoreId;

  const CollaboratorsScreen({super.key, required this.firestoreId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(sharedPantryItemsProvider(firestoreId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Shared Pantry'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Invite Code Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invite Code',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    'Share this code with family members to let them join your pantry.',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Theme.of(context).colorScheme.outline, width: 1),
                        ),
                        child: Text(
                          firestoreId.substring(0, 6).toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text:
                                  firestoreId.substring(0, 6).toUpperCase()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Invite code copied!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () async {
                      final service =
                          ref.read(firestorePantrySharingServiceProvider);
                      final newCode =
                          await service.regenerateInviteCode(firestoreId);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('New invite code: $newCode')),
                        );
                      }
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Regenerate code'),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.coral),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Shared Items Count
          itemsAsync.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.coral)),
            error: (e, _) => Text('Error: $e'),
            data: (items) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2,
                        color: AppColors.sage, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      '${items.length} shared items',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Info about sharing
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How sharing works',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const _InfoRow(
                    icon: Icons.sync,
                    text: 'Changes sync in real-time for all members',
                  ),
                  const _InfoRow(
                    icon: Icons.add_circle_outline,
                    text: 'Anyone can add, edit, or remove items',
                  ),
                  const _InfoRow(
                    icon: Icons.timer,
                    text: 'Invite codes expire after 7 days',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
