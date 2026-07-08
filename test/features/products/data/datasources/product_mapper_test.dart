import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/products/data/datasources/product_mapper.dart';
import 'package:pure_pantry/features/products/domain/models/api_models.dart';
import 'package:pure_pantry/features/products/domain/models/allergen.dart';
import 'package:pure_pantry/features/products/domain/models/identifier_type.dart';
import 'package:pure_pantry/shared/models/product_category.dart';

import '../../../../helpers/test_fixtures.dart';

void main() {
  group('ProductMapper', () {
    group('fromOpenFoodFacts', () {
      test('maps name and brand', () {
        final off = OpenFoodFactsProduct(
          productName: 'Test Cereal',
          brands: 'TestBrand',
        );
        final product = ProductMapper.fromOpenFoodFacts(off, '123456789012');
        expect(product.name, 'Test Cereal');
        expect(product.brand, 'TestBrand');
        expect(product.barcode, '123456789012');
      });

      test('defaults name to Unknown Product when null', () {
        const off = OpenFoodFactsProduct();
        final product = ProductMapper.fromOpenFoodFacts(off, '123');
        expect(product.name, 'Unknown Product');
      });

      test('maps category from OFF categories', () {
        final off = OpenFoodFactsProduct(
          productName: 'Milk',
          categories: 'dairy, milk',
        );
        final product = ProductMapper.fromOpenFoodFacts(off, '123');
        expect(product.category, ProductCategory.dairy);
      });

      test('prefers imageFrontUrl over imageUrl', () {
        final off = OpenFoodFactsProduct(
          productName: 'X',
          imageFrontUrl: 'front.jpg',
          imageUrl: 'fallback.jpg',
        );
        final product = ProductMapper.fromOpenFoodFacts(off, '123');
        expect(product.imageUrl, 'front.jpg');
      });

      test('falls back to imageUrl when imageFrontUrl is null', () {
        final off = OpenFoodFactsProduct(
          productName: 'X',
          imageUrl: 'fallback.jpg',
        );
        final product = ProductMapper.fromOpenFoodFacts(off, '123');
        expect(product.imageUrl, 'fallback.jpg');
      });

      test('maps nutrition info when nutriments present', () {
        final off = OpenFoodFactsProduct(
          productName: 'X',
          nutriments: const OpenFoodFactsNutriments(
            energyKcal: 200,
            fat: 10,
            carbohydrates: 30,
            proteins: 5,
          ),
        );
        final product = ProductMapper.fromOpenFoodFacts(off, '123');
        expect(product.nutritionInfo, isNotNull);
        expect(product.nutritionInfo!.calories, 200);
      });

      test('returns null nutrition when all nutriment fields null', () {
        final off = OpenFoodFactsProduct(
          productName: 'X',
          nutriments: const OpenFoodFactsNutriments(),
        );
        final product = ProductMapper.fromOpenFoodFacts(off, '123');
        expect(product.nutritionInfo, isNull);
      });

      test('parses ingredients text', () {
        final off = OpenFoodFactsProduct(
          productName: 'X',
          ingredientsText: 'flour, sugar, salt',
        );
        final product = ProductMapper.fromOpenFoodFacts(off, '123');
        expect(product.ingredients, ['flour', 'sugar', 'salt']);
      });

      test('returns null ingredients when text is null', () {
        final off = OpenFoodFactsProduct(productName: 'X');
        final product = ProductMapper.fromOpenFoodFacts(off, '123');
        expect(product.ingredients, isNull);
      });

      test('maps allergens from allergens and traces fields', () {
        final off = OpenFoodFactsProduct(
          productName: 'X',
          allergens: 'en:milk',
          traces: 'en:peanuts',
        );
        final product = ProductMapper.fromOpenFoodFacts(off, '123');
        expect(product.allergens, isNotNull);
        expect(product.allergens, contains(Allergen.milk));
        expect(product.allergens, contains(Allergen.peanuts));
      });

      test('sets source to openFoodFacts', () {
        const off = OpenFoodFactsProduct(productName: 'X');
        final product = ProductMapper.fromOpenFoodFacts(off, '123');
        expect(product.source, 'openFoodFacts');
      });

      test('sets identifierType to barcode', () {
        const off = OpenFoodFactsProduct(productName: 'X');
        final product = ProductMapper.fromOpenFoodFacts(off, '123');
        expect(product.identifierType, IdentifierType.barcode);
      });
    });

    group('fromUPCDatabase', () {
      test('maps ean, title, brand, and price', () {
        const upc = UPCDatabaseItem(
          ean: '036000291452',
          title: 'UPC Product',
          brand: 'UPC Brand',
          lowestRecordedPrice: 4.99,
          currency: 'USD',
        );
        final product = ProductMapper.fromUPCDatabase(upc);
        expect(product.barcode, '036000291452');
        expect(product.name, 'UPC Product');
        expect(product.brand, 'UPC Brand');
        expect(product.price, 4.99);
        expect(product.currency, 'USD');
        expect(product.source, 'upcDatabase');
      });
    });

    group('supplementWithUPC', () {
      test('fills null description from UPC', () {
        final base = makeProduct(description: null);
        const upc = UPCDatabaseItem(
          ean: '123',
          title: 'X',
          description: 'UPC desc',
        );
        final result = ProductMapper.supplementWithUPC(base, upc);
        expect(result.description, 'UPC desc');
      });

      test('does not overwrite existing description', () {
        final base = makeProduct(description: 'Original');
        const upc = UPCDatabaseItem(
          ean: '123',
          title: 'X',
          description: 'UPC desc',
        );
        final result = ProductMapper.supplementWithUPC(base, upc);
        expect(result.description, 'Original');
      });

      test('fills null price from UPC', () {
        final base = makeProduct(price: null);
        const upc = UPCDatabaseItem(
          ean: '123',
          title: 'X',
          lowestRecordedPrice: 9.99,
        );
        final result = ProductMapper.supplementWithUPC(base, upc);
        expect(result.price, 9.99);
      });

      test('appends +upcDatabase to source', () {
        final base = makeProduct(source: 'openFoodFacts');
        const upc = UPCDatabaseItem(ean: '123', title: 'X');
        final result = ProductMapper.supplementWithUPC(base, upc);
        expect(result.source, 'openFoodFacts+upcDatabase');
      });

      test('updates category only if base is other', () {
        final base = makeProduct(category: ProductCategory.other);
        const upc = UPCDatabaseItem(
          ean: '123',
          title: 'X',
          category: 'Food',
        );
        final result = ProductMapper.supplementWithUPC(base, upc);
        expect(result.category, ProductCategory.pantryStaple);
      });

      test('preserves existing non-other category', () {
        final base = makeProduct(category: ProductCategory.dairy);
        const upc = UPCDatabaseItem(
          ean: '123',
          title: 'X',
          category: 'Food',
        );
        final result = ProductMapper.supplementWithUPC(base, upc);
        expect(result.category, ProductCategory.dairy);
      });
    });
  });
}
