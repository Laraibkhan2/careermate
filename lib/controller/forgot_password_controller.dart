import 'package:flutter/material.dart';

import 'auth_form_controller.dart';

class ForgotPasswordController extends AuthFormController {
  final email = TextEditingController();

  @override
  Future<void> onSubmit() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  void onClose() {
    email.dispose();
    super.onClose();
  }
}
