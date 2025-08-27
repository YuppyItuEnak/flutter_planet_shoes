import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_planet_shoes/Views/registerpage.dart';
// import 'package:flutter_planet_shoes/Views/mainpage.dart';
import 'package:flutter_planet_shoes/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "PlanetShoes",
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    );
  }
}
