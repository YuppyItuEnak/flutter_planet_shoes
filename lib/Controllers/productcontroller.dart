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
}
