import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// Row of tabs inside a rounded bar. The selected tab slides to white.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 4,
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                button: true,
                selected: i == selectedIndex,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: i == selectedIndex ? AppColors.whiteColour : Colors.transparent,
                    borderRadius: radius,
                    boxShadow: i == selectedIndex
                        ? const [BoxShadow(color: Color(0x1A0F172A), blurRadius: 6, offset: Offset(0, 2))]
                        : const [],
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      borderRadius: radius,
                      onTap: () => onChanged(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: i == selectedIndex ? FontWeight.w600 : FontWeight.w500,
                            color: i == selectedIndex ? AppColors.primary : AppColors.textSecondary,
                          ),
                          child: Text(labels[i]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}