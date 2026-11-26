enum NotificationType { match, status, reminder }

class NotificationModel {
  NotificationModel({
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    this.isToday = false,
    this.isRead = false,
  });

  final NotificationType type;
  final String title;
  final String message;
  final String time;
  final bool isToday;
  bool isRead;
}
