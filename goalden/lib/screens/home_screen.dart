import 'package:flutter/material.dart';
import '../widgets/assistant_sheet.dart';
import '../services/reward_service.dart';
import '../widgets/user_doc_builder.dart';
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

  Future<void> claimReward(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    bool gotPoints;
    try {
      gotPoints = await RewardService.claimDailyReward();
    } catch (e) {
      messenger.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Could not claim your reward. Please try again."),
        ),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromRGBO(156, 236, 237, 1),
        content: Text(
          gotPoints
              ? "🎉 +${RewardService.dailyPoints} Points Earned!"
              : "You already claimed today. Come back tomorrow!",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
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

      // Turns grey once today's reward has been claimed
      floatingActionButton: UserDocBuilder(
        builder: (context, data) {
          final claimed = data['lastClaimDay'] == RewardService.todayKey();

          return FloatingActionButton.extended(
            elevation: claimed ? 0 : 12,
            backgroundColor:
                claimed ? Colors.grey.shade400 : const Color(0xFFFFC107),
            foregroundColor: claimed ? Colors.black45 : Colors.black87,
            icon: Icon(claimed ? Icons.check_circle : Icons.emoji_events),
            label: Text(
              claimed ? "Claimed Today" : "Claim Reward",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: claimed ? null : () => claimReward(context),
          );
        },
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
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          builder: (_) => const FinancialFactSheet(),
                        );
                      },
                      icon: const Icon(Icons.lightbulb_outline),
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('GoldEye'),
                          SizedBox(width: 8),
                          Icon(Icons.auto_awesome, size: 18),
                        ],
                      ),
                    ),
                  ),

                  // Keep the floating Claim Reward button from covering it.
                  const SizedBox(height: 88),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}