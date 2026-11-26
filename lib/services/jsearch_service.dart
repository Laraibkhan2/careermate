import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/job_model.dart';
import '../model/skills.dart';
import '../utils/time_ago.dart';

/// Real job postings from JSearch (LinkedIn, Indeed, Glassdoor ... through
/// Google for Jobs). These jobs have no employer inside CareerMate, so the
/// user applies on the job's own website ([JobModel.applyUrl]).
class JSearchService {
  JSearchService._();

  /// The key is NOT stored in the code. Run the app with:
  ///   flutter run --dart-define=JSEARCH_KEY=your_key
  static const _apiKey = String.fromEnvironment('JSEARCH_KEY');

  /// [query] should hold a job title and a place, e.g. "flutter jobs in Karachi".
  static Future<List<JobModel>> search(
    String query, {
    String country = 'pk',
  }) async {
    if (_apiKey.isEmpty) {
      throw 'JSearch key missing. Run with --dart-define=JSEARCH_KEY=...';
    }

    final uri = Uri.https('api.openwebninja.com', '/jsearch/search-v2', {
      'query': query,
      'country': country,
      'date_posted': 'month',
      'num_pages': '1',
    });

    final response = await http
        .get(uri, headers: {'x-api-key': _apiKey})
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw 'JSearch error ${response.statusCode}';
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return _itemsOf(body)
        .whereType<Map<String, dynamic>>()
        .map(_toJob)
        .whereType<JobModel>()
        .toList();
  }

  /// The list of jobs is in `data`. Some responses put it straight in `data`,
  /// others inside an object in `data`, so both are handled.
  static List<dynamic> _itemsOf(Map<String, dynamic> body) {
    final data = body['data'];
    if (data is List) return data;
    if (data is Map) {
      for (final value in data.values) {
        if (value is List) return value;
      }
    }
    return const [];
  }

  static String _text(dynamic value, [String fallback = '']) =>
      value is String && value.trim().isNotEmpty ? value.trim() : fallback;

  /// null when the posting has no id or title (it cannot be shown).
  static JobModel? _toJob(Map<String, dynamic> j) {
    final id = _text(j['job_id']);
    final title = _text(j['job_title']);
    if (id.isEmpty || title.isEmpty) return null;

    final description = _text(j['job_description']);
    final listed = j['job_required_skills'] is List
        ? List<String>.from((j['job_required_skills'] as List).whereType<String>())
        : <String>[];
    final postedAt = DateTime.tryParse(_text(j['job_posted_at_datetime_utc']));
    final place = [
      j['job_city'],
      j['job_country'],
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');

    return JobModel(
      id: 'js_$id',
      title: title,
      company: _text(j['employer_name'], 'Company'),
      location: _text(j['job_location'], place),
      type: _text(j['job_employment_type']),
      description: description,
      requiredSkills: listed.isNotEmpty ? listed : _skillsIn('$title $description'),
      isRemote: j['job_is_remote'] == true,
      postedAgo: _text(j['job_posted_at'], postedAt != null ? timeAgo(postedAt) : ''),
      applyUrl: _text(j['job_apply_link']),
    );
  }

  /// Postings rarely list their skills in a field, so look for the names from
  /// the app's own skills list inside the title and description.
  static List<String> _skillsIn(String text) {
    final lower = text.toLowerCase();
    return allSkills.where((skill) {
      final pattern = RegExp(
        r'(^|[^a-z0-9])' + RegExp.escape(skill.toLowerCase()) + r'($|[^a-z0-9])',
      );
      return pattern.hasMatch(lower);
    }).toList();
  }
}
