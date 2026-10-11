import 'package:flutter/material.dart';

import '../widgets/user_doc_builder.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Budgeting Chart")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            UserDocBuilder(
              builder: (context, data) {
                final used = readNum(data, 'budgetUsed');
                final limit = readNum(data, 'budgetLimit');
                final progress =
                    limit > 0 ? (used / limit).clamp(0, 1).toDouble() : 0.0;

                return Column(
                  children: [
                    const Text(
                      "Your Budget",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    LinearProgressIndicator(value: progress, minHeight: 16),

                    const SizedBox(height: 10),

                    Text("${formatMoney(used)} / ${formatMoney(limit)}"),
                  ],
                );
              },
            ),

            const SizedBox(height: 25),

            const Text(
              "Deposit History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Expanded(
              child: Center(child: Text("No deposits yet.")),
            ),
          ],
        ),
      ),
    );
  }
}