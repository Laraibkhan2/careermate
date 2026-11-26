import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF2563EB);
  static const primaryLight = Color(0xFFDBEAFE);
  static const onPrimary = Colors.white;

  static const background = Color(0xFFF8FAFC);
  static const whiteColour = Colors.white;

  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textHint = Color(0xFF94A3B8);

  static const border = Color(0xFFE2E8F0);

  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFDC2626);

  static const successLight = Color(0xFFDCFCE7);
  static const onSuccessLight = Color(0xFF166534);
  static const warningLight = Color(0xFFFEF3C7);
  static const onWarningLight = Color(0xFF92400E);

  /// Blue gradient used on hero cards, icons and the main button.
  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
  );

  /// Soft shadow under cards.
  static const cardShadow = BoxShadow(
    color: Color(0x140F172A),
    blurRadius: 24,
    offset: Offset(0, 8),
  );
}