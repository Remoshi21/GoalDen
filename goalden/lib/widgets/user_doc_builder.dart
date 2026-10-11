import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String formatMoney(num amount) => '\$${amount.toStringAsFixed(2)}';

num readNum(Map<String, dynamic> data, String field) {
  final raw = data[field];
  return raw is num ? raw : 0;
}

class UserDocBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Map<String, dynamic> data)
      builder;

  const UserDocBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return builder(context, {});

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        return builder(context, snapshot.data?.data() ?? {});
      },
    );
  }
}