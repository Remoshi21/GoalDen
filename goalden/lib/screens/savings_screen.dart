import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(220, 255, 255, 1),
      appBar: AppBar(
        title: const Text("Budgeting Chart"),
        backgroundColor: const Color.fromRGBO(156, 236, 237, 1),
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Monthly Spending Breakdown",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 45,
                      title: 'Food\n45%',
                      color: Colors.orange,
                      radius: 90,
                    ),
                    PieChartSectionData(
                      value: 30,
                      title: 'Entertainment\n30%',
                      color: Colors.purple,
                      radius: 90,
                    ),
                    PieChartSectionData(
                      value: 25,
                      title: 'Misc\n25%',
                      color: Colors.blue,
                      radius: 90,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Spending History",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: const [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.restaurant),
                      title: Text("-\$42.15"),
                      subtitle: Text("Food • Oct 2"),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.movie),
                      title: Text("-\$18.99"),
                      subtitle: Text("Entertainment • Oct 4"),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.shopping_bag),
                      title: Text("-\$26.50"),
                      subtitle: Text("Miscellaneous • Oct 6"),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.restaurant),
                      title: Text("-\$15.75"),
                      subtitle: Text("Food • Oct 8"),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.movie),
                      title: Text("-\$35.00"),
                      subtitle: Text("Entertainment • Oct 10"),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.shopping_bag),
                      title: Text("-\$12.99"),
                      subtitle: Text("Miscellaneous • Oct 12"),
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
