import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_game_app/services/backend/qr_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'main_screen.dart';

// Widget principal para la pantalla de generación de QR
class GenerateQrScreen extends StatefulWidget {
  const GenerateQrScreen({super.key});

  @override
  State<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

// Estado del widget que maneja la lógica y UI de la pantalla
class _GenerateQrScreenState extends State<GenerateQrScreen> {
  // Instancia del servicio de autenticación
  final QRService _qrService = QRService();
  // Variables de estado
  bool _isLoading = true;
  String? _error;
  String? _qrData;
  // Timer para verificar el estado del QR periódicamente
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Genera el QR al iniciar la pantalla
    _generateQR();
  }

  @override
  void dispose() {
    // Cancela el timer cuando se destruye el widget
    _timer?.cancel();
    super.dispose();
  }

  // Método para generar el código QR
  Future<void> _generateQR() async {
    try {
      // Obtiene el código QR del servidor
      final qrCode = await _qrService.generateLoginQR();
      if (mounted) {
        setState(() {
          _qrData = qrCode;
          _isLoading = false;
        });
        // Inicia la verificación periódica del estado del QR
        _startCheckingQRStatus();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // Método para verificar periódicamente si el QR ha sido escaneado
  void _startCheckingQRStatus() {
    // Verifica cada 2 segundos
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        if (_qrData != null) {
          // Consulta el estado del QR en el servidor
          final status = await _qrService.checkQRStatus(_qrData!);
          // Si está autenticado, navega a la pantalla principal
          if (status['authenticated'] == true) {
            _timer?.cancel();
            if (mounted) {
              // Supón que el backend devuelve el id y nombre del jugador en el objeto status
              final int playerId = status['player']['id'];
              final String playerName = status['player']['nombre'];
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MainScreen(
                    playerId: playerId,
                    playerName: playerName,
                  ),
                ),
              );
            }
          }
        }
      } catch (e) {
        // Continúa verificando incluso si hay un error
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de la pantalla
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://i.ibb.co/NdgRqQCP/ffe426be7cb5ca65f84027dc234478aa.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Contenido principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo de la aplicación
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(
                    'assets/iconoregistro.png',
                    height: 90,
                  ),
                ),
                const SizedBox(height: 30),
                // Título
                const Text(
                  'Quickly Join',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                // Contenedor del código QR
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 250,
                    height: 250,
                    color: Colors.white,
                    child: _isLoading
                        // Indicador de carga mientras se genera el QR
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFF58D00),
                            ),
                          )
                        // Muestra error si ocurrió alguno
                        : _error != null
                            ? Center(
                                child: Text(
                                  _error!,
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            // Muestra el código QR
                            : Center(
                                child: QrImageView(
                                  data: _qrData!,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                              ),
                  ),
                ),
                const SizedBox(height: 30),
                // Texto instructivo
                const Text(
                  'Escanea este código QR\ncon otro dispositivo para unirte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
