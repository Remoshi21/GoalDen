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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Savings Goals')),
      body: _goals == null
          ? const Center(child: Text('Please sign in to view your goals.'))
          : StreamBuilder<List<SavingsGoal>>(
              stream: _goals,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Could not load goals. Please try again.'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final goals = snapshot.data!;

                if (goals.isEmpty) {
                  return const Center(child: Text('No savings goals yet.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: goals.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 32),
                  itemBuilder: (context, index) {
                    final goal = goals[index];

                    return Column(
                      key: ValueKey(goal.id),
                      children: [
                        Text(
                          goal.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: goal.progress,
                          ),
                          duration: const Duration(seconds: 2),
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                              minHeight: 14,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${_money(goal.savedCents)} of '
                          '${_money(goal.targetCents)} Saved',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}