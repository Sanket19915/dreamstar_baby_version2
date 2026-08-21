import 'package:dream_baby/core/utils/app_messenger.dart';
import 'package:dream_baby/core/storage/profile_cache.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/conception_cycle_service.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:dream_baby/shared/widget/loading_overlay.dart';
import 'package:flutter/cupertino.dart';
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
  final TextEditingController _lmpController = TextEditingController();
  final TextEditingController _periodController = TextEditingController(text: '5 days');
  final TextEditingController _cycleController = TextEditingController(text: '28 days');

  @override
  void dispose() {
    _lmpController.dispose();
    _periodController.dispose();
    _cycleController.dispose();
    super.dispose();
  }

  bool get _isValid => _lmpDate != null;

  Future<void> _pickLmpDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
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
    if (picked != null) {
      setState(() {
        _lmpDate = picked;
        _lmpController.text = DateFormat('d MMMM yyyy').format(picked);
      });
    }
  }

  void _showCenteredPicker(Widget picker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            height: 300,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: const Text('Done', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SafeArea(
                    top: false,
                    bottom: false,
                    child: picker,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pickPeriodDuration() {
    _showCenteredPicker(
      CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: _periodDuration - 1),
        itemExtent: 38.0,
        backgroundColor: Colors.white,
        onSelectedItemChanged: (int index) {
          setState(() {
            _periodDuration = index + 1;
            _periodController.text = '$_periodDuration days';
          });
        },
        children: List<Widget>.generate(15, (int index) {
          return Center(
            child: Text('${index + 1} days', style: const TextStyle(fontSize: 18)),
          );
        }),
      ),
    );
  }

  void _pickAvgCycleLength() {
    int initialItem = 0;
    if (_avgCycleLength < 20) {
      initialItem = 0;
    } else if (_avgCycleLength > 40) {
      initialItem = 22;
    } else {
      initialItem = _avgCycleLength - 19;
    }

    _showCenteredPicker(
      CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: initialItem),
        itemExtent: 38.0,
        backgroundColor: Colors.white,
        onSelectedItemChanged: (int index) {
          setState(() {
            if (index == 0) {
              _avgCycleLength = 19;
              _cycleController.text = 'Below 20 days';
            } else if (index == 22) {
              _avgCycleLength = 41;
              _cycleController.text = 'Above 40 days';
            } else {
              _avgCycleLength = index + 19;
              _cycleController.text = '$_avgCycleLength days';
            }
          });
        },
        children: List<Widget>.generate(23, (int index) {
          String text;
          if (index == 0) {
            text = 'Below 20 days';
          } else if (index == 22) {
            text = 'Above 40 days';
          } else {
            text = '${index + 19} days';
          }
          return Center(
            child: Text(text, style: const TextStyle(fontSize: 18)),
          );
        }),
      ),
    );
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
      
      if (_avgCycleLength >= 40 || _avgCycleLength < 20) {
        await ProfileCache.setHasIrregularCycle(true);
      } else {
        await ProfileCache.setHasIrregularCycle(false);
      }
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
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
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
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                        // Q1
                        _buildSectionLabel('1. When was your last period?'),
                        const SizedBox(height: 8),
                        CustomTextField(
                          label: null,
                          onChanged: (_) {},
                          controller: _lmpController,
                          borderColor: Colors.transparent,
                          backGroundColor: Colors.white.withValues(alpha: 0.9),
                          hintText: 'Tap to select date',
                          readOnly: true,
                          onTap: _pickLmpDate,
                          suffix: const Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Q2
                        _buildSectionLabel('2. How long does your period last?'),
                        const SizedBox(height: 8),
                        CustomTextField(
                          label: null,
                          onChanged: (_) {},
                          controller: _periodController,
                          borderColor: Colors.transparent,
                          backGroundColor: Colors.white.withValues(alpha: 0.9),
                          readOnly: true,
                          onTap: _pickPeriodDuration,
                          suffix: const Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Q3
                        _buildSectionLabel('3. What is your average cycle length?'),
                        const SizedBox(height: 8),
                        CustomTextField(
                          label: null,
                          onChanged: (_) {},
                          controller: _cycleController,
                          borderColor: Colors.transparent,
                          backGroundColor: Colors.white.withValues(alpha: 0.9),
                          readOnly: true,
                          onTap: _pickAvgCycleLength,
                          suffix: const Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.mainColor,
                            ),
                          ),
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
