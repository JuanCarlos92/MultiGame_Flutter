import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/register_model.dart';
import '../api_config.dart';

class RegisterService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      print('LOG - Iniciando registro para usuario: $email');

      final registerModel =
          RegisterModel(name: name, email: email, password: password);

      // Agregar log del payload
      print('LOG - Payload: ${json.encode(registerModel.toJson())}');
      print('LOG - Enviando datos al servidor: ${baseUrl}/register');

      final response = await http.post(
        Uri.parse('${baseUrl}/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(registerModel.toJson()),
      );

      print('LOG - Respuesta recibida - Status Code: ${response.statusCode}');

      if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        print('LOG - Error de validación: ${errorData['message'] ?? errorData}');
        throw Exception(
            'Error de validación: ${errorData['message'] ?? 'Datos inválidos'}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('LOG - Registro exitoso para: $email');
        return data;
      } else {
        print('Error del servidor: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Error en el registro: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error durante el proceso de registro: $e');
      if (e is FormatException) {
        print('Error al procesar la respuesta JSON');
      } else if (e is http.ClientException) {
        print('Error de conexión con el servidor');
      }
      throw Exception('Error durante el registro: $e');
    }
  }
}
