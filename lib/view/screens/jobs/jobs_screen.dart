import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/job_search_controller.dart';
import '../../../controller/jobs_controller.dart';
import '../../components/app_page.dart';
import '../../components/dialogs/custom_text_field.dart';
import '../../components/empty_state.dart';
import '../../components/job_card.dart';
import '../../components/loading_view.dart';
import '../../components/screen_header.dart';
import '../../components/skill_chip.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobSearchController>(
      init: JobSearchController(),
      builder: (search) => GetBuilder<JobsController>(
        builder: (jobs) {
          final results = search.results;

          return AppPage(
            onRefresh: () => jobs.loadJobs(showLoading: false),
            children: [
              ScreenHeader(
                title: 'Jobs for you',
                subtitle: '${results.length} jobs found',
              ),
              CustomTextField(
                label: 'Search jobs',
                hint: 'Role, company or skill',
                controller: search.search,
                icon: Icons.search_rounded,
                textInputAction: TextInputAction.search,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8,
                  children: [
                    for (final filter in JobFilter.values)
                      SkillChip(
                        label: filter.label,
                        isSelected: search.filter == filter,
                        onTap: () => search.setFilter(filter),
                      ),
                  ],
                ),
              ),
              if (jobs.isLoading)
                const LoadingView()
              else if (results.isEmpty)
                EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No jobs found',
                  message: jobs.jobs.isEmpty
                      ? 'No jobs have been posted yet. Pull down to refresh.'
                      : 'Try a different search or filter.',
                )
              else
                for (final job in results)
                  JobCard(job: job, matchPercent: jobs.matchPercent(job)),
            ],
          );
        },
      ),
    );
  }
}