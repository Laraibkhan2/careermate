import 'package:flutter/material.dart';

/// Fades a widget in while it slides up. A higher [index] starts a little
/// later, so a list of widgets appears one after another.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  static const _baseMs = 450;
  static const _stepMs = 60;

  @override
  Widget build(BuildContext context) {
    final capped = index > 8 ? 8 : index;
    final delayMs = capped * _stepMs;
    final totalMs = delayMs + _baseMs;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: totalMs),
      curve: Interval(delayMs / totalMs, 1.0, curve: Curves.easeOutCubic),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}