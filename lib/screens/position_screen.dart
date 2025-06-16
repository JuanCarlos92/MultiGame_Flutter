// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/position_model.dart';

class PositionScreen extends StatelessWidget {
  final String playerId;

  const PositionScreen({
    required this.playerId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior con título centrado
              Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: const Center(
                  child: Text(
                    'Posición',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Contenedor con los círculos
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = 80.0;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: constraints.maxHeight * 0.1,
                            child:
                                _buildPositionCircle(size, 'Arriba', context),
                          ),
                          Positioned(
                            bottom: constraints.maxHeight * 0.1,
                            child: _buildPositionCircle(size, 'Abajo', context),
                          ),
                          Positioned(
                            left: constraints.maxWidth * 0.001,
                            child: _buildPositionCircle(
                                size, 'Izquierda', context),
                          ),
                          Positioned(
                            right: constraints.maxWidth * 0.001,
                            child:
                                _buildPositionCircle(size, 'Derecha', context),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPositionCircle(
      double size, String position, BuildContext context) {
    IconData getIcon() {
      switch (position) {
        case 'Arriba':
          return Icons.arrow_upward;
        case 'Abajo':
          return Icons.arrow_downward;
        case 'Izquierda':
          return Icons.arrow_back;
        case 'Derecha':
          return Icons.arrow_forward;
        default:
          return Icons.arrow_upward;
      }
    }

    return GestureDetector(
      onTap: () {
        final positionModel = PositionModel(
          position: position,
          playerId: playerId,
        );
        Navigator.pop(context, positionModel);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 115, 0),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            getIcon(),
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
