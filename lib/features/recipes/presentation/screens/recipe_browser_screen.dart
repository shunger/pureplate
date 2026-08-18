import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/database_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/voice_input_button.dart';
import '../../domain/models/recipe.dart';
import '../providers/recipe_providers.dart';
import '../widgets/recipe_widgets.dart';

/// Recipe browser — search, filter by cuisine, grid of recipe cards.
class RecipeBrowserScreen extends ConsumerStatefulWidget {
  const RecipeBrowserScreen({super.key});

  @override
  ConsumerState<RecipeBrowserScreen> createState() =>
      _RecipeBrowserScreenState();
}

class _RecipeBrowserScreenState extends ConsumerState<RecipeBrowserScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(recipeSearchQueryProvider.notifier).state =
          _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(Recipe recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: Text('Are you sure you want to delete "${recipe.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(recipeDaoProvider).deleteRecipe(recipe.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${recipe.name} deleted'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(filteredRecipesProvider);
    final cuisinesAsync = ref.watch(availableCuisinesProvider);
    final selectedCuisine = ref.watch(recipeCuisineFilterProvider);
    final favoritesOnly = ref.watch(recipeFavoritesOnlyProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: VoiceInputButton(controller: _searchController),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                ),
              ),
            ),
          ),

          // Cuisine filter chips
          cuisinesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (cuisines) {
              if (cuisines.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        avatar: Icon(
                          favoritesOnly ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: favoritesOnly ? Colors.white : AppColors.coral,
                        ),
                        label: const Text('Saved'),
                        selected: favoritesOnly,
                        selectedColor: AppColors.coral,
                        labelStyle: TextStyle(
                          color: favoritesOnly ? Colors.white : null,
                        ),
                        onSelected: (selected) {
                          ref.read(recipeFavoritesOnlyProvider.notifier).state =
                              selected;
                          if (selected) {
                            ref.read(recipeCuisineFilterProvider.notifier).state =
                                null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('All'),
                        selected: selectedCuisine == null && !favoritesOnly,
                        onSelected: (_) {
                          ref.read(recipeCuisineFilterProvider.notifier).state =
                              null;
                          ref.read(recipeFavoritesOnlyProvider.notifier).state =
                              false;
                        },
                      ),
                    ),
                    ...cuisines.map((cuisine) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cuisine),
                            selected: selectedCuisine == cuisine && !favoritesOnly,
                            onSelected: (_) {
                              ref.read(recipeFavoritesOnlyProvider.notifier).state =
                                  false;
                              ref.read(recipeCuisineFilterProvider.notifier).state =
                                  selectedCuisine == cuisine ? null : cuisine;
                            },
                          ),
                        )),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          // Recipe grid
          Expanded(
            child: filteredAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.coral),
              ),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (recipes) {
                if (recipes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book,
                            size: 48,
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text(
                          favoritesOnly
                              ? 'No saved recipes'
                              : 'No recipes found',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          favoritesOnly
                              ? 'Tap the heart icon on a recipe to save it'
                              : 'Generate a meal plan to add recipes',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () => context.push('/recipes/${recipe.id}'),
                      onLongPress: () => _confirmDelete(recipe),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
