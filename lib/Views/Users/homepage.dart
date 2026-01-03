import 'package:flutter/material.dart';
import 'package:flutter_planet_shoes/Controllers/productcontroller.dart';
import 'package:flutter_planet_shoes/Models/product.dart';
import 'package:flutter_planet_shoes/Views/Users/detailproduct.dart';
import 'package:flutter_planet_shoes/Views/Users/widget/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController _controller = ProductController();

  @override
  Widget build(BuildContext context) {
    const crossAxisCount = 2;
    const spacing = 12.0;
    const horizontalPadding = 12.0 * 2;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final gridWidth =
        screenWidth - horizontalPadding - spacing * (crossAxisCount - 1);
    final cardWidth = gridWidth / crossAxisCount;

    const metaHeight = 140.0;
    final childAspectRatio = cardWidth / (cardWidth + metaHeight);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<List<ProductModel>>(
            stream: _controller.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Belum ada produk"));
              }

              final products = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.all(14),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: products[index],
                    imageSize: cardWidth,
                    onDetailPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailProductPage(product: products[index]),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
