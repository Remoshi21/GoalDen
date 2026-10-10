import 'package:flutter/material.dart';

class CoinPiggyAnimation extends StatefulWidget {
  const CoinPiggyAnimation({super.key});

  @override
  State<CoinPiggyAnimation> createState() => _CoinPiggyAnimationState();
}

class _CoinPiggyAnimationState extends State<CoinPiggyAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 180,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              const Positioned(
                bottom: 0,
                child: Icon(Icons.savings, size: 110, color: Colors.pink),
              ),
              Positioned(
                top: 20 + (90 * controller.value),
                child: Transform.rotate(
                  angle: controller.value * 6.28,
                  child: const Icon(
                    Icons.monetization_on,
                    size: 45,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
