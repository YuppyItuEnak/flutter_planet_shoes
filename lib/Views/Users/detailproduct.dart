import 'package:flutter/material.dart';
import 'package:flutter_planet_shoes/Models/product.dart';

class DetailProductPage extends StatefulWidget {
  final ProductModel product;

  const DetailProductPage({super.key, required this.product});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Detail Product Page"),
        ),
      ),
    );
  }
}