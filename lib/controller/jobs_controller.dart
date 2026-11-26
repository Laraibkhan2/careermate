import 'package:get/get.dart';

import '../model/job_model.dart';
import '../model/user_role.dart';
import '../services/application_service.dart';
import '../services/auth_service.dart';
import '../services/job_service.dart';
import '../services/jsearch_service.dart';
import '../view/screens/jobs/job_web_view_screen.dart';
import 'user_controller.dart';

/// All jobs, the match score of each one and the user's job tracker.
class JobsController extends GetxController {
  final jobs = <JobModel>[];
  final statuses = <String, JobStatus>{};
  bool isLoading = true;

  // Online jobs from JSearch. Fetched once per sign-in because the free plan
  // only allows 200 requests a month.
  final _online = <JobModel>[];
  bool _onlineLoaded = false;

  @override
  void onInit() {
    super.onInit();
    loadJobs();
  }

  /// Reads the jobs from Firestore. Pass [showLoading] false to keep the
  /// current list on screen while refreshing (pull-to-refresh).
  Future<void> loadJobs({bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
      update();
    }
    try {
      final fetched = await JobService.fetchJobs();
      await _loadOnlineJobs();
      jobs
        ..clear()
        ..addAll(fetched)
        ..addAll(_online);
      await loadApplications();
    } catch (e) {
      Get.snackbar('Could not load jobs', '$e');
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Jobs from JSearch, only for a signed-in job seeker and only once.
  Future<void> _loadOnlineJobs() async {
    if (_onlineLoaded || AuthService.currentUser == null) return;
    if (!Get.isRegistered<UserController>()) return;
    final user = Get.find<UserController>();
    if (user.role != UserRole.seeker) return;

    try {
      final skill = user.skills.isEmpty ? 'software' : user.skills.first;
      _online
        ..clear()
        ..addAll(await JSearchService.search('$skill jobs in Karachi'));
      _onlineLoaded = true;
    } catch (e) {
      Get.snackbar('Online jobs not loaded', '$e');
    }
  }

  // ---- Matching ----

  Set<String> get _mySkills =>
      Get.find<UserController>().skills.map((s) => s.toLowerCase()).toSet();

  List<String> matchedSkills(JobModel job) =>
      job.requiredSkills.where((s) => _mySkills.contains(s.toLowerCase())).toList();

  List<String> missingSkills(JobModel job) =>
      job.requiredSkills.where((s) => !_mySkills.contains(s.toLowerCase())).toList();

  /// Matched skills divided by required skills, as a whole percent.
  int matchPercent(JobModel job) {
    if (job.requiredSkills.isEmpty) return 0;
    return (matchedSkills(job).length * 100 / job.requiredSkills.length).round();
  }

  int _byMatch(JobModel a, JobModel b) {
    final diff = matchPercent(b).compareTo(matchPercent(a));
    return diff != 0 ? diff : a.title.compareTo(b.title);
  }

  List<JobModel> get rankedJobs => [...jobs]..sort(_byMatch);

  /// The job that fits the user best. null when no job matches at all
  /// (0%), because a job with no matching skill is not a "best match".
  JobModel? get bestMatch {
    final ranked = rankedJobs;
    if (ranked.isEmpty || matchPercent(ranked.first) == 0) return null;
    return ranked.first;
  }

  int get matchCount => jobs.where((j) => matchPercent(j) >= 70).length;

  /// Skills that the posted jobs ask for most and the user does not have
  /// yet (at most 4). Used to suggest what to learn.
  List<String> get inDemandSkills {
    final mine = _mySkills;
    final counts = <String, int>{};
    final names = <String, String>{}; // lowercase -> original spelling

    for (final job in jobs) {
      for (final skill in job.requiredSkills) {
        final key = skill.toLowerCase();
        if (mine.contains(key)) continue;
        counts[key] = (counts[key] ?? 0) + 1;
        names.putIfAbsent(key, () => skill);
      }
    }

    final keys = counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
    return [for (final key in keys.take(4)) names[key]!];
  }

  // ---- Tracker ----

  JobStatus? statusOf(JobModel job) => statuses[job.id];

  bool isSaved(JobModel job) => statuses.containsKey(job.id);

  /// Saves a new job, or un-saves it if it is only "saved" so far.
  void toggleSave(JobModel job) {
    final status = statuses[job.id];
    if (status == null) {
      statuses[job.id] = JobStatus.saved;
    } else if (status == JobStatus.saved) {
      statuses.remove(job.id);
    }
    update();
  }

  /// Reads the user's applications from Firestore. Their status (set by
  /// the employer) replaces the local one; locally saved jobs are kept.
  Future<void> loadApplications() async {
    if (AuthService.currentUser == null) return;
    try {
      final mine = await ApplicationService.fetchMine();
      statuses.removeWhere((_, status) => status != JobStatus.saved);
      for (final app in mine) {
        statuses[app.jobId] = app.status.jobStatus;
      }
    } catch (e) {
      Get.snackbar('Could not load your applications', '$e');
    }
  }

  /// Sends a real application to the employer.
  Future<void> apply(JobModel job) async {
    // Online jobs are applied for on the job's own website, shown inside the
    // app in a WebView.
    if (job.isExternal) {
      await JobWebViewScreen.open(job);
      return;
    }

    final current = statuses[job.id];
    if (current != null && current != JobStatus.saved) return; // already applied
    if (job.postedBy.isEmpty) {
      Get.snackbar('Cannot apply', 'This job does not accept applications.');
      return;
    }

    final user = Get.find<UserController>();
    try {
      await ApplicationService.apply(
        job: job,
        name: user.name,
        email: user.email,
        skills: List<String>.of(user.skills),
      );
      statuses[job.id] = JobStatus.applied;
      update();
      Get.snackbar('Application sent', 'You applied for ${job.title}.');
    } catch (e) {
      Get.snackbar('Could not apply', '$e');
    }
  }

  void removeTracking(JobModel job) {
    statuses.remove(job.id);
    update();
  }

  void clearTracking() {
    statuses.clear();
    _online.clear();
    _onlineLoaded = false;
    update();
  }

  List<JobModel> jobsWithStatus(JobStatus status) =>
      rankedJobs.where((j) => statuses[j.id] == status).toList();

  int countWithStatus(JobStatus status) => jobsWithStatus(status).length;
}
