/// Barcode validation utilities supporting UPC-12, EAN-13, and EAN-8 formats.
///
/// Each format uses a weighted check digit algorithm to verify barcode integrity.
class BarcodeValidator {
  BarcodeValidator._();

  /// Returns `true` if [barcode] is a valid UPC-12, EAN-13, or EAN-8 barcode.
  static bool isValidBarcode(String barcode) {
    return isValidUPC(barcode) ||
        isValidEAN13(barcode) ||
        isValidEAN8(barcode);
  }

  /// Validates a UPC-12 barcode.
  static bool isValidUPC(String barcode) {
    if (barcode.length != 12) return false;
    if (!_isAllDigits(barcode)) return false;

    final digits = barcode.codeUnits.map((c) => c - 48).toList();
    int total = 0;

    for (int i = 0; i < 11; i++) {
      if (i.isEven) {
        total += digits[i] * 3;
      } else {
        total += digits[i];
      }
    }

    final remainder = total % 10;
    final checkDigit = remainder == 0 ? 0 : 10 - remainder;

    return checkDigit == digits[11];
  }

  /// Validates an EAN-13 barcode.
  static bool isValidEAN13(String barcode) {
    if (barcode.length != 13) return false;
    if (!_isAllDigits(barcode)) return false;

    final digits = barcode.codeUnits.map((c) => c - 48).toList();
    int total = 0;

    for (int i = 0; i < 12; i++) {
      if (i.isEven) {
        total += digits[i];
      } else {
        total += digits[i] * 3;
      }
    }

    final remainder = total % 10;
    final checkDigit = remainder == 0 ? 0 : 10 - remainder;

    return checkDigit == digits[12];
  }

  /// Validates an EAN-8 barcode.
  static bool isValidEAN8(String barcode) {
    if (barcode.length != 8) return false;
    if (!_isAllDigits(barcode)) return false;

    final digits = barcode.codeUnits.map((c) => c - 48).toList();
    int total = 0;

    for (int i = 0; i < 7; i++) {
      if (i.isEven) {
        total += digits[i] * 3;
      } else {
        total += digits[i];
      }
    }

    final remainder = total % 10;
    final checkDigit = remainder == 0 ? 0 : 10 - remainder;

    return checkDigit == digits[7];
  }

  /// Detects the barcode format and returns its name.
  static String? detectBarcodeFormat(String barcode) {
    if (isValidUPC(barcode)) return 'UPC-12';
    if (isValidEAN13(barcode)) return 'EAN-13';
    if (isValidEAN8(barcode)) return 'EAN-8';
    return null;
  }

  static bool _isAllDigits(String value) {
    for (int i = 0; i < value.length; i++) {
      final c = value.codeUnitAt(i);
      if (c < 48 || c > 57) return false;
    }
    return true;
  }
}
