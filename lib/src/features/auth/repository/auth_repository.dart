import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaida/src/features/auth/domain/models/app_user.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._firebaseAuth, this._firestore);

  Future<String> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user!.uid;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signUp(
      String email, String password, String name, String phoneNumber) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = userCredential.user!;

      final appUser = AppUser(
        uid: user.uid,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        emailVerified: user.emailVerified,
        createdAt: Timestamp.now().toString(),
      );

      // Now let's save upload the user to a Firestore collection named 'users'
      _firestore.collection('users').doc(user.uid).set(appUser.toMap());

      //After we upload the user. Let's send a email verification
      await user.sendEmailVerification();

      return user.uid;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
