// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'generate_qr_screen.dart';

class PlayersScreen extends StatefulWidget {
  final Widget gameWidget;
  final int playerId;
  final String playerName;

  const PlayersScreen({
    required this.gameWidget,
    required this.playerId,
    required this.playerName,
    super.key,
  });

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  late List<String> players;
  bool mostrarContador = false;
  int contador = 5;

  @override
  void initState() {
    super.initState();
    players = [widget.playerName];
  }

  void _showMaxPlayersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Límite de jugadores'),
        content: const Text('Este juego solo permite 2 jugadores.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
            builder: (_) => widget.gameWidget,
          ),
        );
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool botonActivo = players.length == 2;

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
                            if (players.length >= 2) {
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
                            padding: const EdgeInsets.all(10.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'QR',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (context, index) {
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
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
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
