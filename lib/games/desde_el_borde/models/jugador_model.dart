class JugadorModel {
  final int id;
  final String nombre;
  final String ficha; // X u O
  final int? posicionX; // Posición en el eje X
  final int? posicionY; // Posición en el eje Y

  JugadorModel({
    required this.id,
    required this.nombre,
    required this.ficha,
    this.posicionX,
    this.posicionY,
  });

  factory JugadorModel.fromJson(Map<String, dynamic> json) {
    return JugadorModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      ficha: json['ficha'] as String,
      posicionX: json['posicion_x'] as int?,
      posicionY: json['posicion_y'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'ficha': ficha,
      'posicion_x': posicionX,
      'posicion_y': posicionY,
    };
  }
}
