import 'package:dream_baby/models/cycle_models.dart';
import 'package:dream_baby/services/conception_cycle_service.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Steps 7 & 8: Cycle History with Irregular Pattern Check
class ConceptionHistoryScreen extends StatefulWidget {
  const ConceptionHistoryScreen({super.key});

  @override
  State<ConceptionHistoryScreen> createState() =>
      _ConceptionHistoryScreenState();
}

class _ConceptionHistoryScreenState extends State<ConceptionHistoryScreen> {
  CycleHistoryModel? _history;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoading = true);
    final result = await ConceptionCycleService.getCycleHistory();
    if (!mounted) return;
    if (result.isSuccess) {
      setState(() {
        _history = result.data;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.bg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColors.mainColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Cycle History',
                      style: GoogleFonts.poppins(
                        color: AppColors.mainColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryColor))
                    : _history == null
                        ? Center(
                            child: Text('No history found',
                                style: GoogleFonts.poppins()))
                        : RefreshIndicator(
                            color: AppColors.primaryColor,
                            onRefresh: _fetchHistory,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  // Irregular Pattern Warning
                                  if (_history!.hasIrregularPattern)
                                    _buildIrregularWarning(),
                                  const SizedBox(height: 16),
                                  // Cycles list
                                  if (_history!.cycles.isEmpty)
                                    _buildEmptyState()
                                  else
                                    ..._history!.cycles.map(
                                        (c) => _buildCycleTile(c)),
                                  const SizedBox(height: 24),
                                ],
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

  Widget _buildIrregularWarning() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warningColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Irregular Pattern Detected',
                  style: GoogleFonts.poppins(
                    color: AppColors.warningColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your cycle shows signs of irregularity. This could be due to stress, lifestyle changes, or other factors. Consider consulting a healthcare professional.',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Column(
          children: [
            const Text('📋', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              'No completed cycles yet',
              style: GoogleFonts.poppins(
                color: AppColors.secondaryTextColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your cycle history will appear here once your first cycle completes.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.secondaryTextColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleTile(MenstrualCycleModel cycle) {
    final isLong = (cycle.cycleLength ?? 0) > 35;
    final color = isLong ? AppColors.warningColor : AppColors.successColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.water_drop_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(cycle.startDate),
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (cycle.endDate != null)
                  Text(
                    'Ended: ${_formatDate(cycle.endDate!)}',
                    style: GoogleFonts.poppins(
                      color: AppColors.secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                if (cycle.pregnancyTestResult != null)
                  _buildTestBadge(cycle.pregnancyTestResult!),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (cycle.cycleLength != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${cycle.cycleLength} days',
                    style: GoogleFonts.poppins(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (isLong)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Long cycle',
                    style: GoogleFonts.poppins(
                      color: AppColors.warningColor,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestBadge(String result) {
    final color = result == 'positive'
        ? AppColors.successColor
        : result == 'negative'
            ? AppColors.errorColor
            : AppColors.warningColor;
    final label = result == 'positive'
        ? '✅ Test Positive'
        : result == 'negative'
            ? '❌ Test Negative'
            : '⏳ Not Yet Tested';
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        label,
        style: GoogleFonts.poppins(color: color, fontSize: 11),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy').format(d);
    } catch (_) {
      return dateStr;
    }
  }
}
