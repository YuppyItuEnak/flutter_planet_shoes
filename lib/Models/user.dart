enum UserRole { admin, user }

class UserModel {
  final String id;
  final String username;
  final String email;
  // final String password;
  final UserRole role;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    // required this.password,
    this.role = UserRole.user,
  });

  String _roleToString(UserRole role) {
    return role.toString().split('.').last; // "user" / "admin"
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': _roleToString(role),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      role: map['role'] != null
          ? UserRole.values.firstWhere(
              (e) => e.toString().split('.').last == map['role'],
              orElse: () => UserRole.user,
            )
          : UserRole.user,
    );
  }
}
