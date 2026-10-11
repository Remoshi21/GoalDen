import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int stage = 0;

  AudioSource? introSound;

  Future<void> initializeAudio() async {
    try {
      await SoLoud.instance.init();

      introSound = await SoLoud.instance.loadAsset(
        'assets/audio/ElevenLabs_PiggyBankIntro.mp3',
      );
    } catch (e) {
      debugPrint('Audio initialization failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    initializeAudio();

    // Team intro disappears
    Future.delayed(const Duration(milliseconds: 2200), () async {
      if (!mounted) return;

      setState(() {
        stage = 1;
      });

      if (introSound != null) {
        SoLoud.instance.play(introSound!);
      }
    });

    // Change speech bubble text
    Future.delayed(const Duration(milliseconds: 5500), () {
      if (!mounted) return;

      setState(() {
        stage = 2;
      });
    });

    // Fade to login screen
    Future.delayed(const Duration(milliseconds: 8500), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),

          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },

          transitionDuration: const Duration(milliseconds: 1200),
        ),
      );
    });
  }

  @override
  void dispose() {
    SoLoud.instance.deinit();
    super.dispose();
  }

  Widget buildSpeechBubble(String text) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        Positioned(
          bottom: -10,
          right: 35,
          child: Transform.rotate(
            angle: 0.8,
            child: Container(width: 18, height: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),

      body: Stack(
        children: [
          // MARIO KART 9 INTRO
          AnimatedOpacity(
            opacity: stage == 0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1500),
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.80, end: 1.00),
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: const Text(
                  "Mario Kart 9 presents",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),

          // GOALDEN INTRO
          AnimatedOpacity(
            opacity: stage > 0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1500),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSpeechBubble(
                    stage < 2
                        ? "Welcome to GoalDen!"
                        : "Let's turn goals into gold!",
                  ),

                  const SizedBox(height: 40),

                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.75, end: 1.00),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Image.asset(
                      'assets/images/piggy_bank.png',
                      width: 260,
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "GoalDen",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
