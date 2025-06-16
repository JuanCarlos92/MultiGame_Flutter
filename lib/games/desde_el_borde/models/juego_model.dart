import 'jugador_model.dart';

class JuegoModel {
  final String id;
  final String tipoJuego;
  final List<JugadorModel> jugadores;
  final List<List<String>> tablero;
  final String estado;
  final DateTime creadoEn;
  final DateTime actualizado;
  final int turno;
  final JugadorModel? ganador;

  JuegoModel({
    required this.id,
    required this.tipoJuego,
    required this.jugadores,
    required this.tablero,
    required this.estado,
    required this.creadoEn,
    required this.actualizado,
    required this.turno,
    this.ganador,
  });

  factory JuegoModel.fromJson(Map<String, dynamic> json) {
    return JuegoModel(
      id: json['id'] as String,
      tipoJuego: json['tipo_juego'] as String,
      jugadores: (json['jugadores'] as List)
          .map((j) => JugadorModel.fromJson(j))
          .toList(),
      tablero: (json['tablero'] as List)
          .map((row) => (row as List).map((cell) => cell as String).toList())
          .toList(),
      estado: json['estado'] as String,
      creadoEn: DateTime.parse(json['creado_en']),
      actualizado: DateTime.parse(json['actualizado_en']),
      turno: json['turno'] as int,
      ganador:
          json['winner'] != null ? JugadorModel.fromJson(json['winner']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo_juego': tipoJuego,
      'jugadores': jugadores.map((j) => j.toJson()).toList(),
      'tablero': tablero,
      'estado': estado,
      'creado_en': creadoEn.toIso8601String(),
      'actualizado_en': actualizado.toIso8601String(),
      'turno': turno,
      'winner': ganador?.toJson(),
    };
  }
}
