import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/jobs_controller.dart';
import '../../../controller/main_controller.dart';
import '../../../controller/notifications_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../model/job_model.dart';
import '../../../utils/app_colors.dart';
import '../../components/app_card.dart';
import '../../components/app_page.dart';
import '../../components/empty_state.dart';
import '../../components/gradient_card.dart';
import '../../components/job_card.dart';
import '../../components/loading_view.dart';
import '../../components/match_ring.dart';
import '../../components/profile_avatar.dart';
import '../../components/section_header.dart';
import '../jobs/job_detail_screen.dart';
import '../skills/add_skills_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobsController>(
      builder: (jobs) {
        final best = jobs.bestMatch;

        return AppPage(
          onRefresh: () => jobs.loadJobs(showLoading: false),
          children: [
            const _Header(),
            if (jobs.isLoading)
              const LoadingView()
            else ...[
              if (best != null)
                _BestMatchCard(job: best, percent: jobs.matchPercent(best))
              else
                _ImproveSkillsCard(
                  hasSkills: Get.find<UserController>().skills.isNotEmpty,
                  hasJobs: jobs.jobs.isNotEmpty,
                  inDemand: jobs.inDemandSkills,
                ),
              _StatsRow(jobs: jobs),
              if (jobs.jobs.isEmpty)
                const EmptyState(
                  icon: Icons.work_outline_rounded,
                  title: 'No jobs yet',
                  message: 'Jobs posted by employers will show up here.',
                )
              else ...[
                SectionHeader(
                  title: 'New for you',
                  actionText: 'See all',
                  onAction: () => Get.find<MainController>().setIndex(1),
                ),
                // The best match already has its own card above.
                for (final job in jobs.rankedJobs.skip(best == null ? 0 : 1).take(3))
                  JobCard(job: job, matchPercent: jobs.matchPercent(job)),
              ],
            ],
          ],
        );
      },
    );
  }
}

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: GetBuilder<UserController>(
            builder: (user) => Row(
              spacing: 12,
              children: [
                ProfileAvatar(initials: user.initials, size: 48),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting(),
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      Text(
                        'Hi, ${user.firstName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        GetBuilder<NotificationsController>(
          builder: (alerts) => IconButton.filledTonal(
            tooltip: 'Alerts',
            onPressed: () => Get.find<MainController>().setIndex(3),
            icon: Badge(
              isLabelVisible: alerts.unreadCount > 0,
              smallSize: 8,
              child: const Icon(Icons.notifications_none_rounded),
            ),
          ),
        ),
      ],
    );
  }
}

class _BestMatchCard extends StatelessWidget {
  const _BestMatchCard({required this.job, required this.percent});

  final JobModel job;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                const Text(
                  'Best match today',
                  style: TextStyle(fontSize: 13, color: AppColors.onPrimary),
                ),
                Text(
                  job.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onPrimary,
                  ),
                ),
                Text(
                  '${job.company} · ${job.place}',
                  style: const TextStyle(fontSize: 14, color: AppColors.onPrimary),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.whiteColour,
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () => JobDetailScreen.open(job),
                  child: const Text('View job'),
                ),
              ],
            ),
          ),
          MatchRing(
            percent: percent,
            color: AppColors.onPrimary,
            trackColor: AppColors.onPrimary.withValues(alpha: 0.28),
            textColor: AppColors.onPrimary,
          ),
        ],
      ),
    );
  }
}

/// Shown instead of the best match when no job fits the user's skills.
class _ImproveSkillsCard extends StatelessWidget {
  const _ImproveSkillsCard({
    required this.hasSkills,
    required this.hasJobs,
    required this.inDemand,
  });

  final bool hasSkills;
  final bool hasJobs;
  final List<String> inDemand;

  String get _label => hasSkills ? 'Improve your skills' : 'Add your skills';

  String get _headline {
    if (!hasSkills) return 'Tell us what you know';
    return hasJobs ? 'No job matches yet' : 'Stay ready';
  }

  String get _message {
    if (!hasSkills) {
      return 'Add your skills and we will match you with the right jobs.';
    }
    if (!hasJobs) return 'New jobs will show up here. Keep your skills up to date.';
    if (inDemand.isNotEmpty) return 'In demand now: ${inDemand.join(', ')}';
    return 'Add more skills to find jobs that fit you.';
  }

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  _label,
                  style: const TextStyle(fontSize: 13, color: AppColors.onPrimary),
                ),
                Text(
                  _headline,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onPrimary,
                  ),
                ),
                Text(
                  _message,
                  style: const TextStyle(fontSize: 14, color: AppColors.onPrimary),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.whiteColour,
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () => Get.to(() => const AddSkillsScreen()),
                  child: Text(hasSkills ? 'Update skills' : 'Add skills'),
                ),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onPrimary.withValues(alpha: 0.2),
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              size: 32,
              color: AppColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.jobs});

  final JobsController jobs;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (jobs.countWithStatus(JobStatus.saved), 'Saved'),
      (jobs.countWithStatus(JobStatus.applied), 'Applied'),
      (jobs.matchCount, 'Matches'),
    ];

    return Row(
      spacing: 12,
      children: [
        for (final (value, label) in stats)
          Expanded(
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
