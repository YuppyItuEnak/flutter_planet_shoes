import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_planet_shoes/Controllers/productcontroller.dart';
import 'package:flutter_planet_shoes/Models/product.dart';

class DetailProductPage extends StatelessWidget {
  final ProductModel product;

  const DetailProductPage({super.key, required this.product});

  String _categoryLabel(CategoriesProd category) {
    switch (category) {
      case CategoriesProd.sneakers:
        return "Sneakers";
      case CategoriesProd.casual:
        return "Casual";
      case CategoriesProd.sandals:
        return "Sandals";
      case CategoriesProd.sports:
        return "Sports";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final ProductController productController = ProductController();

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Silakan login terlebih dahulu")),
      );
    }

    final wishlistDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(product.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF0F172A),
        title: const Text(
          "Detail Produk",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: wishlistDoc.snapshots(),
            builder: (context, snapshot) {
              final isWishlisted = snapshot.data?.exists ?? false;

              return IconButton(
                icon: Icon(
                  isWishlisted
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isWishlisted ? Colors.red : Colors.grey[700],
                ),
                onPressed: () async {
                  await productController.toggleWishlist(
                    userId: userId,
                    product: product,
                  );
                },
              );
            },
          ),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Container(
              height: 320,
              width: double.infinity,
              color: const Color(0xFFF1F5F9),
              padding: const EdgeInsets.all(20),
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 60),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CATEGORY
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _categoryLabel(product.category),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // NAME
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // PRICE
                  Text(
                    "Rp ${product.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF16A34A),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // STOCK
                  Row(
                    children: [
                      Icon(
                        product.stock > 0
                            ? Icons.check_circle
                            : Icons.cancel,
                        color:
                            product.stock > 0 ? Colors.green : Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.stock > 0
                            ? "Stok tersedia (${product.stock})"
                            : "Stok habis",
                        style: TextStyle(
                          color: product.stock > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Deskripsi Produk",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= BOTTOM BUTTON =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: product.stock > 0 ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              product.stock > 0
                  ? "Tambah ke Keranjang"
                  : "Stok Habis",
            ),
          ),
        ),
      ),
    );
  }
}
