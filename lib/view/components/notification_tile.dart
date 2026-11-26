import 'package:flutter/material.dart';

import '../../model/notification_model.dart';
import '../../utils/app_colors.dart';
import 'app_card.dart';

/// One alert. Unread alerts have a tinted background and a dot.
class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.item, required this.onTap});

  final NotificationModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, background, foreground) = switch (item.type) {
      NotificationType.match => (
      Icons.work_outline_rounded,
      AppColors.primaryLight,
      AppColors.primary,
      ),
      NotificationType.status => (
      Icons.check_circle_outline_rounded,
      AppColors.successLight,
      AppColors.onSuccessLight,
      ),
      NotificationType.reminder => (
      Icons.schedule_rounded,
      AppColors.warningLight,
      AppColors.onWarningLight,
      ),
    };

    return AppCard(
      onTap: onTap,
      color: item.isRead ? AppColors.whiteColour : const Color(0xFFF3F8FF),
      borderColor: item.isRead ? AppColors.border : AppColors.primaryLight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: background, shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: foreground),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (!item.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      item.time,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Text(
                  item.message,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
