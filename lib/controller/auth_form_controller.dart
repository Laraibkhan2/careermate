import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Base for every auth screen controller: form key, loading state and the
/// "validate, then run" logic. Subclasses only add their own text
/// controllers and write [onSubmit].
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
    } finally {
      isLoading = false;
      update();
    }
  }
}
