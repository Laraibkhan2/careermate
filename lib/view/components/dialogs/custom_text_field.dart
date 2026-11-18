import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

/// Labelled text field. Set [isPassword] to get a show/hide eye icon.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.icon,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? icon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: color),
  );

  Widget _field({bool obscure = false, VoidCallback? onToggle}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.whiteColour,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        prefixIcon: icon == null
            ? null
            : Icon(icon, size: 20, color: AppColors.textSecondary),
        suffixIcon: onToggle == null
            ? null
            : IconButton(
          tooltip: obscure ? 'Show password' : 'Hide password',
          onPressed: onToggle,
          icon: Icon(
            obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 20,
            color: AppColors.textSecondary,
          ),
        ),
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (isPassword)
          GetBuilder<_ObscureController>(
            global: false,
            init: _ObscureController(),
            builder: (c) => _field(obscure: c.obscure, onToggle: c.toggle),
          )
        else
          _field(),
      ],
    );
  }
}

/// Keeps the show/hide state of one password field.
class _ObscureController extends GetxController {
  bool obscure = true;

  void toggle() {
    obscure = !obscure;
    update();
  }
}
