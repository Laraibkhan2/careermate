import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/edit_profile_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../utils/global.dart';
import '../../components/app_page.dart';
import '../../components/dialogs/custom_button.dart';
import '../../components/dialogs/custom_text_field.dart';
import '../../components/profile_avatar.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      builder: (c) => AppPage(
        title: 'Edit profile',
        bottom: CustomButton(
          text: 'Save changes',
          isLoading: c.isLoading,
          onPressed: c.submit,
        ),
        children: [
          Center(
            child: ProfileAvatar(
              initials: Get.find<UserController>().initials,
              size: 88,
            ),
          ),
          Form(
            key: c.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
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
                  label: 'New password',
                  hint: 'Leave empty to keep your password',
                  controller: c.newPassword,
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                  (value == null || value.isEmpty) ? null : Validators.password(value),
                  onSubmitted: (_) => c.submit(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}