
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final int index;
  const GameCard({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videogame_asset, size: 40),
          const SizedBox(height: 8),
          Text("Juego \${index + 1}")
        ],
      ),
    );
  }
}
