// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'generate_qr_screen.dart';
import 'package:flutter_game_app/games/balls/pages/balls.dart';
import 'position_screen.dart';
import '../models/position_model.dart';

class PlayersBallsScreen extends StatefulWidget {
  final Widget gameWidget;
  final int playerId;
  final String playerName;

  const PlayersBallsScreen({
    required this.gameWidget,
    required this.playerId,
    required this.playerName,
    super.key,
  });

  @override
  State<PlayersBallsScreen> createState() => _PlayersBallsScreenState();
}

class _PlayersBallsScreenState extends State<PlayersBallsScreen> {
  late List<String> players;

  List<String> posicionesElegidas = ['', '', '', ''];
  bool todosHanSeleccionadoPosicion = false;

  bool mostrarContador = false;
  int contador = 5;

  @override
  void initState() {
    super.initState();
    // Ahora la lista de jugadores incluye el nombre real del jugador
    players = [widget.playerName];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Atención'),
          content: const Text('Debes elegir una posición'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void _showMaxPlayersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Límite de jugadores'),
        content: const Text('Este juego solo permite 4 jugadores.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  IconData _iconoPorPosicion(String posicion) {
    switch (posicion) {
      case 'arriba':
        return Icons.arrow_upward;
      case 'abajo':
        return Icons.arrow_downward;
      case 'izquierda':
        return Icons.arrow_back;
      case 'derecha':
        return Icons.arrow_forward;
      default:
        return Icons.my_location;
    }
  }

  void _iniciarContador() {
    setState(() {
      mostrarContador = true;
      contador = 5;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (contador > 1) {
        setState(() {
          contador--;
        });
        return true;
      } else {
        setState(() {
          contador = 0;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BallsGame(
              playerId: widget.playerId,
              playerName: widget.playerName,
            ),
          ),
        );
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool botonActivo = todosHanSeleccionadoPosicion;

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
            child: SafeArea(
              child: Column(
                children: [
                  // Barra superior con título y botón QR
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sala de juego',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (widget.gameWidget is! BallsGame &&
                                players.length >= 2) {
                              _showMaxPlayersDialog();
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GenerateQrScreen(),
                              ),
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
                      ],
                    ),
                  ),
                  // Lista de jugadores
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          //USAR POSICIONES ELEGIDAS
                          String posicion = posicionesElegidas.length > index
                              ? posicionesElegidas[index]
                              : '';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Text(
                                  players[index],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        _iconoPorPosicion(posicion),
                                        color: Colors.orange.shade200,
                                        size: 36,
                                      ),
                                      onPressed: () async {
                                        // Navegar a la pantalla de selección de posición y esperar el resultado
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PositionScreen(
                                                playerId: players[index]),
                                          ),
                                        );
                                        if (result != null &&
                                            result is PositionModel) {
                                          setState(() {
                                            posicionesElegidas[index] =
                                                result.position.toLowerCase();
                                            todosHanSeleccionadoPosicion =
                                                posicionesElegidas
                                                    .every((p) => p.isNotEmpty);
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Botón Iniciar Juego
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: botonActivo
                          ? () {
                              _iniciarContador();
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: botonActivo
                              ? const Color.fromARGB(255, 255, 115, 0)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: const Center(
                          child: Text(
                            'Iniciar Juego',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Overlay del contador
          if (mostrarContador)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Text(
                  contador > 0 ? '$contador' : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
