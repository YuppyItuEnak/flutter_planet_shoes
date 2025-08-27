import 'package:flutter/material.dart';
import 'package:flutter_planet_shoes/Controllers/authcontroller.dart';
import 'package:flutter_planet_shoes/Models/user.dart';
import 'package:flutter_planet_shoes/Views/Users/cartpage.dart';
import 'package:flutter_planet_shoes/Views/Users/homepage.dart';
import 'package:flutter_planet_shoes/Views/loginpage.dart';
import 'package:flutter_planet_shoes/Views/profilepage.dart';
import 'package:flutter_planet_shoes/Views/Users/wishlistpage.dart';

class Mainpage extends StatefulWidget {
  final UserModel user;

  const Mainpage({super.key, required this.user});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  final AuthController _authController = AuthController();
  final List<Widget> _pages = [
    const HomePage(),
    const CartPage(),
    const WishlistPage(),
    const ProfilePage(),
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
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
