import 'package:flutter/material.dart';

import '../widgets/user_doc_builder.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Balance History')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            UserDocBuilder(
              builder: (context, data) {
                return Card(
                  child: ListTile(
                    title: Text(
                      formatMoney(readNum(data, 'balance')),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text("Current Balance"),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            const Expanded(
              child: Center(child: Text("No transactions yet.")),
            ),
          ],
        ),
      ),
    );
  }
}