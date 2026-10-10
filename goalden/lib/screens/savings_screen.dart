import 'package:flutter/material.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Savings Goal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "First Apartment",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            LinearProgressIndicator(value: .25, minHeight: 16),

            const SizedBox(height: 10),

            const Text("\$500 / \$2000"),

            const SizedBox(height: 25),

            const Text(
              "Deposit History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.savings),
                    title: Text("+\$100"),
                    subtitle: Text("Jan 2"),
                  ),
                  ListTile(
                    leading: Icon(Icons.savings),
                    title: Text("+\$50"),
                    subtitle: Text("Jan 10"),
                  ),
                  ListTile(
                    leading: Icon(Icons.savings),
                    title: Text("+\$200"),
                    subtitle: Text("Jan 15"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
