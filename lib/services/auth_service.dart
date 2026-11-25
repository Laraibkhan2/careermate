import 'package:firebase_auth/firebase_auth.dart';

/// All Firebase Authentication calls live here, so controllers stay clean.
class AuthService {
  AuthService._();

  /// Opens the Google sign-in sheet and signs the user in to Firebase.
  /// Returns false if the user closed the sheet without choosing an account.
  static Future<bool> signInWithGoogle() async {
    try {
      await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code.contains('cancel')) return false;
      rethrow;
    }
  }
}
