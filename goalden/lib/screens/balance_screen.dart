import 'package:flutter/material.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  Widget transactionCard({
    required bool isIncome,
    required String title,
    required String category,
    required String amount,
    required String date,
  }) {
    final Color amountColor = isIncome
        ? Colors.green.shade700
        : Colors.red.shade700;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.15),
          child: Icon(isIncome ? Icons.add : Icons.remove, color: amountColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$category • $date"),
        trailing: Text(
          amount,
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(220, 255, 255, 1),

      appBar: AppBar(
        title: const Text("Balance History"),
        backgroundColor: const Color.fromRGBO(156, 236, 237, 1),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // Balance Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: const [
                    Text(
                      "Current Balance",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "\$1,250",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Income & Expense Overview
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.green.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.trending_up, color: Colors.green),
                          SizedBox(height: 6),
                          Text("Income"),
                          SizedBox(height: 4),
                          Text(
                            "\$950",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Card(
                    color: Colors.red.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.trending_down, color: Colors.red),
                          SizedBox(height: 6),
                          Text("Expenses"),
                          SizedBox(height: 4),
                          Text(
                            "\$625",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Transaction History",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: [
                  // Income
                  transactionCard(
                    isIncome: true,
                    title: "Paycheck",
                    category: "Income",
                    amount: "+\$500",
                    date: "Oct 1",
                  ),

                  transactionCard(
                    isIncome: true,
                    title: "Side Gig",
                    category: "Income",
                    amount: "+\$150",
                    date: "Oct 3",
                  ),

                  transactionCard(
                    isIncome: true,
                    title: "Freelance Work",
                    category: "Income",
                    amount: "+\$300",
                    date: "Oct 9",
                  ),

                  // Expenses
                  transactionCard(
                    isIncome: false,
                    title: "Rent",
                    category: "Housing",
                    amount: "-\$600",
                    date: "Oct 4",
                  ),

                  transactionCard(
                    isIncome: false,
                    title: "Groceries",
                    category: "Food",
                    amount: "-\$75",
                    date: "Oct 6",
                  ),

                  transactionCard(
                    isIncome: false,
                    title: "Uber",
                    category: "Transportation",
                    amount: "-\$22",
                    date: "Oct 7",
                  ),

                  transactionCard(
                    isIncome: false,
                    title: "Netflix",
                    category: "Entertainment",
                    amount: "-\$16",
                    date: "Oct 8",
                  ),

                  transactionCard(
                    isIncome: false,
                    title: "Coffee Shop",
                    category: "Food",
                    amount: "-\$12",
                    date: "Oct 10",
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
