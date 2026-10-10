import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rewards Store")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.coffee),
              title: Text("Coffee Coupon"),
              trailing: Text("25 pts"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text("\$5 Gift Card"),
              trailing: Text("100 pts"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.movie),
              title: Text("Movie Ticket"),
              trailing: Text("250 pts"),
            ),
          ),

          Card(
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
