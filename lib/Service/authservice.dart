import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_planet_shoes/Models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<UserModel> getUserInfo() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot doc = await _db.collection('users').doc(currentUser.uid).get();
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, currentUser.uid);
  }

  // Register
  Future<UserModel?> register(String email, String password, String username) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Buat data user di Firestore
      UserModel newUser = UserModel(
        id: cred.user!.uid,
        username: username,
        email: email,
        role: UserRole.user,
      );

      await _db.collection('users').doc(newUser.id).set(newUser.toMap());

      return newUser;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Login
Future<UserModel?> login(String email, String password) async {
  try {
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    DocumentSnapshot doc =
        await _db.collection('users').doc(cred.user!.uid).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception("User data not found in Firestore");
    }

    return UserModel.fromMap(doc.data() as Map<String, dynamic>, cred.user!.uid);
  } catch (e) {
    throw Exception(e.toString());
  }
}


  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
