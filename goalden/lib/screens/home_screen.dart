import 'package:flutter/material.dart';


import '../widgets/user_doc_builder.dart';
import '../widgets/assistant_sheet.dart';
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

// Shows one live number (balance or points) from the user's Firestore document
class LiveStat extends StatelessWidget {
  final String field; // 'balance' or 'points'
  final String title;
  final IconData icon;
  final Color color;
  final bool isMoney;

  const LiveStat({
    super.key,
    required this.field,
    required this.title,
    required this.icon,
    required this.color,
    this.isMoney = false,
  });

  @override
  Widget build(BuildContext context) {
    return UserDocBuilder(
      builder: (context, data) {
        final amount = readNum(data, field);

        return DashboardCard(
          icon: icon,
          title: title,
          value: isMoney ? formatMoney(amount) : amount.toInt().toString(),
          color: color,
        );
      },
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

                  // Current Balance (live from Firestore)
                  InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      Navigator.push(
                        context,
                        slideRoute(const BalanceScreen()),
                      );
                    },
                    child: const LiveStat(
                      field: 'balance',
                      title: "Current Balance",
                      icon: Icons.account_balance_wallet,
                      color: Colors.green,
                      isMoney: true,
                    ),
                  ),

                  // Budgeting Chart (live from Firestore)
                  InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      Navigator.push(
                        context,
                        slideRoute(const SavingsScreen()),
                      );
                    },
                    child: UserDocBuilder(
                      builder: (context, data) => DashboardCard(
                        icon: Icons.savings,
                        title: "Budgeting Chart",
                        value:
                            "${formatMoney(readNum(data, 'budgetUsed'))} / ${formatMoney(readNum(data, 'budgetLimit'))}",
                        color: Colors.pink,
                      ),
                    ),
                  ),

                  // Reward Points (live from Firestore)
                  InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      Navigator.push(
                        context,
                        slideRoute(const RewardsScreen()),
                      );
                    },
                    child: const LiveStat(
                      field: 'points',
                      title: "Reward Points",
                      icon: Icons.emoji_events,
                      color: Colors.orange,
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.lightbulb_outline, size: 20),
                      label: const Text('Money Fact'),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          showDragHandle: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (_) => const FinancialFactSheet(),
                        );
                      },
                    ),
                  ),

// Lets the button scroll clear of the existing Claim Reward button.
const SizedBox(height: 90),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}