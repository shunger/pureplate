import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data class representing a community-contributed product in Firestore.
/// Schema shared with Smart Shopping Scanner.
class CommunityProduct {
  final String barcode;
  final String name;
  final String? brand;
  final String? category;
  final String contributedBy;
  final DateTime? contributedAt;
  final int confirmationCount;
  final List<String> confirmedBy;
  final int flagCount;
  final List<String> flaggedBy;
  final bool offSubmitted;

  CommunityProduct({
    required this.barcode,
    required this.name,
    this.brand,
    this.category,
    required this.contributedBy,
    this.contributedAt,
    this.confirmationCount = 0,
    this.confirmedBy = const [],
    this.flagCount = 0,
    this.flaggedBy = const [],
    this.offSubmitted = false,
  });

  factory CommunityProduct.fromFirestore(
      String barcode, Map<String, dynamic> data) {
    return CommunityProduct(
      barcode: barcode,
      name: (data['name'] as String?) ?? '',
      brand: data['brand'] as String?,
      category: data['category'] as String?,
      contributedBy: (data['contributedBy'] as String?) ?? '',
      contributedAt: (data['contributedAt'] as Timestamp?)?.toDate(),
      confirmationCount: (data['confirmationCount'] as num?)?.toInt() ?? 0,
      confirmedBy: (data['confirmedBy'] as List?)?.cast<String>() ?? [],
      flagCount: (data['flagCount'] as num?)?.toInt() ?? 0,
      flaggedBy: (data['flaggedBy'] as List?)?.cast<String>() ?? [],
      offSubmitted: (data['offSubmitted'] as bool?) ?? false,
    );
  }
}

/// Firestore-backed datasource for community-contributed products.
/// Schema and collection shared with Smart Shopping Scanner.
class FirestoreCommunityProductDatasource {
  final FirebaseFirestore _firestore;

  FirestoreCommunityProductDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('communityProducts');

  /// Look up a community product by barcode.
  /// Returns null if not found or flagged 3+ times.
  Future<CommunityProduct?> lookupByBarcode(String barcode) async {
    final doc = await _collection.doc(barcode).get();
    if (!doc.exists || doc.data() == null) return null;

    final product = CommunityProduct.fromFirestore(barcode, doc.data()!);
    if (product.flagCount >= 3) return null;

    return product;
  }

  /// Add a new community product using a transaction to prevent duplicates.
  /// Returns the existing product if one already exists for this barcode.
  Future<CommunityProduct?> addProduct({
    required String barcode,
    required String name,
    String? brand,
    String? category,
    required String contributedBy,
  }) async {
    final docRef = _collection.doc(barcode);

    return _firestore.runTransaction<CommunityProduct?>((txn) async {
      final snapshot = await txn.get(docRef);

      // Already exists — return existing product, don't overwrite
      if (snapshot.exists && snapshot.data() != null) {
        return CommunityProduct.fromFirestore(barcode, snapshot.data()!);
      }

      final data = <String, dynamic>{
        'name': name,
        if (brand != null && brand.isNotEmpty) 'brand': brand,
        if (category != null && category.isNotEmpty) 'category': category,
        'contributedBy': contributedBy,
        'contributedAt': FieldValue.serverTimestamp(),
        'confirmationCount': 0,
        'confirmedBy': <String>[],
        'flagCount': 0,
        'flaggedBy': <String>[],
        'offSubmitted': false,
      };

      txn.set(docRef, data);
      return null; // null signals "newly created"
    });
  }
}

/// Provider for the Firestore community product datasource.
final firestoreCommunityProductDatasourceProvider =
    Provider<FirestoreCommunityProductDatasource>((ref) {
  return FirestoreCommunityProductDatasource(FirebaseFirestore.instance);
});
