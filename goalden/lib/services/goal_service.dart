import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoalService {
  static const int depositXp = 10;
  static const int completeXp = 100;

  static final _db = FirebaseFirestore.instance;

  static String _money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  static Future<String?> createGoal(String title, double target) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'You are not signed in.';

    final cents = (target * 100).round();
    if (title.trim().isEmpty) return 'Give your goal a name.';
    if (cents <= 0) return 'The target must be more than \$0.';

    try {
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .doc()
          .set({
            'title': title.trim(),
            'target_cents': cents,
            'saved_cents': 0,
            'createdAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 8));
      return null;
    } catch (e) {
      return 'Could not create the goal. Please try again.';
    }
  }

  // Positive dollars = move from balance into the goal.
  // Negative dollars = move from the goal back to the balance.
  // Returns null on success, or a message to show the user.
  static Future<String?> moveMoney(String goalId, double dollars) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'You are not signed in.';

    final cents = (dollars * 100).round();
    if (cents == 0) return 'Enter an amount greater than \$0.';

    final userRef = _db.collection('users').doc(user.uid);
    final goalRef = userRef.collection('goals').doc(goalId);

    try {
      return await _db.runTransaction<String?>((tx) async {
        final userSnap = await tx.get(userRef);
        final goalSnap = await tx.get(goalRef);

        if (!goalSnap.exists) return 'That goal no longer exists.';

        final goal = goalSnap.data()!;
        final title = (goal['title'] as String?) ?? 'Goal';
        final saved = (goal['saved_cents'] as num).toInt();
        final target = (goal['target_cents'] as num).toInt();

        final rawBalance = userSnap.data()?['balance'];
        final balanceCents =
            rawBalance is num ? (rawBalance * 100).round() : 0;

        if (cents > 0) {
          if (cents > balanceCents) {
            return 'Not enough balance. You have ${_money(balanceCents)} available.';
          }
          if (saved + cents > target) {
            return 'That is more than this goal needs. '
                'Most you can add is ${_money(target - saved)}.';
          }
        } else {
          if (-cents > saved) {
            return 'This goal only has ${_money(saved)} saved.';
          }
        }

        final newSaved = saved + cents;
        final newBalanceCents = balanceCents - cents;

        var xp = 0;
        if (cents > 0) {
          xp += depositXp;
          if (saved < target && newSaved >= target) xp += completeXp;
        }

        tx.update(goalRef, {'saved_cents': newSaved});

        tx.set(
          userRef,
          {
            'balance': newBalanceCents / 100,
            if (xp > 0) 'xp': FieldValue.increment(xp),
          },
          SetOptions(merge: true),
        );

        tx.set(userRef.collection('transactions').doc(), {
          'type': cents > 0 ? 'deposit' : 'withdrawal',
          'goalTitle': title,
          'amount_cents': cents.abs(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        return null;
      }).timeout(const Duration(seconds: 8));
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  // Deletes a goal and returns anything saved in it to the balance
  static Future<String?> deleteGoal(String goalId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'You are not signed in.';

    final userRef = _db.collection('users').doc(user.uid);
    final goalRef = userRef.collection('goals').doc(goalId);

    try {
      return await _db.runTransaction<String?>((tx) async {
        final userSnap = await tx.get(userRef);
        final goalSnap = await tx.get(goalRef);

        if (!goalSnap.exists) return null;

        final goal = goalSnap.data()!;
        final saved = (goal['saved_cents'] as num).toInt();

        if (saved > 0) {
          final rawBalance = userSnap.data()?['balance'];
          final balanceCents =
              rawBalance is num ? (rawBalance * 100).round() : 0;

          tx.set(
            userRef,
            {'balance': (balanceCents + saved) / 100},
            SetOptions(merge: true),
          );

          tx.set(userRef.collection('transactions').doc(), {
            'type': 'refund',
            'goalTitle': (goal['title'] as String?) ?? 'Goal',
            'amount_cents': saved,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        tx.delete(goalRef);
        return null;
      }).timeout(const Duration(seconds: 8));
    } catch (e) {
      return 'Could not delete the goal. Please try again.';
    }
  }
}