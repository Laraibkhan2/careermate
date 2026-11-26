import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import 'auth_form_controller.dart';
import 'user_controller.dart';

class LoginController extends AuthFormController {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Future<void> onSubmit() async {
    await AuthService.signInWithEmail(email.text, password.text);
    // Reads the user's role and opens the right first screen.
    await Get.find<UserController>().goAfterAuth();
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
