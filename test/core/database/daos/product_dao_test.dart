import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/core/database/daos/product_dao.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ProductDao dao;

  setUp(() {
    db = createTestDatabase();
    dao = db.productDao;
  });

  tearDown(() async {
    await db.close();
  });

  ProductsCompanion _makeProduct({
    required String id,
    String name = 'Test Product',
    String? barcode,
    String? pluCode,
    String? brand,
    String? description,
    String category = 'other',
    bool isCustom = false,
    bool isFavorite = false,
  }) {
    final now = DateTime.now();
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      barcode: Value(barcode),
      pluCode: Value(pluCode),
      brand: Value(brand),
      description: Value(description),
      category: Value(category),
      isCustom: Value(isCustom),
      isFavorite: Value(isFavorite),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  group('ProductDao', () {
    group('CRUD', () {
      test('insert and get product', () async {
        await dao.insertProduct(_makeProduct(id: 'p1', name: 'Cereal'));
        final product = await dao.getProductById('p1');
        expect(product, isNotNull);
        expect(product!.name, 'Cereal');
      });

      test('update product', () async {
        await dao.insertProduct(_makeProduct(id: 'p1', name: 'Cereal'));
        await dao.updateProduct(ProductsCompanion(
          id: const Value('p1'),
          name: const Value('Granola'),
        ));
        final product = await dao.getProductById('p1');
        expect(product!.name, 'Granola');
      });

      test('delete product', () async {
        await dao.insertProduct(_makeProduct(id: 'p1'));
        await dao.deleteProduct('p1');
        final product = await dao.getProductById('p1');
        expect(product, isNull);
      });
    });

    group('getProductByBarcode', () {
      test('returns product with matching barcode', () async {
        await dao.insertProduct(
            _makeProduct(id: 'p1', barcode: '036000291452'));
        final product = await dao.getProductByBarcode('036000291452');
        expect(product, isNotNull);
        expect(product!.id, 'p1');
      });

      test('returns null for missing barcode', () async {
        final product = await dao.getProductByBarcode('nonexistent');
        expect(product, isNull);
      });
    });

    group('getProductByPluCode', () {
      test('returns product with matching PLU code', () async {
        await dao.insertProduct(
            _makeProduct(id: 'p1', pluCode: '4011'));
        final product = await dao.getProductByPluCode('4011');
        expect(product, isNotNull);
        expect(product!.id, 'p1');
      });

      test('returns null for missing PLU code', () async {
        final product = await dao.getProductByPluCode('9999');
        expect(product, isNull);
      });
    });

    group('searchProducts', () {
      test('matches by name', () async {
        await dao.insertProduct(
            _makeProduct(id: 'p1', name: 'Organic Cereal'));
        final results = await dao.searchProducts('Cereal');
        expect(results.length, 1);
      });

      test('matches by brand', () async {
        await dao.insertProduct(
            _makeProduct(id: 'p1', name: 'X', brand: 'Kelloggs'));
        final results = await dao.searchProducts('Kelloggs');
        expect(results.length, 1);
      });

      test('matches by barcode', () async {
        await dao.insertProduct(
            _makeProduct(id: 'p1', name: 'X', barcode: '123456'));
        final results = await dao.searchProducts('123456');
        expect(results.length, 1);
      });

      test('matches by description', () async {
        await dao.insertProduct(_makeProduct(
            id: 'p1', name: 'X', description: 'Whole grain goodness'));
        final results = await dao.searchProducts('grain');
        expect(results.length, 1);
      });

      test('case insensitive search', () async {
        await dao.insertProduct(
            _makeProduct(id: 'p1', name: 'UPPERCASE CEREAL'));
        final results = await dao.searchProducts('uppercase');
        expect(results.length, 1);
      });

      test('returns empty for no match', () async {
        await dao.insertProduct(_makeProduct(id: 'p1', name: 'Cereal'));
        final results = await dao.searchProducts('zzzzzz');
        expect(results, isEmpty);
      });
    });

    group('getProductsByCategory', () {
      test('filters by category', () async {
        await dao.insertProduct(
            _makeProduct(id: 'p1', name: 'Milk', category: 'dairy'));
        await dao.insertProduct(
            _makeProduct(id: 'p2', name: 'Bread', category: 'bakery'));

        final dairy = await dao.getProductsByCategory('dairy');
        expect(dairy.length, 1);
        expect(dairy.first.name, 'Milk');
      });
    });

    group('toggleFavorite', () {
      test('sets favorite to true', () async {
        await dao.insertProduct(
            _makeProduct(id: 'p1', isFavorite: false));
        await dao.toggleFavorite('p1', true);

        final product = await dao.getProductById('p1');
        expect(product!.isFavorite, isTrue);
      });
    });

    group('getCustomProducts', () {
      test('returns only custom products', () async {
        await dao.insertProduct(
            _makeProduct(id: 'p1', isCustom: true));
        await dao.insertProduct(
            _makeProduct(id: 'p2', isCustom: false));

        final custom = await dao.getCustomProducts();
        expect(custom.length, 1);
        expect(custom.first.isCustom, isTrue);
      });
    });

    group('getFavoriteProducts', () {
      test('returns only favorite products', () async {
        await dao.insertProduct(
            _makeProduct(id: 'p1', isFavorite: true));
        await dao.insertProduct(
            _makeProduct(id: 'p2', isFavorite: false));

        final favorites = await dao.getFavoriteProducts();
        expect(favorites.length, 1);
        expect(favorites.first.isFavorite, isTrue);
      });
    });
  });
}
