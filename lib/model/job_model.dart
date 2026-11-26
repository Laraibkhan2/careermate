import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/time_ago.dart';

/// Where a job is in the user's own tracker.
enum JobStatus {
  saved('Saved', 'Apply now'),
  applied('Applied', 'Mark as interview'),
  interviewing('Interview', 'Archive'),
  archived('Archived', 'Restore');

  const JobStatus(this.label, this.actionLabel);

  final String label;

  /// Text of the button that moves a job to the [next] stage.
  final String actionLabel;

  JobStatus get next => switch (this) {
    JobStatus.saved => JobStatus.applied,
    JobStatus.applied => JobStatus.interviewing,
    JobStatus.interviewing => JobStatus.archived,
    JobStatus.archived => JobStatus.saved,
  };
}

class JobModel {
  const JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.postedAgo,
    required this.description,
    required this.requiredSkills,
    this.isRemote = false,
    this.postedBy = '',
    this.applyUrl = '',
  });

  final String id;
  final String title;
  final String company;
  final String location;
  final String type;
  final String postedAgo;
  final String description;
  final List<String> requiredSkills;
  final bool isRemote;

  /// uid of the employer who posted the job.
  final String postedBy;

  /// Link to apply on the job's own website (jobs that come from JSearch).
  final String applyUrl;

  /// True for online jobs from JSearch: they are applied for on the website,
  /// not inside CareerMate.
  bool get isExternal => applyUrl.isNotEmpty;

  String get place => isRemote ? 'Remote' : location;

  /// Builds a job from a document of the `jobs` collection.
  factory JobModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final postedAt = (data['postedAt'] as Timestamp?)?.toDate();

    return JobModel(
      id: doc.id,
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      location: data['location'] ?? '',
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      requiredSkills: List<String>.from(data['requiredSkills'] ?? const []),
      isRemote: data['isRemote'] ?? false,
      postedBy: data['postedBy'] ?? '',
      postedAgo: timeAgo(postedAt),
    );
  }
}
