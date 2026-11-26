import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import 'auth_form_controller.dart';

class ForgotPasswordController extends AuthFormController {
  final email = TextEditingController();

  @override
  Future<void> onSubmit() async {
    await AuthService.sendPasswordReset(email.text);
    Get.back();
    Get.snackbar('Check your email', 'We sent you a link to reset your password.');
  }

  @override
  void onClose() {
    email.dispose();
    super.onClose();
  }
}
