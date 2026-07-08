import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/utils/barcode_validator.dart';

void main() {
  group('BarcodeValidator', () {
    group('isValidUPC', () {
      test('accepts valid UPC-12', () {
        expect(BarcodeValidator.isValidUPC('036000291452'), isTrue);
      });

      test('accepts another valid UPC-12', () {
        expect(BarcodeValidator.isValidUPC('012345678905'), isTrue);
      });

      test('rejects wrong check digit', () {
        expect(BarcodeValidator.isValidUPC('036000291453'), isFalse);
      });

      test('rejects wrong length', () {
        expect(BarcodeValidator.isValidUPC('03600029145'), isFalse);
      });

      test('rejects non-digits', () {
        expect(BarcodeValidator.isValidUPC('03600029145a'), isFalse);
      });

      test('rejects empty string', () {
        expect(BarcodeValidator.isValidUPC(''), isFalse);
      });
    });

    group('isValidEAN13', () {
      test('accepts valid EAN-13', () {
        expect(BarcodeValidator.isValidEAN13('4006381333931'), isTrue);
      });

      test('accepts another valid EAN-13', () {
        expect(BarcodeValidator.isValidEAN13('5901234123457'), isTrue);
      });

      test('rejects wrong check digit', () {
        expect(BarcodeValidator.isValidEAN13('4006381333932'), isFalse);
      });

      test('rejects wrong length', () {
        expect(BarcodeValidator.isValidEAN13('400638133393'), isFalse);
      });
    });

    group('isValidEAN8', () {
      test('accepts valid EAN-8', () {
        expect(BarcodeValidator.isValidEAN8('96385074'), isTrue);
      });

      test('rejects wrong check digit', () {
        expect(BarcodeValidator.isValidEAN8('96385075'), isFalse);
      });

      test('rejects wrong length', () {
        expect(BarcodeValidator.isValidEAN8('9638507'), isFalse);
      });
    });

    group('isValidBarcode', () {
      test('accepts valid UPC-12', () {
        expect(BarcodeValidator.isValidBarcode('036000291452'), isTrue);
      });

      test('accepts valid EAN-13', () {
        expect(BarcodeValidator.isValidBarcode('4006381333931'), isTrue);
      });

      test('accepts valid EAN-8', () {
        expect(BarcodeValidator.isValidBarcode('96385074'), isTrue);
      });

      test('rejects invalid barcode', () {
        expect(BarcodeValidator.isValidBarcode('12345'), isFalse);
      });
    });

    group('detectBarcodeFormat', () {
      test('detects UPC-12', () {
        expect(
            BarcodeValidator.detectBarcodeFormat('036000291452'), 'UPC-12');
      });

      test('detects EAN-13', () {
        expect(
            BarcodeValidator.detectBarcodeFormat('4006381333931'), 'EAN-13');
      });

      test('detects EAN-8', () {
        expect(BarcodeValidator.detectBarcodeFormat('96385074'), 'EAN-8');
      });

      test('returns null for invalid barcode', () {
        expect(BarcodeValidator.detectBarcodeFormat('12345'), isNull);
      });
    });
  });
}
