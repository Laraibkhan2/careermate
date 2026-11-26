import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/main_controller.dart';
import '../../../utils/app_colors.dart';
import '../home/home_screen.dart';
import '../jobs/jobs_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../saved/saved_jobs_screen.dart';

/// Holds the five main tabs and the floating bottom navigation bar.
/// Switching tabs fades the new page in.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> _pages = [
    HomeScreen(),
    JobsScreen(),
    SavedJobsScreen(),
    NotificationsScreen(),
    ProfileScreen(),
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
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.work_outline_rounded),
                      selectedIcon: Icon(Icons.work_rounded),
                      label: 'Jobs',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.bookmark_border_rounded),
                      selectedIcon: Icon(Icons.bookmark_rounded),
                      label: 'Saved',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.notifications_none_rounded),
                      selectedIcon: Icon(Icons.notifications_rounded),
                      label: 'Alerts',
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
