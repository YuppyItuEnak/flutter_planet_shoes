import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_planet_shoes/Controllers/productcontroller.dart';
import 'package:flutter_planet_shoes/Models/product.dart';
import 'package:flutter_planet_shoes/Service/conntoapi.dart';
import 'package:flutter_planet_shoes/Views/dashboardpage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ProductController _controller = ProductController();

  // Controller untuk text field
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _stockCtrl = TextEditingController();

  CategoriesProd? _selectedCategory = CategoriesProd.sneakers;

  File? _selectedImage;
  String? _uploadedImageUrl;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  /// Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }


  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Pilih gambar dulu")));
        return;
      }

      // upload image dulu
      _uploadedImageUrl = await ConnToApi.UploadImage(_selectedImage!);

      if (_uploadedImageUrl == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Upload gambar gagal")));
        return;
      }

      User user = FirebaseAuth.instance.currentUser!;
      if (user != null) {
        final newProduct = ProductModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameCtrl.text,
          image: _uploadedImageUrl!, // pakai URL hasil upload
          description: _descCtrl.text,
          price: double.parse(_priceCtrl.text),
          stock: int.parse(_stockCtrl.text),
          category: _selectedCategory!,
        );

        try {
          await _controller.createProduct(newProduct);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Produk berhasil ditambahkan")),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DashboardPage()),
            (route) => false,
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: $e")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Produk")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Nama Produk"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 10),

              // Upload & Preview Image
              _selectedImage == null
                  ? TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text("Pilih Gambar"),
                    )
                  : Column(
                      children: [
                        Image.file(_selectedImage!, height: 150),
                        TextButton(
                          onPressed: _pickImage,
                          child: const Text("Ganti Gambar"),
                        ),
                      ],
                    ),

              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _stockCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Stok"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CategoriesProd>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: "Kategori"),
                items: CategoriesProd.values.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat.name));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text("Simpan Produk"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
