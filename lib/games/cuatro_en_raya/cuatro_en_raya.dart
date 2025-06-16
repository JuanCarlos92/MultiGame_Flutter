import 'package:flutter/material.dart';

class CuatroEnRaya extends StatefulWidget {
  final int playerId;
  final String playerName;

  const CuatroEnRaya({super.key, required this.playerId, required this.playerName});

  @override
  State<CuatroEnRaya> createState() => _CuatroEnRayaState();
}

class _CuatroEnRayaState extends State<CuatroEnRaya> {
  static const int tamanioTablero = 4;
  List<List<String>> tablero = [
    ['', '', '', ''],
    ['', '', '', ''],
    ['', '', '', ''],
    ['', '', '', ''],
  ];

  String turnoActual = 'Jugador 1';
  int fichasColocadasJugador1 = 0;
  int fichasColocadasJugador2 = 0;
  bool faseColocacion = true;

  int? fichaSeleccionadaFila;
  int? fichaSeleccionadaColumna;

  void reiniciarCuatroEnRaya() {
    setState(() {
      tablero = [
        ['', '', '', ''],
        ['', '', '', ''],
        ['', '', '', ''],
        ['', '', '', ''],
      ];

      turnoActual = 'Jugador 1';
      fichasColocadasJugador1 = 0;
      fichasColocadasJugador2 = 0;
      faseColocacion = true;
      fichaSeleccionadaFila = null;
      fichaSeleccionadaColumna = null;
    });
  }

  bool alBorde(int fila, int columna) {
    return fila == 0 ||
        fila == tamanioTablero - 1 ||
        columna == 0 ||
        columna == tamanioTablero - 1;
  }

  bool esAdyacente(int fila, int columna, int fichaFila, int fichaColumna) {
    return (fila - fichaFila).abs() <= 1 && (columna - fichaColumna).abs() <= 1;
  }

  void colocarFicha(int fila, int columna) {
    if (faseColocacion) {
      bool primeraFichaRestriccion =
          turnoActual == 'Jugador 1' && fichasColocadasJugador1 == 0;

      if (tablero[fila][columna].isEmpty &&
          (fichasColocadasJugador1 < 4 || fichasColocadasJugador2 < 4) &&
          (!primeraFichaRestriccion || alBorde(fila, columna))) {
        setState(() {
          String simbolo = turnoActual == 'Jugador 1' ? 'X' : 'O';
          tablero[fila][columna] = simbolo;

          if (turnoActual == 'Jugador 1') {
            fichasColocadasJugador1++;
          } else {
            fichasColocadasJugador2++;
          }

          if (fichasColocadasJugador1 == 4 && fichasColocadasJugador2 == 4) {
            faseColocacion = false;
          }

          turnoActual = turnoActual == 'Jugador 1' ? 'Jugador 2' : 'Jugador 1';
        });
      }
    } else {
      seleccionarOMoverFicha(fila, columna);
    }
  }

  void seleccionarOMoverFicha(int fila, int columna) {
    if (faseColocacion) return;

    if (fichaSeleccionadaFila == null && fichaSeleccionadaColumna == null) {
      if ((turnoActual == 'Jugador 1' && tablero[fila][columna] == 'X') ||
          (turnoActual == 'Jugador 2' && tablero[fila][columna] == 'O')) {
        setState(() {
          fichaSeleccionadaFila = fila;
          fichaSeleccionadaColumna = columna;
        });
      }
    } else {
      if ((turnoActual == 'Jugador 1' && tablero[fila][columna] == 'X') ||
          (turnoActual == 'Jugador 2' && tablero[fila][columna] == 'O')) {
        setState(() {
          fichaSeleccionadaFila = fila;
          fichaSeleccionadaColumna = columna;
        });
      } else if (esAdyacente(
            fila,
            columna,
            fichaSeleccionadaFila!,
            fichaSeleccionadaColumna!,
          ) &&
          tablero[fila][columna].isEmpty) {
        setState(() {
          String simboloActual = turnoActual == 'Jugador 1' ? 'X' : 'O';
          tablero[fila][columna] = simboloActual;
          tablero[fichaSeleccionadaFila!][fichaSeleccionadaColumna!] = '';
          fichaSeleccionadaFila = null;
          fichaSeleccionadaColumna = null;
          turnoActual = turnoActual == 'Jugador 1' ? 'Jugador 2' : 'Jugador 1';
        });
      }
    }
  }

  bool verificarVictoria() {
    for (int fila = 0; fila < tamanioTablero; fila++) {
      for (int columna = 0; columna < tamanioTablero; columna++) {
        if (tablero[fila][columna].isNotEmpty) {
          if (_esCuatroEnRaya(fila, columna)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool _esCuatroEnRaya(int fila, int columna) {
    const direcciones = [
      [1, 0], // Horizontal
      [0, 1], // Vertical
      [1, 1], // Diagonal principal
      [1, -1], // Diagonal secundaria
    ];

    for (var direccion in direcciones) {
      int consecutivos = 1;
      for (int i = 1; i < 4; i++) {
        int nuevaFila = fila + direccion[0] * i;
        int nuevaColumna = columna + direccion[1] * i;
        if (nuevaFila >= 0 &&
            nuevaFila < tamanioTablero &&
            nuevaColumna >= 0 &&
            nuevaColumna < tamanioTablero &&
            tablero[nuevaFila][nuevaColumna] == tablero[fila][columna]) {
          consecutivos++;
        } else {
          break;
        }
      }
      if (consecutivos == 4) {
        return true;
      }
    }
    return false;
  }

  Widget construirTablero() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(tamanioTablero, (fila) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(tamanioTablero, (columna) {
            bool esSeleccionada = fichaSeleccionadaFila == fila &&
                fichaSeleccionadaColumna == columna;

            return GestureDetector(
              onTap: () {
                colocarFicha(fila, columna);
                if (verificarVictoria()) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("¡Victoria!"),
                      content: Text(
                        "${turnoActual == 'Jugador 1' ? 'Jugador 2' : 'Jugador 1'} ha ganado.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            reiniciarCuatroEnRaya();
                          },
                          child: const Text("Reiniciar"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.all(4.0),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: esSeleccionada ? Colors.yellow : Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    tablero[fila][columna],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

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
                Text(
                  'Turno del $turnoActual',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  faseColocacion ? 'Fase de colocación' : 'Fase de movimiento',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                construirTablero(),
                const SizedBox(height: 40),
                FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 255, 115, 0),
                  onPressed: reiniciarCuatroEnRaya,
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
