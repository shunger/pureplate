import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pure_pantry/features/premium/data/services/purchase_service.dart';

ProductDetails _product(String id) => ProductDetails(
      id: id,
      title: id,
      description: '',
      price: r'$0',
      rawPrice: 0,
      currencyCode: 'USD',
    );

void main() {
  group('PurchaseService.orderForPaywall', () {
    test('puts annual before monthly regardless of store order', () {
      final ordered = PurchaseService.orderForPaywall([
        _product(ProductIds.monthly),
        _product(ProductIds.annual),
      ]);
      expect(ordered.map((p) => p.id),
          [ProductIds.annual, ProductIds.monthly]);
    });

    test('keeps annual first when the store already returns it first', () {
      final ordered = PurchaseService.orderForPaywall([
        _product(ProductIds.annual),
        _product(ProductIds.monthly),
      ]);
      expect(ordered.map((p) => p.id),
          [ProductIds.annual, ProductIds.monthly]);
    });

    test('unknown products go last and keep their store order', () {
      final ordered = PurchaseService.orderForPaywall([
        _product('legacy_b'),
        _product(ProductIds.monthly),
        _product('legacy_a'),
        _product(ProductIds.annual),
      ]);
      expect(ordered.map((p) => p.id), [
        ProductIds.annual,
        ProductIds.monthly,
        'legacy_b',
        'legacy_a',
      ]);
    });

    test('does not mutate the input list', () {
      final input = [
        _product(ProductIds.monthly),
        _product(ProductIds.annual),
      ];
      PurchaseService.orderForPaywall(input);
      expect(input.first.id, ProductIds.monthly);
    });
  });
}
