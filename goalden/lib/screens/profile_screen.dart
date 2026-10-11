import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/phone_formatter.dart';
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

  String _formatPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    if (digits.length == 11 && digits.startsWith('1')) {
      return '1-${digits.substring(1, 4)}-${digits.substring(4, 7)}-${digits.substring(7)}';
    }
    return raw;
  }

  // Loads the current name and phone, then opens the edit dialog
  Future<void> _openEdit(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String name = user.displayName ?? '';
    String phone = '';

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final d = doc.data() ?? {};
      name = (d['name'] as String?) ?? name;
      phone = (d['phone'] as String?) ?? '';
    } catch (_) {
      // If loading fails, the dialog just opens with what we have
    }

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (_) => _EditProfileDialog(
        initialName: name,
        initialPhone: _formatPhone(phone),
      ),
    );
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
                builder: (sheetContext) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text("Edit Profile"),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            _openEdit(context);
                          },
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
              ? _formatPhone(_text(data, 'phone'))
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
                      child: GestureDetector(
                        onTap: () => _openEdit(context),
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

class _EditProfileDialog extends StatefulWidget {
  final String initialName;
  final String initialPhone;

  const _EditProfileDialog({
    required this.initialName,
    required this.initialPhone,
  });

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final TextEditingController nameController =
      TextEditingController(text: widget.initialName);
  late final TextEditingController phoneController =
      TextEditingController(text: widget.initialPhone);

  bool saving = false;
  String? error;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (name.isEmpty) {
      setState(() => error = 'Name cannot be empty.');
      return;
    }
    if (name.length > 40) {
      setState(() => error = 'Name must be 40 characters or less.');
      return;
    }
    if (digits.length != 10) {
      setState(() => error = 'Please enter a 10-digit phone number.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      saving = true;
      error = null;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'name': name, 'phone': phone}).timeout(
              const Duration(seconds: 8));

      try {
        await user.updateDisplayName(name);
      } catch (_) {
        // The Firestore name is the one the app shows, so this is optional
      }

      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('Profile updated!')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        saving = false;
        error = 'Could not save. Check your connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Profile"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: "Full name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [PhoneDashFormatter()],
              decoration: const InputDecoration(
                labelText: "Phone number",
                hintText: "555-123-4567",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: saving ? null : _save,
          child: saving
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Save"),
        ),
      ],
    );
  }
}