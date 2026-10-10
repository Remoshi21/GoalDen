import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/goals_repository.dart';
import '../models/savings_goal.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  Stream<List<SavingsGoal>>? _goals;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _goals = GoalsRepository().watchGoals(user.uid);
    }
  }

  String _money(int cents) =>
      '\$${(cents / 100).toStringAsFixed(2)}';

  Widget goalCard({
    required String title,
    required String amount,
    required double progress,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                  backgroundColor: Colors.grey.shade300,
                );
              },
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                amount,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(220, 255, 255, 1),

      appBar: AppBar(
        title: const Text("Savings Goals"),
        backgroundColor: const Color.fromRGBO(156, 236, 237, 1),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Financial Goals",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Card(
              color: Colors.amber.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Level 3 • Investor Intermediate",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    LinearProgressIndicator(value: .65, minHeight: 10),

                    SizedBox(height: 10),

                    Text("650 / 1000 XP"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: _goals == null
                  ? const Center(
                      child: Text('Please sign in to view your goals.'),
                    )
                  : StreamBuilder<List<SavingsGoal>>(
                      stream: _goals,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Could not load your goals.'),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final goals = snapshot.data!;

                        if (goals.isEmpty) {
                          return const Center(
                            child: Text('No savings goals yet.'),
                          );
                        }

                        const icons = [
                          Icons.home,
                          Icons.health_and_safety,
                          Icons.flight_takeoff,
                          Icons.directions_car,
                        ];


                        const colors = [
                          Colors.deepPurple,
                          Colors.red,
                          Colors.blue,
                          Colors.green,
                        ];

                        return ListView(
                          children: [
                            for (var index = 0; index < goals.length; index++)
                              KeyedSubtree(
                                key: ValueKey(goals[index].id),
                                child: goalCard(
                                  title: goals[index].title,
                                  amount:
                                      '${_money(goals[index].savedCents)} / '
                                      '${_money(goals[index].targetCents)}',
                                  progress: goals[index].progress,
                                  icon: icons[index % icons.length],
                                  color: colors[index % colors.length],
                                ),
                              ),
                            const SizedBox(height: 25),
                            const Text(
                              'Recent Deposits',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Card(
                              child: ListTile(
                                leading: Icon(Icons.savings, color: Colors.green),
                                title: Text('Deposit history is coming soon.'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
>>>>>>> 8401f617a25c8c91171a39c360f06d5591385d06
            ),
          ],
        ),
      ),
    );
  }
}
