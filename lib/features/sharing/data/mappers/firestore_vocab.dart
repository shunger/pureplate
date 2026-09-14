/// Translates Pure Pantry's category, location and unit names to and from the
/// names stored in Firestore.
///
/// Firestore uses Smart Shopping Scanner's names: the scanner is published and
/// its shipped builds can't learn new ones. Where Pure Pantry is more specific
/// (`condiments` is just `pantry` to the scanner), the Pure Pantry value also
/// travels in a `<field>Detail` field that the scanner ignores. On the way back
/// the detail is used only while it still agrees with the main field — if a
/// scanner user has since picked a different value, theirs wins.
class FirestoreVocab {
  FirestoreVocab._();

  static const categoryField = 'category';
  static const locationField = 'location';
  static const unitField = 'unitType';

  static const _categoryToWire = <String, String>{
    'produce': 'produce',
    'dairy': 'dairy',
    'meat': 'meat',
    'bakery': 'bakery',
    'beverages': 'beverages',
    'frozen': 'frozen',
    'snacks': 'snacks',
    'household': 'household',
    'other': 'other',
    'canned': 'pantry',
    'pantryStaple': 'pantry',
    'condiments': 'pantry',
    'spices': 'spicesAndHerbs',
    'healthBeauty': 'health',
  };

  static const _categoryFromWire = <String, String>{
    'produce': 'produce',
    'dairy': 'dairy',
    'meat': 'meat',
    'seafood': 'meat',
    'bakery': 'bakery',
    'beverages': 'beverages',
    'frozen': 'frozen',
    'snacks': 'snacks',
    'household': 'household',
    'other': 'other',
    'pantry': 'pantryStaple',
    'spicesAndHerbs': 'spices',
    'health': 'healthBeauty',
  };

  static const _locationToWire = <String, String>{
    'pantry': 'pantry',
    'fridge': 'fridge',
    'freezer': 'freezer',
    'spices': 'pantry',
  };

  static const _locationFromWire = <String, String>{
    'pantry': 'pantry',
    'fridge': 'fridge',
    'freezer': 'freezer',
  };

  static const _unitToWire = <String, String>{
    'each': 'each',
    'count': 'each',
    'lbs': 'pound',
    'oz': 'ounce',
    'kg': 'kilogram',
    'g': 'gram',
    'packs': 'package',
  };

  static const _unitFromWire = <String, String>{
    'each': 'each',
    'pound': 'lbs',
    'ounce': 'oz',
    'kilogram': 'kg',
    'gram': 'g',
    'package': 'packs',
  };

  /// Scanner units with no Pure Pantry equivalent; kept verbatim both ways.
  static const _scannerOnlyUnits = {
    'bunch',
    'bag',
    'container',
    'bottle',
    'can',
    'box',
  };

  // ── Public API ──────────────────────────────────────────

  static Map<String, dynamic> encodeCategory(String local) =>
      _encode(categoryField, local, _categoryWire, _categoryLocal);

  static String decodeCategory(Map<String, dynamic> data) =>
      _decode(categoryField, data, _categoryWire, _categoryLocal, 'other');

  static Map<String, dynamic> encodeLocation(String local) =>
      _encode(locationField, local, _locationWire, _locationLocal);

  static String decodeLocation(Map<String, dynamic> data) =>
      _decode(locationField, data, _locationWire, _locationLocal, 'pantry');

  static Map<String, dynamic> encodeUnit(String local) =>
      _encode(unitField, local, _unitWire, _unitLocal);

  static String decodeUnit(Map<String, dynamic> data) =>
      _decode(unitField, data, _unitWire, _unitLocal, 'each');

  // ── Mappings ────────────────────────────────────────────

  static String _categoryWire(String local) => _categoryToWire[local] ?? 'other';

  // Unknown wire values that are already Pure Pantry names (written by older
  // Pure Pantry builds) are kept rather than collapsed to `other`.
  static String _categoryLocal(String wire) =>
      _categoryFromWire[wire] ??
      (_categoryToWire.containsKey(wire) ? wire : 'other');

  static String _locationWire(String local) =>
      _locationToWire[local] ?? 'pantry';

  static String _locationLocal(String wire) =>
      _locationFromWire[wire] ??
      (_locationToWire.containsKey(wire) ? wire : 'pantry');

  static String _unitWire(String local) =>
      _unitToWire[local] ?? (_scannerOnlyUnits.contains(local) ? local : 'each');

  static String _unitLocal(String wire) => _unitFromWire[wire] ?? wire;

  static Map<String, dynamic> _encode(
    String field,
    String local,
    String Function(String) toWire,
    String Function(String) toLocal,
  ) {
    final wire = toWire(local);
    return {
      field: wire,
      '${field}Detail': toLocal(wire) == local ? null : local,
    };
  }

  static String _decode(
    String field,
    Map<String, dynamic> data,
    String Function(String) toWire,
    String Function(String) toLocal,
    String fallback,
  ) {
    final wire = data[field];
    if (wire is! String || wire.isEmpty) return fallback;
    final detail = data['${field}Detail'];
    if (detail is String && toWire(detail) == wire) return detail;
    return toLocal(wire);
  }
}
