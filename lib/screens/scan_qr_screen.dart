import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_game_app/services/backend/qr_service.dart';
import 'main_screen.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final QRService _qrService = QRService();
  bool _isProcessing = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue == null) continue;

      setState(() {
        _isProcessing = true;
      });

      try {
        // Procesar el código QR escaneado
        final response = await _qrService.loginWithQR(barcode.rawValue!);
        if (response['success'] == true) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MainScreen(
                  playerId: response['player']['id'],
                  playerName: response['player']['nombre'],
                ),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
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
          Column(
            children: [
              const SizedBox(height: 50),
              // Logo y título
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
              const Text(
                'Scan QR',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              // Área del scanner
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: MobileScanner(
                    onDetect: _onDetect,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Texto instructivo
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Apunta tu cámara al código QR\npara unirte al juego',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }
}
