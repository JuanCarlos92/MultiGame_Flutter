// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_game_app/screens/main_screen.dart';
import 'package:flutter_game_app/screens/register_screen.dart';
import 'package:flutter_game_app/screens/generate_qr_screen.dart';
import 'package:provider/provider.dart';
import 'providers/player_provider.dart';
import 'screens/login_screen.dart';
import 'screens/scan_qr_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ],
      child: const GameApp(),
    ),
  );
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Lugus",
      themeMode: ThemeMode.system, // System theme
      theme: ThemeData.light().copyWith(
        // Light theme
        primaryColor: const Color.fromARGB(255, 0, 0, 0),
        cardColor: const Color(0xFFF6D7A8).withOpacity(0.4),
        canvasColor: const Color(0xFFFFCE77),
        iconTheme: const IconThemeData(color: Colors.black54),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF58D00),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        // Dark theme
        primaryColor: Colors.blue,
        cardColor: Colors.black.withOpacity(0.4),
        canvasColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white70),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF58D00),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
        ),
      ),
      initialRoute: '/scanqr',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/qrgenerate': (context) => const GenerateQrScreen(),
        '/scanqr': (context) => const ScanQrScreen(),
        '/mainscreen': (context) =>
            const MainScreen(playerId: 0, playerName: ''),
      },
    );
  }
}
