import 'package:get/get.dart';

import '../model/user_role.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'user_controller.dart';

/// State of the "How will you use CareerMate?" screen.
class RoleController extends GetxController {
  UserRole? selected;
  bool isLoading = false;

  void select(UserRole role) {
    selected = role;
    update();
  }

  Future<void> confirm() async {
    final role = selected;
    final user = AuthService.currentUser;
    if (role == null || user == null || isLoading) return;

    isLoading = true;
    update();
    var saved = false;
    try {
      await UserService.createProfile(user, role);
      saved = true;
    } catch (e) {
      Get.snackbar('Could not save your role', '$e');
    } finally {
      isLoading = false;
      update();
    }

    if (saved) {
      final userController = Get.find<UserController>();
      userController.role = role;
      userController.openHome();
    }
  }
}