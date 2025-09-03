import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_planet_shoes/Models/product.dart";

class ProductController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<String?> uploadImage(File imageFile) async {
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse("http://your-backend.com/api/upload-image"),
  //   );
  //   request.files.add(
  //     await http.MultipartFile.fromPath('image', imageFile.path),
  //   );

  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     var responseBody = await response.stream.bytesToString();
  //     final data = jsonDecode(responseBody);
  //     return data['url']; // URL untuk disimpan ke Firestore
  //   } else {
  //     return null;
  //   }
  // }

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

  Stream<List<ProductModel>> streamProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProductModel.fromDoc(doc)).toList();
    });
  }
}
