import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Stream<User?> get authState => _auth.authStateChanges();
  String get uid => _auth.currentUser!.uid;

  Future<String?> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      try {
        await cred.user!.updateDisplayName(name);
      } catch (e) {
        print('Display name update failed: $e');
      }

      try {
        await _db
            .collection('users')
            .doc(cred.user!.uid)
            .set({
              'name': name,
              'phone': phone,
              'email': email,
              'createdAt': FieldValue.serverTimestamp(),
            })
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        print('Profile save failed: $e');
      }

      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'unknown';
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'unknown';
    }
  }

  Future<void> signOut() => _auth.signOut();
}