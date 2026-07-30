import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../shared/models/dietary_restriction.dart';
import '../../../meal_plan/domain/models/family_profile.dart';

/// Profile edit form — family size, dietary restrictions, cuisine preferences,
/// cook time, budget level.
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  int _adults = 2;
  int _kids = 0;
  final _selectedKidAgeRanges = <KidAgeRange>{};
  final _selectedDietaryRestrictions = <DietaryRestriction>{};
  final _selectedCuisines = <String>{};
  PreferredCookTime _cookTime = PreferredCookTime.under45;
  BudgetLevel _budgetLevel = BudgetLevel.moderate;
  SkillLevel _skillLevel = SkillLevel.comfortable;
  SpiceTolerance _spiceTolerance = SpiceTolerance.medium;
  VarietyPreference _varietyPreference = VarietyPreference.mixed;
  final _dislikedIngredients = <String>[];
  final _ingredientController = TextEditingController();

  bool _loaded = false;

  static const _cuisineOptions = [
    'Italian',
    'Mexican',
    'Chinese',
    'Indian',
    'Japanese',
    'Thai',
    'Mediterranean',
    'American',
    'Korean',
    'French',
    'Middle Eastern',
    'Vietnamese',
  ];

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(familyProfileProvider);

    // Load existing profile data once
    if (!_loaded) {
      profileAsync.whenData((profile) {
        if (profile != null && !_loaded) {
          _loaded = true;
          setState(() {
            _adults = profile.adults;
            _kids = profile.kids;
            // Parse kid age ranges from JSON
            _parseKidAgeRanges(profile.kidAgeRangesJson);
            // Parse dietary restrictions from JSON
            _parseDietaryRestrictions(profile.dietaryRestrictionsJson);
            // Parse cuisine preferences from JSON
            _parseCuisinePreferences(profile.cuisinePreferencesJson);
            // Parse cook time and budget from string fields
            _cookTime = _parseCookTime(profile.preferredCookTime);
            _budgetLevel = _parseBudgetLevel(profile.budgetLevel);
            _skillLevel = _parseSkillLevel(profile.skillLevel);
            _spiceTolerance = _parseSpiceTolerance(profile.spiceTolerance);
            _varietyPreference = _parseVarietyPreference(profile.varietyPreference);
            _parseDislikedIngredients(profile.dislikedIngredientsJson);
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.coral)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Family Size ──────────────────────────────────────
          Text('Family Size',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _StepperRow(
            label: 'Adults',
            value: _adults,
            onDecrement: _adults > 1
                ? () => setState(() => _adults--)
                : null,
            onIncrement: () => setState(() => _adults++),
          ),
          const SizedBox(height: 12),
          _StepperRow(
            label: 'Kids',
            value: _kids,
            onDecrement: _kids > 0
                ? () => setState(() => _kids--)
                : null,
            onIncrement: () => setState(() => _kids++),
          ),

          // Kid age ranges
          if (_kids > 0) ...[
            const SizedBox(height: 16),
            Text('Kid Age Ranges',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: KidAgeRange.values.map((range) {
                final selected = _selectedKidAgeRanges.contains(range);
                return FilterChip(
                  label: Text(range.label),
                  selected: selected,
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _selectedKidAgeRanges.add(range);
                      } else {
                        _selectedKidAgeRanges.remove(range);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // ── Dietary Restrictions ─────────────────────────────
          Text('Dietary Restrictions',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DietaryRestriction.values.map((dr) {
              final selected = _selectedDietaryRestrictions.contains(dr);
              return FilterChip(
                label: Text(dr.displayName),
                selected: selected,
                onSelected: (v) {
                  setState(() {
                    if (v) {
                      _selectedDietaryRestrictions.add(dr);
                    } else {
                      _selectedDietaryRestrictions.remove(dr);
                    }
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // ── Cuisine Preferences ─────────────────────────────
          Text('Cuisine Preferences',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _cuisineOptions.map((cuisine) {
              final selected = _selectedCuisines.contains(cuisine);
              return FilterChip(
                label: Text(cuisine),
                selected: selected,
                onSelected: (v) {
                  setState(() {
                    if (v) {
                      _selectedCuisines.add(cuisine);
                    } else {
                      _selectedCuisines.remove(cuisine);
                    }
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // ── Cook Time Preference ────────────────────────────
          Text('Preferred Cook Time',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...PreferredCookTime.values.map((ct) => RadioListTile<PreferredCookTime>(
                title: Text(_cookTimeLabel(ct)),
                value: ct,
                groupValue: _cookTime,
                onChanged: (v) => setState(() => _cookTime = v!),
                activeColor: AppColors.coral,
                contentPadding: EdgeInsets.zero,
                dense: true,
              )),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // ── Budget Level ────────────────────────────────────
          Text('Budget Level',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...BudgetLevel.values.map((bl) => RadioListTile<BudgetLevel>(
                title: Text(_budgetLabel(bl)),
                value: bl,
                groupValue: _budgetLevel,
                onChanged: (v) => setState(() => _budgetLevel = v!),
                activeColor: AppColors.coral,
                contentPadding: EdgeInsets.zero,
                dense: true,
              )),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // ── Cooking Skill Level ──────────────────────────
          Text('Cooking Skill',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SkillLevel.values.map((level) {
              final selected = _skillLevel == level;
              return ChoiceChip(
                label: Text(_skillLabel(level)),
                selected: selected,
                onSelected: (_) => setState(() => _skillLevel = level),
                selectedColor: AppColors.sage.withValues(alpha: 0.2),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // ── Spice Tolerance ──────────────────────────────
          Text('Spice Tolerance',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SpiceTolerance.values.map((level) {
              final selected = _spiceTolerance == level;
              return ChoiceChip(
                label: Text(_spiceLabel(level)),
                selected: selected,
                onSelected: (_) =>
                    setState(() => _spiceTolerance = level),
                selectedColor: AppColors.coral.withValues(alpha: 0.15),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // ── Variety Preference ───────────────────────────
          Text('Meal Variety',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: VarietyPreference.values.map((pref) {
              final selected = _varietyPreference == pref;
              return ChoiceChip(
                label: Text(_varietyLabel(pref)),
                selected: selected,
                onSelected: (_) =>
                    setState(() => _varietyPreference = pref),
                selectedColor: AppColors.sage.withValues(alpha: 0.2),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // ── Disliked Ingredients ─────────────────────────
          Text('Disliked Ingredients',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            'We\'ll avoid these in recipe suggestions.',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _ingredientController,
            decoration: InputDecoration(
              hintText: 'Type an ingredient and press enter',
              hintStyle: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.6),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: () => _addIngredient(_ingredientController.text),
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: _addIngredient,
          ),
          if (_dislikedIngredients.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dislikedIngredients.map((ingredient) {
                return Chip(
                  label: Text(ingredient),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    setState(() {
                      _dislikedIngredients.remove(ingredient);
                    });
                  },
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final dao = ref.read(familyProfileDaoProvider);
    final existing = await dao.getProfile();
    final id = existing?.id ?? const Uuid().v4();
    final now = DateTime.now();

    // Build cuisine preferences as a JSON map with equal weights.
    final cuisineMap = <String, dynamic>{};
    for (final c in _selectedCuisines) {
      cuisineMap[c] = 1.0;
    }

    await dao.upsertProfile(FamilyProfilesCompanion(
      id: Value(id),
      adults: Value(_adults),
      kids: Value(_kids),
      kidAgeRangesJson: Value(
          jsonEncode(_selectedKidAgeRanges.map((r) => r.name).toList())),
      dietaryRestrictionsJson: Value(jsonEncode(
          _selectedDietaryRestrictions.map((d) => d.name).toList())),
      cuisinePreferencesJson: Value(jsonEncode(cuisineMap)),
      preferredCookTime: Value(_cookTimeToString(_cookTime)),
      budgetLevel: Value(_budgetLevel.name),
      skillLevel: Value(_skillLevel.name),
      spiceTolerance: Value(_spiceTolerance.name),
      varietyPreference: Value(_varietyPreference.name),
      dislikedIngredientsJson: Value(jsonEncode(_dislikedIngredients)),
      createdAt: Value(existing != null ? existing.createdAt : now),
      updatedAt: Value(now),
    ));

    if (mounted) Navigator.pop(context);
  }

  // ── Parsing helpers ──────────────────────────────────────

  void _parseKidAgeRanges(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      for (final item in list) {
        final range = KidAgeRange.values
            .where((r) => r.name == item.toString())
            .firstOrNull;
        if (range != null) _selectedKidAgeRanges.add(range);
      }
    } catch (_) {}
  }

  void _parseDietaryRestrictions(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      for (final item in list) {
        final dr = DietaryRestriction.values
            .where((d) => d.name == item.toString())
            .firstOrNull;
        if (dr != null) _selectedDietaryRestrictions.add(dr);
      }
    } catch (_) {}
  }

  void _parseCuisinePreferences(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      _selectedCuisines.addAll(map.keys);
    } catch (_) {}
  }

  PreferredCookTime _parseCookTime(String value) {
    switch (value) {
      case '15':
        return PreferredCookTime.under30;
      case '30':
        return PreferredCookTime.under30;
      case '30-45':
        return PreferredCookTime.under45;
      case '45-60':
        return PreferredCookTime.under60;
      case '60+':
        return PreferredCookTime.anyTime;
      default:
        return PreferredCookTime.values
            .where((ct) => ct.name == value)
            .firstOrNull ?? PreferredCookTime.under45;
    }
  }

  BudgetLevel _parseBudgetLevel(String value) {
    return BudgetLevel.values
        .where((bl) => bl.name == value)
        .firstOrNull ?? BudgetLevel.moderate;
  }

  String _cookTimeLabel(PreferredCookTime ct) {
    switch (ct) {
      case PreferredCookTime.under30:
        return 'Under 30 minutes';
      case PreferredCookTime.under45:
        return '30-45 minutes';
      case PreferredCookTime.under60:
        return '45-60 minutes';
      case PreferredCookTime.anyTime:
        return 'Any time (60+ ok)';
    }
  }

  String _cookTimeToString(PreferredCookTime ct) {
    switch (ct) {
      case PreferredCookTime.under30:
        return '30';
      case PreferredCookTime.under45:
        return '30-45';
      case PreferredCookTime.under60:
        return '45-60';
      case PreferredCookTime.anyTime:
        return '60+';
    }
  }

  String _budgetLabel(BudgetLevel bl) {
    switch (bl) {
      case BudgetLevel.budget:
        return 'Budget-friendly';
      case BudgetLevel.moderate:
        return 'Moderate';
      case BudgetLevel.premium:
        return 'Premium ingredients';
    }
  }

  SkillLevel _parseSkillLevel(String value) {
    return SkillLevel.values
            .where((s) => s.name == value)
            .firstOrNull ??
        SkillLevel.comfortable;
  }

  SpiceTolerance _parseSpiceTolerance(String value) {
    return SpiceTolerance.values
            .where((s) => s.name == value)
            .firstOrNull ??
        SpiceTolerance.medium;
  }

  VarietyPreference _parseVarietyPreference(String value) {
    return VarietyPreference.values
            .where((v) => v.name == value)
            .firstOrNull ??
        VarietyPreference.mixed;
  }

  void _parseDislikedIngredients(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      _dislikedIngredients.addAll(list.map((e) => e.toString()));
    } catch (_) {}
  }

  void _addIngredient(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    if (!_dislikedIngredients.contains(trimmed.toLowerCase())) {
      setState(() {
        _dislikedIngredients.add(trimmed.toLowerCase());
      });
    }
    _ingredientController.clear();
  }

  String _skillLabel(SkillLevel level) {
    switch (level) {
      case SkillLevel.beginner:
        return 'Beginner';
      case SkillLevel.comfortable:
        return 'Comfortable';
      case SkillLevel.experienced:
        return 'Experienced';
    }
  }

  String _spiceLabel(SpiceTolerance level) {
    switch (level) {
      case SpiceTolerance.mild:
        return 'Mild';
      case SpiceTolerance.medium:
        return 'Medium';
      case SpiceTolerance.spicy:
        return 'Spicy';
      case SpiceTolerance.hot:
        return 'Bring the heat';
    }
  }

  String _varietyLabel(VarietyPreference pref) {
    switch (pref) {
      case VarietyPreference.familiar:
        return 'Stick to favorites';
      case VarietyPreference.mixed:
        return 'Mix of both';
      case VarietyPreference.adventurous:
        return 'Always something new';
    }
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }
}

class _StepperRow extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const _StepperRow({
    required this.label,
    required this.value,
    this.onDecrement,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
        const Spacer(),
        IconButton.filled(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            minimumSize: const Size(36, 36),
          ),
        ),
        SizedBox(
          width: 40,
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        IconButton.filled(
          onPressed: onIncrement,
          icon: const Icon(Icons.add, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.coral,
            foregroundColor: Colors.white,
            minimumSize: const Size(36, 36),
          ),
        ),
      ],
    );
  }
}
