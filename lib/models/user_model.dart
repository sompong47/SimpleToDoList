class UserModel {
  String username;
  String password;
  String email;
  DateTime createdAt;

  UserModel({
    required this.username,
    required this.password,
    required this.email,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      password: json['password'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'email': email,
        'createdAt': createdAt.toIso8601String(),
      };
}