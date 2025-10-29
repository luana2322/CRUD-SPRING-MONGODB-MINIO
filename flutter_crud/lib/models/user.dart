class UserModel {
  final String username;
  final String email;
  final String? password;
  final String? image; // url

  UserModel({
    required this.username,
    required this.email,
    this.password,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '', // tránh null
      email: json['email'] ?? '',
      password: json['password'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson({bool includePassword = true}) {
    final map = <String, dynamic>{
      'username': username,
      'email': email,
    };
    if (includePassword && password != null) map['password'] = password;
    if (image != null) map['image'] = image;
    return map;
  }
}
