import 'package:cloud_firestore/cloud_firestore.dart';

enum CategoriesProd { sneakers, casual, sandals, sports }

CategoriesProd mapCategory(String cat) {
  switch (cat.toLowerCase()) {
    case "sneakers":
      return CategoriesProd.sneakers;
    case "casual":
      return CategoriesProd.casual;
    case "sandals":
      return CategoriesProd.sandals;
    case "sport":
      return CategoriesProd.sports;
    default:
      return CategoriesProd.sneakers;
  }
}



class ProductModel {
  final String id;
  final String name;
  final String image;
  final String description;
  final double price;
  final int stock;
  final CategoriesProd category;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'image': image,
    'description': description,
    'price': price,
    'stock': stock,
    'category': category.name,
  };

  factory ProductModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'],
      image: data['image'],
      description: data['description'],
      price: (data['price'] as num).toDouble(),
      stock: data['stock'],
      category: CategoriesProd.values.firstWhere(
        (e) =>
            e.name.toLowerCase() == (data['category'] as String).toLowerCase(),
        orElse: () => CategoriesProd.sneakers,
      ),
    );
  }
}
