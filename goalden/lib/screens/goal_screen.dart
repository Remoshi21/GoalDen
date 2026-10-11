import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/goals_repository.dart';
import '../models/savings_goal.dart';
import '../services/goal_service.dart';
import '../services/level_service.dart';
import '../widgets/level_card.dart';
import '../widgets/user_doc_builder.dart';

String _money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

double? _parseAmount(String text) {
  return double.tryParse(
    text.replaceAll(',', '').replaceAll('\$', '').trim(),
  );
}

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  static const _colors = [
    Colors.deepPurple,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.teal,
  ];

  static const _icons = [
    Icons.home,
    Icons.health_and_safety,
    Icons.flight_takeoff,
    Icons.directions_car,
    Icons.star,
    Icons.savings,
  ];

  Future<void> _confirmDelete(BuildContext context, SavingsGoal goal) async {
    final messenger = ScaffoldMessenger.of(context);

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete goal?"),
        content: Text(
          goal.savedCents > 0
              ? "The ${_money(goal.savedCents)} saved in \"${goal.title}\" "
                  "will go back to your balance."
              : "\"${goal.title}\" will be removed.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final error = await GoalService.deleteGoal(goal.id);
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Widget _goalCard(BuildContext context, SavingsGoal goal, int index) {
    final color = _colors[index % _colors.length];
    final icon = _icons[index % _icons.length];
    final done = goal.targetCents > 0 && goal.savedCents >= goal.targetCents;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => showDialog(
          context: context,
          builder: (_) => _MoneyDialog(goal: goal),
        ),
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
                      goal.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (done)
                    const Icon(Icons.check_circle, color: Colors.green),

                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDelete(context, goal),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: goal.progress),
                duration: const Duration(seconds: 1),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    done ? "Goal reached! 🎉" : "Tap to add or withdraw",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    "${_money(goal.savedCents)} / ${_money(goal.targetCents)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(220, 255, 255, 1),

      appBar: AppBar(
        title: const Text("Savings Goals"),
        backgroundColor: const Color.fromRGBO(156, 236, 237, 1),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const _NewGoalDialog(),
        ),
        icon: const Icon(Icons.add),
        label: const Text("New Goal"),
      ),

      body: user == null
          ? const Center(child: Text("You are not signed in."))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Financial Goals",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  const LevelCard(),

                  const SizedBox(height: 20),

                  Expanded(
                    child: StreamBuilder<List<SavingsGoal>>(
                      stream: GoalsRepository().watchGoals(user.uid),
                      builder: (context, snapshot) {
                        final goals = snapshot.data ?? <SavingsGoal>[];
                        final totalSaved =
                            goals.fold<int>(0, (sum, g) => sum + g.savedCents);
                        final anyDone = goals.any(
                          (g) =>
                              g.targetCents > 0 &&
                              g.savedCents >= g.targetCents,
                        );

                        return ListView(
                          padding: const EdgeInsets.only(bottom: 90),
                          children: [
                            // Balance the goals draw from
                            UserDocBuilder(
                              builder: (context, data) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.green,
                                    ),
                                    title: const Text("Available to save"),
                                    trailing: Text(
                                      formatMoney(readNum(data, 'balance')),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            if (snapshot.hasError)
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text("Could not load your goals."),
                              ),

                            if (!snapshot.hasError && goals.isEmpty)
                              const Card(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "No goals yet. Tap \"New Goal\" to create your first one.",
                                  ),
                                ),
                              ),

                            for (int i = 0; i < goals.length; i++)
                              _goalCard(context, goals[i], i),

                            const SizedBox(height: 25),

                            const Text(
                              "Achievements",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                const Chip(
                                  avatar: Icon(Icons.login),
                                  label: Text("First Login"),
                                ),
                                if (goals.isNotEmpty)
                                  const Chip(
                                    avatar: Icon(Icons.flag),
                                    label: Text("First Goal Created"),
                                  ),
                                if (totalSaved > 0)
                                  const Chip(
                                    avatar: Icon(Icons.savings),
                                    label: Text("First Deposit"),
                                  ),
                                if (anyDone)
                                  const Chip(
                                    avatar: Icon(Icons.emoji_events),
                                    label: Text("Goal Complete"),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 25),

                            const Text(
                              "Level Titles",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            for (int i = 0; i < LevelService.titles.length; i++)
                              Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text("${i + 1}"),
                                  ),
                                  title: Text("Level ${i + 1}"),
                                  subtitle: Text(LevelService.titles[i]),
                                ),
                              ),

                            const SizedBox(height: 25),

                            const Text(
                              "Recent Activity",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            _RecentActivity(uid: user.uid),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  final String uid;

  const _RecentActivity({required this.uid});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text("No activity yet."),
            ),
          );
        }

        return Column(
          children: docs.map((doc) {
            final d = doc.data();
            final type = d['type'] as String? ?? 'deposit';
            final cents = (d['amount_cents'] as num?)?.toInt() ?? 0;
            final title = d['goalTitle'] as String? ?? 'Goal';
            final ts = d['createdAt'];
            final date = ts is Timestamp ? ts.toDate() : DateTime.now();
            final deposit = type == 'deposit';

            final label = deposit
                ? title
                : (type == 'refund' ? "$title (deleted, refunded)" : "$title (withdrawal)");

            return Card(
              child: ListTile(
                leading: Icon(
                  deposit ? Icons.savings : Icons.undo,
                  color: deposit ? Colors.green : Colors.red,
                ),
                title: Text("${deposit ? '+' : '-'}${_money(cents)}"),
                subtitle: Text("$label • ${_months[date.month - 1]} ${date.day}"),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _MoneyDialog extends StatefulWidget {
  final SavingsGoal goal;

  const _MoneyDialog({required this.goal});

  @override
  State<_MoneyDialog> createState() => _MoneyDialogState();
}

class _MoneyDialogState extends State<_MoneyDialog> {
  final controller = TextEditingController();
  bool busy = false;
  String? error;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _submit(bool deposit) async {
    final amount = _parseAmount(controller.text);

    if (amount == null || amount <= 0) {
      setState(() => error = 'Enter an amount greater than \$0.');
      return;
    }
    if (amount > 10000000) {
      setState(() => error = 'That amount is too large.');
      return;
    }

    setState(() {
      busy = true;
      error = null;
    });

    final result = await GoalService.moveMoney(
      widget.goal.id,
      deposit ? amount : -amount,
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        busy = false;
        error = result;
      });
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;

    return AlertDialog(
      title: Text(goal.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Saved: ${_money(goal.savedCents)} / ${_money(goal.targetCents)}"),
            const SizedBox(height: 4),
            UserDocBuilder(
              builder: (context, data) => Text(
                "Available balance: ${formatMoney(readNum(data, 'balance'))}",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: const InputDecoration(
                labelText: "Amount",
                prefixText: "\$ ",
                border: OutlineInputBorder(),
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        OutlinedButton(
          onPressed: busy ? null : () => _submit(false),
          child: const Text("Withdraw"),
        ),
        ElevatedButton(
          onPressed: busy ? null : () => _submit(true),
          child: busy
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Add"),
        ),
      ],
    );
  }
}

class _NewGoalDialog extends StatefulWidget {
  const _NewGoalDialog();

  @override
  State<_NewGoalDialog> createState() => _NewGoalDialogState();
}

class _NewGoalDialogState extends State<_NewGoalDialog> {
  final titleController = TextEditingController();
  final targetController = TextEditingController();
  bool busy = false;
  String? error;

  @override
  void dispose() {
    titleController.dispose();
    targetController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final title = titleController.text.trim();
    final target = _parseAmount(targetController.text);

    if (title.isEmpty) {
      setState(() => error = 'Give your goal a name.');
      return;
    }
    if (title.length > 40) {
      setState(() => error = 'Name must be 40 characters or less.');
      return;
    }
    if (target == null || target <= 0) {
      setState(() => error = 'Enter a target amount greater than \$0.');
      return;
    }
    if (target > 10000000) {
      setState(() => error = 'That target is too large.');
      return;
    }

    setState(() {
      busy = true;
      error = null;
    });

    final result = await GoalService.createGoal(title, target);

    if (!mounted) return;

    if (result != null) {
      setState(() {
        busy = false;
        error = result;
      });
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Goal"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: "Goal name",
                hintText: "Emergency Fund",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: targetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: const InputDecoration(
                labelText: "Target amount",
                prefixText: "\$ ",
                border: OutlineInputBorder(),
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: busy ? null : _create,
          child: busy
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Create"),
        ),
      ],
    );
  }
}