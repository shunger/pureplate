import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Quick preferences bottom sheet shown before AI meal suggestions.
///
/// Asks up to 3 questions via chip selectors, then returns the selections
/// as a [MealPreferences] object.
class MealPreferences {
  final String? cuisine;
  final String? effort;
  final String? vibe;

  const MealPreferences({this.cuisine, this.effort, this.vibe});

  /// Encode as query parameter string (e.g. "italian|quick|healthy").
  String toQueryParam() =>
      [cuisine ?? '', effort ?? '', vibe ?? ''].join('|');

  /// Decode from query parameter string.
  factory MealPreferences.fromQueryParam(String param) {
    final parts = param.split('|');
    return MealPreferences(
      cuisine: parts.isNotEmpty && parts[0].isNotEmpty ? parts[0] : null,
      effort: parts.length > 1 && parts[1].isNotEmpty ? parts[1] : null,
      vibe: parts.length > 2 && parts[2].isNotEmpty ? parts[2] : null,
    );
  }

  /// Build a natural-language description for the AI prompt.
  String toPromptFragment() {
    final parts = <String>[];
    if (cuisine != null) {
      if (cuisine == 'Surprise me') {
        parts.add(
            'surprise me with an unexpected cuisine I wouldn\'t think to try');
      } else {
        parts.add(cuisine!);
      }
    }
    if (effort != null) parts.add(effort!);
    if (vibe != null) parts.add(vibe!);
    return parts.join(', ');
  }

  bool get isEmpty => cuisine == null && effort == null && vibe == null;
}

/// Shows the meal preferences sheet and returns selections, or null if
/// the user dismisses without tapping "Go".
Future<MealPreferences?> showMealPreferencesSheet(
    BuildContext context, String mealType) {
  return showModalBottomSheet<MealPreferences>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _MealPreferencesBody(mealType: mealType),
  );
}

class _MealPreferencesBody extends StatefulWidget {
  final String mealType;

  const _MealPreferencesBody({required this.mealType});

  @override
  State<_MealPreferencesBody> createState() => _MealPreferencesBodyState();
}

class _MealPreferencesBodyState extends State<_MealPreferencesBody> {
  String? _cuisine;
  String? _effort;
  String? _vibe;

  static const _cuisines = [
    ('Italian', Icons.local_pizza_outlined),
    ('Mexican', Icons.set_meal_outlined),
    ('Asian', Icons.ramen_dining_outlined),
    ('American', Icons.lunch_dining_outlined),
    ('Mediterranean', Icons.wb_sunny_outlined),
    ('Surprise me', Icons.auto_awesome),
  ];

  static const _efforts = [
    ('Quick & easy', 'Under 30 min'),
    ('Medium effort', '30-60 min'),
    ('Worth the wait', '60+ min'),
  ];

  static const _vibes = [
    ('Healthy & light', Icons.spa_outlined),
    ('Hearty & filling', Icons.restaurant_outlined),
    ('Something new', Icons.explore_outlined),
    ('Use what\u2019s expiring', Icons.timer_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'What sounds good?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pick any that apply, or skip straight to suggestions.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),

            // Q1: Cuisine style
            _QuestionLabel(label: 'Cuisine style'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _cuisines.map((c) {
                final selected = _cuisine == c.$1;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(c.$2,
                          size: 16,
                          color: selected ? Colors.white : null),
                      const SizedBox(width: 6),
                      Text(c.$1),
                    ],
                  ),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _cuisine = selected ? null : c.$1),
                  selectedColor: AppColors.coral,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                    fontWeight: selected ? FontWeight.w600 : null,
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Q2: Effort
            _QuestionLabel(label: 'Cooking effort'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _efforts.map((e) {
                final selected = _effort == e.$1;
                return ChoiceChip(
                  label: Text(e.$1),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _effort = selected ? null : e.$1),
                  selectedColor: AppColors.coral,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                    fontWeight: selected ? FontWeight.w600 : null,
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Q3: Vibe
            _QuestionLabel(label: 'Mood'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _vibes.map((v) {
                final selected = _vibe == v.$1;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(v.$2,
                          size: 16,
                          color: selected ? Colors.white : null),
                      const SizedBox(width: 6),
                      Text(v.$1),
                    ],
                  ),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _vibe = selected ? null : v.$1),
                  selectedColor: AppColors.coral,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                    fontWeight: selected ? FontWeight.w600 : null,
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(
                        context, const MealPreferences()),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Skip'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(
                      context,
                      MealPreferences(
                        cuisine: _cuisine,
                        effort: _effort,
                        vibe: _vibe,
                      ),
                    ),
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: const Text('Suggest something'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.coral,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionLabel extends StatelessWidget {
  final String label;

  const _QuestionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
