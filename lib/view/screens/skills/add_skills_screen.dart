import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/add_skills_controller.dart';
import '../../../utils/app_colors.dart';
import '../../components/dialogs/custom_button.dart';
import '../../components/dialogs/custom_text_field.dart';
import '../../components/screen_header.dart';
import '../../components/skill_chip.dart';

class AddSkillsScreen extends StatelessWidget {
  const AddSkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSkillsController>(
      init: AddSkillsController(),
      builder: (c) {
        final skills = c.filteredSkills;
        return Scaffold(
          appBar: AppBar(title: const Text('Your skills')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  const ScreenHeader(
                    title: 'Pick your skills',
                    subtitle: 'We use these to calculate your job match.',
                  ),
                  CustomTextField(
                    label: 'Search or add a skill',
                    hint: 'Type a skill',
                    controller: c.search,
                    icon: Icons.search_rounded,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => c.addCustomSkill(),
                  ),
                  if (c.canAddCustom)
                    CustomButton(
                      text: 'Add “${c.query}”',
                      isOutlined: true,
                      onPressed: c.addCustomSkill,
                    ),
                  Text(
                    '${c.selected.length} selected',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: skills.isEmpty
                          ? const Text(
                              'No matching skills',
                              style: TextStyle(color: AppColors.textSecondary),
                            )
                          : Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                for (final skill in skills)
                                  SkillChip(
                                    label: skill,
                                    isSelected: c.selected.contains(skill),
                                    onTap: () => c.toggle(skill),
                                  ),
                              ],
                            ),
                    ),
                  ),
                  CustomButton(
                    text: 'Save and continue',
                    isLoading: c.isLoading,
                    onPressed: c.save,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
