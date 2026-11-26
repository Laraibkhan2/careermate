import 'package:get/get.dart';

/// Which tab of the bottom navigation bar is open.
class MainController extends GetxController {
  int index = 0;

  void setIndex(int value) {
    index = value;
    update();
  }
}
