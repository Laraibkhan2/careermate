import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/notifications_controller.dart';
import '../../../model/notification_model.dart';
import '../../../utils/app_colors.dart';
import '../../components/app_page.dart';
import '../../components/empty_state.dart';
import '../../components/notification_tile.dart';
import '../../components/screen_header.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      builder: (c) => AppPage(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ScreenHeader(
                  title: 'Alerts',
                  subtitle: '${c.unreadCount} unread',
                ),
              ),
              TextButton(onPressed: c.markAllRead, child: const Text('Mark all read')),
            ],
          ),
          if (c.items.isEmpty)
            const EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'No alerts yet',
              message: 'New matches and reminders will appear here.',
            ),
          _Group(title: 'Today', items: c.today, onTap: c.markRead),
          _Group(title: 'Earlier', items: c.earlier, onTap: c.markRead),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.items, required this.onTap});

  final String title;
  final List<NotificationModel> items;
  final ValueChanged<NotificationModel> onTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        for (final item in items)
          NotificationTile(item: item, onTap: () => onTap(item)),
      ],
    );
  }
}