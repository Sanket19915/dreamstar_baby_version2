import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/models/cycle_models.dart';
import 'package:dream_baby/services/conception_cycle_service.dart';

class ConceptionIrregularInsightsScreen extends StatefulWidget {
  const ConceptionIrregularInsightsScreen({super.key});

  @override
  State<ConceptionIrregularInsightsScreen> createState() =>
      _ConceptionIrregularInsightsScreenState();
}

class _ConceptionIrregularInsightsScreenState
    extends State<ConceptionIrregularInsightsScreen> {
  bool _isLoading = true;
  CycleHistoryModel? _history;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await ConceptionCycleService.getCycleHistory();
    if (result.isSuccess) {
      setState(() {
        _history = result.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result.errorMessage ?? 'Failed to load cycle insights';
        _isLoading = false;
      });
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, y').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Cycle Insights',
          style: GoogleFonts.poppins(
            color: AppColors.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadInsights,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final h = _history!;
    if (!h.hasIrregularPattern) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Text('✨', style: TextStyle(fontSize: 40)),
              ),
              const SizedBox(height: 20),
              Text(
                'Everything looks normal!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your tracked cycles show a consistent pattern. Keep logging your periods to help us provide the most accurate predictions.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFD8A8), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8CC),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('⚠️', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Irregular Pattern Detected',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFE67700),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Based on your tracked history, we\'ve identified some inconsistencies in your cycle.',
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Reasons Section
          Text(
            'What we noticed',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          ...h.irregularReasons.map((reason) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle, size: 8, color: Color(0xFFE67700)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        reason,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 24),

          // Actionable Advice
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0EE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.medical_services_outlined,
                        color: AppColors.primaryColor),
                    const SizedBox(width: 10),
                    Text(
                      'Doctor Consultation',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Irregular periods can be caused by various factors, including stress, sudden weight changes, PCOS, or thyroid issues. We highly recommend discussing these tracking insights with your healthcare provider or gynecologist.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.secondaryTextColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Cycle History List
          Text(
            'Your Tracked History',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: h.cycles.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final cycle = h.cycles[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                title: Text(
                  'Started on ${_formatDate(cycle.startDate)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                subtitle: Text(
                  cycle.status == 'ongoing' ? 'Ongoing' : 'Completed',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: cycle.cycleLength != null && cycle.cycleLength! > 35
                        ? const Color(0xFFFFE8CC)
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    cycle.cycleLength != null
                        ? '${cycle.cycleLength} days'
                        : '...',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          cycle.cycleLength != null && cycle.cycleLength! > 35
                              ? const Color(0xFFE67700)
                              : const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
