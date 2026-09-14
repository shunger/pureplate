import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/ai_quota.dart';
import '../../domain/models/meal_plan.dart';
import '../../../recipes/domain/models/recipe.dart';
import '../../../recipes/domain/models/ingredient.dart';
import '../../../recipes/domain/models/instruction_step.dart';
import '../../../recipes/domain/models/nutrition_info.dart';

/// Repository that calls the Cloud Function to generate AI meal plans.
///
/// The Cloud Function handles:
/// - Security (auth, rate limit, quota, blocklist, kill switch)
/// - Prompt construction from preference summary
/// - AWS Bedrock / vLLM invocation
/// - Response validation
///
/// This repository only handles serialization and local persistence.
class AiPlanRepository {
  final FirebaseFunctions _functions;
  final Uuid _uuid = const Uuid();

  AiPlanRepository(this._functions);

  /// Generate a meal plan for [numDays] days.
  ///
  /// [preferenceSummary] is the JSON blob from PreferenceSummaryBuilder.
  /// [dayLabels] are the day names ("Monday", "Tuesday", ...).
  ///
  /// Returns a [GeneratedPlanResult] with the meal plan and recipes.
  /// Throws [AiPlanException] on failure.
  Future<GeneratedPlanResult> generatePlan({
    required int numDays,
    required List<String> dayLabels,
    required Map<String, dynamic> preferenceSummary,
    String mealType = 'dinner',
  }) async {
    try {
      final result = await _functions.httpsCallable('generatePlan').call({
        'feature': 'quick_plan',
        'days': numDays,
        'dayLabels': dayLabels,
        'mealType': mealType,
        'preferenceSummary': preferenceSummary,
      });

      final data = _deepCast(result.data);
      return _parseResponse(data, numDays);
    } on FirebaseFunctionsException catch (e) {
      throw AiPlanException(
        _userFriendlyMessage(e.code, e.message),
        code: e.code,
      );
    } catch (e, stackTrace) {
      debugPrint('AiPlanRepository error: $e');
      debugPrint('AiPlanRepository stack: $stackTrace');
      throw AiPlanException(
        'Something went wrong generating your plan. Try again?',
        code: 'unknown',
      );
    }
  }

  GeneratedPlanResult _parseResponse(
      Map<String, dynamic> data, int numDays) {
    final planData = data['plan'] as Map<String, dynamic>;
    final daysData = planData['days'] as List<dynamic>;
    final shoppingData = data['shopping_list'] as List<dynamic>?;

    final planId = _uuid.v4();
    final now = DateTime.now();
    final startDate = _nextMonday(now);

    final recipes = <Recipe>[];
    final planDays = <MealPlanDay>[];

    for (var i = 0; i < daysData.length; i++) {
      final dayMap = daysData[i] as Map<String, dynamic>;
      final mealMap = dayMap['meal'] as Map<String, dynamic>;
      final recipeId = _uuid.v4();

      final recipe = Recipe(
        id: recipeId,
        name: mealMap['name'] as String,
        description: mealMap['description'] as String?,
        cuisine: mealMap['cuisine'] as String?,
        prepTimeMinutes: mealMap['prep_time'] as int? ?? 0,
        cookTimeMinutes: mealMap['cook_time'] as int? ?? 0,
        servings: mealMap['servings'] as int? ?? 4,
        ingredients: _parseIngredients(mealMap['ingredients'] as List?),
        instructions: _parseInstructions(mealMap['instructions'] as List?),
        nutrition: mealMap['nutrition'] != null
            ? NutritionInfo.fromJson(mealMap['nutrition'])
            : null,
        source: RecipeSource.aiGenerated,
        aiMetadata: {'plan_id': planId, 'day_index': i},
        createdAt: now,
      );
      recipes.add(recipe);

      planDays.add(MealPlanDay(
        id: _uuid.v4(),
        planId: planId,
        date: startDate.add(Duration(days: i)),
        recipeId: recipeId,
        recipeName: recipe.name,
        sortOrder: i,
      ));
    }

    final plan = MealPlan(
      id: planId,
      createdAt: now,
      startDate: startDate,
      endDate: startDate.add(Duration(days: numDays - 1)),
      planType: PlanType.quick,
      days: planDays,
    );

    // Parse the AI-suggested shopping list items.
    final shoppingItems = shoppingData
            ?.cast<Map<String, dynamic>>()
            .map((item) => AiShoppingItem(
                  name: item['name'] as String,
                  quantity: item['quantity'] as String?,
                  unit: item['unit'] as String?,
                  category: item['category'] as String?,
                ))
            .toList() ??
        [];

    return GeneratedPlanResult(
      plan: plan,
      recipes: recipes,
      suggestedShoppingItems: shoppingItems,
      quota: AiQuotaStatus.fromJson(data['quota'] as Map<String, dynamic>?),
    );
  }

  List<Ingredient> _parseIngredients(List<dynamic>? data) {
    if (data == null) return [];
    return data.cast<Map<String, dynamic>>().map((m) {
      return Ingredient(
        name: m['name'] as String,
        quantity: m['quantity']?.toString(),
        unit: m['unit'] as String?,
        category: m['category'] as String?,
        optional: m['optional'] as bool? ?? false,
      );
    }).toList();
  }

  List<InstructionStep> _parseInstructions(List<dynamic>? data) {
    if (data == null) return [];
    return data.cast<Map<String, dynamic>>().map((m) {
      return InstructionStep(
        stepNumber: m['step_number'] as int? ?? 0,
        instruction: m['instruction'] as String,
        timeMinutes: m['time_minutes'] as int?,
        tip: m['tip'] as String?,
      );
    }).toList();
  }

  /// Recursively converts Firebase response data (which may contain
  /// Map<Object?, Object?> on iOS) to Map<String, dynamic>.
  Map<String, dynamic> _deepCast(dynamic data) {
    if (data is Map) {
      return data.map((key, value) => MapEntry(
            key.toString(),
            value is Map
                ? _deepCast(value)
                : value is List
                    ? _deepCastList(value)
                    : value,
          ));
    }
    throw ArgumentError('Expected Map, got ${data.runtimeType}');
  }

  List<dynamic> _deepCastList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map) return _deepCast(item);
      if (item is List) return _deepCastList(item);
      return item;
    }).toList();
  }

  DateTime _nextMonday(DateTime from) {
    final daysUntilMonday = (DateTime.monday - from.weekday + 7) % 7;
    if (daysUntilMonday == 0) return from;
    return DateTime(from.year, from.month, from.day + daysUntilMonday);
  }

  String _userFriendlyMessage(String code, String? serverMessage) {
    switch (code) {
      case 'invalid-argument':
        // The server explains what to fix ("A meal plan can be 1 to 14 days…").
        return (serverMessage != null && serverMessage.isNotEmpty)
            ? serverMessage
            : 'Something went wrong generating your plan. Try again?';
      case 'resource-exhausted':
        return "You've used all your free plans this week. Upgrade to Premium for unlimited plans!";
      case 'unavailable':
        return "The meal planner is temporarily unavailable. Try again in a moment.";
      case 'permission-denied':
        return 'Your account has been restricted. Contact support for help.';
      case 'deadline-exceeded':
        return 'The request timed out. Check your connection and try again.';
      default:
        return 'Something went wrong generating your plan. Try again?';
    }
  }
}

/// Result of a plan generation call.
class GeneratedPlanResult {
  final MealPlan plan;
  final List<Recipe> recipes;
  final List<AiShoppingItem> suggestedShoppingItems;

  /// Weekly usage after this call, or null if the backend did not report it.
  final AiQuotaStatus? quota;

  const GeneratedPlanResult({
    required this.plan,
    required this.recipes,
    required this.suggestedShoppingItems,
    this.quota,
  });
}

/// A shopping item suggested by the AI (before pantry deduction).
class AiShoppingItem {
  final String name;
  final String? quantity;
  final String? unit;
  final String? category;

  const AiShoppingItem({
    required this.name,
    this.quantity,
    this.unit,
    this.category,
  });
}

class AiPlanException implements Exception {
  final String message;
  final String code;
  const AiPlanException(this.message, {required this.code});

  @override
  String toString() => message;
}

/// Provider for the AI plan repository.
final aiPlanRepositoryProvider = Provider<AiPlanRepository>((ref) {
  return AiPlanRepository(FirebaseFunctions.instance);
});
