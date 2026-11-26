import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/login_controller.dart';
import '../../../utils/global.dart';
import '../../components/auth_layout.dart';
import '../../components/dialogs/custom_button.dart';
import '../../components/dialogs/custom_text_field.dart';
import 'create_account_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (c) => AuthLayout(
        formKey: c.formKey,
        icon: Icons.work_outline_rounded,
        title: 'Welcome back',
        subtitle: 'Sign in to continue to your jobs.',
        footerText: 'New to CareerMate?',
        footerLink: 'Create account',
        onFooterTap: () => Get.to(() => const CreateAccountScreen()),
        onGoogleTap: c.continueWithGoogle,
        children: [
          CustomTextField(
            label: 'Email',
            hint: 'you@email.com',
            controller: c.email,
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          CustomTextField(
            label: 'Password',
            hint: 'Enter your password',
            controller: c.password,
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: (value) => Validators.required(value, 'Password'),
            onSubmitted: (_) => c.submit(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Get.to(() => const ForgotPasswordScreen()),
              child: const Text('Forgot password?'),
            ),
          ),
          CustomButton(
            text: 'Sign in',
            isLoading: c.isLoading,
            onPressed: c.submit,
          ),
        ],
      ),
    );
  }
}
