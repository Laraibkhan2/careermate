import 'package:flutter/material.dart';
import 'auth_form_controller.dart';

class LoginController extends AuthFormController {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Future<void> onSubmit() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
