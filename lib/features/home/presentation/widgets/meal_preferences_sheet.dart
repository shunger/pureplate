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
  final bool pantryOnly;

  /// Free-text ingredients the user wants the meal to include.
  final String? ingredients;
  final String? notes;

  const MealPreferences({
    this.cuisine,
    this.effort,
    this.vibe,
    this.pantryOnly = false,
    this.ingredients,
    this.notes,
  });

  /// Encode as query parameter string
  /// (e.g. "italian|quick|healthy|pantryOnly|notes|ingredients").
  /// Free-text parts are URL-encoded to avoid issues with `|` or special
  /// characters.
  String toQueryParam() => [
        cuisine != null ? Uri.encodeComponent(cuisine!) : '',
        effort ?? '',
        vibe != null ? Uri.encodeComponent(vibe!) : '',
        pantryOnly ? 'pantryOnly' : '',
        notes != null ? Uri.encodeComponent(notes!) : '',
        ingredients != null ? Uri.encodeComponent(ingredients!) : '',
      ].join('|');

  /// Decode from query parameter string.
  factory MealPreferences.fromQueryParam(String param) {
    final parts = param.split('|');
    String? at(int i) =>
        parts.length > i && parts[i].isNotEmpty ? parts[i] : null;
    String? decoded(int i) {
      final raw = at(i);
      return raw == null ? null : Uri.decodeComponent(raw);
    }

    return MealPreferences(
      cuisine: decoded(0),
      effort: at(1),
      vibe: decoded(2),
      pantryOnly: at(3) == 'pantryOnly',
      notes: decoded(4),
      ingredients: decoded(5),
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

  bool get isEmpty =>
      cuisine == null &&
      effort == null &&
      vibe == null &&
      !pantryOnly &&
      (ingredients == null || ingredients!.isEmpty) &&
      (notes == null || notes!.isEmpty);
}

/// Shows the meal preferences sheet and returns selections, or null if
/// the user dismisses without tapping "Go".
Future<MealPreferences?> showMealPreferencesSheet(
    BuildContext context, String mealType) {
  return showModalBottomSheet<MealPreferences>(
    context: context,
    isScrollControlled: true,
    // Keeps the sheet below the status bar / Dynamic Island so the title is
    // never covered when the content is tall enough to fill the screen.
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.92,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      // Lift the sheet above the keyboard while a text field is focused.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
      child: _MealPreferencesBody(mealType: mealType),
    ),
  );
}

/// Sentinel chip value meaning "the user is typing their own answer".
const _kOther = '__other__';

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
  bool _pantryOnly = false;
  final _cuisineOther = TextEditingController();
  final _vibeOther = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _cuisineOther.dispose();
    _vibeOther.dispose();
    _ingredientsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

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
    ('Use what’s expiring', Icons.timer_outlined),
  ];

  /// Resolve a chip group's value: a typed "Other" answer wins over the
  /// sentinel, and an empty "Other" box counts as no selection.
  String? _resolve(String? chip, TextEditingController other) {
    if (chip != _kOther) return chip;
    final text = other.text.trim();
    return text.isEmpty ? null : text;
  }

  String? _text(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
  }

  void _submit({required bool skip}) {
    Navigator.pop(
      context,
      skip
          ? MealPreferences(notes: _text(_notesController))
          : MealPreferences(
              cuisine: _resolve(_cuisine, _cuisineOther),
              effort: _effort,
              vibe: _resolve(_vibe, _vibeOther),
              pantryOnly: _pantryOnly,
              ingredients: _text(_ingredientsController),
              notes: _text(_notesController),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
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
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              'What sounds good?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Pick any that apply, or skip straight to suggestions.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),

            // Scrollable question area — a fallback for small screens; the
            // default layout is sized to fit without scrolling on a phone.
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Q1: Cuisine style
                    const _QuestionLabel(label: 'Cuisine style'),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final c in _cuisines)
                          _Chip(
                            label: c.$1,
                            // Icons only on the odd one out; the text-only
                            // chips let all six fit in two rows.
                            icon: c.$1 == 'Surprise me' ? c.$2 : null,
                            selected: _cuisine == c.$1,
                            onTap: () => setState(() =>
                                _cuisine = _cuisine == c.$1 ? null : c.$1),
                          ),
                        _Chip(
                          label: 'Other…',
                          icon: Icons.edit_outlined,
                          selected: _cuisine == _kOther,
                          onTap: () => setState(() =>
                              _cuisine = _cuisine == _kOther ? null : _kOther),
                        ),
                      ],
                    ),
                    if (_cuisine == _kOther) ...[
                      const SizedBox(height: 6),
                      _OtherField(
                        controller: _cuisineOther,
                        hint: 'e.g. Thai, Indian, Cajun',
                      ),
                    ],
                    const SizedBox(height: 10),

                    // Q2: Effort
                    const _QuestionLabel(label: 'Cooking effort'),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final e in _efforts)
                          _Chip(
                            label: e.$1,
                            selected: _effort == e.$1,
                            onTap: () => setState(() =>
                                _effort = _effort == e.$1 ? null : e.$1),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Q3: Vibe
                    const _QuestionLabel(label: 'Mood'),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final v in _vibes)
                          _Chip(
                            label: v.$1,
                            icon: v.$2,
                            selected: _vibe == v.$1,
                            onTap: () => setState(
                                () => _vibe = _vibe == v.$1 ? null : v.$1),
                          ),
                        _Chip(
                          label: 'Other…',
                          icon: Icons.edit_outlined,
                          selected: _vibe == _kOther,
                          onTap: () => setState(
                              () => _vibe = _vibe == _kOther ? null : _kOther),
                        ),
                      ],
                    ),
                    if (_vibe == _kOther) ...[
                      const SizedBox(height: 6),
                      _OtherField(
                        controller: _vibeOther,
                        hint: 'e.g. comfort food, spicy, kid-friendly',
                      ),
                    ],
                    const SizedBox(height: 10),

                    // Ingredients: pantry-only toggle + must-include text.
                    const _QuestionLabel(label: 'Ingredients'),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _Chip(
                          label: 'Use only pantry',
                          icon: Icons.kitchen_outlined,
                          selected: _pantryOnly,
                          onTap: () =>
                              setState(() => _pantryOnly = !_pantryOnly),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _OtherField(
                            controller: _ingredientsController,
                            hint: 'Must include, e.g. chicken',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Free-form notes (label folded into the hint to save a row)
                    _OtherField(
                      controller: _notesController,
                      hint: 'Anything else? e.g. pasta night, feeds 6',
                      capitalization: TextCapitalization.sentences,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Action buttons (pinned at bottom)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _submit(skip: true),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                    onPressed: () => _submit(skip: false),
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: const Text('Suggest something'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.coral,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

/// A compact selectable chip. Sized so a full row of three fits a phone
/// width and the whole sheet fits on screen without scrolling.
class _Chip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: selected ? Colors.white : null),
            const SizedBox(width: 5),
          ],
          Text(label),
        ],
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.coral,
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      labelPadding: EdgeInsets.zero,
      labelStyle: TextStyle(
        fontSize: 13,
        color: selected ? Colors.white : null,
        fontWeight: selected ? FontWeight.w600 : null,
      ),
    );
  }
}

/// Single-line free-text input styled to sit alongside the chips.
class _OtherField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextCapitalization capitalization;

  const _OtherField({
    required this.controller,
    required this.hint,
    this.capitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      maxLines: 1,
      textCapitalization: capitalization,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
