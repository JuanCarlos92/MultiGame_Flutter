import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/game_logic.dart';

class BoardWidget extends ConsumerStatefulWidget {
  const BoardWidget({super.key});

  @override
  ConsumerState<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends ConsumerState<BoardWidget>
    with SingleTickerProviderStateMixin {
  late GameLogic gameLogic;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    gameLogic = GameLogic();
    gameLogic.initializeBalls();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(_updatePhysics);
  }

  void _updatePhysics() {
    setState(() {
      gameLogic.updatePhysics(MediaQuery.of(context).size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final touchPoint = details.localPosition;
        for (var ball in gameLogic.balls) {
          if (gameLogic.isPointInsideBall(touchPoint, ball)) {
            setState(() {
              gameLogic.selectedBall = ball;
              gameLogic.dragStart = touchPoint;
            });
            break;
          }
        }
      },
      onPanEnd: (details) {
        if (gameLogic.selectedBall != null && gameLogic.dragStart != null) {
          // Calculamos la velocidad basada en la dirección del arrastre
          final dx = gameLogic.selectedBall!.x - gameLogic.dragStart!.dx;
          final dy = gameLogic.selectedBall!.y - gameLogic.dragStart!.dy;
          // La velocidad será proporcional a la distancia del arrastre
          gameLogic.selectedBall!.vx = dx * 0.1;
          gameLogic.selectedBall!.vy = dy * 0.1;
        }
        setState(() {
          gameLogic.selectedBall = null;
          gameLogic.dragStart = null;
        });
      },
      onPanUpdate: (details) {
        if (gameLogic.selectedBall != null) {
          setState(() {
            gameLogic.selectedBall!.x = details.localPosition.dx;
            gameLogic.selectedBall!.y = details.localPosition.dy;
            gameLogic.selectedBall!.vx = 0;
            gameLogic.selectedBall!.vy = 0;
          });
        }
      },
      child: CustomPaint(
        painter: BallsPainter(gameLogic.balls, gameLogic.selectedBall),
        size: Size.infinite,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class BallsPainter extends CustomPainter {
  final List<Ball> balls;
  final Ball? selectedBall;

  BallsPainter(this.balls, this.selectedBall);

  @override
  void paint(Canvas canvas, Size size) {
    for (var ball in balls) {
      final paint = Paint()
        ..color =
            // ignore: deprecated_member_use
            ball == selectedBall ? ball.color.withOpacity(0.5) : ball.color;
      canvas.drawCircle(Offset(ball.x, ball.y), Ball.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
