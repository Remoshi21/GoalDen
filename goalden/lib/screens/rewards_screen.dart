import 'package:flutter/material.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  Widget rewardCard({
    required IconData icon,
    required String title,
    required String points,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              points,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
        title: const Text("Rewards Store"),
        backgroundColor: const Color.fromRGBO(156, 236, 237, 1),
        foregroundColor: Colors.black87,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.9 + (value * 0.1),
                    child: child,
                  ),
                );
              },
              child: Card(
                color: Colors.amber.shade100,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("Available Points", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text(
                        "350",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Popular Rewards",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            rewardCard(
              icon: Icons.coffee,
              title: "Coffee Coupon",
              points: "25 pts",
              color: Colors.brown,
              delay: 100,
            ),

            rewardCard(
              icon: Icons.local_pizza,
              title: "Free Pizza Slice",
              points: "50 pts",
              color: Colors.orange,
              delay: 200,
            ),

            rewardCard(
              icon: Icons.card_giftcard,
              title: "\$5 Gift Card",
              points: "100 pts",
              color: Colors.purple,
              delay: 300,
            ),

            rewardCard(
              icon: Icons.shopping_bag,
              title: "Store Discount",
              points: "150 pts",
              color: Colors.blue,
              delay: 400,
            ),

            rewardCard(
              icon: Icons.movie,
              title: "Movie Ticket",
              points: "250 pts",
              color: Colors.red,
              delay: 500,
            ),

            rewardCard(
              icon: Icons.headphones,
              title: "Music Subscription",
              points: "300 pts",
              color: Colors.teal,
              delay: 600,
            ),

            rewardCard(
              icon: Icons.attach_money,
              title: "\$10 Cash Back",
              points: "500 pts",
              color: Colors.green,
              delay: 700,
            ),

            rewardCard(
              icon: Icons.flight,
              title: "Travel Voucher",
              points: "750 pts",
              color: Colors.indigo,
              delay: 800,
            ),

            rewardCard(
              icon: Icons.workspace_premium,
              title: "Premium GoalDen Badge",
              points: "1000 pts",
              color: Colors.amber,
              delay: 900,
            ),
          ],
        ),
      ),
    );
  }
}
