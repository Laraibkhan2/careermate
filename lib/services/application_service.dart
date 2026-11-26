import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/application_model.dart';
import '../model/job_model.dart';
import 'auth_service.dart';

/// Reads and writes the `applications` collection in Cloud Firestore.
class ApplicationService {
  ApplicationService._();

  static final _apps = FirebaseFirestore.instance.collection('applications');

  // ---- Job seeker ----

  /// The document id is jobId_seekerId, so one person can apply to one job
  /// only once (a second try is refused by the security rules).
  static Future<void> apply({
    required JobModel job,
    required String name,
    required String email,
    required List<String> skills,
  }) {
    final uid = AuthService.currentUser!.uid;
    return _apps.doc('${job.id}_$uid').set({
      'jobId': job.id,
      'jobTitle': job.title,
      'company': job.company,
      'seekerId': uid,
      'seekerName': name,
      'seekerEmail': email,
      'seekerSkills': skills,
      'employerId': job.postedBy,
      'status': ApplicationStatus.applied.name,
      'appliedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Applications sent by the signed-in job seeker.
  static Future<List<ApplicationModel>> fetchMine() async {
    final uid = AuthService.currentUser!.uid;
    final snapshot = await _apps.where('seekerId', isEqualTo: uid).get();
    return _newestFirst(snapshot.docs);
  }

  // ---- Employer ----

  /// Applications received for the signed-in employer's jobs.
  static Future<List<ApplicationModel>> fetchForEmployer() async {
    final uid = AuthService.currentUser!.uid;
    final snapshot = await _apps.where('employerId', isEqualTo: uid).get();
    return _newestFirst(snapshot.docs);
  }

  static Future<void> setStatus(String id, ApplicationStatus status) {
    return _apps.doc(id).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ---- Shared ----

  static List<ApplicationModel> _newestFirst(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final list = docs.map(ApplicationModel.fromFirestore).toList();
    list.sort((a, b) {
      final x = a.appliedAt?.millisecondsSinceEpoch ?? 0;
      final y = b.appliedAt?.millisecondsSinceEpoch ?? 0;
      return y.compareTo(x);
    });
    return list;
  }
}
