import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/user_doc_builder.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String _monthYear(DateTime d) => '${_months[d.month - 1]} ${d.year}';

  String _text(Map<String, dynamic> data, String field) {
    final v = data[field];
    return v is String ? v.trim() : '';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 238, 238),

      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text("Edit Profile"),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text(
                            "Delete Account",
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),

      body: UserDocBuilder(
        builder: (context, data) {
          final name = _text(data, 'name').isNotEmpty
              ? _text(data, 'name')
              : ((user?.displayName ?? '').trim().isNotEmpty
                  ? user!.displayName!
                  : 'GoalDen User');

          final email = _text(data, 'email').isNotEmpty
              ? _text(data, 'email')
              : (user?.email ?? 'No email');

          final phone = _text(data, 'phone').isNotEmpty
              ? _text(data, 'phone')
              : 'Not provided';

          final createdAt = data['createdAt'];
          final memberSince = createdAt is Timestamp
              ? _monthYear(createdAt.toDate())
              : (user?.metadata.creationTime != null
                  ? _monthYear(user!.metadata.creationTime!)
                  : '—');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Color.fromARGB(255, 186, 191, 186),
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "🏆 Budget Rookie",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text("Email"),
                    subtitle: Text(email),
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text("Mobile Number"),
                    subtitle: Text(phone),
                  ),
                ),

                const SizedBox(height: 25),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Achievements & Badges",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 12),

                const Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Chip(
                      avatar: Icon(
                        Icons.savings,
                        color: Color.fromARGB(255, 242, 64, 188),
                      ),
                      label: Text("First Savings"),
                    ),
                    Chip(
                      avatar: Icon(Icons.flag, color: Colors.blue),
                      label: Text("Goal Starter"),
                    ),
                    Chip(
                      avatar: Icon(Icons.emoji_events, color: Colors.orange),
                      label: Text("Reward Earner"),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.people),
                    label: const Text("Connect With a Friend"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 236, 103, 86),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),

                const SizedBox(height: 25),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: const Text("Member Since"),
                    subtitle: Text(memberSince),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}