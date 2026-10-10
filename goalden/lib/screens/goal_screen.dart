import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

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

            Expanded(
              child: ListView(
                children: [
                  goalCard(
                    title: "Move Into First Apartment",
                    amount: "\$500 / \$2,000",
                    progress: 0.25,
                    icon: Icons.home,
                    color: Colors.deepPurple,
                  ),

                  goalCard(
                    title: "Emergency Fund",
                    amount: "\$1,500 / \$5,000",
                    progress: 0.30,
                    icon: Icons.health_and_safety,
                    color: Colors.red,
                  ),

                  goalCard(
                    title: "Travel Budget",
                    amount: "\$800 / \$2,000",
                    progress: 0.40,
                    icon: Icons.flight_takeoff,
                    color: Colors.blue,
                  ),

                  goalCard(
                    title: "Buy New Car",
                    amount: "\$4,000 / \$15,000",
                    progress: 0.27,
                    icon: Icons.directions_car,
                    color: Colors.green,
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Recent Deposits",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.savings, color: Colors.green),
                      title: Text("+\$100"),
                      subtitle: Text("Emergency Fund • Jan 2"),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.savings, color: Colors.green),
                      title: Text("+\$50"),
                      subtitle: Text("Travel Budget • Jan 10"),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.savings, color: Colors.green),
                      title: Text("+\$200"),
                      subtitle: Text("Buy New Car • Jan 15"),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.savings, color: Colors.green),
                      title: Text("+\$300"),
                      subtitle: Text("Move Into First Apartment • Jan 22"),
                    ),
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
