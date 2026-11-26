import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/job_model.dart';
import 'jobs_controller.dart';

enum JobFilter {
  all('All'),
  remote('Remote'),
  topMatch('70%+ match');

  const JobFilter(this.label);

  final String label;
}

/// Search text and filter of the Jobs screen.
class JobSearchController extends GetxController {
  final search = TextEditingController();
  JobFilter filter = JobFilter.all;

  List<JobModel> get results {
    final jobs = Get.find<JobsController>();
    final query = search.text.trim().toLowerCase();

    bool matchesQuery(JobModel job) =>
        query.isEmpty ||
        job.title.toLowerCase().contains(query) ||
        job.company.toLowerCase().contains(query) ||
        job.requiredSkills.any((s) => s.toLowerCase().contains(query));

    bool matchesFilter(JobModel job) => switch (filter) {
      JobFilter.all => true,
      JobFilter.remote => job.isRemote,
      JobFilter.topMatch => jobs.matchPercent(job) >= 70,
    };

    return jobs.rankedJobs.where((j) => matchesQuery(j) && matchesFilter(j)).toList();
  }

  void setFilter(JobFilter value) {
    filter = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    search.addListener(update);
  }

  @override
  void onClose() {
    search.dispose();
    super.onClose();
  }
}
