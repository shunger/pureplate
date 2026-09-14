import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/features/pantry/data/datasources/pantry_wire_mapper.dart';
import 'package:pure_pantry/features/shopping_list/data/datasources/shopping_list_wire_mapper.dart';

void main() {
  final now = DateTime(2026, 9, 14, 10);

  group('PantryWireMapper', () {
    final row = PantryItem(
      id: 'local-1',
      productId: 'product-uuid',
      name: 'Hot sauce',
      category: 'condiments',
      quantity: 2,
      unitType: 'bottle',
      purchasedAt: now,
      expiresAt: DateTime(2027, 1, 1),
      location: 'fridge',
      notes: 'Opened',
      isStaple: true,
      reorderThreshold: 1,
      isBulk: false,
      purchasePrice: 4.5,
      packSize: null,
      status: 'opened',
      firestorePantryId: null,
      firestoreItemId: null,
      createdAt: now,
      updatedAt: now,
    );

    test('a new item is sent in the scanner format', () {
      final doc = PantryWireMapper.fromRow(row);

      expect(doc['name'], 'Hot sauce');
      expect(doc['category'], 'pantry');
      expect(doc['categoryDetail'], 'condiments');
      expect(doc['unitType'], 'bottle');
      expect(doc['location'], 'fridge');
      expect(doc['expiresAt'], Timestamp.fromDate(DateTime(2027, 1, 1)));
      expect(doc['reorderThreshold'], 1);
      expect(doc['status'], 'opened');
      expect(doc['purchasePrice'], 4.5);
      expect(doc['sourceApp'], 'pantry');
    });

    test('local product IDs are never sent', () {
      expect(PantryWireMapper.fromRow(row).containsKey('productId'), isFalse);
    });

    test('an update sends only the fields that changed', () {
      final fields = PantryWireMapper.fromCompanion(const PantryItemsCompanion(
        id: Value('local-1'),
        quantity: Value(1),
        location: Value('spices'),
      ));

      expect(fields, {
        'quantity': 1.0,
        'location': 'pantry',
        'locationDetail': 'spices',
      });
    });

    test('a scanner-written item decodes into Pure Pantry values', () {
      final companion = PantryWireMapper.toCompanion(
        newLocalId: 'new-id',
        pantryId: 'home',
        itemId: 'fs-1',
        data: {
          'name': 'Oregano',
          'category': 'spicesAndHerbs',
          'quantity': 1,
          'unitType': 'ounce',
          'location': 'freezer',
          'expiresAt': Timestamp.fromDate(DateTime(2027, 3, 1)),
          'reorderThreshold': 2,
          'isBulk': true,
          'status': 'orderSoon',
          'productId': 'scanner-product-id',
        },
        now: now,
      );

      expect(companion.category.value, 'spices');
      expect(companion.unitType.value, 'oz');
      expect(companion.location.value, 'freezer');
      expect(companion.quantity.value, 1.0);
      expect(companion.expiresAt.value, DateTime(2027, 3, 1));
      expect(companion.reorderThreshold.value, 2);
      expect(companion.isBulk.value, isTrue);
      expect(companion.status.value, 'orderSoon');
      expect(companion.firestorePantryId.value, 'home');
      expect(companion.firestoreItemId.value, 'fs-1');
      expect(companion.productId.present, isFalse);
    });
  });

  group('ShoppingListWireMapper', () {
    final row = ShoppingListItem(
      id: 'item-1',
      listId: 'list-1',
      productId: 'product-uuid',
      name: 'Basil',
      brand: 'Farm Co',
      category: 'produce',
      quantity: 2,
      unitType: 'bunch',
      estimatedPrice: 1.99,
      actualPrice: null,
      salePrice: null,
      isOnSale: false,
      isCompleted: true,
      priority: 'normal',
      notes: null,
      recipeId: null,
      recipeName: null,
      pantryQuantityAvailable: 0,
      firestoreListId: null,
      firestoreItemId: null,
      sortOrder: 0,
      addedAt: now,
      updatedAt: now,
    );

    test('a new item uses the scanner field names', () {
      final doc = ShoppingListWireMapper.fromRow(row);

      expect(doc['productName'], 'Basil');
      expect(doc['brand'], 'Farm Co');
      expect(doc['price'], 1.99);
      expect(doc['isChecked'], isTrue);
      expect(doc['category'], 'produce');
      expect(doc['unitType'], 'bunch');
    });

    test('local product IDs are never sent as barcodes', () {
      final doc = ShoppingListWireMapper.fromRow(row);
      expect(doc.containsKey('barcode'), isFalse);
      expect(doc.containsKey('productId'), isFalse);
    });

    test('a scanner-written item decodes with defaults for missing fields', () {
      final companion = ShoppingListWireMapper.toCompanion(
        newLocalId: 'new-id',
        localListId: 'list-1',
        firestoreListId: 'fs-list',
        itemId: 'fs-item',
        data: {
          'productName': 'Salmon',
          'quantity': 1,
          'isChecked': false,
          'category': 'seafood',
          'barcode': '0123456789012',
        },
        now: now,
      );

      expect(companion.name.value, 'Salmon');
      expect(companion.category.value, 'meat');
      expect(companion.unitType.value, 'count');
      expect(companion.isCompleted.value, isFalse);
      expect(companion.productId.present, isFalse);
      expect(companion.listId.value, 'list-1');
    });
  });
}
