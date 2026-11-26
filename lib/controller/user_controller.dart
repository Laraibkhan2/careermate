import 'package:get/get.dart';

import '../model/user_role.dart';
import '../services/auth_service.dart';
import '../services/push_service.dart';
import '../services/user_service.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/screens/employer/employer_main_screen.dart';
import '../view/screens/main/main_screen.dart';
import '../view/screens/role/role_selection_screen.dart';
import '../view/screens/skills/add_skills_screen.dart';
import 'jobs_controller.dart';
import 'main_controller.dart';

/// The signed-in user: name, email, role, skills and settings.
class UserController extends GetxController {
  static const _defaultName = 'Your name';

  final skills = <String>[];
  String? _name;
  bool pushEnabled = true;

  /// null until the user picks a role (first sign-in).
  UserRole? role;

  /// True once the user has finished the skills step (saved in Firestore),
  /// so it is only asked once, right after the account is created.
  bool skillsDone = false;

  bool get isEmployer => role == UserRole.employer;

  String get name {
    final value = (_name ?? AuthService.currentUser?.displayName)?.trim();
    return (value == null || value.isEmpty) ? _defaultName : value;
  }

  bool get hasName => name != _defaultName;

  String get firstName => name.split(' ').first;

  String get email => AuthService.currentUser?.email ?? 'you@email.com';

  String get initials {
    final parts = name.split(' ').where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  /// How complete the profile is: name, email and at least one skill.
  int get completion {
    final done = [
      hasName,
      AuthService.currentUser?.email != null,
      skills.isNotEmpty,
    ].where((step) => step).length;
    return (done * 100 / 3).round();
  }

  /// Saves the skills in the app and in Firestore.
  Future<void> setSkills(List<String> value) async {
    skills
      ..clear()
      ..addAll(value);
    skillsDone = true;
    update();
    Get.find<JobsController>().update();

    final user = AuthService.currentUser;
    if (user == null) return;
    try {
      await UserService.saveSkills(user.uid, value);
    } catch (e) {
      Get.snackbar('Skills not saved', '$e');
    }
  }

  Future<void> updateName(String value) async {
    _name = value.trim();
    update();
    try {
      await AuthService.updateName(_name!);
    } catch (e) {
      Get.snackbar('Name not synced', '$e');
    }
  }

  void togglePush(bool value) {
    // TODO: register or unregister this phone for push notifications.
    pushEnabled = value;
    update();
  }

  // ---- Role and first screen after sign-in ----

  /// Call this right after any successful sign-in.
  Future<void> goAfterAuth() async {
    final user = AuthService.currentUser;
    if (user == null) {
      Get.snackbar('Not signed in', 'Please sign in first.');
      return;
    }
    try {
      final profile = await UserService.getProfile(user.uid);
      role = profile.role;
      skillsDone = profile.skillsDone;
      skills
        ..clear()
        ..addAll(profile.skills);
      update();
      openHome();
    } catch (e) {
      Get.snackbar('Could not load your account', '$e');
    }
  }

  /// Opens the first screen that fits the user's role.
  void openHome() {
    // Save this phone's notification token once the account has a role.
    if (role != null) PushService.saveToken();

    switch (role) {
      case null:
        Get.offAll(() => const RoleSelectionScreen());
      case UserRole.seeker:
        Get.find<JobsController>().loadJobs(); // pick up newly posted jobs
        // Skills are asked only once, right after the account is created.
        Get.offAll(
          () => skillsDone ? const MainScreen() : const AddSkillsScreen(),
        );
      case UserRole.employer:
        Get.offAll(() => const EmployerMainScreen());
    }
  }

  Future<void> logout() async {
    await PushService.removeToken(); // before sign-out: needs the signed-in user
    await AuthService.signOut();
    skills.clear();
    skillsDone = false;
    role = null;
    Get.find<JobsController>().clearTracking();
    Get.find<MainController>().setIndex(0);
    Get.offAll(() => const LoginScreen());
  }
}
