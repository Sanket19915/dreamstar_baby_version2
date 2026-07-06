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

  List<String> quotients = [
    "Atma Conception",
    "Sharir Conception",
    "Bhav Conception",
    "Mann Conception",
  ];
  Map<String, bool> quotientStatuses = {};

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
  }

  Future<void> _fetchQuotientStatuses() async {
    try {
      final data = await ApiClient.get(
        ApiConfig.userQuestionStatus,
        authenticated: true,
      );
      final statuses = data['statuses'] as Map<String, dynamic>?;

      if (statuses != null && mounted) {
        setState(() {
          quotientStatuses =
              statuses.map((key, value) => MapEntry(key, value as bool));
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
        return AppColors.primaryColor;
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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final scrollView = RefreshIndicator(
      color: AppColors.primaryColor,
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
                              color: AppColors.primaryColor)),
                    )
                  : _hasError
                      ? _buildSetupState()
                      : _buildMainContent(),
            ),
          ],
        ),
      );

    if (widget.isEmbedded) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImages.bg), fit: BoxFit.cover),
        ),
        child: scrollView,
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImages.bg), fit: BoxFit.cover),
        ),
        child: scrollView,
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

  // ─── Main Dashboard Content ──────────────────────────────────────────
  Widget _buildMainContent() {
    final s = _status!;
    final profile = ProfileCache.read() ?? {};
    final firstName = profile['first_name']?.toString() ?? '';
    final profilePicture = profile['profile_pic']?.toString() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Greeting
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
          child: InkWell(
            onTap: () => context.push(Routes.settingsScreen),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.secondaryTextColor.withValues(alpha: 0.3),
                  backgroundImage: profilePicture.isNotEmpty
                      ? NetworkImage(ApiConfig.storageUrl(profilePicture))
                      : null,
                  child: profilePicture.isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  _greetingText(firstName),
                  style: GoogleFonts.lobsterTwo(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Weekly Calendar Strip
        _buildCalendarStrip(s),

        // Cycle Arc / Phase Hero Card
        _buildPhaseHeroCard(s),

        const SizedBox(height: 16),

        // Stats Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  label: 'Cycle Day',
                  value: 'Day ${s.currentCycleDay}',
                  icon: Icons.calendar_today_rounded,
                  color: AppColors.babySizeColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatTile(
                  label: s.isDelayed ? 'Expected Date' : 'Next Period',
                  value: _formatDate(s.expectedPeriodDate),
                  subtitle: s.isDelayed ? '⚠️ ${s.delayDays}d late' : null,
                  icon: s.isDelayed
                      ? Icons.warning_amber_rounded
                      : Icons.event_rounded,
                  color: s.isDelayed
                      ? AppColors.warningColor
                      : AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatTile(
                  label: 'Ovulation',
                  value: _formatDate(s.ovulationDate),
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFF2FBF71),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Fertile Window Banner
        _buildFertileWindowBanner(s),

        const SizedBox(height: 20),

        // Irregular Pattern Banner
        if (s.hasIrregularPattern) ...[
          _buildIrregularPatternBanner(s),
          const SizedBox(height: 20),
        ],

        // Quick Actions
        _buildQuickActions(s),

        const SizedBox(height: 20),

        // Questions Section
        _buildQuestionsSection(),

        const SizedBox(height: 28),
      ],
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
                          ? AppColors.primaryColor
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
                          : (isToday ? AppColors.primaryColor : Colors.transparent),
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
              _phaseMessage,
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
          Text(
            value,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                color: AppColors.warningColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]
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
                color: AppColors.primaryColor,
                onTap: () => _showLogPeriodSheet(context),
              ),
              const SizedBox(width: 10),
              _buildActionButton(
                icon: Icons.science_outlined,
                label: 'Tests',
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
                label: 'History',
                color: AppColors.babySizeColor,
                onTap: () => context.push(Routes.conceptionHistory),
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

  // ─── Questions Section ──────────────────────────────────────────────
  Widget _buildQuestionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.mainColor.withValues(alpha: 0.08),
                  AppColors.primaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.mainColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Fertility Wellness Activities',
                        style: GoogleFonts.poppins(
                          color: AppColors.mainColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete your daily wellness activities to support your fertility journey.',
                  style: GoogleFonts.poppins(
                    color: AppColors.secondaryTextColor,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${quotients.where((q) => quotientStatuses[q] == true).length}/${quotients.length} Completed',
                    style: GoogleFonts.poppins(
                      color: AppColors.mainColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (_todayQuestionStatus.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _todayQuestionStatus,
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _startDailyActivity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE71C65), Color(0xFF861088)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Start Today\'s Activity',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward,
                            color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                          primary: AppColors.primaryColor,
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
                            ? AppColors.primaryColor
                            : AppColors.secondaryTextColor
                                .withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded,
                          color: AppColors.primaryColor),
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
          cycleDay: _status?.currentCycleDay,
          notifyWidget: () {
            _fetchQuotientStatuses();
            _fetchTodayQuestionStatus();
          },
        ),
      ),
    );
  }
}
