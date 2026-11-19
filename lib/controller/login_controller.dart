import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/screens/main_screen/add_skills_screen.dart';
import 'auth_form_controller.dart';

class LoginController extends AuthFormController {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Future<void> onSubmit() async {
    // TODO: call the login API with email.text and password.text.
    // Open the next screen only when the API says the login worked.
    await Future<void>.delayed(const Duration(seconds: 1));
    Get.offAll(() => const AddSkillsScreen());
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
