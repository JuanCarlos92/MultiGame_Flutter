import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/juego_model.dart';
import '../models/jugador_model.dart';

class JuegoService {
  final String baseUrl = 'http://localhost:8080'; // Ajusta según tu configuración

  Future<JuegoModel> crearJuego(List<JugadorModel> jugadores) async {
    final response = await http.post(
      Uri.parse('$baseUrl/juego/desde-borde'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jugadores.map((j) => j.toJson()).toList()),
    );

    if (response.statusCode == 201) {
      return JuegoModel.fromJson(json.decode(response.body)['juego']);
    } else {
      throw Exception('Error al crear el juego');
    }
  }

  Future<void> hacerMovimiento(String juegoId, int destinoX, int destinoY) async {
    final response = await http.post(
      Uri.parse('$baseUrl/juego/desde-borde/$juegoId/movimiento'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'destino_x': destinoX,
        'destino_y': destinoY,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al realizar el movimiento');
    }
  }

  Future<JuegoModel> obtenerJuego(String juegoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/juego/desde-borde/$juegoId'),
    );

    if (response.statusCode == 200) {
      return JuegoModel.fromJson(json.decode(response.body)['juego']);
    } else {
      throw Exception('Error al obtener el juego');
    }
  }
}