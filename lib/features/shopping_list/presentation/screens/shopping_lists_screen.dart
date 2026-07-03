import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/providers/database_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/shopping_list.dart';
import '../providers/shopping_list_providers.dart';
import '../widgets/shopping_list_widgets.dart';

/// Main shopping lists tab — shows active and archived lists.
class ShoppingListsScreen extends ConsumerWidget {
  const ShoppingListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAsync = ref.watch(activeShoppingListsDomainProvider);
    final archivedAsync = ref.watch(archivedShoppingListsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Lists'),
        actions: [
          IconButton(
            onPressed: () => _showCreateDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: activeAsync.when(
        data: (activeLists) {
          final archivedLists = archivedAsync.valueOrNull ?? [];
          if (activeLists.isEmpty && archivedLists.isEmpty) {
            return const _EmptyState();
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              // Active lists
              if (activeLists.isNotEmpty) ...[
                _SectionHeader(
                  title: 'Active',
                  count: activeLists.length,
                ),
                ...activeLists.map((list) => ShoppingListCard(
                      list: list,
                      onTap: () => _openDetail(context, list.id),
                      onArchive: () => _archiveList(ref, list.id),
                      onDelete: () => _deleteList(ref, list.id),
                    )),
              ],

              // Archived lists
              if (archivedLists.isNotEmpty)
                _ArchivedSection(
                  lists: archivedLists,
                  onTap: (id) => _openDetail(context, id),
                  onRestore: (id) => _restoreList(ref, id),
                  onDelete: (id) => _deleteList(ref, id),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog<ShoppingList>(
      context: context,
      builder: (_) => const CreateListDialog(),
    );
  }

  void _openDetail(BuildContext context, String listId) {
    context.go('${Routes.lists}/$listId');
  }

  Future<void> _archiveList(WidgetRef ref, String id) async {
    await ref.read(shoppingListDaoProvider).archiveList(id);
  }

  Future<void> _restoreList(WidgetRef ref, String id) async {
    final dao = ref.read(shoppingListDaoProvider);
    await dao.updateList(db.ShoppingListsCompanion(
      id: Value(id),
      isArchived: const Value(false),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> _deleteList(WidgetRef ref, String id) async {
    await ref.read(shoppingListDaoProvider).deleteList(id);
  }
}

// ── Section header ──────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(width: 6),
          Text(
            '($count)',
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Archived section (collapsible) ──────────────────────────

class _ArchivedSection extends StatefulWidget {
  final List<ShoppingList> lists;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRestore;
  final ValueChanged<String> onDelete;

  const _ArchivedSection({
    required this.lists,
    required this.onTap,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  State<_ArchivedSection> createState() => _ArchivedSectionState();
}

class _ArchivedSectionState extends State<_ArchivedSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Text(
                  'Archived',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${widget.lists.length})',
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          ...widget.lists.map((list) => ShoppingListCard(
                list: list,
                onTap: () => widget.onTap(list.id),
                onArchive: () => widget.onRestore(list.id),
                onDelete: () => widget.onDelete(list.id),
              )),
      ],
    );
  }
}

// ── Empty state ─────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No shopping lists yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap + to create your first list',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
