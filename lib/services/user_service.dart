import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_role.dart';

/// What is stored about a user in the `users` collection.
class UserProfile {
  const UserProfile({
    this.role,
    this.skills = const [],
    this.skillsDone = false,
  });

  /// null until the user picks a role (first sign-in).
  final UserRole? role;
  final List<String> skills;

  /// True once the user has finished the "Pick your skills" step.
  final bool skillsDone;
}

/// Reads and writes the `users` collection in Firestore.
class UserService {
  UserService._();

  static final _users = FirebaseFirestore.instance.collection('users');

  static Future<UserProfile> getProfile(String uid) async {
    final data = (await _users.doc(uid).get()).data();
    if (data == null) return const UserProfile();
    return UserProfile(
      role: UserRole.values.where((r) => r.name == data['role']).firstOrNull,
      skills: List<String>.from(data['skills'] ?? const []),
      skillsDone: data['skillsDone'] ?? false,
    );
  }

  static Future<void> createProfile(User user, UserRole role) {
    return _users.doc(user.uid).set({
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'role': role.name,
      'skills': <String>[],
      'skillsDone': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> saveSkills(String uid, List<String> skills) {
    return _users.doc(uid).update({'skills': skills, 'skillsDone': true});
  }
}
