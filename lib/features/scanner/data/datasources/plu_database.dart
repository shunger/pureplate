import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../shared/models/product_category.dart';
import '../../../products/domain/models/product_unit.dart';

class PluEntry {
  final String code;
  final String name;
  final String? category;
  final bool isOrganic;

  const PluEntry({
    required this.code,
    required this.name,
    this.category,
    this.isOrganic = false,
  });

  /// Infer product category from name keywords.
  ProductCategory get inferredCategory {
    final lower = name.toLowerCase();
    if (lower.contains('apple') ||
        lower.contains('banana') ||
        lower.contains('orange') ||
        lower.contains('grape') ||
        lower.contains('berry') ||
        lower.contains('melon') ||
        lower.contains('pear') ||
        lower.contains('peach') ||
        lower.contains('plum') ||
        lower.contains('cherry') ||
        lower.contains('mango') ||
        lower.contains('kiwi') ||
        lower.contains('lemon') ||
        lower.contains('lime') ||
        lower.contains('fruit')) {
      return ProductCategory.produce;
    }
    if (lower.contains('lettuce') ||
        lower.contains('tomato') ||
        lower.contains('potato') ||
        lower.contains('onion') ||
        lower.contains('carrot') ||
        lower.contains('pepper') ||
        lower.contains('cucumber') ||
        lower.contains('broccoli') ||
        lower.contains('celery') ||
        lower.contains('spinach') ||
        lower.contains('herb') ||
        lower.contains('vegetable')) {
      return ProductCategory.produce;
    }
    return ProductCategory.produce; // PLU codes are almost always produce
  }

  /// Infer unit type from name keywords.
  ProductUnit get inferredUnit {
    final lower = name.toLowerCase();
    if (lower.contains('bunch')) return ProductUnit.bunch;
    if (lower.contains('bag')) return ProductUnit.bag;
    return ProductUnit.each;
  }
}

class PluDatabase {
  List<PluEntry>? _entries;
  final List<String> _recentCodes = [];
  static const int _maxRecent = 20;

  /// Load the PLU database from assets.
  Future<void> load() async {
    if (_entries != null) return;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/ifps_plu_codes.json');
      final data = jsonDecode(jsonString);

      if (data is List) {
        _entries = data.map((item) {
          final map = item as Map<String, dynamic>;
          final code = (map['plu_code'] ?? map['code'] ?? map['PLU'] ?? '')
              .toString()
              .trim();
          final name = (map['commodity'] ??
                  map['name'] ??
                  map['Commodity'] ??
                  'Unknown')
              .toString()
              .trim();
          final category =
              (map['category'] ?? map['Category'])?.toString().trim();

          // 5-digit codes starting with 9 are organic
          final isOrganic = code.length == 5 && code.startsWith('9');

          return PluEntry(
            code: code,
            name: name,
            category: category,
            isOrganic: isOrganic,
          );
        }).toList();
      } else {
        _entries = [];
      }
    } catch (e) {
      _entries = [];
    }
  }

  /// Look up a specific PLU code.
  PluEntry? lookup(String code) {
    if (_entries == null) return null;
    final trimmed = code.trim();
    return _entries!.where((e) => e.code == trimmed).firstOrNull;
  }

  /// Search PLU entries by name or code.
  List<PluEntry> search(String query) {
    if (_entries == null) return [];
    final lower = query.toLowerCase().trim();
    if (lower.isEmpty) return [];

    return _entries!.where((e) {
      return e.code.contains(lower) || e.name.toLowerCase().contains(lower);
    }).take(50).toList();
  }

  /// Get all entries.
  List<PluEntry> get allEntries => _entries ?? [];

  /// Track recently used PLU codes.
  void trackRecent(String code) {
    _recentCodes.remove(code);
    _recentCodes.insert(0, code);
    if (_recentCodes.length > _maxRecent) {
      _recentCodes.removeLast();
    }
  }

  /// Get recently used PLU entries.
  List<PluEntry> get recentEntries {
    if (_entries == null) return [];
    return _recentCodes
        .map((code) => lookup(code))
        .whereType<PluEntry>()
        .toList();
  }

  /// Check if database is loaded.
  bool get isLoaded => _entries != null;

  /// Number of entries in the database.
  int get entryCount => _entries?.length ?? 0;
}
