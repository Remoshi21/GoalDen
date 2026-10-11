import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LevelService {
  static const int xpPerLevel = 1000; // change this to make leveling faster or slower

  static const List<String> titles = [
    'Recession Rookie',
    'Non-Sufficient Novice',
    'Investor Intermediate',
    'Profit Proficient',
    'Equity Expert',
  ];

  static int levelFromXp(int xp) => xp <= 0 ? 1 : (xp ~/ xpPerLevel) + 1;

  static int xpIntoLevel(int xp) => xp <= 0 ? 0 : xp % xpPerLevel;

  // Levels past the last title keep the top title
  static String titleFor(int level) {
    final index = (level - 1).clamp(0, titles.length - 1);
    return titles[index];
  }

  // Use this anywhere you want to award XP later (goals, deposits, etc.)
  static Future<void> addXp(int amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {'xp': FieldValue.increment(amount)},
      SetOptions(merge: true),
    );
  }
}