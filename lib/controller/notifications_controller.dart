import 'package:get/get.dart';

import '../model/notification_model.dart';

class NotificationsController extends GetxController {
  // TODO: load these from the API / Firebase instead of sample data.
  final items = <NotificationModel>[
    NotificationModel(
      type: NotificationType.match,
      title: 'New job match',
      message: 'Full-Stack Developer at Nova Labs matches your skills.',
      time: '2h',
      isToday: true,
    ),
    NotificationModel(
      type: NotificationType.match,
      title: 'New job match',
      message: 'React Developer at Bright Apps matches your skills.',
      time: '5h',
      isToday: true,
    ),
    NotificationModel(
      type: NotificationType.status,
      title: 'Status updated',
      message: 'Backend Engineer was moved to Applied.',
      time: 'Yesterday',
      isRead: true,
    ),
    NotificationModel(
      type: NotificationType.reminder,
      title: 'Reminder',
      message: 'Follow up on your Pixel Works application.',
      time: '2d',
      isRead: true,
    ),
    NotificationModel(
      type: NotificationType.reminder,
      title: 'Reminder',
      message: 'You saved jobs this week but have not applied yet.',
      time: '3d',
      isRead: true,
    ),
  ];

  int get unreadCount => items.where((n) => !n.isRead).length;

  List<NotificationModel> get today => items.where((n) => n.isToday).toList();

  List<NotificationModel> get earlier => items.where((n) => !n.isToday).toList();

  void markRead(NotificationModel item) {
    item.isRead = true;
    update();
  }

  void markAllRead() {
    for (final item in items) {
      item.isRead = true;
    }
    update();
  }
}
