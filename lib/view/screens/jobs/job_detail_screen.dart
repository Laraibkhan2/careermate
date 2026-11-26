import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/jobs_controller.dart';
import '../../../model/job_model.dart';
import '../../../utils/app_colors.dart';
import '../../components/app_card.dart';
import '../../components/app_page.dart';
import '../../components/company_logo.dart';
import '../../components/dialogs/custom_button.dart';
import '../../components/match_ring.dart';
import '../../components/tag_chip.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key, required this.job});

  final JobModel job;

  static void open(JobModel job) => Get.to(() => JobDetailScreen(job: job));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobsController>(
      builder: (jobs) {
        final percent = jobs.matchPercent(job);
        final matched = jobs.matchedSkills(job);
        final missing = jobs.missingSkills(job);
        final status = jobs.statusOf(job);
        final isApplied = status != null && status != JobStatus.saved;

        return AppPage(
          title: 'Job details',
          actions: [
            IconButton(
              tooltip: jobs.isSaved(job) ? 'Remove from saved' : 'Save job',
              onPressed: () => jobs.toggleSave(job),
              icon: Icon(
                jobs.isSaved(job)
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: AppColors.primary,
              ),
            ),
          ],
          bottom: Row(
            spacing: 12,
            children: [
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: jobs.isSaved(job) ? 'Saved' : 'Save job',
                  isOutlined: true,
                  onPressed: () => jobs.toggleSave(job),
                ),
              ),
              Expanded(
                flex: 3,
                child: CustomButton(
                  text: job.isExternal
                      ? 'Apply on website'
                      : (isApplied ? (status?.label ?? 'Applied') : 'Apply now'),
                  color: isApplied ? AppColors.success : AppColors.primary,
                  onPressed: isApplied
                      ? null
                      : () => jobs.apply(job),
                ),
              ),
            ],
          ),
          children: [
            Row(
              spacing: 14,
              children: [
                CompanyLogo(company: job.company, size: 56, heroTag: 'logo-${job.id}'),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${job.company} · ${job.place}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                TagChip(label: job.type, background: AppColors.border),
                if (job.isRemote)
                  const TagChip(label: 'Remote', background: AppColors.border),
                TagChip(label: 'Posted ${job.postedAgo}', background: AppColors.border),
              ],
            ),
            AppCard(
              child: Row(
                spacing: 16,
                children: [
                  MatchRing(
                    percent: percent,
                    size: 80,
                    color: percent >= 70 ? AppColors.success : AppColors.primary,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          _matchLabel(percent),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'You have ${matched.length} of ${job.requiredSkills.length} required skills.',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  const _BlockTitle('Matched skills'),
                  if (matched.isEmpty)
                    const _Note('None yet. Add skills in your profile.')
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [for (final s in matched) TagChip.matched(label: s)],
                    ),
                  const _BlockTitle('Missing skills'),
                  if (missing.isEmpty)
                    const _Note('You have every skill this job asks for.')
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [for (final s in missing) TagChip.missing(label: s)],
                    ),
                ],
              ),
            ),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  const _BlockTitle('About the role'),
                  _Note(job.description),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

String _matchLabel(int percent) {
  if (percent >= 85) return 'Strong match';
  if (percent >= 60) return 'Good match';
  return 'Low match';
}

class _BlockTitle extends StatelessWidget {
  const _BlockTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.textSecondary),
    );
  }
}
