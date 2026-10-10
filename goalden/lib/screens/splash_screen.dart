import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  bool coinEntered = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    controller.forward();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          coinEntered = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget sparkle(double left, double top, double size, Color color) {
    return Positioned(
      left: left,
      top: top,
      child: Icon(Icons.auto_awesome, color: color, size: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Falling Coin
                if (!coinEntered)
                  Positioned(
                    top: 120 + (150 * controller.value),
                    child: Transform.rotate(
                      angle: controller.value * 12,
                      child: const Icon(
                        Icons.monetization_on,
                        size: 60,
                        color: Colors.amber,
                      ),
                    ),
                  ),

                // Piggy Bank
                AnimatedScale(
                  duration: const Duration(milliseconds: 500),
                  scale: coinEntered ? 1.25 : 1.0,
                  child: Icon(
                    Icons.savings,
                    size: 140,
                    color: coinEntered ? Colors.amber : Colors.pink,
                  ),
                ),

                // Sparkles
                if (coinEntered) ...[
                  sparkle(-70, -60, 30, Colors.amber),
                  sparkle(70, -50, 25, Colors.yellow),
                  sparkle(-60, 30, 24, Colors.orange),
                  sparkle(60, 40, 28, Colors.amber),
                  sparkle(0, -90, 35, Colors.yellow),
                ],

                const Positioned(
                  bottom: 100,
                  child: Text(
                    "GoalDen",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),

                const Positioned(
                  bottom: 70,
                  child: Text(
                    "Turn Financial Goals Into Gold",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
