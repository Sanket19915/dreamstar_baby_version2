import 'package:dream_baby/models/popup_model.dart';
import 'package:dream_baby/services/popup_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreakBadgeWidget extends StatefulWidget {
  const StreakBadgeWidget({super.key});

  @override
  State<StreakBadgeWidget> createState() => _StreakBadgeWidgetState();
}

class _StreakBadgeWidgetState extends State<StreakBadgeWidget>
    with SingleTickerProviderStateMixin {
  StreakData? _streakData;
  bool _loading = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _loadStreak();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadStreak() async {
    final data = await PopupService.fetchStreak();
    if (mounted) {
      setState(() {
        _streakData = data;
        _loading = false;
      });
    }
  }

  void _showStreakDetails() {
    if (_streakData == null) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _StreakDetailsSheet(streakData: _streakData!),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();
    final streak = _streakData?.currentStreak ?? 0;
    if (streak == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: _showStreakDetails,
      child: ScaleTransition(
        scale: _pulseAnim,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFFB347)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B35).withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                '$streak ${streak == 1 ? 'day' : 'days'}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if ((_streakData?.badgesEarned.isNotEmpty ?? false)) ...[
                const SizedBox(width: 6),
                Text(
                  _streakData!.badgesEarned.last.emoji,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakDetailsSheet extends StatelessWidget {
  final StreakData streakData;
  const _StreakDetailsSheet({required this.streakData});

  @override
  Widget build(BuildContext context) {
    final milestones = [
      {'days': 7,   'name': 'Sankalp Seed', 'emoji': '🌱', 'key': '7_days'},
      {'days': 30,  'name': 'Sadhak',        'emoji': '🧘', 'key': '30_days'},
      {'days': 60,  'name': 'Dhyana',        'emoji': '🪷', 'key': '60_days'},
      {'days': 105, 'name': 'Siddhi',        'emoji': '✨', 'key': '105_days'},
    ];
    final earnedKeys = streakData.badgesEarned.map((b) => b.key).toSet();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Streak display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 36)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${streakData.currentStreak} Day Streak',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  Text(
                    'Best: ${streakData.longestStreak} days',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Milestone badges
          Text(
            'Milestone Badges',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 14),
          ...milestones.map((m) {
            final earned = earnedKeys.contains(m['key']);
            final days = m['days'] as int;
            final progress = (streakData.currentStreak / days).clamp(0.0, 1.0);
            return _MilestoneTile(
              emoji: m['emoji'] as String,
              name: m['name'] as String,
              days: days,
              earned: earned,
              progress: progress,
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  final String emoji;
  final String name;
  final int days;
  final bool earned;
  final double progress;

  const _MilestoneTile({
    required this.emoji,
    required this.name,
    required this.days,
    required this.earned,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: earned ? const Color(0xFFF3E5F5) : Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: earned ? const Color(0xFFCE93D8) : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Text(
            earned ? emoji : '🔒',
            style: TextStyle(fontSize: 22, color: earned ? null : Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: earned ? const Color(0xFF6A1B9A) : Colors.grey[500],
                  ),
                ),
                Text(
                  '$days days',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[400],
                  ),
                ),
                if (!earned) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      color: const Color(0xFF7B1FA2),
                      minHeight: 5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (earned)
            const Icon(Icons.check_circle, color: Color(0xFF7B1FA2), size: 20),
        ],
      ),
    );
  }
}
