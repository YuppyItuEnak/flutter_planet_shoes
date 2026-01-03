import 'package:flutter_planet_shoes/Models/user.dart';
import 'package:flutter_planet_shoes/Service/authservice.dart';

class AuthController {
  final AuthService _authService = AuthService();
  




  Future<UserModel> getUserInfo() async{
    try {
      return await _authService.getUserInfo();
    } catch (e) {
      rethrow;
    }
  }

  // Register user baru
  Future<UserModel?> register(String email, String password, String username) async {
    try {
      return await _authService.register(email, password, username);
    } catch (e) {
      rethrow;
    }
  }

  // Login user
  Future<UserModel?> login(String email, String password) async {
    try {
      return await _authService.login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  // Logout user
  Future<void> logout() async {
    await _authService.logout();
  }
}