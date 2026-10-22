import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_baby/shared/helper/app_color.dart';

class DarpanReportScreen extends StatefulWidget {
  final int cycleNumber;

  /// The full score map returned from the API (the 'score' key inside the response).
  final Map<String, dynamic> scoreData;

  const DarpanReportScreen({
    super.key,
    required this.cycleNumber,
    required this.scoreData,
  });

  @override
  State<DarpanReportScreen> createState() => _DarpanReportScreenState();
}

class _DarpanReportScreenState extends State<DarpanReportScreen>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _anim;

  // Which quadrant cards are expanded
  final Map<String, bool> _expanded = {
    'Sharir': false,
    'Mann': false,
    'Bhav': false,
    'Atma': false,
  };

  static const Map<String, Map<String, dynamic>> _quadrantConfig = {
    'Sharir': {
      'label': 'Sharir Shuddhi',
      'subtitle': 'Body Purification',
      'icon': Icons.self_improvement,
      'color': Color(0xFF6C63FF),
    },
    'Mann': {
      'label': 'Mann Shuddhi',
      'subtitle': 'Mind Purification',
      'icon': Icons.psychology,
      'color': Color(0xFF43A6C6),
    },
    'Bhav': {
      'label': 'Bhav Shuddhi',
      'subtitle': 'Emotion Purification',
      'icon': Icons.favorite,
      'color': Color(0xFFE8567C),
    },
    'Atma': {
      'label': 'Atma Shuddhi',
      'subtitle': 'Soul Purification',
      'icon': Icons.brightness_high,
      'color': Color(0xFFF6A623),
    },
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _anim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passiveScore = _scoreValue('passive_score_display', 'passive_score');
    final hasActiveScore = _hasScore('active_score_display', 'active_score');
    final isTestActiveScore =
        widget.scoreData['is_test_active_score'] == true ||
            (widget.cycleNumber == 1 && !hasActiveScore);
    final activeScore = hasActiveScore
        ? _scoreValue('active_score_display', 'active_score')
        : (isTestActiveScore ? 50.0 : 0.0);
    final finalScore = _hasScore('final_score_display', 'final_score')
        ? _scoreValue('final_score_display', 'final_score')
        : (passiveScore + activeScore) / 2;
    final activeScoreNote = widget.scoreData['active_score_note'] as String? ??
        (isTestActiveScore
            ? 'Active Score is a fixed 50/100 test value for Cycle 1.'
            : null);
    final overallThreshold =
        (widget.scoreData['overall_threshold'] as num?)?.toDouble() ?? 60.0;
    final isAboveOverall = widget.scoreData['is_above_threshold'] as bool? ??
        finalScore >= overallThreshold;
    final quadrants =
        Map<String, dynamic>.from(widget.scoreData['quadrants'] ?? {});

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.blackColor),
        title: Text(
          'Shuddhi Report \u00b7 Cycle ${widget.cycleNumber}',
          style: GoogleFonts.poppins(
            color: AppColors.blackColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallBanner(
              finalScore,
              passiveScore,
              activeScore,
              overallThreshold,
              isAboveOverall,
              isTestActiveScore,
              activeScoreNote,
            ),
            const SizedBox(height: 24),
            Text(
              'Quadrant Report',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap any quadrant to see practice-level insights',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 14),
            ...quadrants.entries.map((e) => _buildQuadrantCard(e.key, e.value)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Overall Score Banner
  // ────────────────────────────────────────────────────────────────────────────
  double _scoreValue(String displayKey, String rawKey) {
    final value = widget.scoreData[displayKey] ?? widget.scoreData[rawKey] ?? 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  bool _hasScore(String displayKey, String rawKey) =>
      widget.scoreData.containsKey(displayKey) ||
      widget.scoreData.containsKey(rawKey);

  Widget _buildOverallBanner(
    double score,
    double passiveScore,
    double activeScore,
    double threshold,
    bool isAbove,
    bool isTestActiveScore,
    String? activeScoreNote,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF4FACFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Final Darpan Score',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) {
              final displayed = score * _anim.value;
              return Text(
                displayed.toStringAsFixed(2),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 58,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              );
            },
          ),
          Text(
            '/ 100',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (score / 100) * _anim.value,
                minHeight: 10,
                backgroundColor: Colors.white.withOpacity(0.25),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _thresholdBadge(
            isAbove: isAbove,
            label: isAbove
                ? 'ABOVE THRESHOLD (${threshold.toInt()})'
                : 'BELOW THRESHOLD (${threshold.toInt()})',
            light: true,
          ),
          const SizedBox(height: 14),
          _scoreRow('Passive Score', passiveScore),
          const SizedBox(height: 8),
          _scoreRow('Active Score', activeScore, isTest: isTestActiveScore),
          if (activeScoreNote != null) ...[
            const SizedBox(height: 10),
            Text(
              activeScoreNote,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.85),
                fontSize: 11,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Cycle ${widget.cycleNumber} of 5',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.65),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreRow(String label, double score, {bool isTest = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isTest ? '$label (Test)' : label,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13,
          ),
        ),
        Text(
          '${score.toStringAsFixed(2)} / 100',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Quadrant Card with expandable practices
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildQuadrantCard(String key, dynamic data) {
    final config = _quadrantConfig[key] ??
        {
          'label': key,
          'subtitle': '',
          'icon': Icons.circle,
          'color': AppColors.mainColor,
        };
    final color = config['color'] as Color;
    final hasActiveWeightage = data.containsKey('active_weightage');
    final isTestActiveScore =
        widget.scoreData['is_test_active_score'] == true ||
            (widget.cycleNumber == 1 && !hasActiveWeightage);
    final passiveWeightage = _asDouble(
      data['passive_weightage'] ?? data['weightage_out_25'],
    );
    final activeWeightage = hasActiveWeightage
        ? _asDouble(data['active_weightage'])
        : (isTestActiveScore ? 12.5 : 0.0);
    final weightage = _asDouble(
      data['final_weightage'] ??
          (hasActiveWeightage
              ? data['weightage_out_25']
              : (passiveWeightage + activeWeightage) / 2),
    );
    final threshold = (data['threshold'] as num?)?.toDouble() ?? 15.0;
    final isAbove = data['is_above_threshold'] as bool? ?? false;
    final practiceReport =
        Map<String, dynamic>.from(data['practice_report'] ?? {});
    final isExpanded = _expanded[key] ?? false;

    return GestureDetector(
      onTap: () => setState(() => _expanded[key] = !isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Header Row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(config['icon'] as IconData,
                        color: color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          config['label'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.blackColor,
                          ),
                        ),
                        Text(
                          config['subtitle'] as String,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${weightage.toStringAsFixed(2)} / 25',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _thresholdBadge(isAbove: isAbove),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
            // ── Quadrant Progress Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (weightage / 25) * _anim.value,
                    minHeight: 7,
                    backgroundColor: color.withOpacity(0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildQuadrantScoreBreakdown(
                passiveWeightage,
                activeWeightage,
                weightage,
                isTestActiveScore,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0',
                      style: GoogleFonts.poppins(
                          fontSize: 10, color: Colors.grey)),
                  Text('Threshold: $threshold',
                      style: GoogleFonts.poppins(
                          fontSize: 10, color: Colors.grey)),
                  Text('25',
                      style: GoogleFonts.poppins(
                          fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
            // ── Expanded: Practice Rows ──
            if (isExpanded) ...[
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: practiceReport.entries
                      .map((p) => _buildPracticeRow(p.key, p.value, color))
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  Widget _buildQuadrantScoreBreakdown(
    double passive,
    double active,
    double finalScore,
    bool isTestActiveScore,
  ) {
    return Row(
      children: [
        Expanded(child: _buildQuadrantScore('Passive', passive)),
        const SizedBox(width: 8),
        Expanded(
          child: _buildQuadrantScore(
            isTestActiveScore ? 'Active (Test)' : 'Active',
            active,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: _buildQuadrantScore('Final', finalScore)),
      ],
    );
  }

  Widget _buildQuadrantScore(String label, double score) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Text(
            '${score.toStringAsFixed(2)} / 25',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Single practice row inside expanded quadrant
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildPracticeRow(String name, dynamic data, Color quadrantColor) {
    final score = (data['score'] as num).toDouble();
    final threshold = (data['threshold'] as num).toDouble();
    final isAbove = data['is_above_threshold'] as bool? ?? false;
    final comment = data['comment'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isAbove ? const Color(0xFFF0FBF4) : const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isAbove
              ? const Color(0xFF34C77B).withOpacity(0.3)
              : const Color(0xFFFF6B6B).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Practice name + score + badge
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              Text(
                '${score.toStringAsFixed(1)} / 21',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: quadrantColor,
                ),
              ),
              const SizedBox(width: 8),
              _thresholdBadge(isAbove: isAbove, small: true),
            ],
          ),
          const SizedBox(height: 8),
          // Score progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: score / 21,
              minHeight: 6,
              backgroundColor: quadrantColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                isAbove ? const Color(0xFF34C77B) : const Color(0xFFFF6B6B),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Threshold: ${threshold.toInt()} / 21',
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          // Comment
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isAbove ? Icons.check_circle_outline : Icons.info_outline,
                size: 15,
                color:
                    isAbove ? const Color(0xFF34C77B) : const Color(0xFFFF6B6B),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  comment,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF555555),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Reusable threshold badge widget
  // ────────────────────────────────────────────────────────────────────────────
  Widget _thresholdBadge({
    required bool isAbove,
    String? label,
    bool light = false,
    bool small = false,
  }) {
    final text = label ??
        (isAbove
            ? (small ? '\u2713 Good' : '\u2713 Good')
            : (small ? '\u26a0 Low' : '\u26a0 Needs Attention'));
    final bgColor = isAbove
        ? (light ? Colors.white.withOpacity(0.25) : const Color(0xFFE8F8F0))
        : (light ? Colors.white.withOpacity(0.15) : const Color(0xFFFFEBEB));
    final textColor = isAbove
        ? (light ? Colors.white : const Color(0xFF27AE60))
        : (light ? Colors.white : const Color(0xFFE74C3C));

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
