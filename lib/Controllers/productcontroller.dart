import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_planet_shoes/Models/product.dart";

class ProductController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createProduct(ProductModel product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .set(product.toMap());
      print('Product created successfully');
    } catch (e) {
      print('Error creating product: $e');
    }
  }

  Stream<List<ProductModel>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProductModel.fromDoc(doc)).toList();
    });
  }

  Future<void> toggleWishlist({
  required String userId,
  required ProductModel product,
}) async {
  final doc = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('wishlist')
      .doc(product.id);

  final snapshot = await doc.get();

  if (snapshot.exists) {
    await doc.delete();
  } else {
    await doc.set({
      'productId': product.id,
      'name': product.name,
      'image': product.image,
      'description': product.description,
      'price': product.price,
      'stock': product.stock,
      'category': product.category.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}


  Future<bool> isWishlisted({
    required String userId,
    required String productId,
  }) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(productId)
        .get();

    return doc.exists;
  }
}
