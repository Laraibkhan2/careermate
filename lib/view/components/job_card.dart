import 'package:flutter/material.dart';

import '../../model/job_model.dart';
import '../../utils/app_colors.dart';
import '../screens/jobs/job_detail_screen.dart';
import 'app_card.dart';
import 'company_logo.dart';
import 'tag_chip.dart';

/// One job in a list. Tapping it opens the job details.
/// [footer] adds extra content at the bottom (used by the tracker).
class JobCard extends StatelessWidget {
  const JobCard({
    super.key,
    required this.job,
    required this.matchPercent,
    this.footer,
  });

  final JobModel job;
  final int matchPercent;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final isStrong = matchPercent >= 85;

    return AppCard(
      onTap: () => JobDetailScreen.open(job),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          Row(
            spacing: 12,
            children: [
              CompanyLogo(company: job.company, heroTag: 'logo-${job.id}'),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      job.company,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: '$matchPercent% match',
                excludeSemantics: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isStrong ? AppColors.successLight : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$matchPercent%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isStrong ? AppColors.onSuccessLight : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            spacing: 6,
            children: [
              const Icon(Icons.place_outlined, size: 16, color: AppColors.textSecondary),
              Expanded(
                child: Text(
                  job.place,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
              TagChip(label: job.type, background: AppColors.border),
            ],
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}
