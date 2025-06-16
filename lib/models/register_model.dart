class RegisterModel {
  final String name;
  final String email;
  final String password;

  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Crear instancia desde JSON
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
