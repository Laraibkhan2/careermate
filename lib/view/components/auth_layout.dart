import 'package:flutter/material.dart';
import 'package:careermate/utils/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
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
                if (icon != null)
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 30, color: AppColors.primary),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                ...children,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}