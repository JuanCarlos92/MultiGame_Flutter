import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_config.dart';

class QRService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, dynamic>> loginWithQR(String qrData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/qr'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'qr_data': qrData,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('Código QR inválido o expirado');
      } else {
        throw Exception(
            'Error en la autenticación QR: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error durante la autenticación QR: $e');
    }
  }

  Future<String> generateLoginQR() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generate-qr'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('qr_code')) {
          return data['qr_code'];
        } else {
          throw Exception('QR code not found in response');
        }
      } else {
        throw Exception(
            'Error generating QR code: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating QR code: $e');
    }
  }

  Future<Map<String, dynamic>> checkQRStatus(String qrCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/check-qr-status'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'qr_code': qrCode,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Error checking QR status');
      }
    } catch (e) {
      throw Exception('Error checking QR status: $e');
    }
  }
}
