import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_config.dart';
import '../../models/login_model.dart';
import '../../models/response/player_response.dart';
import 'package:provider/provider.dart';
import '../../providers/player_provider.dart';

class LoginService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<PlayerResponse> login(
      String email, String password, BuildContext context) async {
    try {
      final loginModel = LoginModel(email: email, password: password);

      // Agregar log del payload
      print('Login Request Payload: ${json.encode(loginModel.toJson())}');
      print('LOG - Enviando datos al servidor: ${baseUrl}/login');

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(loginModel.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final player = PlayerResponse.fromJson(data);
        // Actualizar el provider
        Provider.of<PlayerProvider>(context, listen: false).setPlayer(player);
        return player;
      } else if (response.statusCode == 401) {
        throw Exception(
            'Credenciales inválidas. Por favor, inicia sesión nuevamente.');
      } else {
        throw Exception(
            'Error de autenticación: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
