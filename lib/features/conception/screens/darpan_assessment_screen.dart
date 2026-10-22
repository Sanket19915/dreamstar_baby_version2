import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/services/darpan_service.dart';
import 'package:dream_baby/core/utils/app_messenger.dart';
import 'package:dream_baby/features/conception/screens/darpan_result_screen.dart';

class DarpanAssessmentScreen extends StatefulWidget {
  final int cycleNumber;
  final String? bgImagePath; // Optional background image path

  const DarpanAssessmentScreen({
    super.key,
    required this.cycleNumber,
    this.bgImagePath,
  });

  @override
  State<DarpanAssessmentScreen> createState() => _DarpanAssessmentScreenState();
}

class _DarpanAssessmentScreenState extends State<DarpanAssessmentScreen> {
  late PageController _pageController;
  List<dynamic> _questions = [];
  final Map<int, int> _answers = {}; // question_id -> days_count
  bool _isLoading = true;
  bool _isSubmitting = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.90);
    _fetchQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchQuestions() async {
    final result = await DarpanService.getQuestions();
    if (mounted) {
      setState(() {
        _questions = result.data ?? [];
        _isLoading = false;
      });
      if (!result.isSuccess) {
        AppMessenger.showError(
          result.errorMessage ?? 'Unable to load Darpan questions.',
        );
      }
    }
  }

  void _nextPage() {
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _confirmExit() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Exit Assessment?', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('Your progress will not be saved if you leave now.', style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Exit', style: GoogleFonts.poppins(color: Colors.redAccent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (shouldExit == true && mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _submitAssessment() async {
    final firstUnansweredIndex = _questions.indexWhere(
      (question) => !_answers.containsKey(question['id']),
    );
    if (firstUnansweredIndex != -1) {
      final unansweredCount = _questions.where(
        (question) => !_answers.containsKey(question['id']),
      ).length;
      await _pageController.animateToPage(
        firstUnansweredIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
      AppMessenger.showError(
        'Please answer all questions. $unansweredCount remaining.',
      );
      return;
    }

    setState(() { _isSubmitting = true; });

    final formattedAnswers = _answers.entries.map((e) => {
      'question_id': e.key,
      'days_count': e.value,
    }).toList();

    final result = await DarpanService.submitAssessment(
      cycleNumber: widget.cycleNumber,
      answers: formattedAnswers,
    );

    if (mounted) {
      setState(() { _isSubmitting = false; });

      if (result.isSuccess) {
        AppMessenger.showSuccess('Darpan Assessment completed successfully!');
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DarpanResultScreen(
              cycleNumber: widget.cycleNumber,
              preloadedScore: result.data,
            ),
          ),
        );
        if (mounted) Navigator.pop(context, true);
      } else {
        AppMessenger.showError(
          result.errorMessage ?? 'Failed to submit assessment. Please try again.',
        );
      }
    }
  }

  IconData _getQuadrantIcon(String quadrant) {
    final lower = quadrant.toLowerCase();
    if (lower.contains('sharir') || lower.contains('physical')) return Icons.fitness_center_rounded;
    if (lower.contains('atma') || lower.contains('spiritual')) return Icons.self_improvement_rounded;
    if (lower.contains('bhav') || lower.contains('emotional')) return Icons.favorite_border_rounded;
    if (lower.contains('mann') || lower.contains('mental')) return Icons.psychology_rounded;
    return Icons.category_rounded;
  }

  IconData _getPracticeIcon(String practice) {
    final lower = practice.toLowerCase();
    if (lower.contains('jal') || lower.contains('water')) return Icons.water_drop_rounded;
    if (lower.contains('ahaar') || lower.contains('nutrition') || lower.contains('food')) return Icons.restaurant_rounded;
    if (lower.contains('nidra') || lower.contains('sleep')) return Icons.bedtime_rounded;
    if (lower.contains('vyayam') || lower.contains('movement') || lower.contains('exercise')) return Icons.directions_run_rounded;
    if (lower.contains('pranayama') || lower.contains('breath')) return Icons.air_rounded;
    if (lower.contains('sanyam')) return Icons.spa_rounded;
    if (lower.contains('shodhan') || lower.contains('cleanse')) return Icons.clean_hands_rounded;
    if (lower.contains('vatavaran') || lower.contains('environment')) return Icons.eco_rounded;
    if (lower.contains('seva')) return Icons.favorite_rounded;
    if (lower.contains('sankirtan')) return Icons.music_note_rounded;
    if (lower.contains('swadhyay')) return Icons.menu_book_rounded;
    if (lower.contains('sadhna')) return Icons.self_improvement_rounded;
    return Icons.auto_awesome_rounded;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F0B24),
        body: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F0B24),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
        ),
        body: Center(
          child: Text('No questions found.', style: GoogleFonts.poppins(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background (Image or Fallback Gradient)
          Positioned.fill(
            child: widget.bgImagePath != null
                ? Image.asset(
                    widget.bgImagePath!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF1B1437),
                          Color(0xFF0F0B24),
                          Color(0xFF161132),
                        ],
                      ),
                    ),
                  ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Header Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: _confirmExit,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 28),
                        ),
                      ),

                      // Title & Subtitle
                      Column(
                        children: [
                          Text(
                            'Shuddhi Darpan',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Cycle ${widget.cycleNumber} Self-Assessment',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      // Close Button
                      GestureDetector(
                        onTap: _confirmExit,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // PageView Card Deck
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double pageOffset = 0.0;
                          if (_pageController.position.haveDimensions) {
                            pageOffset = (_pageController.page! - index);
                          } else {
                            pageOffset = (index == _currentPage) ? 0.0 : 1.0;
                          }

                          final double scale = (1 - (pageOffset.abs() * 0.10)).clamp(0.88, 1.0);
                          final double opacity = (1 - (pageOffset.abs() * 0.35)).clamp(0.45, 1.0);
                          final double rotation = (pageOffset * -0.035).clamp(-0.10, 0.10);
                          final double translateX = pageOffset * 14.0;

                          return Transform.translate(
                            offset: Offset(translateX, 0),
                            child: Transform.rotate(
                              angle: rotation,
                              child: Transform.scale(
                                scale: scale,
                                child: Opacity(
                                  opacity: opacity,
                                  child: child,
                                ),
                              ),
                            ),
                          );
                        },
                        child: _buildCardContent(_questions[index], index),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Bottom Swipe Helper Bar (Matching Mockup Image)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_rounded, color: Colors.white.withOpacity(0.8), size: 18),
                          const SizedBox(width: 8),
                          Icon(Icons.touch_app_rounded, color: Colors.white.withOpacity(0.9), size: 24),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white.withOpacity(0.8), size: 18),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Swipe left or right to move between questions',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(Map<String, dynamic> q, int index) {
    final qId = q['id'] as int;
    final bool hasAnswer = _answers.containsKey(qId);
    final int daysVal = _answers[qId] ?? 0;
    final String quadrantStr = q['quadrant']?.toString() ?? '';
    final String practiceStr = q['practice']?.toString() ?? '';

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8A2BE2).withOpacity(0.35),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Top Row: Question Counter Pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Question ${index + 1} of ${_questions.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8A2BE2),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Thin Progress Bar (Matching Mockup)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (index + 1) / _questions.length,
                  backgroundColor: const Color(0xFFF0E6FF),
                  color: const Color(0xFF8A2BE2),
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: 18),

              // Quadrant & Practice Pill Badges with Icons
              Row(
                children: [
                  if (quadrantStr.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getQuadrantIcon(quadrantStr), size: 16, color: const Color(0xFF8A2BE2)),
                          const SizedBox(width: 6),
                          Text(
                            quadrantStr,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF8A2BE2),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (quadrantStr.isNotEmpty && practiceStr.isNotEmpty)
                    const SizedBox(width: 8),
                  if (practiceStr.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getPracticeIcon(practiceStr), size: 16, color: const Color(0xFFF57C00)),
                          const SizedBox(width: 6),
                          Text(
                            practiceStr,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFFF57C00),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 18),

              // Question Text (Matching Mockup)
              Text(
                q['question_text'] ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E1B4B),
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 24),

              // Prompt Sub-header
              Center(
                child: Column(
                  children: [
                    Text(
                      'HOW MANY DAYS IN LAST 21 DAYS?',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Days Counter Pill Display (Matching Mockup)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBF7FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE9D5FF), width: 1.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_month_rounded, size: 20, color: Color(0xFF8A2BE2)),
                          const SizedBox(width: 8),
                          Text(
                            hasAnswer ? '$daysVal Days' : 'Select days',
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF8A2BE2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Slider with Min (0) & Max (21) Labels (Matching Mockup)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Text(
                      '0',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF8A2BE2),
                          inactiveTrackColor: const Color(0xFFE2E8F0),
                          thumbColor: const Color(0xFF8A2BE2),
                          overlayColor: const Color(0xFF8A2BE2).withOpacity(0.2),
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
                        ),
                        child: Slider(
                          value: daysVal.toDouble(),
                          min: 0,
                          max: 21,
                          divisions: 21,
                          onChanged: (val) {
                            setState(() {
                              _answers[qId] = val.toInt();
                            });
                          },
                        ),
                      ),
                    ),
                    Text(
                      '21',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Quick Preset Selection Pills (Matching Mockup)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [0, 7, 14, 21].map((preset) {
                  final isSelected = hasAnswer && daysVal == preset;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _answers[qId] = preset;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF8A2BE2) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '$preset d',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // If last question, show SUBMIT button inside card
              if (index == _questions.length - 1) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitAssessment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A2BE2),
                      elevation: 4,
                      shadowColor: const Color(0xFF8A2BE2).withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            'SUBMIT ASSESSMENT',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
