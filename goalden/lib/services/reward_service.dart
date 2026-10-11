import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardService {
  static const int dailyPoints = 50;
  static const int dailyXp = 10;

  // Today's date as text, e.g. "2026-10-10"
  static String todayKey() {
    final n = DateTime.now();
    final m = n.month.toString().padLeft(2, '0');
    final d = n.day.toString().padLeft(2, '0');
    return '${n.year}-$m-$d';
  }

  // Returns true if points were given, false if already claimed today
  static Future<bool> claimDailyReward() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final today = todayKey();

    return FirebaseFirestore.instance.runTransaction<bool>((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data() ?? {};

      if (data['lastClaimDay'] == today) return false;

      tx.set(
        ref,
        {
          'points': FieldValue.increment(dailyPoints),
          'xp': FieldValue.increment(dailyXp),
          'lastClaimDay': today,
        },
        SetOptions(merge: true),
      );
      return true;
    }).timeout(const Duration(seconds: 8));
  }
}