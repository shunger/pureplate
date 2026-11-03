import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/shared/models/product_category.dart';

void main() {
  test('fromName reads every category by its name', () {
    for (final category in ProductCategory.values) {
      expect(ProductCategory.fromName(category.name), category);
    }
  });

  test('fromName reads the older "pantry" as pantry staples', () {
    expect(ProductCategory.fromName('pantry'), ProductCategory.pantryStaple);
  });

  test('fromName reads unknown names as other', () {
    expect(ProductCategory.fromName('bogus'), ProductCategory.other);
  });
}
