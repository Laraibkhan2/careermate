import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

/// Full-width app button. Usually only [text] and [onPressed] are needed;
/// pass [color] / [textColor] to change the look, [isOutlined] for a
/// secondary button, and [isLoading] to show a spinner while waiting.
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
    final background = isOutlined ? AppColors.whiteColour : color;
    final foreground = isOutlined ? color : textColor;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: background,
          disabledForegroundColor: foreground,
          elevation: 0,
          side: isOutlined ? BorderSide(color: color) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: isLoading
            ? SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: foreground,
          ),
        )
            : Text(text),
      ),
    );
  }
}
