import 'package:flutter/material.dart';
import '../widgets/board_widget.dart';

class BallsGame extends StatelessWidget {
  final int playerId;
  final String playerName;

  const BallsGame({super.key, required this.playerId, required this.playerName});

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
          const Center(
            child: BoardWidget(),
          ),
        ],
      ),
    );
  }
}