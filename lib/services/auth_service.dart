import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign up method with email verification
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification after sign-up
      await userCredential.user?.sendEmailVerification();

      return userCredential.user;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'sign-up-error',
        message: e.toString(),
      );
    }
  }

  /// Sign in method (no email verification check)
  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'sign-in-error',
        message: e.toString(),
      );
    }
  }

  /// Sign out method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Check if the user is logged in
  Future<User?> checkUser() async {
    return _auth.currentUser;
  }

  /// Resend email verification (for email update)
  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is signed in or email is already verified.',
      );
    }
  }

  /// Update email with verification in Firebase Authentication
  Future<void> updateEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Update the email in Firebase Authentication
        await user.updateEmail(newEmail);

        // Send email verification after the update
        await user.sendEmailVerification();

        // Update the email in Firestore (assuming the Firestore collection is "users")
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'email': newEmail,
        });
      } catch (e) {
        throw FirebaseAuthException(
          code: 'update-email-error',
          message: e.toString(),
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is signed in.',
      );
    }
  }
}
