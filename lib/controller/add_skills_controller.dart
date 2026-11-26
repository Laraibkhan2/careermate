import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/skills.dart';
import '../view/screens/main/main_screen.dart';
import 'user_controller.dart';

class AddSkillsController extends GetxController {
  static const _maxSkillLength = 30;

  final search = TextEditingController();
  final selected = <String>{};
  final customSkills = <String>[];
  bool isLoading = false;

  String get query => search.text.trim();

  List<String> get _allSkills => [...allSkills, ...customSkills];

  /// Skills that match the text typed in the search field.
  List<String> get filteredSkills {
    final text = query.toLowerCase();
    return _allSkills.where((s) => s.toLowerCase().contains(text)).toList();
  }

  /// True when the typed text is not already in the list, so it can be added.
  bool get canAddCustom =>
      query.isNotEmpty &&
      !_allSkills.any((s) => s.toLowerCase() == query.toLowerCase());

  void toggle(String skill) {
    if (!selected.remove(skill)) selected.add(skill);
    update();
  }

  /// Adds the typed skill to the list and selects it.
  void addCustomSkill() {
    if (!canAddCustom) return;
    if (query.length > _maxSkillLength) {
      Get.snackbar('Too long', 'Use at most $_maxSkillLength characters.');
      return;
    }
    final skill = query;
    customSkills.add(skill);
    selected.add(skill);
    search.clear();
    update();
  }

  Future<void> save() async {
    if (selected.isEmpty) {
      Get.snackbar('Pick a skill', 'Select at least one skill to continue.');
      return;
    }
    isLoading = true;
    update();
    try {
      await Get.find<UserController>().setSkills(selected.toList());
      Get.offAll(() => const MainScreen());
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Show the skills the user already has (when opened from Profile).
    final mine = Get.find<UserController>().skills;
    selected.addAll(mine);
    customSkills.addAll(mine.where((s) => !allSkills.contains(s)));
    search.addListener(update);
  }

  @override
  void onClose() {
    search.dispose();
    super.onClose();
  }
}
