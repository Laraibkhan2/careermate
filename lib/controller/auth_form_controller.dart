import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import 'user_controller.dart';

/// Base for every auth screen controller: form key, loading state, the
/// "validate, then run" logic and Google sign-in. Subclasses only add their
/// own text controllers and write [onSubmit].
abstract class AuthFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> onSubmit();

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isLoading = true;
    update();
    try {
      await onSubmit();
    } catch (e) {
      Get.snackbar('Something went wrong', AuthService.errorMessage(e));
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> continueWithGoogle() async {
    if (isLoading) return;
    isLoading = true;
    update();
    try {
      final signedIn = await AuthService.signInWithGoogle();
      if (signedIn) await Get.find<UserController>().goAfterAuth();
    } catch (e) {
      Get.snackbar('Google sign-in failed', AuthService.errorMessage(e));
    } finally {
      isLoading = false;
      update();
    }
  }
}
