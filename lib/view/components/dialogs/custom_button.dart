import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

/// Full-width app button. Usually only [text] and [onPressed] are needed;
/// pass [color] / [textColor] to change the look, [isOutlined] for a
/// secondary button, and [isLoading] to show a spinner while waiting.
/// The default blue button gets the brand gradient.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primary,
    this.textColor = AppColors.onPrimary,
    this.isOutlined = false,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final bool isOutlined;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final useGradient = !isOutlined && color == AppColors.primary;
    final foreground = isOutlined ? color : textColor;
    final radius = BorderRadius.circular(16);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: useGradient ? AppColors.brandGradient : null,
          color: useGradient
              ? null
              : (isOutlined ? AppColors.whiteColour : color),
          borderRadius: radius,
          border: isOutlined ? Border.all(color: color) : null,
          boxShadow: isOutlined
              ? null
              : [
            BoxShadow(
              color: color.withValues(alpha: 0.28),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: foreground,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: foreground,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(borderRadius: radius),
            textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isLoading
                ? SizedBox(
              key: const ValueKey('loading'),
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: foreground,
              ),
            )
                : Text(
              text,
              key: ValueKey(text),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}