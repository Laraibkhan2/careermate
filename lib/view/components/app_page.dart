import 'package:flutter/material.dart';

import 'fade_slide_in.dart';

/// Standard page: optional app bar, scrolling content with even spacing
/// (each block fades in one after another), and an optional [bottom]
/// widget (usually a button) that stays in place.
/// Pass [onRefresh] to let the user pull down to reload the page.
class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.children,
    this.title,
    this.actions,
    this.bottom,
    this.onRefresh,
  });

  final List<Widget> children;
  final String? title;
  final List<Widget>? actions;
  final Widget? bottom;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final scroll = SingleChildScrollView(
      physics: onRefresh == null ? null : const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          for (final (index, child) in children.indexed)
            FadeSlideIn(index: index, child: child),
        ],
      ),
    );

    return Scaffold(
      appBar: title == null ? null : AppBar(title: Text(title!), actions: actions),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: onRefresh == null
                  ? scroll
                  : RefreshIndicator(onRefresh: onRefresh!, child: scroll),
            ),
            if (bottom != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: bottom,
              ),
          ],
        ),
      ),
    );
  }
}
