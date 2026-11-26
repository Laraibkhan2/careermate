import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_form_controller.dart';
import 'user_controller.dart';

class EditProfileController extends AuthFormController {
  final name = TextEditingController();
  final newPassword = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final user = Get.find<UserController>();
    name.text = user.hasName ? user.name : '';
  }

  @override
  Future<void> onSubmit() async {
    await Get.find<UserController>().updateName(name.text);
    // TODO: if newPassword.text is not empty, send it to the API.
    Get.back();
    Get.snackbar('Saved', 'Your profile was updated.');
  }

  @override
  void onClose() {
    name.dispose();
    newPassword.dispose();
    super.onClose();
  }
}
