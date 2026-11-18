import 'package:flutter/material.dart';

import 'auth_form_controller.dart';

class CreateAccountController extends AuthFormController {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Future<void> onSubmit() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
