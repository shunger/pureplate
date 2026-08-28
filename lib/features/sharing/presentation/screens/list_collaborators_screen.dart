import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/firestore_list_sharing_service.dart';
import '../providers/sharing_providers.dart';

/// Shows shared list info, collaborator list, and invite code management.
class ListCollaboratorsScreen extends ConsumerWidget {
  final String firestoreId;

  const ListCollaboratorsScreen({super.key, required this.firestoreId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(sharedListItemsProvider(firestoreId));
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final uid = currentUser?.uid;
    final listsAsync =
        uid != null ? ref.watch(sharedListsProvider(uid)) : null;

    // Find the specific shared list from the stream.
    final listInfo = listsAsync?.whenData((lists) =>
        lists.cast<SharedListInfo?>().firstWhere(
              (l) => l!.firestoreId == firestoreId,
              orElse: () => null,
            ));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Shared List'),
      ),
      body: listInfo == null
          ? const Center(child: CircularProgressIndicator())
          : listInfo.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (sharedList) {
                if (sharedList == null) {
                  return const Center(child: Text('Shared list not found'));
                }
                final inviteCode = sharedList.inviteCode ?? '------';
                final isOwner = currentUser != null &&
                    sharedList.ownerUid == currentUser.uid;

                return ListView(
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
                              'Share this code to let others join your list.',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  fontSize: 13),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        width: 1),
                                  ),
                                  child: Text(
                                    inviteCode,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 4,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: inviteCode));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Invite code copied!')),
                                    );
                                  },
                                ),
                              ],
                            ),
                            if (sharedList.inviteCodeExpiresAt != null) ...[
                              const SizedBox(height: 8),
                              _InviteCodeExpiry(
                                  expiresAt:
                                      sharedList.inviteCodeExpiresAt!),
                            ],
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () async {
                                final service = ref
                                    .read(firestoreListSharingServiceProvider);
                                final newCode = await service
                                    .regenerateInviteCode(firestoreId);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'New invite code: $newCode')),
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

                    // Collaborator List
                    if (sharedList.collaborators.isNotEmpty) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Members',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              ...sharedList.collaborators.values
                                  .map((collab) => ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          backgroundColor: AppColors.coral
                                              .withValues(alpha: 0.15),
                                          child: Text(
                                            collab.displayName.isNotEmpty
                                                ? collab.displayName[0]
                                                    .toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                                color: AppColors.coral,
                                                fontWeight:
                                                    FontWeight.w600),
                                          ),
                                        ),
                                        title: Text(collab.displayName),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: collab.role == 'owner'
                                                    ? AppColors.coral
                                                        .withValues(
                                                            alpha: 0.1)
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surfaceContainerHighest,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12),
                                              ),
                                              child: Text(
                                                collab.role == 'owner'
                                                    ? 'Owner'
                                                    : 'Editor',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  color: collab.role ==
                                                          'owner'
                                                      ? AppColors.coral
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                ),
                                              ),
                                            ),
                                            if (isOwner &&
                                                collab.role != 'owner')
                                              IconButton(
                                                icon: Icon(
                                                    Icons
                                                        .remove_circle_outline,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                    size: 20),
                                                onPressed: () =>
                                                    _confirmRemoveCollaborator(
                                                        context,
                                                        ref,
                                                        collab),
                                              ),
                                          ],
                                        ),
                                      )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Shared Items Count
                    itemsAsync.when(
                      loading: () => const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.coral)),
                      error: (e, _) => Text('Error: $e'),
                      data: (items) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.shopping_cart,
                                  color: AppColors.sage, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                '${items.length} shared items',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
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
                              text:
                                  'Changes sync in real-time for all members',
                            ),
                            const _InfoRow(
                              icon: Icons.add_circle_outline,
                              text:
                                  'Anyone can add, edit, or check off items',
                            ),
                            const _InfoRow(
                              icon: Icons.timer,
                              text: 'Invite codes expire after 7 days',
                            ),
                            const _InfoRow(
                              icon: Icons.devices,
                              text:
                                  'Works with SmartShoppingScanner too',
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Leave list (non-owners only)
                    if (!isOwner) ...[
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: () =>
                            _confirmLeaveList(context, ref, sharedList),
                        icon: const Icon(Icons.exit_to_app,
                            color: AppColors.error),
                        label: const Text('Leave list',
                            style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ],
                );
              },
            ),
    );
  }

  void _confirmRemoveCollaborator(
      BuildContext context, WidgetRef ref, ListCollaborator collab) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove member?'),
        content:
            Text('Remove ${collab.displayName} from this shared list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final service =
                  ref.read(firestoreListSharingServiceProvider);
              await service.removeCollaborator(firestoreId, collab.uid);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('${collab.displayName} removed')),
                );
              }
            },
            child: const Text('Remove',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _confirmLeaveList(
      BuildContext context, WidgetRef ref, SharedListInfo list) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave list?'),
        content: Text(
            'You will no longer have access to "${list.name}". '
            'Your local list items will be kept.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final user =
                  ref.read(currentUserProvider).valueOrNull;
              if (user == null) return;
              final service =
                  ref.read(firestoreListSharingServiceProvider);
              await service.removeCollaborator(
                  firestoreId, user.uid);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Left "${list.name}"')),
                );
                context.pop();
              }
            },
            child: const Text('Leave',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _InviteCodeExpiry extends StatelessWidget {
  final DateTime expiresAt;

  const _InviteCodeExpiry({required this.expiresAt});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isExpired = now.isAfter(expiresAt);
    final days = expiresAt.difference(now).inDays;

    return Text(
      isExpired
          ? 'Expired'
          : 'Expires in $days day${days == 1 ? '' : 's'}',
      style: TextStyle(
        fontSize: 12,
        color: isExpired
            ? AppColors.error
            : Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: isExpired ? FontWeight.w600 : FontWeight.normal,
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
          Icon(icon,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
