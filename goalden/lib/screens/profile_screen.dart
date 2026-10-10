import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String _formatMonthYear(DateTime date) {
    return '${_months[date.month - 1]} ${date.year}';
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

      body: user == null
          ? const Center(child: Text("You are not signed in."))
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data() ?? {};
                final isLoading = snapshot.connectionState ==
                        ConnectionState.waiting &&
                    !snapshot.hasData;

                // Use Firestore first, then fall back to the Firebase account
                final name = (data['name'] as String?)?.trim().isNotEmpty ==
                        true
                    ? data['name'] as String
                    : (user.displayName?.trim().isNotEmpty == true
                        ? user.displayName!
                        : "GoalDen User");

                final email = (data['email'] as String?)?.trim().isNotEmpty ==
                        true
                    ? data['email'] as String
                    : (user.email ?? "No email");

                final phone = (data['phone'] as String?)?.trim().isNotEmpty ==
                        true
                    ? data['phone'] as String
                    : (isLoading ? "Loading..." : "Not provided");

                final createdAt = data['createdAt'];
                final memberSince = createdAt is Timestamp
                    ? _formatMonthYear(createdAt.toDate())
                    : (user.metadata.creationTime != null
                        ? _formatMonthYear(user.metadata.creationTime!)
                        : "—");

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 55,
                            backgroundColor:
                                Color.fromARGB(255, 186, 191, 186),
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
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
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                            avatar: Icon(
                              Icons.emoji_events,
                              color: Colors.orange,
                            ),
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
                            backgroundColor:
                                const Color.fromARGB(255, 236, 103, 86),
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