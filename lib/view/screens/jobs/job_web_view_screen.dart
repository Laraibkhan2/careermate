import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../model/job_model.dart';
import '../../../utils/app_colors.dart';
import '../../components/dialogs/custom_button.dart';

/// Shows a job's application page inside CareerMate (a WebView), so the user
/// does not have to leave the app.
class JobWebViewScreen extends StatefulWidget {
  const JobWebViewScreen({super.key, required this.job});

  final JobModel job;

  /// Opens the job's page inside the app. Flutter on the web cannot show a
  /// WebView, so there it falls back to the browser.
  static Future<void> open(JobModel job) async {
    if (kIsWeb) {
      await launchUrl(
        Uri.parse(job.applyUrl),
        mode: LaunchMode.externalApplication,
      );
      return;
    }
    await Get.to(() => JobWebViewScreen(job: job));
  }

  @override
  State<JobWebViewScreen> createState() => _JobWebViewScreenState();
}

class _JobWebViewScreenState extends State<JobWebViewScreen> {
  late final Uri _url = _secure(widget.job.applyUrl);
  late final WebViewController _web;

  int _progress = 0;
  bool _failed = false;

  /// Android blocks plain http pages, so try https instead.
  static Uri _secure(String link) {
    final uri = Uri.parse(link);
    return uri.scheme == 'http' ? uri.replace(scheme: 'https') : uri;
  }

  @override
  void initState() {
    super.initState();
    _web = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.whiteColour)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (value) => setState(() => _progress = value),
          onPageStarted: (_) => setState(() => _failed = false),
          onWebResourceError: (error) {
            // Ignore failed images/scripts; only a failed page matters.
            if (error.isForMainFrame == false) return;
            setState(() => _failed = true);
          },
          onNavigationRequest: _onNavigation,
        ),
      )
      ..loadRequest(_url);
  }

  /// Web pages stay in the app; mail and phone links open their own app.
  Future<NavigationDecision> _onNavigation(NavigationRequest request) async {
    final uri = Uri.tryParse(request.url);
    final scheme = uri?.scheme ?? '';
    if (scheme == 'http' || scheme == 'https' || scheme == 'about') {
      return NavigationDecision.navigate;
    }
    if (uri != null && (scheme == 'mailto' || scheme == 'tel')) {
      await launchUrl(uri);
    }
    return NavigationDecision.prevent;
  }

  void _reload() {
    setState(() {
      _failed = false;
      _progress = 0;
    });
    _web.loadRequest(_url);
  }

  Future<void> _openInBrowser() =>
      launchUrl(_url, mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // The back button goes back inside the page first, then closes the screen.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _web.canGoBack()) {
          await _web.goBack();
        } else {
          Get.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Close',
            icon: const Icon(Icons.close_rounded),
            onPressed: Get.back,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.job.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Text(
                _url.host,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Reload',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _reload,
            ),
            IconButton(
              tooltip: 'Open in browser',
              icon: const Icon(Icons.open_in_browser_rounded),
              onPressed: _openInBrowser,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: _progress < 100 && !_failed
                ? LinearProgressIndicator(
                    value: _progress == 0 ? null : _progress / 100,
                    minHeight: 3,
                  )
                : const SizedBox(height: 3),
          ),
        ),
        body: _failed
            ? _LoadError(onRetry: _reload, onBrowser: _openInBrowser)
            : WebViewWidget(controller: _web),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry, required this.onBrowser});

  final VoidCallback onRetry;
  final VoidCallback onBrowser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textHint),
          const Text(
            'This page could not be loaded',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Text(
            'Check your internet connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          CustomButton(text: 'Try again', onPressed: onRetry),
          CustomButton(
            text: 'Open in browser',
            isOutlined: true,
            onPressed: onBrowser,
          ),
        ],
      ),
    );
  }
}
