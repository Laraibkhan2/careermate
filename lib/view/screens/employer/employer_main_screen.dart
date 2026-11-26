import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/main_controller.dart';
import '../../../utils/app_colors.dart';
import 'applicants_screen.dart';
import 'employer_profile_screen.dart';
import 'my_jobs_screen.dart';
import 'post_job_screen.dart';

/// Employer's version of MainScreen: My Jobs, Post Job and Profile tabs.
class EmployerMainScreen extends StatelessWidget {
  const EmployerMainScreen({super.key});

  static const List<Widget> _pages = [
    MyJobsScreen(),
    PostJobScreen(),
    ApplicantsScreen(),
    EmployerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (c) => Scaffold(
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(
            key: ValueKey(c.index),
            child: _pages[c.index],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.whiteColour,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [AppColors.cardShadow],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: NavigationBar(
                  height: 68,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  selectedIndex: c.index,
                  onDestinationSelected: c.setIndex,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.work_outline_rounded),
                      selectedIcon: Icon(Icons.work_rounded),
                      label: 'My Jobs',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.add_circle_outline_rounded),
                      selectedIcon: Icon(Icons.add_circle_rounded),
                      label: 'Post Job',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.people_outline_rounded),
                      selectedIcon: Icon(Icons.people_rounded),
                      label: 'Applicants',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}