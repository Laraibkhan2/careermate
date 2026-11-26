import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/post_job_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/global.dart';
import '../../components/app_page.dart';
import '../../components/dialogs/custom_button.dart';
import '../../components/dialogs/custom_text_field.dart';
import '../../components/screen_header.dart';

class PostJobScreen extends StatelessWidget {
  const PostJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostJobController>(
      init: PostJobController(),
      builder: (c) => AppPage(
        children: [
          const ScreenHeader(
            title: 'Post a job',
            subtitle: 'Fill in the details. Job seekers will see it right away.',
          ),
          Form(
            key: c.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                CustomTextField(
                  label: 'Job title',
                  hint: 'Flutter Developer',
                  controller: c.title,
                  icon: Icons.work_outline_rounded,
                  validator: (v) => Validators.required(v, 'Job title'),
                ),
                CustomTextField(
                  label: 'Company',
                  hint: 'Pixel Works',
                  controller: c.company,
                  icon: Icons.business_outlined,
                  validator: (v) => Validators.required(v, 'Company'),
                ),
                CustomTextField(
                  label: 'Location',
                  hint: 'Karachi',
                  controller: c.location,
                  icon: Icons.place_outlined,
                  validator: (v) => Validators.required(v, 'Location'),
                ),
                const Text(
                  'Job type',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final t in PostJobController.types)
                      ChoiceChip(
                        label: Text(t),
                        selected: c.type == t,
                        onSelected: (_) => c.setType(t),
                      ),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Remote friendly'),
                  value: c.isRemote,
                  onChanged: c.setRemote,
                ),
                CustomTextField(
                  label: 'Required skills',
                  hint: 'Flutter, Dart, Firebase',
                  controller: c.skills,
                  icon: Icons.bolt_outlined,
                  validator: (v) => Validators.required(v, 'Skills'),
                ),
                CustomTextField(
                  label: 'Description',
                  hint: 'What will the person work on?',
                  controller: c.description,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 5,
                  validator: (v) => Validators.required(v, 'Description'),
                ),
                CustomButton(
                  text: 'Post job',
                  isLoading: c.isLoading,
                  onPressed: c.submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}