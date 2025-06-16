import 'package:flutter/material.dart';
import 'dart:math' as math;

class Ball {
  double x;
  double y;
  double vx;
  double vy;
  Color color;
  static const double radius = 40.0;
  double latitude;
  double longitude;
  String playerId;

  Ball({
    required this.x,
    required this.y,
    this.vx = 0,
    this.vy = 0,
    required this.color,
    this.latitude = 0,
    this.longitude = 0,
    required this.playerId,
  });
}

class GameLogic {
  final List<Ball> balls = [];
  Ball? selectedBall;
  Offset? dragStart;

  void initializeBalls() {
    final random = math.Random();
    for (int i = 0; i < 10; i++) {
      balls.add(Ball(
        x: 150 + random.nextDouble() * 100,
        y: 150 + random.nextDouble() * 100,
        color: Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        ),
        playerId: 'Player$i',
      ));
    }
  }

  void updatePhysics(Size screenSize) {
    for (var ball in balls) {
      // Aplicar gravedad
      ball.vy += 0.5;

      // Actualizar posición
      ball.x += ball.vx;
      ball.y += ball.vy;

      // Colisión con el suelo
      if (ball.y > screenSize.height - Ball.radius) {
        ball.y = screenSize.height - Ball.radius;
        ball.vy *= -0.8;
      }

      // Colisiones con paredes laterales dependiendo de la posición vertical
      if (ball.y > screenSize.height / 2) {
        // En la mitad inferior: mantener las bolas dentro de la pantalla
        if (ball.x < Ball.radius || ball.x > screenSize.width - Ball.radius) {
          ball.x = ball.x < Ball.radius
              ? Ball.radius
              : screenSize.width - Ball.radius;
          ball.vx *= -0.8;
        }
      }
      // En la mitad superior las bolas pueden salir libremente

      // Fricción
      ball.vx *= 0.99;
      ball.vy *= 0.99;
    }

    // Colisiones entre pelotas
    for (int i = 0; i < balls.length; i++) {
      for (int j = i + 1; j < balls.length; j++) {
        handleCollision(balls[i], balls[j]);
      }
    }
  }

  void handleCollision(Ball b1, Ball b2) {
    double dx = b2.x - b1.x;
    double dy = b2.y - b1.y;
    double distance = math.sqrt(dx * dx + dy * dy);

    if (distance < Ball.radius * 2) {
      double angle = math.atan2(dy, dx);
      double sin = math.sin(angle);
      double cos = math.cos(angle);

      // Rotación de velocidades
      double vx1 = b1.vx * cos + b1.vy * sin;
      double vy1 = b1.vy * cos - b1.vx * sin;
      double vx2 = b2.vx * cos + b2.vy * sin;
      double vy2 = b2.vy * cos - b2.vx * sin;

      // Intercambio de velocidades
      double temp = vx1;
      vx1 = vx2;
      vx2 = temp;

      // Rotación inversa
      b1.vx = vx1 * cos - vy1 * sin;
      b1.vy = vy1 * cos + vx1 * sin;
      b2.vx = vx2 * cos - vy2 * sin;
      b2.vy = vy2 * cos + vx2 * sin;

      // Separar las bolas
      double overlap = Ball.radius * 2 - distance;
      double moveX = (overlap * cos) / 2;
      double moveY = (overlap * sin) / 2;
      b1.x -= moveX;
      b1.y -= moveY;
      b2.x += moveX;
      b2.y += moveY;
    }
  }

  bool isPointInsideBall(Offset point, Ball ball) {
    return math.sqrt(
            math.pow(point.dx - ball.x, 2) + math.pow(point.dy - ball.y, 2)) <
        Ball.radius;
  }
}
