import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'app_card.dart';

/// One row of a settings list: icon, title and an optional widget on the right.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.color = AppColors.textPrimary,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      trailing: trailing,
      title: Text(
        title,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color),
      ),
    );
  }
}

/// Card that holds [SettingsTile]s with a thin line between them.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.border),
            children[i],
          ],
        ],
      ),
    );
  }
}
