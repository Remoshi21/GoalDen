import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showReward(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text(
          "🎉 +50 Points Earned!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GoalDen Dashboard")),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.emoji_events),
        label: const Text("Claim Reward"),
        onPressed: () => showReward(context),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.green,
                ),
                title: const Text("Current Balance"),
                subtitle: const Text("\$1,250"),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.savings, color: Colors.pink),
                title: const Text("Savings Goal"),
                subtitle: const Text("\$500 / \$2000"),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.orange),
                title: const Text("Reward Points"),
                subtitle: const Text("350 Points"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
