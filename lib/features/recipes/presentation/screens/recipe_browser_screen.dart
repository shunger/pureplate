import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/recipe_providers.dart';
import '../widgets/recipe_widgets.dart';

/// Recipe browser — search, filter by cuisine, grid of recipe cards.
class RecipeBrowserScreen extends ConsumerWidget {
  const RecipeBrowserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredRecipesProvider);
    final cuisinesAsync = ref.watch(availableCuisinesProvider);
    final selectedCuisine = ref.watch(recipeCuisineFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              onChanged: (v) =>
                  ref.read(recipeSearchQueryProvider.notifier).state = v,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.divider),
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
                        label: const Text('All'),
                        selected: selectedCuisine == null,
                        onSelected: (_) => ref
                            .read(recipeCuisineFilterProvider.notifier)
                            .state = null,
                      ),
                    ),
                    ...cuisines.map((cuisine) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cuisine),
                            selected: selectedCuisine == cuisine,
                            onSelected: (_) => ref
                                .read(recipeCuisineFilterProvider.notifier)
                                .state = selectedCuisine == cuisine
                                ? null
                                : cuisine,
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
                            color: AppColors.textTertiary.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        const Text(
                          'No recipes found',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Generate a meal plan to add recipes',
                          style: TextStyle(
                            color: AppColors.textTertiary,
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
