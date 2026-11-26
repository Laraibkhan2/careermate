import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/job_service.dart';
import 'main_controller.dart';

/// Form state of the "Post a job" screen.
class PostJobController extends GetxController {
  static const types = ['Full-time', 'Part-time', 'Contract', 'Internship'];

  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final company = TextEditingController();
  final location = TextEditingController();
  final skills = TextEditingController(); // comma separated
  final description = TextEditingController();

  String type = types.first;
  bool isRemote = false;
  bool isLoading = false;

  void setType(String value) {
    type = value;
    update();
  }

  void setRemote(bool value) {
    isRemote = value;
    update();
  }

  Future<void> submit() async {
    if (isLoading || !formKey.currentState!.validate()) return;

    isLoading = true;
    update();
    var posted = false;
    try {
      await JobService.postJob(
        title: title.text.trim(),
        company: company.text.trim(),
        location: location.text.trim(),
        type: type,
        description: description.text.trim(),
        isRemote: isRemote,
        requiredSkills: skills.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
      );
      posted = true;
    } catch (e) {
      Get.snackbar('Could not post the job', '$e');
    } finally {
      isLoading = false;
      update();
    }

    if (posted) {
      Get.snackbar('Job posted', '${title.text.trim()} is now live.');
      Get.find<MainController>().setIndex(0); // back to "My Jobs"
    }
  }

  @override
  void onClose() {
    title.dispose();
    company.dispose();
    location.dispose();
    skills.dispose();
    description.dispose();
    super.onClose();
  }
}