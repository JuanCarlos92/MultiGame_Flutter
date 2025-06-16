class PositionModel {
  final String position;
  final String playerId;

  PositionModel({
    required this.position,
    required this.playerId,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'playerId': playerId,
    };
  }

  // Crear instancia desde JSON
  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      position: json['position'] ?? '',
      playerId: json['playerId'] ?? '',
    );
  }
}