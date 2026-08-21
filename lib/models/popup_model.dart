// Models for the daily popup engagement feature

class PopupQuestion {
  final int id;
  final String type; // 'mcq' | 'note'
  final String questionText;
  final List<String>? options;
  final int dayNumber;

  PopupQuestion({
    required this.id,
    required this.type,
    required this.questionText,
    this.options,
    required this.dayNumber,
  });

  factory PopupQuestion.fromJson(Map<String, dynamic> json) {
    return PopupQuestion(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'mcq',
      questionText: json['question_text'] ?? '',
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      dayNumber: json['day_number'] ?? 1,
    );
  }

  bool get isMcq => type == 'mcq';
  bool get isNote => type == 'note';
}

class StreakData {
  final int currentStreak;
  final int longestStreak;
  final List<BadgeData> badgesEarned;
  final String? lastRespondedAt;

  StreakData({
    required this.currentStreak,
    required this.longestStreak,
    required this.badgesEarned,
    this.lastRespondedAt,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['current_streak'] ?? 0,
      longestStreak: json['longest_streak'] ?? 0,
      badgesEarned: (json['badges_earned'] as List<dynamic>? ?? [])
          .map((b) => BadgeData.fromJson(b as Map<String, dynamic>))
          .toList(),
      lastRespondedAt: json['last_responded_at'],
    );
  }
}

class BadgeData {
  final String key;
  final String name;
  final String emoji;
  final int days;

  BadgeData({
    required this.key,
    required this.name,
    required this.emoji,
    required this.days,
  });

  factory BadgeData.fromJson(Map<String, dynamic> json) {
    return BadgeData(
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      emoji: json['emoji'] ?? '🏅',
      days: json['days'] ?? 0,
    );
  }
}

class PopupRespondResult {
  final bool success;
  final int currentStreak;
  final int longestStreak;
  final List<Map<String, dynamic>> newBadges;
  final String message;

  PopupRespondResult({
    required this.success,
    required this.currentStreak,
    required this.longestStreak,
    required this.newBadges,
    required this.message,
  });

  factory PopupRespondResult.fromJson(Map<String, dynamic> json) {
    return PopupRespondResult(
      success: json['success'] ?? false,
      currentStreak: json['current_streak'] ?? 0,
      longestStreak: json['longest_streak'] ?? 0,
      newBadges: List<Map<String, dynamic>>.from(json['new_badges'] ?? []),
      message: json['message'] ?? '',
    );
  }
}
