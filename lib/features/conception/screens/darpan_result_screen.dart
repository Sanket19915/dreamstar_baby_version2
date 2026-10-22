import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/services/darpan_service.dart';
import 'package:dream_baby/features/conception/screens/darpan_report_screen.dart';

class DarpanResultScreen extends StatefulWidget {
  final int cycleNumber;

  /// If passed directly from submitAssessment response, use this immediately (no extra API call)
  final Map<String, dynamic>? preloadedScore;

  const DarpanResultScreen({
    super.key,
    required this.cycleNumber,
    this.preloadedScore,
  });

  @override
  State<DarpanResultScreen> createState() => _DarpanResultScreenState();
}

class _DarpanResultScreenState extends State<DarpanResultScreen>
    with TickerProviderStateMixin {
  Map<String, dynamic>? _scoreData;
  String? _errorMessage;
  bool _isLoading = true;
  late AnimationController _scoreAnimController;
  late Animation<double> _scoreAnim;

  // Quadrant display config
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
    _scoreAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnim = CurvedAnimation(
      parent: _scoreAnimController,
      curve: Curves.easeOutCubic,
    );

    if (widget.preloadedScore != null) {
      _scoreData = widget.preloadedScore!['score'];
      _isLoading = false;
      _scoreAnimController.forward();
    } else {
      _fetchScore();
    }
  }

  @override
  void dispose() {
    _scoreAnimController.dispose();
    super.dispose();
  }

  Future<void> _fetchScore() async {
    final result = await DarpanService.getScore(widget.cycleNumber);
    if (mounted) {
      setState(() {
        _scoreData = result.data?['score'];
        _errorMessage = result.errorMessage;
        _isLoading = false;
      });
      if (result.isSuccess) {
        _scoreAnimController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.blackColor),
        title: Text(
          'Darpan Results — Cycle ${widget.cycleNumber}',
          style: GoogleFonts.poppins(
            color: AppColors.blackColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.mainColor))
          : _scoreData == null
              ? _buildError()
              : _buildResults(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          _errorMessage ?? 'Could not load your score.\nPlease try again.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildResults() {
    final quadrants = Map<String, dynamic>.from(_scoreData!['quadrants'] ?? {});
    final passiveScore = _scoreValue('passive_score_display', 'passive_score');
    final hasActiveScore = _hasScore('active_score_display', 'active_score');
    final isTestActiveScore = _scoreData!['is_test_active_score'] == true ||
        (widget.cycleNumber == 1 && !hasActiveScore);
    final activeScore = hasActiveScore
        ? _scoreValue('active_score_display', 'active_score')
        : (isTestActiveScore ? 50.0 : 0.0);
    final finalScore = _hasScore('final_score_display', 'final_score')
        ? _scoreValue('final_score_display', 'final_score')
        : (passiveScore + activeScore) / 2;
    final activeScoreNote = _scoreData!['active_score_note'] as String? ??
        (isTestActiveScore
            ? 'Active Score is a fixed 50/100 test value for Cycle 1.'
            : null);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // — Overall Score Card —
          _buildOverallScoreCard(finalScore),
          const SizedBox(height: 20),
          Text(
            'Score Breakdown',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildComponentScoreCard(
                  'Passive Score',
                  passiveScore,
                  const Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildComponentScoreCard(
                  isTestActiveScore ? 'Active Score (Test)' : 'Active Score',
                  activeScore,
                  const Color(0xFF43A6C6),
                ),
              ),
            ],
          ),
          if (activeScoreNote != null) ...[
            const SizedBox(height: 12),
            _buildTestingNote(activeScoreNote),
          ],
          const SizedBox(height: 24),
          Text(
            'Quadrant Breakdown',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 12),
          // — Quadrant Cards —
          ...quadrants.entries
              .map((entry) => _buildQuadrantCard(entry.key, entry.value)),
          const SizedBox(height: 24),
          // — View Full Report Card Button —
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DarpanReportScreen(
                      cycleNumber: widget.cycleNumber,
                      scoreData: _scoreData!,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.description_outlined, size: 18),
              label: Text(
                'View Full Report Card',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: const Color(0xFF6C63FF).withOpacity(0.4),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  double _scoreValue(String displayKey, String rawKey) {
    final value = _scoreData![displayKey] ?? _scoreData![rawKey] ?? 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  bool _hasScore(String displayKey, String rawKey) =>
      _scoreData!.containsKey(displayKey) || _scoreData!.containsKey(rawKey);

  Widget _buildOverallScoreCard(double finalScore) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF4FACFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Final Darpan Score',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _scoreAnim,
            builder: (context, child) {
              final animatedScore = finalScore * _scoreAnim.value;
              return Column(
                children: [
                  Text(
                    animatedScore.toStringAsFixed(2),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  Text(
                    '/ 100',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          // Score bar
          AnimatedBuilder(
            animation: _scoreAnim,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (finalScore / 100) * _scoreAnim.value,
                  minHeight: 10,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          Text(
            'Cycle ${widget.cycleNumber} of 5',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.75),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentScoreCard(String label, double score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            score.toStringAsFixed(2),
            style: GoogleFonts.poppins(
              color: AppColors.blackColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            '/ 100',
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTestingNote(String note) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: const Color(0xFF237A9B),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildQuadrantCard(String quadrantKey, dynamic quadrantData) {
    final config = _quadrantConfig[quadrantKey] ??
        {
          'label': quadrantKey,
          'subtitle': '',
          'icon': Icons.circle,
          'color': AppColors.mainColor,
        };

    final color = config['color'] as Color;
    final hasActiveWeightage = quadrantData.containsKey('active_weightage');
    final isTestActiveScore = _scoreData!['is_test_active_score'] == true ||
        (widget.cycleNumber == 1 && !hasActiveWeightage);
    final passiveWeightage = _asDouble(
      quadrantData['passive_weightage'] ?? quadrantData['weightage_out_25'],
    );
    final activeWeightage = hasActiveWeightage
        ? _asDouble(quadrantData['active_weightage'])
        : (isTestActiveScore ? 12.5 : 0.0);
    final weightage = _asDouble(
      quadrantData['final_weightage'] ??
          (hasActiveWeightage
              ? quadrantData['weightage_out_25']
              : (passiveWeightage + activeWeightage) / 2),
    );
    final maxMarks = _asDouble(quadrantData['max_marks']);
    final marksObtained = _asDouble(quadrantData['marks_obtained']);
    final practices =
        Map<String, dynamic>.from(quadrantData['practices'] ?? {});

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(config['icon'] as IconData, color: color, size: 22),
          ),
          title: Text(
            config['label'] as String,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.blackColor,
            ),
          ),
          subtitle: Text(
            config['subtitle'] as String,
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Text(
                '${marksObtained.toStringAsFixed(1)} / ${maxMarks.toInt()}',
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          children: [
            // Progress bar for this quadrant
            AnimatedBuilder(
              animation: _scoreAnim,
              builder: (context, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (weightage / 25) * _scoreAnim.value,
                    minHeight: 7,
                    backgroundColor: color.withOpacity(0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildQuadrantScoreBreakdown(
              passiveWeightage,
              activeWeightage,
              weightage,
              isTestActiveScore,
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 12),
            // Attribute breakdown
            ...practices.entries.map((p) {
              final attrScore = (p.value as num).toDouble();
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        p.key,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: attrScore / 21,
                          minHeight: 6,
                          backgroundColor: color.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              color.withOpacity(0.7)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 44,
                      child: Text(
                        '${attrScore.toStringAsFixed(1)}/21',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
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
}
