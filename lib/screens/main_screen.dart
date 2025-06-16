import 'package:flutter/material.dart';
import 'package:flutter_game_app/games/balls/pages/balls.dart';
import 'package:flutter_game_app/screens/generate_qr_screen.dart';
import 'package:flutter_game_app/games/conecta_cuatro/conecta_cuatro.dart';
import 'package:flutter_game_app/games/cuatro_en_raya/cuatro_en_raya.dart';
import 'package:flutter_game_app/games/desde_el_borde/pages/desde_el_borde.dart';

import 'players_balls_screen.dart';
import 'players_screen.dart';
// import '../services/token_service.dart';
// import 'login_screen.dart';// Add this import at the top

class MainScreen extends StatefulWidget {
  final int playerId;
  final String playerName;

  const MainScreen({
    super.key,
    required this.playerId,
    required this.playerName,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    // Lista de nombres predefinidos para los juegos
    final gameNames = [
      'Conecta 4',
      '4 en Rayas',
      'Desde el borde',
      'Juego de pelotas'
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 48.0,
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'LUGUS',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 40,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 30,
                    ),
                    itemCount: gameNames.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Widget selectedGame;
                          if (index == 0) {
                            selectedGame = ConectaCuatro(
                              playerId: widget.playerId,
                              playerName: widget.playerName,
                            );
                          } else if (index == 1) {
                            selectedGame = CuatroEnRaya(
                              playerId: widget.playerId,
                              playerName: widget.playerName,
                            );
                          } else if (index == 2) {
                            selectedGame = DesdeElBorde(
                              playerId: widget.playerId,
                              playerName: widget.playerName,
                            );
                          } else {
                            selectedGame = BallsGame(
                              playerId: widget.playerId,
                              playerName: widget.playerName,
                            );
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => index == 3
                                  ? PlayersBallsScreen(
                                      gameWidget: selectedGame,
                                      playerId: widget.playerId,
                                      playerName: widget.playerName)
                                  : PlayersScreen(
                                      gameWidget: selectedGame,
                                      playerId: widget.playerId,
                                      playerName: widget.playerName),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 148,
                              width: 148,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/game${index + 1}.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              gameNames[index],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const GenerateQrScreen()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 115, 0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            color: Colors.black,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
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
