import 'package:firebase_auth/firebase_auth.dart';

/// All Firebase Authentication calls live here, so controllers stay clean.
class AuthService {
  AuthService._();

  static User? get currentUser => FirebaseAuth.instance.currentUser;

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

  static Future<User> signInWithEmail(String email, String password) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user!;
  }

  /// Creates the account and stores [name] as the display name.
  static Future<User> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email.trim(), password: password);
    await credential.user!.updateDisplayName(name.trim());
    await credential.user!.reload();
    return FirebaseAuth.instance.currentUser!;
  }

  static Future<void> sendPasswordReset(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
  }

  static Future<void> updateName(String name) async {
    await currentUser?.updateDisplayName(name);
  }

  static Future<void> signOut() => FirebaseAuth.instance.signOut();

  /// Turns any error into a short message the user can understand.
  static String errorMessage(Object error) {
    if (error is! FirebaseAuthException) return '$error';
    return switch (error.code) {
      'invalid-email' => 'That email address is not valid.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => 'Email or password is wrong.',
      'email-already-in-use' => 'An account with this email already exists.',
      'weak-password' => 'Choose a stronger password (8+ characters).',
      'network-request-failed' => 'No internet connection.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      'operation-not-allowed' =>
        'Email sign-in is not enabled in the Firebase console.',
      _ => error.message ?? error.code,
    };
  }
}
