import 'package:flutter/material.dart';

import '../widgets/user_doc_builder.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rewards Store")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          UserDocBuilder(
            builder: (context, data) {
              return Card(
                color: Colors.amber.shade100,
                child: ListTile(
                  leading: const Icon(Icons.emoji_events, color: Colors.orange),
                  title: const Text("Your Points"),
                  trailing: Text(
                    "${readNum(data, 'points').toInt()} pts",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),

          const Card(
            child: ListTile(
              leading: Icon(Icons.coffee),
              title: Text("Coffee Coupon"),
              trailing: Text("25 pts"),
            ),
          ),

          const Card(
            child: ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text("\$5 Gift Card"),
              trailing: Text("100 pts"),
            ),
          ),

          const Card(
            child: ListTile(
              leading: Icon(Icons.movie),
              title: Text("Movie Ticket"),
              trailing: Text("250 pts"),
            ),
          ),

          const Card(
            child: ListTile(
              leading: Icon(Icons.attach_money),
              title: Text("\$10 Cash Back"),
              trailing: Text("500 pts"),
            ),
          ),
        ],
      ),
    );
  }
}