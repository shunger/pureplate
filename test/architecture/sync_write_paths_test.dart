import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Writes to pantry items and shopping list items must go through
/// `PantrySyncOrchestrator` / `ShoppingListSyncOrchestrator`. A direct DAO
/// write never reaches shared pantries and lists — or Smart Shopping Scanner
/// users sharing them.
void main() {
  const syncedWrites = [
    'insertItem',
    'insertItems',
    'updateItem',
    'deleteItem',
    'toggleItemCompletion',
    'clearCompletedItems',
    'checkAllItems',
    'resetAllItems',
    'deleteAllItemsForList',
    'moveItems',
    'deleteList',
    'updateQuantity',
    'updateStatus',
    'updateLocation',
    'updateStapleSettings',
  ];

  // Files that may write directly, and why.
  const allowed = {
    'lib/features/pantry/data/datasources/pantry_sync_orchestrator.dart':
        'is the pantry sync layer',
    'lib/features/shopping_list/data/datasources/shopping_list_sync_orchestrator.dart':
        'is the shopping list sync layer',
    'lib/features/shopping_list/data/services/shopping_list_merge_service.dart':
        'fills a list it just created, which is not shared',
    'lib/features/meal_plan/presentation/providers/plan_generation_providers.dart':
        'fills a list it just created, which is not shared',
  };

  test('pantry and shopping list writes go through the sync orchestrators',
      () {
    final call = RegExp(
      r'\b(\w*(?:pantryDao|shoppingListDao|PantryDao|ShoppingListDao)\w*\)?|dao)'
      r'\s*\.\s*(' '${syncedWrites.join('|')}' r')\(',
    );

    final violations = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'))
        .where((f) => !f.path.startsWith('lib/core/database/daos/'));

    for (final file in files) {
      if (allowed.containsKey(file.path)) continue;
      // Match against the whole file: calls are often chained across lines,
      // e.g. `ref\n  .read(shoppingListDaoProvider)\n  .deleteItem(id)`.
      final source = file.readAsStringSync();
      for (final match in call.allMatches(source)) {
        final line = '\n'.allMatches(source.substring(0, match.start)).length + 1;
        final snippet = match.group(0)!.replaceAll(RegExp(r'\s+'), '');
        violations.add('${file.path}:$line  $snippet');
      }
    }

    expect(violations, isEmpty,
        reason: 'Route these writes through the sync orchestrators, or add '
            'the file to `allowed` with a reason:\n${violations.join('\n')}');
  });
}
