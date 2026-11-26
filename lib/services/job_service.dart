import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/job_model.dart';
import 'auth_service.dart';

/// Reads and writes the `jobs` collection in Cloud Firestore.
class JobService {
  JobService._();

  static final _jobs = FirebaseFirestore.instance.collection('jobs');

  // ---- Job seeker ----

  /// Every posted job, newest first.
  static Future<List<JobModel>> fetchJobs() async {
    final snapshot = await _jobs.get();
    debugPrint('JobService: ${snapshot.docs.length} jobs in Firestore');
    return _newestFirst(snapshot.docs);
  }

  // ---- Employer ----

  static Future<void> postJob({
    required String title,
    required String company,
    required String location,
    required String type,
    required String description,
    required bool isRemote,
    required List<String> requiredSkills,
  }) {
    return _jobs.add({
      'title': title,
      'company': company,
      'location': location,
      'type': type,
      'description': description,
      'isRemote': isRemote,
      'requiredSkills': requiredSkills,
      'postedBy': AuthService.currentUser!.uid,
      'postedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Jobs posted by the signed-in employer, newest first.
  static Future<List<JobModel>> fetchMyJobs() async {
    final uid = AuthService.currentUser!.uid;
    final snapshot = await _jobs.where('postedBy', isEqualTo: uid).get();
    return _newestFirst(snapshot.docs);
  }

  static Future<void> deleteJob(String id) => _jobs.doc(id).delete();

  // ---- Shared ----

  /// Sorted here (not in the query) so no Firestore index is needed and a
  /// job without `postedAt` is never left out.
  static List<JobModel> _newestFirst(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    int millis(QueryDocumentSnapshot<Map<String, dynamic>> d) =>
        (d.data()['postedAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;

    final sorted = [...docs]..sort((a, b) => millis(b).compareTo(millis(a)));
    final jobs = <JobModel>[];
    for (final doc in sorted) {
      try {
        jobs.add(JobModel.fromFirestore(doc));
      } catch (e) {
        debugPrint('JobService: skipped job ${doc.id}: $e');
      }
    }
    return jobs;
  }
}
