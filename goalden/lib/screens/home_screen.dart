import 'package:flutter/material.dart';

import 'balance_screen.dart';
import 'savings_screen.dart';
import 'rewards_screen.dart';

Route slideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 32),
            ),

            const SizedBox(width: 20),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18)),

                const SizedBox(height: 8),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showReward(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.fromRGBO(156, 236, 237, 1),
        content: Text(
          "🎉 +50 Points Earned!",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: const Text("GoalDen Dashboard"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),

      floatingActionButton: FloatingActionButton.extended(
        elevation: 12,
        backgroundColor: const Color(0xFFFFC107),
        foregroundColor: Colors.black87,
        icon: const Icon(Icons.emoji_events),
        label: const Text(
          "Claim Reward",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () => showReward(context),
      ),

      body: Stack(
        children: [
          // Cyan Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(156, 236, 237, 1),
                  Color.fromRGBO(220, 255, 255, 1),
                ],
              ),
            ),
          ),

          // Decorative Wave
          Positioned(
            top: -100,
            left: -50,
            right: -50,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(200),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Let's grow your savings today.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  const SizedBox(height: 30),

                  InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      Navigator.push(
                        context,
                        slideRoute(const BalanceScreen()),
                      );
                    },
                    child: const DashboardCard(
                      icon: Icons.account_balance_wallet,
                      title: "Current Balance",
                      value: "\$1,250",
                      color: Colors.green,
                    ),
                  ),

                  InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      Navigator.push(
                        context,
                        slideRoute(const SavingsScreen()),
                      );
                    },
                    child: const DashboardCard(
                      icon: Icons.savings,
                      title: "Budgeting Chart",
                      value: "\$500 / \$2000",
                      color: Colors.pink,
                    ),
                  ),

                  InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      Navigator.push(
                        context,
                        slideRoute(const RewardsScreen()),
                      );
                    },
                    child: const DashboardCard(
                      icon: Icons.emoji_events,
                      title: "Reward Points",
                      value: "350",
                      color: Colors.orange,
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
