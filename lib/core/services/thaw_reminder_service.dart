import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/daos/meal_plan_dao.dart';
import '../database/daos/pantry_dao.dart';
import '../database/daos/recipe_dao.dart';
import 'notification_service.dart';

/// Checks upcoming meals for ingredients stored in the freezer and schedules
/// thaw reminder notifications.
///
/// Defaults:
/// - Night before: 8 PM (enabled)
/// - Morning of: 7 AM (enabled)
class ThawReminderService {
  final MealPlanDao _mealPlanDao;
  final PantryDao _pantryDao;
  final RecipeDao _recipeDao;
  final NotificationService _notificationService;

  // SharedPreferences keys.
  static const keyNightBeforeEnabled = 'notif_thaw_night_before';
  static const keyMorningOfEnabled = 'notif_thaw_morning_of';
  static const keyNightBeforeHour = 'notif_thaw_night_before_hour';
  static const keyNightBeforeMinute = 'notif_thaw_night_before_minute';
  static const keyMorningOfHour = 'notif_thaw_morning_of_hour';
  static const keyMorningOfMinute = 'notif_thaw_morning_of_minute';

  // Defaults.
  static const defaultNightBeforeHour = 20; // 8 PM
  static const defaultNightBeforeMinute = 0;
  static const defaultMorningOfHour = 7; // 7 AM
  static const defaultMorningOfMinute = 0;

  ThawReminderService({
    required MealPlanDao mealPlanDao,
    required PantryDao pantryDao,
    required RecipeDao recipeDao,
    required NotificationService notificationService,
  })  : _mealPlanDao = mealPlanDao,
        _pantryDao = pantryDao,
        _recipeDao = recipeDao,
        _notificationService = notificationService;

  /// Schedule thaw reminders for tomorrow's meals that use frozen ingredients.
  Future<void> scheduleThawReminders() async {
    try {
      // Cancel any previously scheduled thaw reminders.
      await _notificationService.cancelById(NotificationService.thawNightBeforeId);
      await _notificationService.cancelById(NotificationService.thawMorningOfId);

      final prefs = await SharedPreferences.getInstance();
      final nightBeforeEnabled = prefs.getBool(keyNightBeforeEnabled) ?? true;
      final morningOfEnabled = prefs.getBool(keyMorningOfEnabled) ?? true;

      if (!nightBeforeEnabled && !morningOfEnabled) return;

      // Get tomorrow's meals.
      final tomorrowsMeals = await _mealPlanDao.getTomorrowsMeals();
      if (tomorrowsMeals.isEmpty) return;

      // Get freezer items.
      final allPantryItems = await _pantryDao.getAllItems();
      final freezerItems = allPantryItems
          .where((item) => item.location == 'freezer')
          .toList();
      if (freezerItems.isEmpty) return;

      // Build set of freezer item names (lowercase for matching).
      final freezerNames =
          freezerItems.map((item) => item.name.toLowerCase()).toSet();

      // Check each uncooked meal's recipe ingredients against freezer items.
      final matchedItems = <String>{};
      for (final meal in tomorrowsMeals) {
        if (meal.isCooked) continue;

        final recipe = await _recipeDao.getRecipeById(meal.recipeId);
        if (recipe == null) continue;

        final ingredientNames = _parseIngredientNames(recipe.ingredientsJson);
        for (final ingredient in ingredientNames) {
          final lower = ingredient.toLowerCase();
          for (final freezerName in freezerNames) {
            if (lower.contains(freezerName) || freezerName.contains(lower)) {
              matchedItems.add(freezerName);
            }
          }
        }
      }

      if (matchedItems.isEmpty) return;

      // Build notification body.
      final itemList = matchedItems.take(3).join(', ');
      final extra = matchedItems.length > 3
          ? ' and ${matchedItems.length - 3} more'
          : '';
      final body = 'Remember to thaw: $itemList$extra';

      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day)
          .add(const Duration(days: 1));

      // Schedule night-before notification (tonight).
      if (nightBeforeEnabled) {
        final hour = prefs.getInt(keyNightBeforeHour) ?? defaultNightBeforeHour;
        final minute =
            prefs.getInt(keyNightBeforeMinute) ?? defaultNightBeforeMinute;
        final tonight = DateTime(now.year, now.month, now.day, hour, minute);

        await _notificationService.scheduleOnce(
          id: NotificationService.thawNightBeforeId,
          title: 'Thaw reminder for tomorrow',
          body: body,
          scheduledDate: tonight,
        );
      }

      // Schedule morning-of notification (tomorrow morning).
      if (morningOfEnabled) {
        final hour = prefs.getInt(keyMorningOfHour) ?? defaultMorningOfHour;
        final minute =
            prefs.getInt(keyMorningOfMinute) ?? defaultMorningOfMinute;
        final morningOf =
            DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hour, minute);

        await _notificationService.scheduleOnce(
          id: NotificationService.thawMorningOfId,
          title: 'Thaw reminder for today',
          body: body,
          scheduledDate: morningOf,
        );
      }
    } catch (e) {
      debugPrint('ThawReminderService error: $e');
    }
  }

  /// Parse ingredient names from the recipe's ingredientsJson field.
  /// Expected format: JSON array of objects with a "name" key.
  List<String> _parseIngredientNames(String ingredientsJson) {
    try {
      final List<dynamic> ingredients = jsonDecode(ingredientsJson);
      return ingredients
          .whereType<Map<String, dynamic>>()
          .map((i) => (i['name'] as String?) ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }
}
