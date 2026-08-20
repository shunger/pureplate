import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../shared/models/product_category.dart';
import '../../../meal_plan/presentation/providers/meal_plan_providers.dart';
import '../../../pantry/data/services/pantry_consumption_service.dart';
import '../../../pantry/domain/models/pantry_item.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../shopping_list/data/datasources/auto_list_generator.dart';
import '../../../shopping_list/data/datasources/shopping_list_mapper.dart';
import '../../../shopping_list/domain/models/shopping_list.dart';
import '../../../shopping_list/presentation/providers/shopping_list_providers.dart';
import '../../data/datasources/recipe_mapper.dart';
import '../../domain/models/recipe.dart';
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

  Future<void> _shareAsPdf(BuildContext context, Recipe recipe) async {
    // Premium gate.
    final isPremium = ref.read(isPremiumProvider);
    final premium = isPremium.whenOrNull(data: (v) => v) ?? false;
    if (!premium) {
      context.push(Routes.premium);
      return;
    }

    // Capture the share button position for the iOS share popover.
    final box = context.findRenderObject() as RenderBox?;
    final shareOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : Rect.fromLTWH(0, 0, 100, 100);

    ScaffoldMessenger.of(this.context).showSnackBar(
      const SnackBar(
        content: Text('Generating PDF...'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );

    try {
      final pdfBytes =
          await ref.read(recipePdfServiceProvider).generatePdf(recipe);

      final tempDir = await getTemporaryDirectory();
      final safeName =
          recipe.name.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
      final file = File(p.join(tempDir.path, '$safeName.pdf'));
      await file.writeAsBytes(pdfBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        sharePositionOrigin: shareOrigin,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showAssignToMealPlanSheet(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AssignToMealPlanSheet(recipe: recipe),
    );
  }

  Future<void> _showAddToListSheet(Recipe recipe) async {
    // Fetch pantry items and compute missing ingredients.
    final pantryDao = ref.read(pantryDaoProvider);
    final dbPantryItems = await pantryDao.getAllItems();
    final domainPantryItems = dbPantryItems
        .map((item) => PantryItem(
              id: item.id,
              name: item.name,
              category: ProductCategory.values.firstWhere(
                (c) => c.name == item.category,
                orElse: () => ProductCategory.other,
              ),
              quantity: item.quantity,
              unitType: item.unitType,
              createdAt: item.createdAt,
            ))
        .toList();

    final generator = ref.read(autoListGeneratorProvider);
    final generatedList = generator.generate(
      recipes: [recipe],
      pantryItems: domainPantryItems,
      mealPlanId: '', // Not from a meal plan.
    );

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AddToListSheet(
        missingItems: generatedList.items,
        recipeName: recipe.name,
      ),
    );
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
                    icon: const Icon(Icons.auto_awesome),
                    tooltip: 'Modify with AI',
                    onPressed: () {
                      final isPremium = ref.read(isPremiumProvider);
                      final premium =
                          isPremium.whenOrNull(data: (v) => v) ?? false;
                      if (!premium) {
                        context.push(Routes.premium);
                      } else {
                        context.push('/recipes/${recipe.id}/chat');
                      }
                    },
                  ),
                  Builder(
                    builder: (btnContext) => IconButton(
                      icon: const Icon(Icons.share_outlined),
                      tooltip: 'Share as PDF',
                      onPressed: () => _shareAsPdf(btnContext, recipe),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month_outlined),
                    tooltip: 'Add to meal plan',
                    onPressed: () => _showAssignToMealPlanSheet(recipe),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    tooltip: 'Add to shopping list',
                    onPressed: () => _showAddToListSheet(recipe),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    tooltip: 'Add photo',
                    onPressed: _showImageSourceSheet,
                  ),
                  IconButton(
                    icon: Icon(
                      recipe.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: recipe.isFavorite ? AppColors.coral : null,
                    ),
                    tooltip: recipe.isFavorite
                        ? 'Remove from favorites'
                        : 'Add to favorites',
                    onPressed: () {
                      ref
                          .read(recipeDaoProvider)
                          .toggleFavorite(
                              recipe.id, !recipe.isFavorite);
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
          bottomNavigationBar: _BottomCookingBar(
            recipeId: widget.recipeId,
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

// ── Bottom Cooking Bar ────────────────────────────────────

String _consumptionMessage(String recipeName, ConsumptionResult? result) {
  if (result == null || result.deductedCount == 0) {
    return '$recipeName marked as cooked';
  }
  final parts = <String>[
    'Pantry updated — ${result.deductedCount} item${result.deductedCount == 1 ? '' : 's'} deducted',
  ];
  if (result.addedToListCount > 0) {
    parts.add(
      '${result.addedToListCount} added to ${result.shoppingListName ?? 'shopping list'}',
    );
  }
  return parts.join(', ');
}

class _BottomCookingBar extends ConsumerWidget {
  final String recipeId;

  const _BottomCookingBar({required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysAsync = ref.watch(mealPlanDaysForRecipeProvider(recipeId));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: daysAsync.when(
          loading: () => _cookingRow(context, ref),
          error: (_, _) => _cookingRow(context, ref),
          data: (days) {
            final uncookedDays =
                days.where((d) => !d.isCooked).toList();
            final allCooked =
                days.isNotEmpty && uncookedDays.isEmpty;

            // Not in any plan — just "Start Cooking" + voice
            if (days.isEmpty) {
              return _cookingRow(context, ref);
            }

            // All matching days already cooked
            if (allCooked) {
              return Row(
                children: [
                  _voiceCookingButton(context, ref),
                  const SizedBox(width: 8),
                  Expanded(child: _startCookingButton(context)),
                  const SizedBox(width: 12),
                  const Icon(Icons.check_circle,
                      color: AppColors.sage, size: 28),
                  const SizedBox(width: 4),
                  Text(
                    'Cooked',
                    style: TextStyle(
                      color: AppColors.sage,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            }

            // Has uncooked days — show all buttons
            return Row(
              children: [
                _voiceCookingButton(context, ref),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.push('/cooking/$recipeId'),
                    icon: const Icon(Icons.restaurant),
                    label: const Text('Start Cooking'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.coral,
                      side: const BorderSide(color: AppColors.coral),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      final day = uncookedDays.first;
                      await ref
                          .read(mealPlanDaoProvider)
                          .markCooked(day.id, true);

                      // Deduct pantry items.
                      ConsumptionResult? result;
                      final dbRecipe = await ref
                          .read(recipeDaoProvider)
                          .getRecipeById(recipeId);
                      if (dbRecipe != null) {
                        final recipe = RecipeMapper.fromDb(dbRecipe);
                        result = await ref
                            .read(pantryConsumptionServiceProvider)
                            .deductIngredientsForRecipe(
                              recipe: recipe,
                              pantryDao: ref.read(pantryDaoProvider),
                              shoppingListDao:
                                  ref.read(shoppingListDaoProvider),
                            );
                      }

                      if (context.mounted) {
                        final msg = _consumptionMessage(
                          day.recipeName,
                          result,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msg),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Mark Cooked'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.sage,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Start Cooking button + voice cooking button side by side.
  Widget _cookingRow(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        _voiceCookingButton(context, ref),
        const SizedBox(width: 8),
        Expanded(child: _startCookingButton(context)),
      ],
    );
  }

  Widget _startCookingButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => context.push('/cooking/$recipeId'),
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
    );
  }

  Widget _voiceCookingButton(BuildContext context, WidgetRef ref) {
    return IconButton.filled(
      onPressed: () {
        final isPremium = ref.read(isPremiumProvider);
        final premium = isPremium.whenOrNull(data: (v) => v) ?? false;
        if (!premium) {
          context.push(Routes.premium);
        } else {
          context.push('/voice-cooking/$recipeId');
        }
      },
      icon: const Icon(Icons.headset_mic, size: 22),
      tooltip: 'Voice cooking assistant',
      style: IconButton.styleFrom(
        backgroundColor: AppColors.coral.withValues(alpha: 0.12),
        foregroundColor: AppColors.coral,
        padding: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    );
  }
}

// ── Assign to Meal Plan Bottom Sheet ──────────────────────

const _kNewPlanId = '__new_plan__';

class _AssignToMealPlanSheet extends ConsumerStatefulWidget {
  final Recipe recipe;

  const _AssignToMealPlanSheet({required this.recipe});

  @override
  ConsumerState<_AssignToMealPlanSheet> createState() =>
      _AssignToMealPlanSheetState();
}

class _AssignToMealPlanSheetState
    extends ConsumerState<_AssignToMealPlanSheet> {
  DateTime _selectedDate = DateTime.now();
  String _selectedMealType = 'dinner';
  String _selectedPlanId = _kNewPlanId;
  bool _isSaving = false;

  static const _mealTypes = ['breakfast', 'lunch', 'dinner'];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      final dao = ref.read(mealPlanDaoProvider);
      final uuid = const Uuid();
      final dateOnly = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );

      String targetPlanId;

      if (_selectedPlanId == _kNewPlanId) {
        targetPlanId = uuid.v4();
        final now = DateTime.now();
        await dao.insertPlan(db.MealPlansCompanion(
          id: Value(targetPlanId),
          createdAt: Value(now),
          startDate: Value(dateOnly),
          endDate: Value(dateOnly),
          planType: const Value('quick'),
        ));
      } else {
        targetPlanId = _selectedPlanId;
      }

      await dao.insertPlanDays([
        db.MealPlanDaysCompanion(
          id: Value(uuid.v4()),
          planId: Value(targetPlanId),
          date: Value(dateOnly),
          recipeId: Value(widget.recipe.id),
          recipeName: Value(widget.recipe.name),
          mealType: Value(_selectedMealType),
        ),
      ]);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${widget.recipe.name} added to $_selectedMealType on '
              '${DateFormat.MMMd().format(dateOnly)}',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plansAsync = ref.watch(allMealPlansDomainProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add to Meal Plan',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          // Date picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: const Icon(Icons.calendar_today, size: 20),
                ),
                child: Text(
                  DateFormat.yMMMEd().format(_selectedDate),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
          ),
          // Meal type selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SegmentedButton<String>(
              segments: _mealTypes
                  .map((t) => ButtonSegment(
                        value: t,
                        label: Text(t[0].toUpperCase() + t.substring(1)),
                      ))
                  .toList(),
              selected: {_selectedMealType},
              onSelectionChanged: (v) =>
                  setState(() => _selectedMealType = v.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          // Plan picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: plansAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (plans) {
                final items = <DropdownMenuItem<String>>[
                  const DropdownMenuItem(
                    value: _kNewPlanId,
                    child: Text('New plan'),
                  ),
                  ...plans.map((plan) => DropdownMenuItem(
                        value: plan.id,
                        child: Text(
                          '${DateFormat.MMMd().format(plan.startDate)}'
                          ' – ${DateFormat.MMMd().format(plan.endDate)}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                ];

                return DropdownButtonFormField<String>(
                  initialValue: _selectedPlanId,
                  decoration: InputDecoration(
                    labelText: 'Meal plan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: items,
                  onChanged: (v) =>
                      setState(() => _selectedPlanId = v ?? _kNewPlanId),
                );
              },
            ),
          ),
          // Save button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(_isSaving ? 'Adding...' : 'Add to Plan'),
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
        ],
      ),
    );
  }

}

// ── Add to Shopping List Bottom Sheet ──────────────────────

/// Sentinel value for the "New list" option in the list picker.
const _kNewListId = '__new_list__';

class _AddToListSheet extends ConsumerStatefulWidget {
  final List<ShoppingListItem> missingItems;
  final String recipeName;

  const _AddToListSheet({
    required this.missingItems,
    required this.recipeName,
  });

  @override
  ConsumerState<_AddToListSheet> createState() => _AddToListSheetState();
}

class _AddToListSheetState extends ConsumerState<_AddToListSheet> {
  late final Set<String> _checkedItemIds;
  String? _selectedListId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // All items checked by default.
    _checkedItemIds = widget.missingItems.map((i) => i.id).toSet();
  }

  Future<void> _addItems() async {
    final selectedItems = widget.missingItems
        .where((i) => _checkedItemIds.contains(i.id))
        .toList();
    if (selectedItems.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final dao = ref.read(shoppingListDaoProvider);
      final uuid = const Uuid();
      String targetListId;

      if (_selectedListId == null || _selectedListId == _kNewListId) {
        // Create a new list.
        targetListId = uuid.v4();
        final now = DateTime.now();
        final newList = ShoppingList(
          id: targetListId,
          name: widget.recipeName,
          source: ShoppingListSource.manual,
          createdAt: now,
        );
        await dao.insertList(ShoppingListMapper.listToCompanion(newList));
      } else {
        targetListId = _selectedListId!;
      }

      // Re-map items to target list with new IDs.
      final companions = selectedItems.map((item) {
        final remapped = item.copyWith(
          id: uuid.v4(),
          listId: targetListId,
        );
        return ShoppingListMapper.itemToCompanion(remapped);
      }).toList();

      await dao.insertItems(companions);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${selectedItems.length} item${selectedItems.length == 1 ? '' : 's'} added to list',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listsAsync = ref.watch(activeShoppingListsDomainProvider);

    // Nothing missing — everything is in pantry.
    if (widget.missingItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 56, color: AppColors.sage),
            const SizedBox(height: 16),
            Text(
              'You have everything!',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'All ingredients for this recipe are already in your pantry.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Add to Shopping List',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_checkedItemIds.length ==
                          widget.missingItems.length) {
                        _checkedItemIds.clear();
                      } else {
                        _checkedItemIds.addAll(
                          widget.missingItems.map((i) => i.id),
                        );
                      }
                    });
                  },
                  child: Text(
                    _checkedItemIds.length == widget.missingItems.length
                        ? 'Deselect all'
                        : 'Select all',
                    style: TextStyle(color: AppColors.coral),
                  ),
                ),
              ],
            ),
          ),
          // Item list
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: widget.missingItems.length,
              itemBuilder: (context, index) {
                final item = widget.missingItems[index];
                final checked = _checkedItemIds.contains(item.id);
                final qtyDisplay = item.quantityNeeded % 1 == 0
                    ? item.quantityNeeded.toInt().toString()
                    : item.quantityNeeded.toStringAsFixed(1);
                final unitDisplay =
                    item.unitType == 'count' ? '' : ' ${item.unitType}';

                return CheckboxListTile(
                  value: checked,
                  activeColor: AppColors.coral,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(item.name),
                  subtitle: Text(
                    '$qtyDisplay$unitDisplay',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  secondary: Text(
                    item.category.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _checkedItemIds.add(item.id);
                      } else {
                        _checkedItemIds.remove(item.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
          // List picker + add button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // List selector
                listsAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (lists) {
                    final items = <DropdownMenuItem<String>>[
                      const DropdownMenuItem(
                        value: _kNewListId,
                        child: Text('New list'),
                      ),
                      ...lists.map((l) => DropdownMenuItem(
                            value: l.id,
                            child: Text(
                              l.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ];

                    return DropdownButtonFormField<String>(
                      initialValue: _selectedListId ?? _kNewListId,
                      decoration: InputDecoration(
                        labelText: 'Shopping list',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      items: items,
                      onChanged: (v) =>
                          setState(() => _selectedListId = v),
                    );
                  },
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _checkedItemIds.isEmpty || _isSaving
                      ? null
                      : _addItems,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add_shopping_cart),
                  label: Text(
                    _isSaving
                        ? 'Adding...'
                        : 'Add ${_checkedItemIds.length} item${_checkedItemIds.length == 1 ? '' : 's'}',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
