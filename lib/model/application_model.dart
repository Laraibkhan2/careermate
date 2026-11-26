import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/time_ago.dart';
import 'job_model.dart';

/// Where an application stands. The employer changes it; the job seeker
/// sees it in the "My jobs" tracker through [jobStatus].
enum ApplicationStatus {
  applied('Applied', JobStatus.applied),
  interviewing('Interview', JobStatus.interviewing),
  rejected('Rejected', JobStatus.archived);

  const ApplicationStatus(this.label, this.jobStatus);

  final String label;
  final JobStatus jobStatus;

  static ApplicationStatus fromName(Object? name) =>
      values.where((s) => s.name == name).firstOrNull ?? applied;
}

/// One document of the `applications` collection.
class ApplicationModel {
  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.company,
    required this.seekerId,
    required this.seekerName,
    required this.seekerEmail,
    required this.seekerSkills,
    required this.employerId,
    required this.status,
    required this.appliedAt,
  });

  final String id;
  final String jobId;
  final String jobTitle;
  final String company;
  final String seekerId;
  final String seekerName;
  final String seekerEmail;
  final List<String> seekerSkills;
  final String employerId;
  final DateTime? appliedAt;
  ApplicationStatus status;

  String get appliedAgo => timeAgo(appliedAt);

  factory ApplicationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return ApplicationModel(
      id: doc.id,
      jobId: data['jobId'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
      company: data['company'] ?? '',
      seekerId: data['seekerId'] ?? '',
      seekerName: data['seekerName'] ?? '',
      seekerEmail: data['seekerEmail'] ?? '',
      seekerSkills: List<String>.from(data['seekerSkills'] ?? const []),
      employerId: data['employerId'] ?? '',
      status: ApplicationStatus.fromName(data['status']),
      appliedAt: (data['appliedAt'] as Timestamp?)?.toDate(),
    );
  }
}
