import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/jobs_controller.dart';
import '../../../controller/saved_jobs_controller.dart';
import '../../../model/job_model.dart';
import '../../../utils/app_colors.dart';
import '../../components/app_page.dart';
import '../../components/empty_state.dart';
import '../../components/job_card.dart';
import '../../components/screen_header.dart';
import '../../components/segmented_tabs.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SavedJobsController>(
      init: SavedJobsController(),
      builder: (c) => GetBuilder<JobsController>(
        builder: (jobs) {
          final list = jobs.jobsWithStatus(c.tab);

          return AppPage(
            children: [
              const ScreenHeader(
                title: 'My jobs',
                subtitle: 'Track every job you saved or applied to.',
              ),
              SegmentedTabs(
                labels: [for (final status in JobStatus.values) status.label],
                selectedIndex: c.tab.index,
                onChanged: (i) => c.setTab(JobStatus.values[i]),
              ),
              if (list.isEmpty)
                EmptyState(
                  icon: Icons.bookmark_border_rounded,
                  title: 'Nothing here yet',
                  message: 'Jobs you mark as ${c.tab.label.toLowerCase()} show up here.',
                )
              else
                for (final job in list)
                  JobCard(
                    job: job,
                    matchPercent: jobs.matchPercent(job),
                    footer: _JobActions(job: job, status: c.tab, jobs: jobs),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _JobActions extends StatelessWidget {
  const _JobActions({required this.job, required this.status, required this.jobs});

  final JobModel job;
  final JobStatus status;
  final JobsController jobs;

  @override
  Widget build(BuildContext context) {
    // Applied / interview / archived are set by the employer, not by the user.
    if (status != JobStatus.saved) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 4,
      children: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
          onPressed: () => jobs.removeTracking(job),
          child: const Text('Remove'),
        ),
        TextButton(
          onPressed: () => jobs.apply(job),
          child: Text(status.actionLabel),
        ),
      ],
    );
  }
}
