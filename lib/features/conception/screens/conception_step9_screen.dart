import 'package:dream_baby/core/utils/app_messenger.dart';
import 'package:dream_baby/core/storage/profile_cache.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/conception_cycle_service.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Step 9 — Ask 3 questions and map the calendar
class ConceptionStep9Screen extends StatefulWidget {
  const ConceptionStep9Screen({super.key});

  @override
  State<ConceptionStep9Screen> createState() => _ConceptionStep9ScreenState();
}

class _ConceptionStep9ScreenState extends State<ConceptionStep9Screen> {
  DateTime? _lmpDate;
  int _periodDuration = 5;
  int _avgCycleLength = 28;
  bool _isLoading = false;

  bool get _isValid => _lmpDate != null;

  Future<void> _pickLmpDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryColor,
            onPrimary: AppColors.whiteColor,
            surface: AppColors.whiteColor,
            onSurface: AppColors.primaryTextColor,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _lmpDate = picked);
  }

  Future<void> _submit() async {
    if (!_isValid) return;
    setState(() => _isLoading = true);
    final result = await ConceptionCycleService.submitStep9Questions(
      lmpDate: DateFormat('yyyy-MM-dd').format(_lmpDate!),
      periodDuration: _periodDuration,
      avgCycleLength: _avgCycleLength,
    );
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (result.isSuccess) {
      // Persist journey_type so HomeScreen shows Conception Dashboard
      final currentProfile = ProfileCache.read() ?? {};
      currentProfile['journey_type'] = 'conception';
      await ProfileCache.save(currentProfile);
      if (!mounted) return;
      context.go(Routes.home);
    } else {
      AppMessenger.showError(result.errorMessage ?? 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.loginbg),
              fit: BoxFit.cover,
              opacity: 0.9,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        'Cycle Setup',
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        // Intro
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Text('🌸', style: TextStyle(fontSize: 24)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Tell us about your cycle so we can track your journey!',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Main Questions Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.15), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withValues(alpha: 0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                        // Q1
                        _buildSectionLabel('1. When was your last period?'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickLmpDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _lmpDate != null
                                    ? AppColors.primaryColor
                                    : AppColors.secondaryTextColor.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: _lmpDate != null
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryTextColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _lmpDate != null
                                      ? DateFormat('d MMMM yyyy').format(_lmpDate!)
                                      : 'Tap to select date',
                                  style: GoogleFonts.poppins(
                                    color: _lmpDate != null
                                        ? AppColors.primaryTextColor
                                        : AppColors.secondaryTextColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Q2
                        _buildSectionLabel('2. How long does your period last?'),
                        const SizedBox(height: 4),
                        Text(
                          '$_periodDuration days',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primaryColor,
                            thumbColor: AppColors.primaryColor,
                            inactiveTrackColor: AppColors.pinkFFC2D1,
                            overlayColor: AppColors.primaryColor.withValues(alpha: 0.15),
                          ),
                          child: Slider(
                            value: _periodDuration.toDouble(),
                            min: 1,
                            max: 15,
                            divisions: 14,
                            label: '$_periodDuration days',
                            onChanged: (v) =>
                                setState(() => _periodDuration = v.toInt()),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('1 day', style: GoogleFonts.poppins(color: AppColors.secondaryTextColor, fontSize: 12)),
                            Text('15 days', style: GoogleFonts.poppins(color: AppColors.secondaryTextColor, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 28),
                        // Q3
                        _buildSectionLabel('3. What is your average cycle length?'),
                        const SizedBox(height: 4),
                        Text(
                          '$_avgCycleLength days',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primaryColor,
                            thumbColor: AppColors.primaryColor,
                            inactiveTrackColor: AppColors.pinkFFC2D1,
                            overlayColor: AppColors.primaryColor.withValues(alpha: 0.15),
                          ),
                          child: Slider(
                            value: _avgCycleLength.toDouble(),
                            min: 21,
                            max: 45,
                            divisions: 24,
                            label: '$_avgCycleLength days',
                            onChanged: (v) =>
                                setState(() => _avgCycleLength = v.toInt()),
                          ),
                        ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('21 days', style: GoogleFonts.poppins(color: AppColors.secondaryTextColor, fontSize: 12)),
                                  Text('45 days', style: GoogleFonts.poppins(color: AppColors.secondaryTextColor, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),
                        CustomButton(
                          text: 'Continue',
                          isEnabled: _isValid,
                          backgroundColor: _isValid
                              ? AppColors.primaryColor
                              : AppColors.secondaryTextColor.withValues(alpha: 0.4),
                          activeButtonColor: _isValid
                              ? AppColors.primaryColor
                              : AppColors.secondaryTextColor.withValues(alpha: 0.4),
                          borderColor: _isValid
                              ? AppColors.primaryColor
                              : AppColors.secondaryTextColor.withValues(alpha: 0.4),
                          textStyle: GoogleFonts.poppins(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          onPressed: _isValid ? _submit : null,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColors.mainColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
