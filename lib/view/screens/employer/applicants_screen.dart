import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/applicants_controller.dart';
import '../../../model/application_model.dart';
import '../../../utils/app_colors.dart';
import '../../components/app_card.dart';
import '../../components/app_page.dart';
import '../../components/empty_state.dart';
import '../../components/loading_view.dart';
import '../../components/screen_header.dart';

class ApplicantsScreen extends StatelessWidget {
  const ApplicantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ApplicantsController>(
      init: ApplicantsController(), // reloads every time this tab opens
      builder: (c) => AppPage(
        onRefresh: () => c.load(showLoading: false),
        children: [
          ScreenHeader(
            title: 'Applicants',
            subtitle: c.isLoading
                ? 'Loading applications...'
                : '${c.applications.length} applications to your jobs.',
          ),
          if (c.isLoading)
            const LoadingView()
          else if (c.applications.isEmpty)
            const EmptyState(
              icon: Icons.people_outline_rounded,
              title: 'No applicants yet',
              message: 'When job seekers apply, they will show up here.',
            )
          else
            for (final app in c.applications)
              _ApplicantCard(
                app: app,
                onStatus: (status) => c.setStatus(app, status),
              ),
        ],
      ),
    );
  }
}

class _ApplicantCard extends StatelessWidget {
  const _ApplicantCard({required this.app, required this.onStatus});

  final ApplicationModel app;
  final ValueChanged<ApplicationStatus> onStatus;

  Color get _statusColor => switch (app.status) {
    ApplicationStatus.applied => AppColors.primary,
    ApplicationStatus.interviewing => AppColors.success,
    ApplicationStatus.rejected => AppColors.error,
  };

  Widget _action(String text, ApplicationStatus status, {bool danger = false}) {
    return TextButton(
      style: danger
          ? TextButton.styleFrom(foregroundColor: AppColors.error)
          : null,
      onPressed: () => onStatus(status),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actions = switch (app.status) {
      ApplicationStatus.applied => [
        _action('Reject', ApplicationStatus.rejected, danger: true),
        _action('Interview', ApplicationStatus.interviewing),
      ],
      ApplicationStatus.interviewing => [
        _action('Reject', ApplicationStatus.rejected, danger: true),
      ],
      ApplicationStatus.rejected => [
        _action('Reconsider', ApplicationStatus.applied),
      ],
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      app.seekerName.isEmpty ? 'Job seeker' : app.seekerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      app.seekerEmail,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                app.status.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _statusColor,
                ),
              ),
            ],
          ),
          Text(
            'Applied for ${app.jobTitle} · ${app.appliedAgo}',
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
          if (app.seekerSkills.isNotEmpty)
            Text(
              'Skills: ${app.seekerSkills.join(', ')}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 4,
            children: actions,
          ),
        ],
      ),
    );
  }
}
