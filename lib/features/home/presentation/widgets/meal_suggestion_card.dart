import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import 'meal_preferences_sheet.dart';

/// Card that launches the AI chat in a specific meal mode.
///
/// Used for breakfast, lunch, dessert, and snack on the home screen
/// alongside the larger "What's for dinner?" hero button.
///
/// Set [compact] to true for smaller dessert/snack buttons.
class MealSuggestionCard extends StatelessWidget {
  final String mealType;
  final String label;
  final IconData icon;
  final Color color;
  final Color colorDark;
  final bool compact;

  const MealSuggestionCard({
    super.key,
    required this.mealType,
    required this.label,
    required this.icon,
    required this.color,
    required this.colorDark,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final prefs =
                await showMealPreferencesSheet(context, mealType);
            if (prefs == null || !context.mounted) return;
            final query = prefs.isEmpty
                ? 'mode=$mealType'
                : 'mode=$mealType&prefs=${Uri.encodeComponent(prefs.toQueryParam())}';
            context.push('${Routes.chat}?$query');
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 10 : 12,
              vertical: compact ? 8 : 10,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, colorDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: compact ? 0.15 : 0.2),
                  blurRadius: compact ? 4 : 6,
                  offset: Offset(0, compact ? 1 : 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon,
                    color: Colors.white.withValues(alpha: 0.9),
                    size: compact ? 16 : 18),
                SizedBox(width: compact ? 6 : 8),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 13 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white60,
                  size: compact ? 14 : 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
