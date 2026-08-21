import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/core/utils/app_messenger.dart';
import 'package:dream_baby/models/cycle_models.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/conception_cycle_service.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dream_baby/core/storage/profile_cache.dart';
import 'package:dream_baby/features/conception/screens/conception_daily_activities_screen.dart';
import 'package:dream_baby/features/questions/sq/existential.dart';
import 'package:dream_baby/features/home/screens/four_quotients.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dream_baby/features/rough.dart';
import 'package:auto_size_text/auto_size_text.dart';

/// The main Conception Dashboard — beautiful fertility-style home screen
class ConceptionDashboardScreen extends StatefulWidget {
  final bool isEmbedded;
  const ConceptionDashboardScreen({super.key, this.isEmbedded = false});

  @override
  State<ConceptionDashboardScreen> createState() =>
      _ConceptionDashboardScreenState();
}

class _ConceptionDashboardScreenState extends State<ConceptionDashboardScreen> {
  CycleStatusModel? _status;
  bool _isLoading = true;
  bool _hasError = false;
  String _todayQuestionStatus = '';
  int _notificationCount = 0;
  Map<String, bool> quotientStatuses = {};
  Map<String, int> quotientTotals = {};
  Map<String, dynamic>? _conceptionData;
  bool _isCycleExpanded = false;
  bool _isShuddhiIntroExpanded = false;

  List<String> quotients = [
    "Atma Conception",
    "Sharir Conception",
    "Bhav Conception",
    "Mann Conception",
  ];

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    final result = await ConceptionCycleService.getCycleStatus();
    if (!mounted) return;
    if (result.isSuccess) {
      setState(() {
        _status = result.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
    await _fetchNotificationCount();
    await _fetchTodayQuestionStatus();
    await _fetchQuotientStatuses();
    await _fetchConceptionData();
  }

  Future<void> _fetchConceptionData() async {
    try {
      final shuddhiDay = _status?.shuddhiDay;
      if (shuddhiDay == null) {
        setState(() {
          _conceptionData = null;
        });
        return;
      }
      
      final body = await ApiClient.get(
        '${ApiConfig.conceptionData}?cycle_day=$shuddhiDay',
        authenticated: true,
      );
      if (!mounted) return;
      if (body['status'] == true && body['data'] != null) {
        setState(() {
          _conceptionData = body['data'];
        });
      } else {
        setState(() {
          _conceptionData = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _conceptionData = null;
        });
      }
    }
  }

  Future<void> _fetchQuotientStatuses() async {
    try {
      final cycleDay = _status?.currentCycleDay;
      final queryStr = cycleDay != null ? '?day=$cycleDay' : '';
      final data = await ApiClient.get(
        '${ApiConfig.userQuestionStatus}$queryStr',
        authenticated: true,
      );
      final statuses = data['statuses'] as Map<String, dynamic>?;
      final totals = data['totals'] as Map<String, dynamic>?;

      if (statuses != null && mounted) {
        setState(() {
          quotientStatuses =
              statuses.map((key, value) => MapEntry(key, value as bool));
          if (totals != null) {
            quotientTotals =
                totals.map((key, value) => MapEntry(key, (value as num).toInt()));
          }
        });
      }
    } catch (_) {}
  }

  Future<void> _fetchNotificationCount() async {
    try {
      final body = await ApiClient.get(
        ApiConfig.notificationsUnreadCount,
        authenticated: true,
      );
      if (!mounted) return;
      setState(() {
        _notificationCount =
            (body['unread_count'] ?? body['count'] ?? 0) as int;
      });
    } catch (_) {}
  }

  Future<void> _fetchTodayQuestionStatus() async {
    try {
      final body = await ApiClient.get(
        ApiConfig.questionsStatusToday,
        authenticated: true,
      );
      if (!mounted) return;
      setState(() {
        _todayQuestionStatus = body['message']?.toString() ?? '';
      });
    } catch (_) {}
  }

  Color get _phaseColor {
    switch (_status?.phase) {
      case 'Menstrual':
        return const Color(0xFFE71C65);
      case 'Follicular':
        return const Color(0xFF59ACE0);
      case 'Ovulation':
        return const Color(0xFF2FBF71);
      case 'Luteal':
        return const Color(0xFF861088);
      default:
        return AppColors.mainColor;
    }
  }

  String get _phaseEmoji {
    switch (_status?.phase) {
      case 'Menstrual':
        return '🌊';
      case 'Follicular':
        return '🌱';
      case 'Ovulation':
        return '🌟';
      case 'Luteal':
        return '🌙';
      default:
        return '🌸';
    }
  }

  String get _phaseMessage {
    if (_status == null) return '';
    final s = _status!;
    if (s.isDelayed) {
      return 'Your period is ${s.delayDays} day${s.delayDays == 1 ? '' : 's'} late. Consider taking a pregnancy test.';
    }
    switch (s.phase) {
      case 'Menstrual':
        return 'Rest and take care of yourself. Your period is here — you\'ve got this.';
      case 'Follicular':
        return 'Your body is preparing to release an egg. A great time to be active!';
      case 'Ovulation':
        return 'You\'re in your fertile window! This is your best time to conceive.';
      case 'Luteal':
        return 'Post-ovulation phase. Your body is in a waiting period. Stay calm and positive.';
      default:
        return 'Track your cycle to see your fertility insights.';
    }
  }

  String get _displayMessage {
    return _phaseMessage;
  }

  

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final scrollView = RefreshIndicator(
      color: AppColors.mainColor,
      onRefresh: _fetchAll,
      child: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: const Color(0xffF0F1FC),
            elevation: 0,
            expandedHeight: 0,
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    SharePlus.instance.share(ShareParams(
                        text:
                            'Experience the Best Online Garbhasanskar Community in India!',
                        sharePositionOrigin: Rect.fromCenter(
                            center: Offset.zero, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height)));
                  },
                  child: Image.asset(
                    AppImages.share,
                    height: 24,
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      AppImages.logoN,
                      height: 45,
                    ),
                    Text(
                      'DreamStar Baby',
                      style: GoogleFonts.lobsterTwo(
                          color: AppColors.mainColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
                InkWell(
                    onTap: () =>
                        GoRouter.of(context).push(Routes.notification).then(
                              (value) async => await _fetchNotificationCount(),
                            ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          size: 30,
                          color: Colors.black,
                        ),
                        if (_notificationCount > 0)
                          CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.red,
                            child: Text(
                              "$_notificationCount",
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 8),
                            ),
                          ),
                      ],
                    )),
              ],
            ),
          ),

            // ── Content ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.mainColor)),
                    )
                  : _hasError
                      ? _buildSetupState()
                      : _buildMainContent(),
            ),
          ],
        ),
      );

    if (widget.isEmbedded) {
      return Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.bg,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const _BlobBackground(),
            ),
          ),
          scrollView,
        ],
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.bg,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const _BlobBackground(),
            ),
          ),
          scrollView,
        ],
      ),
    );
  }

  // ─── No cycle data — prompt user to set up ──────────────────────────
  Widget _buildSetupState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          const Text('🌸', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 20),
          Text(
            'Set up your cycle',
            style: GoogleFonts.poppins(
              color: AppColors.primaryTextColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tell us about your cycle so we can track your fertility journey.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.secondaryTextColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => context.push(Routes.conceptionStep9),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE71C65), Color(0xFF861088)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Get Started →',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Greeting Builder ──────────────────────────────────────────────
  String _greetingText(String firstName) {
    final name = firstName.trim();
    if (name.isEmpty) return 'Hi there,';
    if (name.length == 1) return 'Hi ${name.toUpperCase()},';
    return 'Hi ${name[0].toUpperCase()}${name.substring(1).toLowerCase()},';
  }

  Widget _buildIrregularCycleBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your cycle appears to be irregular. To help regulate it, please follow our Shuddhi Framework or consult a gynecologist for personalized medical advice.',
              style: GoogleFonts.poppins(
                color: Colors.red.shade900,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Main Dashboard Content ──────────────────────────────────────────
  Widget _buildMainContent() {
    final s = _status!;
    final profile = ProfileCache.read() ?? {};
    final firstName = profile['first_name']?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // ── Greeting ──
          FadeAndSlide(
            delay: const Duration(milliseconds: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _greetingText(firstName),
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D1B69),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.7), width: 1),
                  ),
                  child: Text(
                    'Conception Journey',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7C3AED),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          if (s.hasIrregularPattern || ProfileCache.hasIrregularCycle())
            FadeAndSlide(
              delay: const Duration(milliseconds: 50),
              child: _buildIrregularCycleBanner(),
            ),
            
          const SizedBox(height: 12),

          // ── Hero Cycle Card (Expandable) ──
          FadeAndSlide(
            delay: const Duration(milliseconds: 100),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isCycleExpanded = !_isCycleExpanded;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.mainColor.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Track your cycle progress',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor.withOpacity(0.8),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _isCycleExpanded ? 'Close' : 'Open',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mainColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isCycleExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.mainColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isCycleExpanded
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      FloatingAnimation(
                        child: _FlippableCycleHeroCard(
                          frontWidget: _buildPremiumCycleHeroCard(s),
                          backWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.6),
                                      AppColors.mainColor.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(AppImages.mcPhases, height: 260, fit: BoxFit.contain),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.flip,
                                          color: const Color(0xFF5B4182).withOpacity(0.8),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Tap to flip back',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF5B4182).withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'The representation indicates the normal periodic cycle.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF5B4182).withOpacity(0.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),

          // ── Unified Stats & Actions ──
          FadeAndSlide(
            delay: const Duration(milliseconds: 150),
            child: Column(
              children: [
                _buildPremiumStatsRow(s),
                const SizedBox(height: 8),
                _buildPremiumQuickActions(),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Wellness (Shuddhi Framework only) ──
          FadeAndSlide(
            delay: const Duration(milliseconds: 250),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              if (_status?.isDelayed != true)
                _buildQuestionsSection(),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Knowledge Hub & Amazon Link ──
          FadeAndSlide(
            delay: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    GoRouter.of(context).push(Routes.knowEntry);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.50),
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(colors: [
                          const Color(0xffB88FEB).withValues(alpha: 0.90),
                          const Color(0xffADBDF5).withValues(alpha: 0.80),
                        ])),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText('Knowledge Hub',
                                  style: GoogleFonts.poppins(
                                      color: AppColors.babySizeColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  minFontSize: 13,
                                  maxLines: 1),
                              const SizedBox(height: 8),
                              AutoSizeText(
                                'Mantras, Meditation, Yoga, Nutrition\nand more...',
                                style: GoogleFonts.poppins(
                                    color: const Color(0xff404155),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400),
                                minFontSize: 8,
                              )
                            ],
                          ),
                        ),
                        Image.asset(AppImages.knowledgeHub,
                            fit: BoxFit.contain, height: 80)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AmazonLinkWidget(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
                const SizedBox(height: 20),
                _buildYouTubeBanner(),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildYouTubeBanner() {
    return InkWell(
      onTap: () {
        // TODO: Add YouTube link navigation later
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('YouTube channel link coming soon!')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.red, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join us on YouTube',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E2A5D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Watch expert sessions and tips on your conception journey.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF4A4A68),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCycleHeroCard(CycleStatusModel status) {
    final phaseName = '${status.phase} Phase';
    final day = status.currentCycleDay;
    final message = _displayMessage;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.6),
                AppColors.mainColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 290,
                height: 290,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Twinkling stars
                    Positioned(
                      top: 20,
                      left: 30,
                      child: TwinkleAnimation(
                        delay: const Duration(milliseconds: 300),
                        child: Icon(Icons.auto_awesome, color: const Color(0xFFD4A96A).withOpacity(0.6), size: 20),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      right: 20,
                      child: TwinkleAnimation(
                        delay: const Duration(milliseconds: 800),
                        child: Icon(Icons.auto_awesome, color: const Color(0xFF917BB3).withOpacity(0.5), size: 16),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      right: 40,
                      child: TwinkleAnimation(
                        delay: const Duration(milliseconds: 100),
                        child: Icon(Icons.star_rounded, color: const Color(0xFF6EC6C1).withOpacity(0.4), size: 12),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: math.min((day / status.cycleLength).clamp(0.0, 1.0), 1.0)),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return CustomPaint(
                          size: const Size(290, 290),
                          painter: _GlowRingPainter(
                            progress: value,
                            color: _phaseColor,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            phaseName,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF3D2B72),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          TweenAnimationBuilder<int>(
                            tween: IntTween(begin: 0, end: day),
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Text(
                                'Day $value',
                                style: GoogleFonts.poppins(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2D1B69),
                                  height: 1.0,
                                ),
                              );
                            },
                          ),
                          Text(
                            'of your cycle',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF3D2B72),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF2D1B69),
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flip,
                                color: const Color(0xFF5B4182).withOpacity(0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Tap to flip',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF5B4182).withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumStatsRow(CycleStatusModel status) {
    return Row(
      children: [
        _buildStatPill(
          icon: Icons.calendar_today_outlined,
          label: 'Cycle Day',
          value: 'Day ${status.currentCycleDay}',
        ),
        const SizedBox(width: 8),
        _buildStatPill(
          icon: Icons.access_time_rounded,
          label: 'Next Period',
          value: _formatDate(status.expectedPeriodDate),
        ),
        const SizedBox(width: 8),
        _buildStatPill(
          icon: Icons.favorite_border_rounded,
          label: 'Ovulation',
          value: _formatDate(status.ovulationDate),
        ),
      ],
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.7), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF7C3AED).withOpacity(0.08),
                  ),
                  child: Icon(icon, size: 16, color: const Color(0xFF5B4182)),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: const Color(0xFF5B4182),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D1B69),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumQuickActions() {
    return Row(
      children: [
        _buildActionCard(
          icon: Icons.water_drop_outlined,
          label: 'Log Period',
          iconColor: const Color(0xFFE71C65),
          onTap: () {
            HapticFeedback.lightImpact();
            _showLogPeriodSheet(context);
          },
        ),
        const SizedBox(width: 12),
        _buildActionCard(
          icon: Icons.science_outlined,
          label: 'Pregnancy Test',
          iconColor: const Color(0xFF7C3AED),
          onTap: () {
            HapticFeedback.lightImpact();
            GoRouter.of(context).push(Routes.conceptionDelayCheck);
          },
        ),
        const SizedBox(width: 12),
        _buildActionCard(
          icon: Icons.bar_chart_rounded,
          label: 'Menstrual History',
          iconColor: const Color(0xFFB5832A),
          onTap: () {
            HapticFeedback.lightImpact();
            GoRouter.of(context).push(Routes.conceptionHistory);
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.7), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconColor.withOpacity(0.1),
                    ),
                    child: Icon(icon, color: iconColor, size: 16),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D1B69),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWellnessCard() {
    final activeQuotients = quotients.where((q) => (quotientTotals[q] ?? 0) > 0).toList();
    final total = activeQuotients.length;
    final completed = activeQuotients.where((q) => quotientStatuses[q] == true).length;
    final progress = total > 0 ? completed / total : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
          ),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shuddhi Framework',
            style: GoogleFonts.poppins(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D1B69),
            )),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress bar
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E0FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOut,
                          widthFactor: progress,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF5B4182), Color(0xFFB8A8E8)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        // Star indicator
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOut,
                          left: 0,
                          right: 0,
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Transform.translate(
                                offset: const Offset(6, 0),
                                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22,
                                  shadows: [Shadow(color: Color(0xFF7C3AED), blurRadius: 12)]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('$completed/$total Completed',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF5B4182),
                      )),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: _startDailyActivity,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF917BB3), Color(0xFF7A62A3)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7A62A3).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    "Start Today's Activity",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
      ),
    );
  }

  // ─── Weekly Calendar Strip ──────────────────────────────────────────
  Widget _buildCalendarStrip(CycleStatusModel s) {
    final today = DateTime.now();
    // Show 61 days: 30 before today, today, 30 after
    final days = List.generate(61, (i) => today.subtract(Duration(days: 30 - i)));
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    // We can estimate the initial scroll offset so 'today' is somewhat centered.
    // Each item is about 52 pixels wide. (padding 8*2 + container 36 = 52)
    final initialOffset = (30 * 52.0) - (MediaQuery.of(context).size.width / 2) + 26.0;
    final ScrollController scrollController = ScrollController(initialScrollOffset: initialOffset > 0 ? initialOffset : 0);

    return GestureDetector(
      onTap: () => context.push(Routes.conceptionCalendar),
      child: Container(
        height: 95, // Increased height to prevent clipping
        color: Colors.white.withValues(alpha: 0.7),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            final isToday = day.day == today.day &&
                day.month == today.month &&
                day.year == today.year;

            final dayColor = s.getDayColor(day);
            final hasColor = dayColor != null;

            return Container(
              width: 50,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayNames[day.weekday % 7],
                    style: GoogleFonts.poppins(
                      color: isToday
                          ? AppColors.mainColor
                          : AppColors.primaryTextColor, // Make day names darker to ensure visibility
                      fontSize: 12,
                      fontWeight:
                          isToday ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasColor
                          ? dayColor
                          : (isToday ? AppColors.mainColor : Colors.transparent),
                      border: (isToday || hasColor)
                          ? null
                          : Border.all(
                              color: Colors.transparent, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: GoogleFonts.poppins(
                          color: (isToday || hasColor)
                              ? Colors.white
                              : AppColors.primaryTextColor,
                          fontSize: 13,
                          fontWeight: (isToday || hasColor)
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── Phase Hero Card ────────────────────────────────────────────────
  Widget _buildPhaseHeroCard(CycleStatusModel s) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _phaseColor.withValues(alpha: 0.15),
            _phaseColor.withValues(alpha: 0.05),
            const Color(0xFFFCF0F5),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _phaseColor.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: _phaseColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${s.phase} Phase',
                      style: GoogleFonts.poppins(
                        color: _phaseColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      s.isInFertileWindow
                          ? '✨ You\'re in the Fertile Window!'
                          : 'Day ${s.currentCycleDay} of your cycle',
                      style: GoogleFonts.poppins(
                        color: AppColors.secondaryTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // History icon
              GestureDetector(
                onTap: () => context.push(Routes.conceptionHistory),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.history,
                      color: AppColors.mainColor, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _displayMessage,
              style: GoogleFonts.poppins(
                color: AppColors.primaryTextColor,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile({
    required String label,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.secondaryTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  TextSpan(
                    text: ' $subtitle',
                    style: GoogleFonts.poppins(
                      color: AppColors.warningColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Fertile Window Banner ──────────────────────────────────────────
  Widget _buildFertileWindowBanner(CycleStatusModel s) {
    if (!s.isInFertileWindow) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F0EE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🌟', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '✨ You\'re in your Fertile Window!',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF2FBF71),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatDate(s.fertileWindowStart)} – ${_formatDate(s.fertileWindowEnd)}',
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Ovulation: ${_formatDate(s.ovulationDate)}',
                        style: GoogleFonts.poppins(
                          color: AppColors.secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Irregular Pattern Banner ──────────────────────────────────────
  Widget _buildIrregularPatternBanner(CycleStatusModel s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => context.push(Routes.conceptionIrregularInsights),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4E5), // Light warning orange
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFD8A8), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8CC),
                  shape: BoxShape.circle,
                ),
                child: const Text('⚠️', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Irregular Pattern Detected',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFE67700),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your cycle tracking indicates an irregular pattern. Tap here for insights and advice.',
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFE67700)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Quick Actions ──────────────────────────────────────────────────
  Widget _buildQuickActions(CycleStatusModel s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              color: AppColors.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildActionButton(
                icon: Icons.calendar_month,
                label: 'Log Period',
                color: AppColors.mainColor,
                onTap: () => _showLogPeriodSheet(context),
              ),
              const SizedBox(width: 10),
              _buildActionButton(
                icon: Icons.science_outlined,
                label: 'Pregnancy Test',
                color: AppColors.mainColor,
                onTap: () {
                  if (s.isDelayed) {
                    context.push(Routes.conceptionDelayCheck);
                  } else {
                    AppMessenger.showSuccess(
                        'Tests are available when your period is delayed.');
                  }
                },
              ),
              const SizedBox(width: 10),
              _buildActionButton(
                icon: Icons.bar_chart_outlined,
                label: 'Menstrual History',
                color: AppColors.babySizeColor,
                onTap: () => context.push(Routes.conceptionHistory),
              ),
              const SizedBox(width: 10),
              _buildActionButton(
                icon: Icons.library_books_outlined,
                label: 'Hub',
                color: AppColors.mainColor,
                onTap: () => context.push(Routes.knowEntry),
              ),
            ],
          ),
        ),
        if (s.isDelayed) ...[
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () => context.push(Routes.conceptionDelayCheck),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.warningColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.warningColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Text('⏰', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Period is ${s.delayDays} days late',
                            style: GoogleFonts.poppins(
                              color: AppColors.warningColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Tap to check what\'s happening',
                            style: GoogleFonts.poppins(
                              color: AppColors.secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        color: AppColors.warningColor),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShuddhiIntro() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isShuddhiIntroExpanded = !_isShuddhiIntroExpanded;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.mainColor.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.mainColor.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Try Our Shuddhi Framework',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E2A5D),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isShuddhiIntroExpanded ? 'Close' : 'Open',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _isShuddhiIntroExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.mainColor,
                    ),
                  ],
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isShuddhiIntroExpanded
                  ? Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'A 108-day holistic journey to prepare your mind, body, and soul for conception. Build healthy habits, practice mindfulness, and track your wellness across four core pillars: Atma, Sharir, Bhav, and Mann.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF4A4A68),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() => _isLoading = true);
                              final result = await ConceptionCycleService.startShuddhiJourney();
                              if (result.isSuccess) {
                                await _fetchAll();
                              } else {
                                setState(() => _isLoading = false);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result.errorMessage ?? 'Failed to start journey.')),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Start Shuddhi Journey',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Questions Section ──────────────────────────────────────────────
  Widget _buildQuestionsSection() {
    if (_status?.shuddhiJourneyStartDate == null) {
      return _buildShuddhiIntro();
    }
    
    final int effectiveDay = _status?.shuddhiDay ?? 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Shuddhi Framework',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E2A5D),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Day X Activities Banner
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          // Overlapping quad layout
          Transform.scale(
            scale: 1.05,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _quadCard(
                            context: context,
                            originalTitle: 'Atma Conception',
                            index: 0,
                            imagePath: 'assets/images/s_u.png',
                            isCompleted: quotientStatuses['Atma Conception'] == true && (quotientTotals['Atma Conception'] ?? 0) > 0,
                            effectiveDay: effectiveDay,
                          ),
                        ),
                        Expanded(
                          child: _quadCard(
                            context: context,
                            originalTitle: 'Sharir Conception',
                            index: 1,
                            imagePath: 'assets/images/p_d.png',
                            isCompleted: quotientStatuses['Sharir Conception'] == true && (quotientTotals['Sharir Conception'] ?? 0) > 0,
                            effectiveDay: effectiveDay,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _quadCard(
                            context: context,
                            originalTitle: 'Bhav Conception',
                            index: 2,
                            imagePath: 'assets/images/e_c.png',
                            isCompleted: quotientStatuses['Bhav Conception'] == true && (quotientTotals['Bhav Conception'] ?? 0) > 0,
                            effectiveDay: effectiveDay,
                          ),
                        ),
                        Expanded(
                          child: _quadCard(
                            context: context,
                            originalTitle: 'Mann Conception',
                            index: 3,
                            imagePath: 'assets/images/m_p.png',
                            isCompleted: quotientStatuses['Mann Conception'] == true && (quotientTotals['Mann Conception'] ?? 0) > 0,
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
      notifyWidget: () {
        _fetchQuotientStatuses();
        _fetchTodayQuestionStatus();
      },
      quotientStatuses: quotientStatuses,
    );
  }

  // ─── Log Period Sheet ───────────────────────────────────────────────
  void _showLogPeriodSheet(BuildContext context) {
    DateTime? pickedDate;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInner) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log Period Start Date',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final d = await showDatePicker(
                    context: ctx,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 14)),
                    lastDate: DateTime.now(),
                    builder: (c, child) => Theme(
                      data: Theme.of(c).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.mainColor,
                          onPrimary: AppColors.whiteColor,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (d != null) setInner(() => pickedDate = d);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: pickedDate != null
                            ? AppColors.mainColor
                            : AppColors.secondaryTextColor
                                .withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded,
                          color: AppColors.mainColor),
                      const SizedBox(width: 12),
                      Text(
                        pickedDate != null
                            ? DateFormat('d MMMM yyyy').format(pickedDate!)
                            : 'Select start date',
                        style: GoogleFonts.poppins(
                          color: pickedDate != null
                              ? AppColors.primaryTextColor
                              : AppColors.secondaryTextColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: pickedDate == null
                    ? null
                    : () async {
                        Navigator.pop(ctx);
                        final r = await ConceptionCycleService.logPeriod(
                          lmpDate: DateFormat('yyyy-MM-dd')
                              .format(pickedDate!),
                        );
                        if (!mounted) return;
                        if (r.isSuccess) {
                          AppMessenger.showSuccess('Period logged!');
                          _fetchAll();
                        } else {
                          AppMessenger.showError(
                              r.errorMessage ?? 'Failed to log period');
                        }
                      },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: pickedDate != null
                        ? const LinearGradient(colors: [
                            Color(0xFFE71C65),
                            Color(0xFF861088)
                          ])
                        : null,
                    color: pickedDate == null
                        ? AppColors.secondaryTextColor.withValues(alpha: 0.3)
                        : null,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Confirm',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      return DateFormat('d MMM').format(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }

  String _formatDateFull(String dateStr) {
    try {
      return DateFormat('d MMM yyyy').format(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }

  void _startDailyActivity() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ConceptionDailyActivitiesScreen(
          quotientStatuses: quotientStatuses,
          quotientTotals: quotientTotals,
          cycleDay: _status?.currentCycleDay,
          delayDays: _status?.delayDays ?? 0,
          isDelayed: _status?.isDelayed ?? false,
          notifyWidget: () {
            _fetchQuotientStatuses();
            _fetchTodayQuestionStatus();
          },
        ),
      ),
    );
  }
}

class _BlobBackground extends StatefulWidget {
  const _BlobBackground();

  @override
  State<_BlobBackground> createState() => _BlobBackgroundState();
}

class _BlobBackgroundState extends State<_BlobBackground> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _anim1;
  late Animation<Offset> _anim2;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
    _anim1 = Tween<Offset>(begin: Offset.zero, end: const Offset(0.03, 0.04)).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine));
    _anim2 = Tween<Offset>(begin: Offset.zero, end: const Offset(-0.04, -0.02)).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF7F4FB),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Stack(
            children: [
              // Purple blob — top left
              Positioned(
                top: -100 + (_anim1.value.dy * 200),
                left: -80 + (_anim1.value.dx * 200),
                child: _blob(350, const Color(0xFFC7B1E8).withOpacity(0.85)),
              ),
              // Teal blob — center right
              Positioned(
                top: size.height * 0.15 + (_anim2.value.dy * 150),
                right: -100 + (_anim2.value.dx * 150),
                child: _blob(280, const Color(0xFF9ADAC6).withOpacity(0.65)),
              ),
              // Gold blob — bottom left
              Positioned(
                bottom: size.height * 0.1 - (_anim1.value.dy * 100),
                left: -120 - (_anim2.value.dx * 100),
                child: _blob(350, const Color(0xFFE3C68E).withOpacity(0.55)),
              ),
              // Light lavender blob — bottom right
              Positioned(
                bottom: -80 - (_anim2.value.dy * 150),
                right: -60 - (_anim1.value.dx * 150),
                child: _blob(300, const Color(0xFFD0C3F0).withOpacity(0.7)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Glowing Ring Painter
// ═══════════════════════════════════════════════════════════════
class _GlowRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _GlowRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;

    // Background track with inner bevel feel
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final trackInnerShadow = Paint()
      ..color = const Color(0xFF2D1B69).withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 4);
    canvas.drawCircle(center, radius, trackInnerShadow);

    // Glow shadow for the progress arc
    final sweepGradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + 2 * math.pi * progress,
      colors: const [
        Color(0xFF917BB3),
        Color(0xFF5B2ED8),
        Color(0xFFD4A96A),
        Color(0xFF6EC6C1),
      ],
      stops: const [0.0, 0.4, 0.8, 1.0],
      transform: const GradientRotation(-math.pi / 2),
    );

    final glowPaint = Paint()
      ..shader = sweepGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      glowPaint,
    );

    // Main arc
    final arcPaint = Paint()
      ..shader = sweepGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_GlowRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class FadeAndSlide extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const FadeAndSlide({Key? key, required this.child, required this.delay}) : super(key: key);

  @override
  State<FadeAndSlide> createState() => _FadeAndSlideState();
}

class _FadeAndSlideState extends State<FadeAndSlide> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _scale = Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: widget.child,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Next Level Animations
// ═══════════════════════════════════════════════════════════════

class FloatingAnimation extends StatefulWidget {
  final Widget child;
  const FloatingAnimation({Key? key, required this.child}) : super(key: key);

  @override
  State<FloatingAnimation> createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _anim = Tween<Offset>(begin: const Offset(0, -0.015), end: const Offset(0, 0.015)).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _anim,
      child: widget.child,
    );
  }
}

class TwinkleAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const TwinkleAnimation({Key? key, required this.child, this.delay = Duration.zero}) : super(key: key);

  @override
  State<TwinkleAnimation> createState() => _TwinkleAnimationState();
}

class _TwinkleAnimationState extends State<TwinkleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut)),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut)),
        child: RotationTransition(
          turns: Tween<double>(begin: -0.02, end: 0.02).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine)),
          child: widget.child,
        ),
      ),
    );
  }
}

class _FlippableCycleHeroCard extends StatefulWidget {
  final Widget frontWidget;
  final Widget backWidget;

  const _FlippableCycleHeroCard({
    required this.frontWidget,
    required this.backWidget,
  });

  @override
  State<_FlippableCycleHeroCard> createState() => _FlippableCycleHeroCardState();
}

class _FlippableCycleHeroCardState extends State<_FlippableCycleHeroCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final isFrontVisible = angle <= math.pi / 2;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFrontVisible
                ? widget.frontWidget
                : Transform(
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: widget.backWidget,
                  ),
          );
        },
      ),
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
      onTapDown: (_) => _controller.forward(),
      onTapCancel: () => _controller.reverse(),
      onTapUp: (_) async {
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
    );
  }
}
