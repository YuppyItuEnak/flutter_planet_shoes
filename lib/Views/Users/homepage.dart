import 'package:flutter/material.dart';
import 'package:flutter_planet_shoes/Controllers/productcontroller.dart';
import 'package:flutter_planet_shoes/Views/Users/detailproduct.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final ProductController productcont = ProductController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 produk per row
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: productcont.Products.length,
          itemBuilder: (context, index) {
            final product = productcont.Products[index];
            return GestureDetector(
              onTap: () {
                // Navigasi ke halaman detail product
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailProductPage(product: product),
                  ),
                );
              },
              child: Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        // productcont.toggleFavorite(product.id);
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        // product.isFavorite
                        //     ? Icons.favorite
                        //     : Icons.favorite_border,
                        // color: product.isFavorite ? Colors.red : Colors.white,
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15)),
                        // contoh image
                        // child: Image.asset(
                        //   product.imageUrl,
                        //   fit: BoxFit.cover,
                        //   width: double.infinity,
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        product.name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8.0),
                      child: Text(
                        "\$${product.price}",
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}