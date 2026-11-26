import 'package:get/get.dart';

import 'jobs_controller.dart';
import 'main_controller.dart';
import 'notifications_controller.dart';
import 'user_controller.dart';

/// Controllers that live as long as the app and are shared by many screens.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController(), permanent: true);
    Get.put(JobsController(), permanent: true);
    Get.put(NotificationsController(), permanent: true);
    Get.put(MainController(), permanent: true);
  }
}
