import '../../domain/models/ingredient.dart';

/// Turns recipe text into something that sounds natural when read aloud by
/// text-to-speech: no markdown, no abbreviations, fractions said the way a
/// person says them ("half a cup", "one and a quarter teaspoons").
class SpokenText {
  SpokenText._();

  static const _units = <String, (String, String)>{
    'tbsp': ('tablespoon', 'tablespoons'),
    'tbsps': ('tablespoon', 'tablespoons'),
    'tbs': ('tablespoon', 'tablespoons'),
    'tbl': ('tablespoon', 'tablespoons'),
    'tablespoon': ('tablespoon', 'tablespoons'),
    'tablespoons': ('tablespoon', 'tablespoons'),
    'tsp': ('teaspoon', 'teaspoons'),
    'tsps': ('teaspoon', 'teaspoons'),
    'teaspoon': ('teaspoon', 'teaspoons'),
    'teaspoons': ('teaspoon', 'teaspoons'),
    'c': ('cup', 'cups'),
    'cup': ('cup', 'cups'),
    'cups': ('cup', 'cups'),
    'oz': ('ounce', 'ounces'),
    'fl oz': ('fluid ounce', 'fluid ounces'),
    'lb': ('pound', 'pounds'),
    'lbs': ('pound', 'pounds'),
    'g': ('gram', 'grams'),
    'kg': ('kilogram', 'kilograms'),
    'mg': ('milligram', 'milligrams'),
    'ml': ('milliliter', 'milliliters'),
    'l': ('liter', 'liters'),
    'qt': ('quart', 'quarts'),
    'pt': ('pint', 'pints'),
    'gal': ('gallon', 'gallons'),
    'pkg': ('package', 'packages'),
    'in': ('inch', 'inches'),
    'min': ('minute', 'minutes'),
    'mins': ('minute', 'minutes'),
    'hr': ('hour', 'hours'),
    'hrs': ('hour', 'hours'),
  };

  /// Units are only expanded when they follow a number in running text,
  /// since letters like "g" and "c" mean other things alone.
  static final _unitAfterNumber = RegExp(
    r'(\d+\s+\d+/\d+|\d+/\d+|\d*\.\d+|\d+)\s*'
    r'(tablespoons?|teaspoons?|cups?|tbsps?|tbs|tbl|tsps?|fl\.?\s?oz|oz|lbs?|kg|mg|ml|g|l|qt|pt|gal|pkg|mins?|hrs?|c)(?:\.(?=\s+[a-z]))?(?![a-z])',
    caseSensitive: false,
  );

  /// Recipe "units" that are really size words: "2 large eggs", not
  /// "2 large of eggs".
  static const _sizeWords = {'small', 'medium', 'large', 'whole', 'big'};

  static const _unicodeFractions = {
    '½': '1/2', '⅓': '1/3', '⅔': '2/3', '¼': '1/4', '¾': '3/4',
    '⅛': '1/8', '⅜': '3/8', '⅝': '5/8', '⅞': '7/8',
  };

  /// Strips markdown and symbols that TTS would read out or stumble on, and
  /// spells out measurements.
  static String forSpeech(String text) {
    var s = text;

    // Markdown: headings, bullets, numbered lists, emphasis, links, code.
    s = s.replaceAll(RegExp(r'^\s{0,3}#{1,6}\s*', multiLine: true), '');
    s = s.replaceAll(RegExp(r'^\s*[-*•]\s+', multiLine: true), '');
    s = s.replaceAll(RegExp(r'^\s*\d+[.)]\s+', multiLine: true), '');
    s = s.replaceAllMapped(
        RegExp(r'\[([^\]]+)\]\([^)]*\)'), (m) => m.group(1)!);
    s = s.replaceAll(RegExp(r'[*_`~]{1,3}'), '');

    // Line breaks become sentence breaks.
    s = s.replaceAllMapped(RegExp(r'([^.!?:,])\s*\n+\s*'), (m) => '${m[1]}. ');
    s = s.replaceAll(RegExp(r'\s*\n+\s*'), ' ');

    for (final e in _unicodeFractions.entries) {
      // "1½" → "1 1/2"
      s = s.replaceAllMapped(
          RegExp('(\\d)${e.key}'), (m) => '${m[1]} ${e.value}');
      s = s.replaceAll(e.key, e.value);
    }

    // Temperatures.
    s = s.replaceAllMapped(
        RegExp(r'(\d+)\s*°\s*F\b'), (m) => '${m[1]} degrees');
    s = s.replaceAllMapped(
        RegExp(r'(\d+)\s*°\s*C\b'), (m) => '${m[1]} degrees Celsius');
    s = s.replaceAllMapped(RegExp(r'(\d+)\s*°'), (m) => '${m[1]} degrees');
    s = s.replaceAllMapped(
        RegExp(r'\b(\d{3})\s?F\b'), (m) => '${m[1]} degrees');

    // Ranges: "5-7 minutes" → "5 to 7 minutes".
    s = s.replaceAllMapped(RegExp(r'(\d)\s*[-–—]\s*(\d)'),
        (m) => '${m[1]} to ${m[2]}');

    // Number + abbreviated unit → spoken amount.
    s = s.replaceAllMapped(_unitAfterNumber, (m) {
      final key = m[2]!.toLowerCase().replaceAll('.', '').replaceAll(
          RegExp(r'\s+'), ' ');
      final unit = _units[key == 'floz' ? 'fl oz' : key];
      if (unit == null) return m[0]!;
      return amount(m[1]!, unit: unit);
    });

    // Any fractions left over ("cut in 1/2", "1 1/2 onions").
    s = s.replaceAllMapped(RegExp(r'(\d+\s+)?\d+/\d+'),
        (m) => amount(m[0]!, unit: null));

    s = s
        .replaceAll(RegExp(r'and\s*/\s*or', caseSensitive: false), 'or')
        .replaceAll('&', ' and ')
        .replaceAll(RegExp(r'\be\.g\.', caseSensitive: false), 'for example')
        .replaceAll(RegExp(r'\bi\.e\.', caseSensitive: false), 'that is')
        .replaceAll(RegExp(r'\bapprox\.?', caseSensitive: false), 'about')
        .replaceAll(RegExp(r'\s*/\s*'), ' or ')
        .replaceAll(RegExp(r'[()]'), ', ')
        .replaceAll(RegExp(r'\s+([,.!?])'), r'$1')
        .replaceAll(RegExp(r',\s*,'), ',')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
    return s;
  }

  /// Says a quantity, with an optional (singular, plural) unit:
  /// "0.5" + cup → "half a cup", "1 1/2" + tsp → "1 and a half teaspoons".
  /// Falls back to the text as written when it isn't a number.
  static String amount(String quantity, {required (String, String)? unit}) {
    final value = _parse(quantity.trim());
    if (value == null) {
      // "2-3", "1 to 2"
      final q = forSpeech(quantity.trim());
      return unit == null ? q : '$q ${unit.$2}';
    }

    final whole = value.floor();
    final frac = _fractionWord(value - whole);
    final plural = unit?.$2;
    final singular = unit?.$1;

    if (frac == null) {
      final n = _formatNumber(value);
      if (unit == null) return n;
      return '$n ${value == 1 ? singular : plural}';
    }

    if (whole > 0) {
      final words = '$whole and ${frac.$2}';
      return unit == null ? words : '$words $plural';
    }

    // Under one: "half a cup", "a quarter teaspoon", "two thirds of a cup".
    if (unit == null) return frac.$3;
    return '${frac.$1} ${singular!}';
  }

  /// One ingredient as you'd say it: "2 cups of flour", "half an onion",
  /// "salt, to taste".
  static String ingredient(Ingredient i) {
    final name = forSpeech(i.name);
    var q = i.quantity?.trim() ?? '';
    for (final e in _unicodeFractions.entries) {
      q = q.replaceAll(e.key, ' ${e.value}').trim();
    }
    final rawUnit = i.unit?.trim().toLowerCase().replaceAll('.', '') ?? '';

    // "to taste", "as needed", "a pinch"
    if (q.isNotEmpty && !RegExp(r'^\d').hasMatch(q)) {
      final said = forSpeech(q);
      return rawUnit.isEmpty ? '$name, $said' : '$name, $said $rawUnit';
    }

    if (_sizeWords.contains(rawUnit)) {
      return q.isEmpty ? '$rawUnit $name' : _countable(q, '$rawUnit $name');
    }
    if (rawUnit.isEmpty) {
      return q.isEmpty ? name : _countable(q, name);
    }

    final unit = _units[rawUnit] ?? (rawUnit, _plural(rawUnit));
    if (q.isEmpty) return '${unit.$2} of $name';
    return '${amount(q, unit: unit)} of $name';
  }

  /// "2 eggs", "half an onion", "a quarter of a lemon".
  static String _countable(String q, String name) {
    final value = _parse(q);
    final frac = value == null ? null : _fractionWord(value);
    if (value == null || value >= 1 || frac == null) {
      return '${amount(q, unit: null)} $name';
    }
    final article =
        RegExp(r'^[aeiou]', caseSensitive: false).hasMatch(name) ? 'an' : 'a';
    final words = frac.$3 == 'half' ? 'half' : '${frac.$3} of';
    return '$words $article $name';
  }

  static String _plural(String unit) {
    if (unit.endsWith('s')) return unit;
    if (RegExp(r'(ch|sh|x)$').hasMatch(unit)) return '${unit}es';
    return '${unit}s';
  }

  /// "a, b, and c" — the way a list sounds in a sentence.
  static String joinNaturally(List<String> items) {
    if (items.isEmpty) return '';
    if (items.length == 1) return items.first;
    if (items.length == 2) return '${items[0]} and ${items[1]}';
    return '${items.sublist(0, items.length - 1).join(', ')}, and ${items.last}';
  }

  static double? _parse(String q) {
    final mixed = RegExp(r'^(\d+)\s+(\d+)/(\d+)$').firstMatch(q);
    if (mixed != null) {
      final d = int.parse(mixed[3]!);
      if (d == 0) return null;
      return int.parse(mixed[1]!) + int.parse(mixed[2]!) / d;
    }
    final frac = RegExp(r'^(\d+)/(\d+)$').firstMatch(q);
    if (frac != null) {
      final d = int.parse(frac[2]!);
      if (d == 0) return null;
      return int.parse(frac[1]!) / d;
    }
    return double.tryParse(q);
  }

  /// (before a unit, after "and", standalone) phrasings for common fractions.
  static (String, String, String)? _fractionWord(double f) {
    bool near(double x) => (f - x).abs() < 0.02;
    if (near(0)) return null;
    if (near(0.5)) return ('half a', 'a half', 'half');
    if (near(0.25)) return ('a quarter', 'a quarter', 'a quarter');
    if (near(0.75)) return ('three quarters of a', 'three quarters', 'three quarters');
    if (near(1 / 3)) return ('a third of a', 'a third', 'a third');
    if (near(2 / 3)) return ('two thirds of a', 'two thirds', 'two thirds');
    if (near(0.125)) return ('an eighth of a', 'an eighth', 'an eighth');
    return null;
  }

  static String _formatNumber(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toString();
  }
}
