import 'package:flutter/widgets.dart';

/// The current page of a PageView as a fraction (0.0, 0.4, 1.0 ...), which
/// also works before the PageView has been laid out for the first time.
double pageOf(PageController controller) {
  final page = controller.hasClients ? controller.page : null;
  return page ?? controller.initialPage.toDouble();
}
