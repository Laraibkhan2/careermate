import 'package:get/get.dart';

import '../model/job_model.dart';

/// Which tab (Saved, Applied, Interview, Archived) is open.
class SavedJobsController extends GetxController {
  JobStatus tab = JobStatus.saved;

  void setTab(JobStatus value) {
    tab = value;
    update();
  }
}
