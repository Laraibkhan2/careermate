import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/employer_jobs_controller.dart';
import '../../../model/job_model.dart';
import '../../../utils/app_colors.dart';
import '../../components/app_card.dart';
import '../../components/app_page.dart';
import '../../components/empty_state.dart';
import '../../components/loading_view.dart';
import '../../components/screen_header.dart';

class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployerJobsController>(
      init: EmployerJobsController(), // reloads every time this tab opens
      builder: (c) => AppPage(
        children: [
          const ScreenHeader(
            title: 'Your jobs',
            subtitle: 'Jobs you have posted.',
          ),
          if (c.isLoading)
            const LoadingView()
          else if (c.jobs.isEmpty)
            const EmptyState(
              icon: Icons.work_outline_rounded,
              title: 'No jobs posted yet',
              message: 'Open the Post Job tab to add your first job.',
            )
          else
            for (final job in c.jobs)
              _PostedJobCard(job: job, onDelete: () => c.delete(job)),
        ],
      ),
    );
  }
}

class _PostedJobCard extends StatelessWidget {
  const _PostedJobCard({required this.job, required this.onDelete});

  final JobModel job;
  final VoidCallback onDelete;

  void _confirmDelete() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete job?'),
        content: Text('"${job.title}" will be removed for everyone.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              onDelete();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  job.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${job.company} · ${job.place}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${job.type} · ${job.postedAgo}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Delete job',
            onPressed: _confirmDelete,
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}