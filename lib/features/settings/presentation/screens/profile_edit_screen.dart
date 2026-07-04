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
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
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
                    ?.copyWith(color: AppColors.textSecondary)),
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
            style: const TextStyle(fontSize: 16, color: AppColors.textPrimary)),
        const Spacer(),
        IconButton.filled(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.cream,
            foregroundColor: AppColors.textPrimary,
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
