import 'package:flutter/material.dart';
import '../widgets/board_widget.dart';

class DesdeElBorde extends StatefulWidget {
  final int playerId;
  final String playerName;

  const DesdeElBorde({
    super.key,
    required this.playerId,
    required this.playerName,
  });

  @override
  State<DesdeElBorde> createState() => _DesdeElBordeState();
}

class _DesdeElBordeState extends State<DesdeElBorde> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoardWidget(
                  playerId: widget.playerId,
                  playerName: widget.playerName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
