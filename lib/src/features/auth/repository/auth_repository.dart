import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kaida/src/features/auth/domain/models/app_user.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._firebaseAuth, this._firestore);

  Future<String> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = userCredential.user!;
      // Check if the user's email is verified
      if (!user.emailVerified) {
        throw FirebaseAuthException(
            code: 'email-not-verified', message: 'Email not verified');
      }

      return user.uid;
    } catch (e) {
      print('SignIn Error $e');
      rethrow;
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw FirebaseAuthException(code: 'google-sign-in-cancelled',
            message: 'Google sign-in cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
          credential);

      final user = userCredential.user!;

      final appUser = AppUser(uid: user.uid,
        email: user.email!,
        name: user.displayName ?? 'N/A',
        phoneNumber: user.phoneNumber ?? 'N/A',
        emailVerified: user.emailVerified,
        createdAt: Timestamp.now().toString(),);

      await _firestore.collection('users').doc(user.uid).set(appUser.toMap(), SetOptions(merge: true));

      return user.uid;
    }
    catch (e) {
      print('Google Sign In Error: $e');
      rethrow;
    }
  }

  Future<String> signUp(String email, String password, String name,
      String phoneNumber) async {
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
      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());

      //Send verification email
      await user.sendEmailVerification();

      return user.uid;
    } catch (e) {
      print('Signup Error: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Reset Password Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    }
    catch (e) {
      print('Signout Error: $e');
      rethrow;
    }
  }
}
