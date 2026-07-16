import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/database_providers.dart';
import '../providers/recipe_providers.dart';
import '../widgets/recipe_widgets.dart';

/// Full recipe detail — hero image, ingredients, instructions, nutrition.
class RecipeDetailScreen extends ConsumerStatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  final _checkedIngredients = <int>{};
  final _picker = ImagePicker();

  Future<void> _showImageSourceSheet() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    await _pickImage(source);
  }

  Future<void> _pickImage(ImageSource source) async {
    final xFile = await _picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (xFile == null) return;

    final docsDir = await getApplicationDocumentsDirectory();
    final imgDir = Directory(p.join(docsDir.path, 'recipe_images'));
    if (!imgDir.existsSync()) {
      imgDir.createSync(recursive: true);
    }

    final destPath = p.join(imgDir.path, '${widget.recipeId}.jpg');
    await File(xFile.path).copy(destPath);

    ref.read(recipeDaoProvider).updateImageUrl(widget.recipeId, destPath);
  }

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeDetailProvider(widget.recipeId));

    return recipeAsync.when(
      loading: () => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.coral),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
      data: (recipe) {
        if (recipe == null) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(),
            body: const Center(child: Text('Recipe not found')),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              // Hero app bar
              SliverAppBar(
                expandedHeight: recipe.imageUrl != null ? 250 : 180,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    tooltip: 'Add photo',
                    onPressed: _showImageSourceSheet,
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    tooltip: 'Favorite recipe',
                    onPressed: () {
                      ref
                          .read(recipeDaoProvider)
                          .toggleFavorite(recipe.id, true);
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: recipe.imageUrl != null
                      ? RecipeImage(
                          imageUrl: recipe.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                          placeholder: Container(
                            color: AppColors.coral.withValues(alpha: 0.1),
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.coralLight),
                            ),
                          ),
                          errorWidget: Container(
                            color: AppColors.coral.withValues(alpha: 0.1),
                            child: const Center(
                              child: Icon(Icons.restaurant,
                                  size: 64, color: AppColors.coralLight),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: _showImageSourceSheet,
                          child: Container(
                            color: AppColors.coral.withValues(alpha: 0.08),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.camera_alt,
                                      size: 40,
                                      color: AppColors.coral
                                          .withValues(alpha: 0.5)),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add your photo',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.coral
                                          .withValues(alpha: 0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),

              // Recipe header info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      if (recipe.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          recipe.description!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      // Meta row
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          _MetaChip(
                            icon: Icons.schedule,
                            label: recipe.totalTimeDisplay,
                          ),
                          _MetaChip(
                            icon: Icons.people_outline,
                            label: '${recipe.servings} servings',
                          ),
                          if (recipe.cuisine != null)
                            _MetaChip(
                              icon: Icons.restaurant,
                              label: recipe.cuisine!,
                            ),
                          if (recipe.difficulty != null)
                            _MetaChip(
                              icon: Icons.signal_cellular_alt,
                              label: recipe.difficulty!,
                            ),
                        ],
                      ),
                      // Dietary flags
                      if (recipe.isVegetarian ||
                          recipe.isVegan ||
                          recipe.isGlutenFree ||
                          recipe.isDairyFree ||
                          recipe.isNutFree) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          children: [
                            if (recipe.isVegetarian)
                              _DietaryBadge(label: 'Vegetarian'),
                            if (recipe.isVegan) _DietaryBadge(label: 'Vegan'),
                            if (recipe.isGlutenFree)
                              _DietaryBadge(label: 'Gluten-Free'),
                            if (recipe.isDairyFree)
                              _DietaryBadge(label: 'Dairy-Free'),
                            if (recipe.isNutFree)
                              _DietaryBadge(label: 'Nut-Free'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Ingredients section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingredients',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      ...recipe.ingredients.asMap().entries.map((entry) {
                        final index = entry.key;
                        final ingredient = entry.value;
                        return IngredientTile(
                          ingredient: ingredient,
                          checked: _checkedIngredients.contains(index),
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                _checkedIngredients.add(index);
                              } else {
                                _checkedIngredients.remove(index);
                              }
                            });
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Instructions section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instructions',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      ...recipe.instructions.map((step) =>
                          InstructionStepTile(step: step)),
                    ],
                  ),
                ),
              ),

              // Nutrition section
              if (recipe.nutrition != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nutrition (per serving)',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _NutrientValue(
                                    label: 'Calories',
                                    value: '${recipe.nutrition!.calories}'),
                                _NutrientValue(
                                    label: 'Protein',
                                    value:
                                        '${recipe.nutrition!.proteinG.round()}g'),
                                _NutrientValue(
                                    label: 'Carbs',
                                    value:
                                        '${recipe.nutrition!.carbsG.round()}g'),
                                _NutrientValue(
                                    label: 'Fat',
                                    value:
                                        '${recipe.nutrition!.fatG.round()}g'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: FilledButton.icon(
                onPressed: () =>
                    context.push('/cooking/${widget.recipeId}'),
                icon: const Icon(Icons.restaurant),
                label: const Text('Start Cooking'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.coral,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

class _DietaryBadge extends StatelessWidget {
  final String label;

  const _DietaryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.sage.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.sageDark,
        ),
      ),
    );
  }
}

class _NutrientValue extends StatelessWidget {
  final String label;
  final String value;

  const _NutrientValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
