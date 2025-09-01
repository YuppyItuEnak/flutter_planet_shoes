import 'package:flutter/material.dart';
import 'package:flutter_planet_shoes/Controllers/authcontroller.dart';
import 'package:flutter_planet_shoes/Models/user.dart';
import 'package:flutter_planet_shoes/Views/Admin/addproductpage.dart';
import 'package:flutter_planet_shoes/Views/Admin/adminhomepage.dart';
import 'package:flutter_planet_shoes/Views/Admin/adminprofile.dart';
import 'package:flutter_planet_shoes/Views/loginpage.dart';

class DashboardPage extends StatefulWidget {

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final AuthController _authController = AuthController();
  final List<Widget> _pages = [
    const AdminHomePage(),
    const AddProductPage(),
    const AdminProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planet Shoes"),
        actions: [
          IconButton(
            onPressed: () async {
              await _authController.logout();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (Route<dynamic> route) => false, // hapus semua route sebelumnya
              );
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.grey[900],
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Product",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
