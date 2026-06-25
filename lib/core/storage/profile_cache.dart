import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

/// Local cache for user profile including LMP / EDD fields.
class ProfileCache {
  ProfileCache._();

  static const _boxName = 'profileBox';
  static const _profileKey = 'user_profile';

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<String>(_boxName);
    }
  }

  static Future<void> save(Map<String, dynamic> profile) async {
    await init();
    await Hive.box<String>(_boxName).put(_profileKey, jsonEncode(profile));
  }

  static Map<String, dynamic>? read() {
    if (!Hive.isBoxOpen(_boxName)) return null;
    final raw = Hive.box<String>(_boxName).get(_profileKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  static String? get lmp => read()?['lmp']?.toString();

  static String? get eed => read()?['eed']?.toString();

  /// Days elapsed since LMP (or from `eed` minus 280 days when only EDD is stored).
  static int? pregnancyDayCount() {
    final profile = read();
    if (profile == null) return null;

    DateTime? lmpDate;
    final lmpStr = profile['lmp']?.toString();
    if (lmpStr != null && lmpStr.isNotEmpty && lmpStr != 'null') {
      lmpDate = DateTime.tryParse(lmpStr.split(' ').first);
    }

    if (lmpDate == null) {
      final eedStr = profile['eed']?.toString();
      if (eedStr != null && eedStr.isNotEmpty && eedStr != 'null') {
        final eed = DateTime.tryParse(eedStr.split(' ').first);
        if (eed != null) {
          lmpDate = eed.subtract(const Duration(days: 280));
        }
      }
    }

    if (lmpDate == null) return null;
    return DateTime.now().difference(lmpDate).inDays.clamp(0, 281);
  }

  static Future<void> clear() async {
    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box<String>(_boxName).delete(_profileKey);
    }
  }
}
