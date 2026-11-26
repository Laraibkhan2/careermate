import 'package:get/get.dart';

import '../model/job_model.dart';
import '../services/job_service.dart';

/// The jobs posted by the signed-in employer.
class EmployerJobsController extends GetxController {
  final jobs = <JobModel>[];
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading = true;
    update();
    try {
      final fetched = await JobService.fetchMyJobs();
      jobs
        ..clear()
        ..addAll(fetched);
    } catch (e) {
      Get.snackbar('Could not load your jobs', '$e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> delete(JobModel job) async {
    try {
      await JobService.deleteJob(job.id);
      jobs.remove(job);
      update();
    } catch (e) {
      Get.snackbar('Could not delete the job', '$e');
    }
  }
}