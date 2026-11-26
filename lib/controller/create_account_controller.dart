import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_role.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'auth_form_controller.dart';
import 'user_controller.dart';

class CreateAccountController extends AuthFormController {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  UserRole role = UserRole.seeker;

  void setRole(UserRole value) {
    role = value;
    update();
  }

  @override
  Future<void> onSubmit() async {
    final user = await AuthService.registerWithEmail(
      name: name.text,
      email: email.text,
      password: password.text,
    );
    await UserService.createProfile(user, role);

    final userController = Get.find<UserController>();
    userController.role = role;
    userController.openHome();
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
