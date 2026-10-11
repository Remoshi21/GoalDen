import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'user_doc_builder.dart';

// Put this as the LAST child of a Stack so confetti falls over everything
class WelcomeConfetti extends StatefulWidget {
  const WelcomeConfetti({super.key});

  @override
  State<WelcomeConfetti> createState() => _WelcomeConfettiState();
}

class _WelcomeConfettiState extends State<WelcomeConfetti> {
  final _controller = ConfettiController(duration: const Duration(seconds: 4));
  bool _triggered = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _celebrate() {
    if (_triggered) return;
    _triggered = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      _controller.play();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromRGBO(156, 236, 237, 1),
          content: Text(
            "🎉 Welcome to GoalDen! Here are 25 bonus points!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'welcomeShown': true});
        } catch (_) {
          // If this fails, the confetti may play again next login
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserDocBuilder(
      builder: (context, data) {
        if (data['welcomeShown'] == false) _celebrate();

        return IgnorePointer(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
              gravity: 0.2,
              emissionFrequency: 0.05,
              colors: const [
                Colors.amber,
                Colors.pink,
                Colors.cyan,
                Colors.green,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        );
      },
    );
  }
}