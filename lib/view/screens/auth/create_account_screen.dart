import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/create_account_controller.dart';
import '../../../utils/global.dart';
import '../../components/auth_layout.dart';
import '../../components/dialogs/custom_button.dart';
import '../../components/dialogs/custom_text_field.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateAccountController>(
      init: CreateAccountController(),
      builder: (c) => AuthLayout(
        formKey: c.formKey,
        showBack: true,
        icon: Icons.person_add_alt_1_outlined,
        title: 'Create your account',
        subtitle: 'It takes less than a minute.',
        footerText: 'Already have an account?',
        footerLink: 'Sign in',
        onFooterTap: Get.back,
        children: [
          CustomTextField(
            label: 'Full name',
            hint: 'Your name',
            controller: c.name,
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            validator: (value) => Validators.required(value, 'Name'),
          ),
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
            hint: 'At least 8 characters',
            controller: c.password,
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: Validators.password,
            onSubmitted: (_) => c.submit(),
          ),
          CustomButton(
            text: 'Create account',
            isLoading: c.isLoading,
            onPressed: c.submit,
          ),
        ],
      ),
    );
  }
}
