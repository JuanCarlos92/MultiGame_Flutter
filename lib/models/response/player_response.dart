class PlayerResponse {
  final int id;
  final String nombre;
  final String email;

  PlayerResponse({
    required this.id,
    required this.nombre,
    required this.email,
  });

  // Crear instancia desde JSON
  factory PlayerResponse.fromJson(Map<String, dynamic> json) {
    return PlayerResponse(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
    };
  }
}
