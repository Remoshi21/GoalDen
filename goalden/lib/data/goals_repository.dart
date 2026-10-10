import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/savings_goal.dart';

class GoalsRepository {
  final FirebaseFirestore _firestore;

  GoalsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _goals(String uid) {
    return _firestore.collection('users').doc(uid).collection('goals');
  }

  Stream<List<SavingsGoal>> watchGoals(String uid) {
    return _goals(uid).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => SavingsGoal.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> createGoal(String uid, SavingsGoal goal) {
    return _goals(uid).doc(goal.id).set(goal.toMap());
  }

  Future<void> updateSavedAmount(
    String uid,
    String goalId,
    int savedCents,
  ) {
    if (savedCents < 0) {
      throw ArgumentError('Saved amount cannot be negative.');
    }

    return _goals(uid).doc(goalId).update({
      'saved_cents': savedCents,
    });
  }
}