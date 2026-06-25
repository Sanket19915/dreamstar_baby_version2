import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

/// Persists quotient completion, MCQ answers, and media watch progress locally.
class ActivityProgressCache {
  ActivityProgressCache._();

  static const _boxName = 'activityBox';
  static const _quotientKey = 'quotient_statuses';
  static const _mediaKey = 'media_progress';
  static const _answersKey = 'mcq_answers';
  static const _reflectionKey = 'reflection_viewed';

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<String>(_boxName);
    }
  }

  static Future<void> saveQuotientStatuses(Map<String, bool> statuses) async {
    await init();
    await Hive.box<String>(_boxName).put(
      _quotientKey,
      jsonEncode(statuses),
    );
  }

  static Map<String, bool> readQuotientStatuses() {
    if (!Hive.isBoxOpen(_boxName)) return {};
    final raw = Hive.box<String>(_boxName).get(_quotientKey);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v == true));
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveMcqAnswer(int questionId, String answer) async {
    await init();
    final answers = readMcqAnswers();
    answers['$questionId'] = answer;
    await Hive.box<String>(_boxName).put(_answersKey, jsonEncode(answers));
  }

  static Map<String, String> readMcqAnswers() {
    if (!Hive.isBoxOpen(_boxName)) return {};
    final raw = Hive.box<String>(_boxName).get(_answersKey);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  /// [percent] is 0–100.
  static Future<void> saveMediaProgress(int questionId, double percent) async {
    await init();
    final progress = readMediaProgress();
    progress['$questionId'] = percent.clamp(0, 100);
    await Hive.box<String>(_boxName).put(_mediaKey, jsonEncode(progress));
  }

  static Map<String, double> readMediaProgress() {
    if (!Hive.isBoxOpen(_boxName)) return {};
    final raw = Hive.box<String>(_boxName).get(_mediaKey);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      );
    } catch (_) {
      return {};
    }
  }

  static double mediaProgressFor(int questionId) {
    return readMediaProgress()['$questionId'] ?? 0;
  }

  static Future<void> markReflectionViewed(int questionId) async {
    await init();
    final viewed = readReflectionViewed();
    viewed.add('$questionId');
    await Hive.box<String>(_boxName).put(_reflectionKey, jsonEncode(viewed.toList()));
  }

  static Set<String> readReflectionViewed() {
    if (!Hive.isBoxOpen(_boxName)) return {};
    final raw = Hive.box<String>(_boxName).get(_reflectionKey);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => e.toString()).toSet();
    } catch (_) {
      return {};
    }
  }

  static bool isReflectionViewed(int questionId) {
    return readReflectionViewed().contains('$questionId');
  }
}
