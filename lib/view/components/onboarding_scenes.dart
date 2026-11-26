import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/page_offset.dart';

/// Every scene is drawn on a 300 x 330 canvas and scaled to fit the stage.
const double kSceneWidth = 300;
const double kSceneHeight = 330;

/// Progress (0 to 1) of the part of the animation that runs from [start]
/// to [end]. Lets one timeline drive many small steps one after another.
double _seg(
  double t,
  double start,
  double end, [
  Curve curve = Curves.easeOutCubic,
]) {
  final linear = ((t - start) / (end - start)).clamp(0.0, 1.0).toDouble();
  return curve.transform(linear);
}

// ---------------------------------------------------------------------------
// Plays a scene when its page comes into view, and again every time you
// return to it.
// ---------------------------------------------------------------------------

class ScenePlayer extends StatefulWidget {
  const ScenePlayer({
    super.key,
    required this.controller,
    required this.index,
    required this.builder,
  });

  final PageController controller;
  final int index;

  /// Builds the scene for animation time [t] (0 = start, 1 = finished).
  final Widget Function(BuildContext context, double t) builder;

  @override
  State<ScenePlayer> createState() => _ScenePlayerState();
}

class _ScenePlayerState extends State<ScenePlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  /// Starts when the page begins to slide in, resets once it is fully gone.
  void _check() {
    if (!mounted) return;
    final distance = (pageOf(widget.controller) - widget.index).abs();
    if (distance < 0.85 && !_playing) {
      _playing = true;
      if (MediaQuery.disableAnimationsOf(context)) {
        _anim.value = 1;
      } else {
        _anim.forward(from: 0);
      }
    } else if (distance >= 1 && _playing) {
      _playing = false;
      _anim.value = 0;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_check);
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) => widget.builder(context, _anim.value),
    );
  }
}

// ---------------------------------------------------------------------------
// Small pieces shared by the scenes
// ---------------------------------------------------------------------------

/// White card that floats on the gradient stage.
class _SceneCard extends StatelessWidget {
  const _SceneCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 24,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.whiteColour,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x331E1B4B),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Rounded square with a gradient, holding a letter or an icon.
class _Badge extends StatelessWidget {
  const _Badge({this.letter, this.icon, this.size = 42});

  final String? letter;
  final IconData? icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: icon != null
              ? Icon(icon, size: size * 0.5, color: AppColors.onPrimary)
              : Text(
                  letter ?? '',
                  style: TextStyle(
                    fontSize: size * 0.42,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}

/// White pill with an icon, e.g. "Best match for you".
class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.whiteColour,
        shape: StadiumBorder(),
        shadows: [
          BoxShadow(
            color: Color(0x331E1B4B),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Icon(icon, size: 16, color: AppColors.warning),
            Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scene 1: a job with its match score
// ---------------------------------------------------------------------------

class MatchScene extends StatelessWidget {
  const MatchScene({super.key, required this.controller, required this.index});

  final PageController controller;
  final int index;

  static const _skills = [
    ('Flutter', true),
    ('Dart', true),
    ('Firebase', true),
    ('REST API', false),
  ];
  static const _score = 86;

  @override
  Widget build(BuildContext context) {
    return ScenePlayer(
      controller: controller,
      index: index,
      builder: (context, t) {
        final back2 = _seg(t, 0.00, 0.35);
        final back1 = _seg(t, 0.08, 0.43);
        final front = _seg(t, 0.16, 0.52);
        final ring = _seg(t, 0.30, 0.80);
        final pill = _seg(t, 0.80, 1.00, Curves.easeOutBack);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Two cards peeking out from behind, like a stack of jobs.
            Positioned(
              left: 30,
              right: 30,
              top: 14 + 30 * (1 - back2),
              height: 120,
              child: Opacity(
                opacity: back2 * 0.35,
                child: const _SceneCard(child: SizedBox.shrink()),
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              top: 40 + 30 * (1 - back1),
              height: 120,
              child: Opacity(
                opacity: back1 * 0.6,
                child: const _SceneCard(child: SizedBox.shrink()),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 70 + 50 * (1 - front),
              child: Opacity(
                opacity: front,
                child: _SceneCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          const _Badge(letter: 'P'),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 2,
                              children: [
                                _FitLine(
                                  'Flutter Developer',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                _FitLine(
                                  'Pixel Works · Karachi',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _Ring(value: _score / 100 * ring, label: '${(_score * ring).round()}%'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Your skills for this job',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final (i, skill) in _skills.indexed)
                            _SkillTag(
                              label: skill.$1,
                              matched: skill.$2,
                              progress: _seg(t, 0.50 + i * 0.08, 0.70 + i * 0.08),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Transform.scale(
                  scale: pill,
                  child: const _Pill(
                    icon: Icons.star_rounded,
                    text: 'Best match for you',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// One line of text that shrinks instead of being cut off.
class _FitLine extends StatelessWidget {
  const _FitLine(this.text, {required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(text, style: style, maxLines: 1),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.value, required this.label});

  final double value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 6.5,
            strokeCap: StrokeCap.round,
            color: AppColors.success,
            backgroundColor: AppColors.border,
          ),
          Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillTag extends StatelessWidget {
  const _SkillTag({
    required this.label,
    required this.matched,
    required this.progress,
  });

  final String label;
  final bool matched;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final color = matched ? AppColors.onSuccessLight : AppColors.textSecondary;

    return Opacity(
      opacity: progress,
      child: Transform.scale(
        scale: 0.85 + 0.15 * progress,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: matched ? AppColors.successLight : AppColors.background,
            shape: StadiumBorder(
              side: matched
                  ? BorderSide.none
                  : const BorderSide(color: AppColors.border),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                if (matched) Icon(Icons.check_rounded, size: 14, color: color),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scene 2: the skills you have and the ones you still need
// ---------------------------------------------------------------------------

class SkillsScene extends StatelessWidget {
  const SkillsScene({super.key, required this.controller, required this.index});

  final PageController controller;
  final int index;

  static const _rows = [
    ('Flutter', true),
    ('Dart', true),
    ('Firebase', false),
    ('REST API', false),
  ];

  @override
  Widget build(BuildContext context) {
    return ScenePlayer(
      controller: controller,
      index: index,
      builder: (context, t) {
        final card = _seg(t, 0.00, 0.30);
        final bar = _seg(t, 0.25, 0.70);
        final bulb = _seg(t, 0.78, 1.00, Curves.easeOutBack);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 44 + 40 * (1 - card),
              child: Opacity(
                opacity: card,
                child: _SceneCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        spacing: 10,
                        children: [
                          _Badge(icon: Icons.phone_android_rounded),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 2,
                              children: [
                                _FitLine(
                                  'Mobile Developer',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                _FitLine(
                                  'You have 2 of 4 skills',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _ProgressBar(value: 0.5 * bar),
                      const SizedBox(height: 10),
                      for (final (i, row) in _rows.indexed)
                        _SkillRow(
                          label: row.$1,
                          have: row.$2,
                          progress: _seg(t, 0.30 + i * 0.09, 0.50 + i * 0.09),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -6,
              top: 4,
              child: Transform.scale(
                scale: bulb,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColour,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x331E1B4B),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: Icon(
                      Icons.lightbulb_rounded,
                      size: 28,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 10,
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: AppColors.border)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0.0, 1.0).toDouble(),
              child: const DecoratedBox(
                decoration: BoxDecoration(gradient: AppColors.brandGradient),
                child: SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({
    required this.label,
    required this.have,
    required this.progress,
  });

  final String label;
  final bool have;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: progress,
      child: Transform.translate(
        offset: Offset(0, 10 * (1 - progress)),
        child: SizedBox(
          height: 38,
          child: Row(
            spacing: 10,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: have ? AppColors.success : AppColors.warningLight,
                ),
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: Icon(
                    have ? Icons.check_rounded : Icons.add_rounded,
                    size: 14,
                    color: have ? AppColors.onPrimary : AppColors.onWarningLight,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (!have)
                const DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.warningLight,
                    shape: StadiumBorder(),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text(
                      'Learn next',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onWarningLight,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scene 3: an application moving from Saved to Interview
// ---------------------------------------------------------------------------

class TrackerScene extends StatelessWidget {
  const TrackerScene({super.key, required this.controller, required this.index});

  final PageController controller;
  final int index;

  static const _stages = ['Saved', 'Applied', 'Interview'];
  static const _colWidth = 92.0;
  static const _gap = 12.0;
  static const _step = _colWidth + _gap;

  @override
  Widget build(BuildContext context) {
    return ScenePlayer(
      controller: controller,
      index: index,
      builder: (context, t) {
        final enter = _seg(t, 0.00, 0.22);
        final move1 = _seg(t, 0.30, 0.48, Curves.easeInOutCubic);
        final move2 = _seg(t, 0.58, 0.76, Curves.easeInOutCubic);
        final note = _seg(t, 0.82, 1.00, Curves.easeOutBack);

        final x = 4 + _step * (move1 + move2);
        final hop = math.sin(math.pi * move1) * 14 + math.sin(math.pi * move2) * 14;
        final status = Color.lerp(
          Color.lerp(AppColors.primary, const Color(0xFF4F46E5), move1)!,
          AppColors.success,
          move2,
        )!;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < _stages.length; i++)
              Positioned(
                left: i * _step,
                top: 0,
                width: _colWidth,
                height: 240,
                child: _Column(title: _stages[i]),
              ),
            // Cards of other jobs, so the board does not look empty.
            for (var i = 0; i < 2; i++)
              Positioned(
                left: i * _step + 4,
                top: 132,
                width: 84,
                height: 60,
                child: Opacity(
                  opacity: enter,
                  child: const _GhostJob(),
                ),
              ),
            Positioned(
              left: x,
              top: 52 - hop,
              width: 84,
              child: Opacity(
                opacity: enter,
                child: Transform.scale(
                  scale: 0.9 + 0.1 * enter,
                  child: _MiniJob(statusColor: status),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 256 + 24 * (1 - note),
              child: Opacity(
                opacity: note.clamp(0.0, 1.0).toDouble(),
                child: const _SceneCard(
                  radius: 18,
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    spacing: 10,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 34,
                          height: 34,
                          child: Icon(
                            Icons.notifications_active_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 1,
                          children: [
                            Text(
                              'Interview invite',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Pixel Works replied to you',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Column extends StatelessWidget {
  const _Column({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _GhostJob extends StatelessWidget {
  const _GhostJob();

  @override
  Widget build(BuildContext context) {
    final line = DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const SizedBox(height: 7),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            FractionallySizedBox(widthFactor: 0.7, child: line),
            line,
            FractionallySizedBox(widthFactor: 0.45, child: line),
          ],
        ),
      ),
    );
  }
}

class _MiniJob extends StatelessWidget {
  const _MiniJob({required this.statusColor});

  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return _SceneCard(
      radius: 16,
      padding: const EdgeInsets.all(9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Badge(letter: 'P', size: 22),
          const SizedBox(height: 6),
          const _FitLine(
            'Flutter Dev',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const _FitLine(
            'Pixel Works',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 7),
          DecoratedBox(
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: const SizedBox(height: 4, width: double.infinity),
          ),
        ],
      ),
    );
  }
}
