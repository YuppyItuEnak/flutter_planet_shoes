import "package:flutter/material.dart";
import "package:flutter_planet_shoes/Models/product.dart";


class ProductController with ChangeNotifier {
  final List<ProductModel> _products = [
    ProductModel(
      id: '1',
      name: 'Nike Air Max',
      // imageUrl: 'assets/s1.jpg',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer vestibulum velit ut dolor posuere, at tristique quam pellentesque.',
      price: 120.0, 
      stock: 10.0,
    ),
    ProductModel(
      id: '2',
      name: 'Adidas Ultraboost',
      // imageUrl: 'assets/s2.jpg',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer vestibulum velit ut dolor posuere, at tristique quam pellentesque.',
      price: 150.0,
      stock: 10.0,
    ),
    ProductModel(
      id: '3',
      name: 'Puma Classic',
      // imageUrl: 'assets/s3.jpg',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer vestibulum velit ut dolor posuere, at tristique quam pellentesque.',
      price: 90.0,
      stock: 10.0,
    ),
  ];


  List<ProductModel> get Products => _products;

  // void toggleFavorite(String id) {
  //   final index = _products.indexWhere((product) => product.id == id);
  //   if (index != -1) {
  //     _products[index].isFavorite = !_products[index].isFavorite;
  //     notifyListeners();
  //   }
  // }

  // List<Product> getFavoriteProducts() {
  //   return _products.where((product) => product.isFavorite).toList();
  // }
}
