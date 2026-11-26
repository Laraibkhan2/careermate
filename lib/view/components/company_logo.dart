import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Coloured square with the first letter of the company name.
/// Give the same [heroTag] on two screens to make it fly between them.
class CompanyLogo extends StatelessWidget {
  const CompanyLogo({
    super.key,
    required this.company,
    this.size = 44,
    this.heroTag,
  });

  final String company;
  final double size;
  final String? heroTag;

  static const _colors = [
    AppColors.primary,
    Color(0xFF0F766E),
    Color(0xFFB45309),
    Color(0xFFBE185D),
    Color(0xFF7C3AED),
  ];

  @override
  Widget build(BuildContext context) {
    final seed = company.codeUnits.fold(0, (sum, unit) => sum + unit);

    final logo = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _colors[seed % _colors.length],
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Text(
        company.isEmpty ? '?' : company[0].toUpperCase(),
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
          color: AppColors.onPrimary,
        ),
      ),
    );

    if (heroTag == null) return logo;
    return Hero(
      tag: heroTag!,
      child: Material(type: MaterialType.transparency, child: logo),
    );
  }
}