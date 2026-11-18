import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/forgot_password_controller.dart';
import '../../../utils/global.dart';
import '../../components/auth_layout.dart';
import '../../components/dialogs/custom_button.dart';
import '../../components/dialogs/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      init: ForgotPasswordController(),
      builder: (c) => AuthLayout(
        formKey: c.formKey,
        showBack: true,
        icon: Icons.lock_reset_rounded,
        title: 'Forgot your password?',
        subtitle: 'Enter your email and we will send you a link to reset it.',
        footerText: 'Remembered it?',
        footerLink: 'Back to sign in',
        onFooterTap: Get.back,
        children: [
          CustomTextField(
            label: 'Email',
            hint: 'you@email.com',
            controller: c.email,
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: Validators.email,
            onSubmitted: (_) => c.submit(),
          ),
          CustomButton(
            text: 'Send reset link',
            isLoading: c.isLoading,
            onPressed: c.submit,
          ),
        ],
      ),
    );
  }
}
