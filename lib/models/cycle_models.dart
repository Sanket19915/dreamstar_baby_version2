import 'package:flutter/material.dart';

class MenstrualCycleModel {
  final int? id;
  final int? userId;
  final String startDate;
  final String? endDate;
  final int? cycleLength;
  final String status;
  final String? pregnancyTestResult;

  const MenstrualCycleModel({
    this.id,
    this.userId,
    required this.startDate,
    this.endDate,
    this.cycleLength,
    this.status = 'ongoing',
    this.pregnancyTestResult,
  });

  factory MenstrualCycleModel.fromJson(Map<String, dynamic> json) {
    return MenstrualCycleModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString(),
      cycleLength: json['cycle_length'] as int?,
      status: json['status']?.toString() ?? 'ongoing',
      pregnancyTestResult: json['pregnancy_test_result']?.toString(),
    );
  }
}

class CycleStatusModel {
  final int currentCycleDay;
  final String expectedPeriodDate;
  final int delayDays;
  final String phase;
  final String periodStartDate;
  final String periodEndDate;
  final String ovulationDate;
  final String fertileWindowStart;
  final String fertileWindowEnd;
  final bool hasIrregularPattern;

  const CycleStatusModel({
    required this.currentCycleDay,
    required this.expectedPeriodDate,
    required this.delayDays,
    required this.phase,
    required this.periodStartDate,
    required this.periodEndDate,
    required this.ovulationDate,
    required this.fertileWindowStart,
    required this.fertileWindowEnd,
    required this.hasIrregularPattern,
  });

  factory CycleStatusModel.fromJson(Map<String, dynamic> json) {
    return CycleStatusModel(
      currentCycleDay: json['current_cycle_day'] as int? ?? 1,
      expectedPeriodDate: json['expected_period_date'] as String? ?? '',
      delayDays: json['delay_days'] as int? ?? 0,
      phase: json['phase'] as String? ?? '',
      periodStartDate: json['period_start_date'] as String? ?? '',
      periodEndDate: json['period_end_date'] as String? ?? '',
      ovulationDate: json['ovulation_date'] as String? ?? '',
      fertileWindowStart: json['fertile_window_start'] as String? ?? '',
      fertileWindowEnd: json['fertile_window_end'] as String? ?? '',
      hasIrregularPattern: json['has_irregular_pattern'] as bool? ?? false,
    );
  }

  bool get isDelayed => delayDays > 0;

  bool get isInFertileWindow {
    try {
      final today = DateTime.now();
      final start = DateTime.parse(fertileWindowStart);
      final end = DateTime.parse(fertileWindowEnd);
      return today.isAfter(start.subtract(const Duration(days: 1))) &&
          today.isBefore(end.add(const Duration(days: 1)));
    } catch (_) {
      return false;
    }
  }

  String get phaseDescription {
    switch (phase) {
      case 'Menstrual':
        return 'Your period is currently active. Focus on rest and self-care.';
      case 'Follicular':
        return 'Follicles are maturing. Energy levels are rising!';
      case 'Ovulation':
        return '🌟 Peak fertile window! Best time for conception.';
      case 'Luteal':
        return 'Post-ovulation phase. The body is preparing for the next cycle.';
      default:
        return '';
    }
  }

  /// Returns the color for a given date in the calendar
  Color? getDayColor(DateTime date) {
    if (expectedPeriodDate.isEmpty ||
        ovulationDate.isEmpty ||
        periodStartDate.isEmpty ||
        fertileWindowStart.isEmpty) {
      return null;
    }

    // Strip time from date to compare just the Y-M-D
    final d = DateTime(date.year, date.month, date.day);

    final expected = DateTime.parse(expectedPeriodDate);
    final ovulation = DateTime.parse(ovulationDate);
    final periodStart = DateTime.parse(periodStartDate);
    final periodEnd = DateTime.parse(periodEndDate);
    final fertileStart = DateTime.parse(fertileWindowStart);
    final fertileEnd = DateTime.parse(fertileWindowEnd);

    // 1. Next possible date (Expected Period) - Orange
    if (d.isAtSameMomentAs(expected)) {
      return const Color(0xFFE67700); // Orange
    }

    // 2. Ovulation Date - Green
    if (d.isAtSameMomentAs(ovulation)) {
      return const Color(0xFF2FBF71); // Green
    }

    // 3. Period Days - Red
    if (d.isAtSameMomentAs(periodStart) ||
        d.isAtSameMomentAs(periodEnd) ||
        (d.isAfter(periodStart) && d.isBefore(periodEnd))) {
      return const Color(0xFFE53935); // Red
    }

    // 4. Fertile Window - Blue
    if (d.isAtSameMomentAs(fertileStart) ||
        d.isAtSameMomentAs(fertileEnd) ||
        (d.isAfter(fertileStart) && d.isBefore(fertileEnd))) {
      return const Color(0xFF42A5F5); // Blue
    }

    // 5. Luteal Phase - Baby Pink (Between Ovulation and Expected Period)
    if (d.isAfter(ovulation) && d.isBefore(expected)) {
      return const Color(0xFFF48FB1); // Baby Pink
    }

    return null;
  }
}

class CycleHistoryModel {
  final bool hasIrregularPattern;
  final List<String> irregularReasons;
  final int cycleVariationDays;
  final List<MenstrualCycleModel> cycles;

  const CycleHistoryModel({
    required this.hasIrregularPattern,
    this.irregularReasons = const [],
    this.cycleVariationDays = 0,
    required this.cycles,
  });

  factory CycleHistoryModel.fromJson(Map<String, dynamic> json) {
    final cyclesList = (json['cycles'] as List<dynamic>? ?? [])
        .map((e) => MenstrualCycleModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final reasonsList = (json['irregular_reasons'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    return CycleHistoryModel(
      hasIrregularPattern: json['has_irregular_pattern'] as bool? ?? false,
      irregularReasons: reasonsList,
      cycleVariationDays: (json['cycle_variation_days'] as num?)?.toInt() ?? 0,
      cycles: cyclesList,
    );
  }
}
