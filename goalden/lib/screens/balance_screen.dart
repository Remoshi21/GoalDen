import 'package:flutter/material.dart';

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
            const Card(
              child: ListTile(
                title: Text(
                  "\$1,250",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Current Balance"),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.add, color: Colors.green),
                    title: Text("Paycheck"),
                    trailing: Text("+\$500"),
                  ),
                  ListTile(
                    leading: Icon(Icons.add, color: Colors.green),
                    title: Text("Side Gig"),
                    trailing: Text("+\$150"),
                  ),
                  ListTile(
                    leading: Icon(Icons.remove, color: Colors.red),
                    title: Text("Rent"),
                    trailing: Text("-\$600"),
                  ),
                  ListTile(
                    leading: Icon(Icons.remove, color: Colors.red),
                    title: Text("Groceries"),
                    trailing: Text("-\$75"),
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
