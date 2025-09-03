import 'package:flutter/material.dart';
import 'package:flutter_planet_shoes/Controllers/productcontroller.dart';
import 'package:flutter_planet_shoes/Models/product.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final ProductController _controller = ProductController();

  @override
  Widget build(BuildContext context) {
    // ---- hitung rasio item grid secara dinamis ----
    const crossAxisCount = 2;
    const spacing = 12.0;
    const horizontalPadding = 12.0 * 2; // kiri+kanan GridView
    final screenWidth = MediaQuery.sizeOf(context).width;

    final gridWidth =
        screenWidth - horizontalPadding - spacing * (crossAxisCount - 1);
    final cardWidth = gridWidth / crossAxisCount;

    // tinggi bagian bawah (judul, harga, stok, tombol)
    const metaHeight = 140.0; // sesuaikan jika butuh
    final childAspectRatio = cardWidth / (cardWidth + metaHeight);

    return Scaffold(
      body: StreamBuilder<List<ProductModel>>(
        stream: _controller.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada produk"));
          }

          final products = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: childAspectRatio, // <= kunci anti-overflow
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final prod = products[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Gambar persegi 1:1, tidak terpotong ---
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: SizedBox(
                        height: cardWidth, // persegi: tinggi == lebar
                        width: double.infinity,
                        child: Container(
                          color: const Color(0xFFF5F5F5),
                          alignment: Alignment.center,
                          child: Image.network(
                            prod.image,
                            fit: BoxFit.contain, // tampil utuh, tidak terpotong
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 40),
                            loadingBuilder: (ctx, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // --- Info produk + tombol ---
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prod.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Rp ${prod.price.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("Stok: ${prod.stock}"),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 38,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "Detail Product",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
