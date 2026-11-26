import 'package:get/get.dart';

import '../model/application_model.dart';
import '../services/application_service.dart';

/// Applications received by the signed-in employer.
class ApplicantsController extends GetxController {
  final applications = <ApplicationModel>[];
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
      update();
    }
    try {
      final fetched = await ApplicationService.fetchForEmployer();
      applications
        ..clear()
        ..addAll(fetched);
    } catch (e) {
      Get.snackbar('Could not load applicants', '$e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> setStatus(ApplicationModel app, ApplicationStatus status) async {
    try {
      await ApplicationService.setStatus(app.id, status);
      app.status = status;
      update();
    } catch (e) {
      Get.snackbar('Could not update the application', '$e');
    }
  }
}
