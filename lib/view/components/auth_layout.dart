import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'dialogs/custom_button.dart';
import 'fade_slide_in.dart';
import 'screen_header.dart';

/// Shared page shell for Login, Create Account and Forgot Password:
/// icon, title, subtitle, the form fields and the bottom link.
/// Every block fades in one after another.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.formKey,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.footerText,
    required this.footerLink,
    required this.onFooterTap,
    this.icon,
    this.showBack = false,
    this.onGoogleTap,
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final String footerText;
  final String footerLink;
  final VoidCallback onFooterTap;
  final IconData? icon;
  final bool showBack;

  /// When set, an "or" line and a "Continue with Google" button are shown.
  final VoidCallback? onGoogleTap;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      if (icon != null) _IconBadge(icon: icon!),
      ScreenHeader(title: title, subtitle: subtitle),
      ...children,
      if (onGoogleTap != null) ...[
        const _OrDivider(),
        CustomButton(
          text: 'Continue with Google',
          isOutlined: true,
          onPressed: onGoogleTap,
        ),
      ],
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            footerText,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          TextButton(onPressed: onFooterTap, child: Text(footerLink)),
        ],
      ),
    ];

    return Scaffold(
      appBar: showBack ? AppBar() : null,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                for (final (index, item) in items.indexed)
                  FadeSlideIn(index: index, child: item),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(icon, size: 32, color: AppColors.onPrimary),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 12,
      children: [
        Expanded(child: Divider(color: AppColors.border)),
        Text('or', style: TextStyle(color: AppColors.textSecondary)),
        Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}