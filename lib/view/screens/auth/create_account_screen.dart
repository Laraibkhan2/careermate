import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/create_account_controller.dart';
import '../../../model/user_role.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/global.dart';
import '../../components/auth_layout.dart';
import '../../components/dialogs/custom_button.dart';
import '../../components/dialogs/custom_text_field.dart';
import '../../components/segmented_tabs.dart';

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
        onGoogleTap: c.continueWithGoogle,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              const Text(
                'I am a',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SegmentedTabs(
                labels: const ['Job seeker', 'Employer'],
                selectedIndex: c.role.index,
                onChanged: (i) => c.setRole(UserRole.values[i]),
              ),
            ],
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
