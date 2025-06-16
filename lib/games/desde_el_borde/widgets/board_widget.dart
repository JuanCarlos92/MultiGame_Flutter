import 'package:flutter/material.dart';
import '../logic/game_board.dart';
import '../logic/game_logic.dart';
import '../models/jugador_model.dart';
import '../services/juego_service.dart';

class BoardWidget extends StatefulWidget {
  final int playerId;
  final String playerName;

  const BoardWidget({
    super.key,
    required this.playerId,
    required this.playerName,
  });

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  late GameBoard board;
  late GameLogic gameLogic;
  late JuegoService juegoService;
  String? juegoId;

  @override
  void initState() {
    super.initState();
    board = GameBoard();
    gameLogic = GameLogic(board);
    juegoService = JuegoService();
    _iniciarJuego();
  }

  Future<void> _iniciarJuego() async {
    try {
      final jugadores = [
        JugadorModel(
          id: widget.playerId,
          nombre: widget.playerName,
          ficha: 'X',
          //Sin posicion X e Y
        ),
        JugadorModel(
          id: 2,
          nombre: "Jugador 2",
          ficha: 'O',
          //Sin posicion X e Y
        ),
      ];

      final juego = await juegoService.crearJuego(jugadores);
      setState(() {
        juegoId = juego.id;
      });
    } catch (e) {
      print('Error al iniciar el juego: $e');
    }
  }

  void resetGame() {
    setState(() {
      board.reset();
    });
  }

  // Muestra un cuadro de diálogo cuando un jugador gana
  void showWinnerDialog() {
    showDialog(
      context: context,
      // Evita que se cierre al tocar fuera del diálogo
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('¡Jugador ${board.currentPlayer} ha ganado!'),
        actions: [
          TextButton(
            onPressed: () {
              // Cierra el cuadro de diálogo
              Navigator.pop(context);
              resetGame();
            },
            child: Text('Jugar de nuevo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // Centra el contenido verticalmente
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Muestra el turno del jugador actual
          Text(
            'Turno del Jugador ${board.currentPlayer}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // Muestra el nivel actual del juego
          Text(
            'Nivel: ${board.currentLevel == 0 ? "Exterior" : "Interior"}',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(height: 20),
          // Genera las filas del tablero de juego
          for (int row = 0; row < board.size; row++)
            Row(
              // Centra las filas horizontalmente
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Genera las celdas del tablero
                for (int col = 0; col < board.size; col++)
                  GestureDetector(
                    onTap: () async {
                      if (juegoId != null) {
                        try {
                          await juegoService.hacerMovimiento(
                              juegoId!, row, col);
                          setState(() {
                            gameLogic.playMove(row, col);
                            if (board.gameOver) {
                              showWinnerDialog();
                            }
                          });
                        } catch (e) {
                          // Mostrar error al usuario
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Error al realizar el movimiento')),
                          );
                        }
                      }
                    },
                    child: Container(
                      // Margen entre las celdas
                      margin: EdgeInsets.all(4),
                      width: 60, // Ancho de la celda
                      height: 60, // Alto de la celda
                      decoration: BoxDecoration(
                        color: board.board[row][col] == null
                            ? (board.isValidMove(row, col)
                                ? Colors.green[
                                    100] // Si la celda es válida, color verde claro
                                : Colors.grey[
                                    300]) // Si no es válida, color gris claro
                            : board.board[row][col] == 'X'
                                ? Colors.red
                                : Colors.yellow,
                        // Bordes redondeados
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 40),
          FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 255, 115, 0),
            onPressed: resetGame,
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
