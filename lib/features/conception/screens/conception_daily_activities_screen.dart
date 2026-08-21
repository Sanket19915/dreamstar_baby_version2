import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/features/questions/sq/existential.dart';
import 'package:shimmer/shimmer.dart';

class ConceptionDailyActivitiesScreen extends StatelessWidget {
  final Map<String, bool> quotientStatuses;
  final Map<String, int>? quotientTotals;
  final VoidCallback notifyWidget;
  final int? cycleDay;
  final int delayDays;
  final bool isDelayed;

  const ConceptionDailyActivitiesScreen({
    super.key,
    required this.quotientStatuses,
    this.quotientTotals,
    required this.notifyWidget,
    this.cycleDay,
    this.delayDays = 0,
    this.isDelayed = false,
  });

  @override
  Widget build(BuildContext context) {
    bool allCompleted = false;
    bool hasNoActivities = false;
    
    if (quotientStatuses.isNotEmpty) {
      allCompleted = [
        'Atma Conception',
        'Sharir Conception',
        'Bhav Conception',
        'Mann Conception'
      ].every((title) => quotientStatuses[title] == true);
    }
    
    if (quotientTotals != null && quotientTotals!.isNotEmpty) {
      hasNoActivities = [
        'Atma Conception',
        'Sharir Conception',
        'Bhav Conception',
        'Mann Conception'
      ].every((title) => (quotientTotals![title] ?? 0) == 0);
    }

    final int effectiveDay = cycleDay ?? 1;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
          onPressed: () {
            notifyWidget();
            context.pop();
          },
        ),
        title: Text(
          'Shuddhi Framework',
          style: GoogleFonts.poppins(
            color: AppColors.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 96, // Minus the vertical padding
              ),
              child: Center(
                child: Builder(
                  builder: (context) {
            if (quotientStatuses.isEmpty) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 390,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            } else if (effectiveDay > 90) {
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.mainColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 60, color: AppColors.mainColor),
                      const SizedBox(height: 20),
                      Text(
                        'Cycle Delayed',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your cycle has been delayed for more than 90 days. Please restart your Shuddhi Framework once your cycle restarts or consult a doctor.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: AppColors.primaryTextColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  // Header section
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5B4182), Color(0xFFC26D68)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Day $effectiveDay Activities',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (hasNoActivities)
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          'No questions are available for today.',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else if (allCompleted)
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          'All activities are completed for the day',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  // Overlapping quad layout (scaled down slightly to fit edges)
                  Transform.scale(
                    scale: 1.05, // Reduced from 1.15 so it doesn't bleed out of edges
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                      Column(
                        children: [
                          // Top row
                          Row(
                            children: [
                              Expanded(
                                child: _quadCard(
                                  context: context,
                                  originalTitle: 'Atma Conception',
                                  index: 0,
                                  imagePath: 'assets/images/s_u.png',
                                  isCompleted: quotientStatuses['Atma Conception'] == true && (quotientTotals?['Atma Conception'] ?? 0) > 0,
                                  effectiveDay: effectiveDay,
                                ),
                              ),
                              Expanded(
                                child: _quadCard(
                                  context: context,
                                  originalTitle: 'Sharir Conception',
                                  index: 1,
                                  imagePath: 'assets/images/p_d.png',
                                  isCompleted: quotientStatuses['Sharir Conception'] == true && (quotientTotals?['Sharir Conception'] ?? 0) > 0,
                                  effectiveDay: effectiveDay,
                                ),
                              ),
                            ],
                          ),
                          // Bottom row
                          Row(
                            children: [
                              Expanded(
                                child: _quadCard(
                                  context: context,
                                  originalTitle: 'Bhav Conception',
                                  index: 2,
                                  imagePath: 'assets/images/e_c.png',
                                  isCompleted: quotientStatuses['Bhav Conception'] == true && (quotientTotals?['Bhav Conception'] ?? 0) > 0,
                                  effectiveDay: effectiveDay,
                                ),
                              ),
                              Expanded(
                                child: _quadCard(
                                  context: context,
                                  originalTitle: 'Mann Conception',
                                  index: 3,
                                  imagePath: 'assets/images/m_p.png',
                                  isCompleted: quotientStatuses['Mann Conception'] == true && (quotientTotals?['Mann Conception'] ?? 0) > 0,
                                  effectiveDay: effectiveDay,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            }
          },
        ),
              ),
            ),
          );
        },
      ),
    ),
    );
  }

  Widget _quadCard({
    required BuildContext context,
    required String originalTitle,
    required int index,
    required String imagePath,
    required bool isCompleted,
    required int effectiveDay,
  }) {
    return AnimatedQuadCard(
      originalTitle: originalTitle,
      index: index,
      imagePath: imagePath,
      isCompleted: isCompleted,
      effectiveDay: effectiveDay,
      notifyWidget: notifyWidget,
      quotientStatuses: quotientStatuses,
    );
  }
}

class AnimatedQuadCard extends StatefulWidget {
  final String originalTitle;
  final int index;
  final String imagePath;
  final bool isCompleted;
  final int effectiveDay;
  final VoidCallback notifyWidget;
  final Map<String, bool> quotientStatuses;

  const AnimatedQuadCard({
    super.key,
    required this.originalTitle,
    required this.index,
    required this.imagePath,
    required this.isCompleted,
    required this.effectiveDay,
    required this.notifyWidget,
    required this.quotientStatuses,
  });

  @override
  State<AnimatedQuadCard> createState() => _AnimatedQuadCardState();
}

class _AnimatedQuadCardState extends State<AnimatedQuadCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapUp: (_) async {
        setState(() => _isPressed = false);
        await _controller.reverse();
        HapticFeedback.lightImpact(); // Add native vibration
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ExistentialScreen(
              from: widget.originalTitle,
              quotientStatuses: widget.quotientStatuses,
              index: widget.index,
              cycleDay: widget.effectiveDay,
              onExit: widget.notifyWidget,
            ),
          ),
        ).then((_) => widget.notifyWidget());
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Image.asset(
              widget.imagePath,
              fit: BoxFit.fitWidth,
            ),
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _glowAnimation.value * 0.4,
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.fitWidth,
                    color: Colors.white,
                    colorBlendMode: BlendMode.srcATop,
                  ),
                );
              },
            ),
            
            // Completion checkmark badge (inset to prevent edge clipping)
            if (widget.isCompleted)
              Positioned(
                top: (widget.index == 0 || widget.index == 1) ? 12 : null,
                bottom: (widget.index == 2 || widget.index == 3) ? 12 : null,
                right: (widget.index == 1 || widget.index == 3) ? 12 : null,
                left: (widget.index == 0 || widget.index == 2) ? 12 : null,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF2FBF71),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
