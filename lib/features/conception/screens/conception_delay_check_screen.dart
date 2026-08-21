import 'package:dream_baby/core/utils/app_messenger.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/conception_cycle_service.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/widget/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Step 5B / 6B: Delay check + Pregnancy Risk Check + Pregnancy Test
class ConceptionDelayCheckScreen extends StatefulWidget {
  const ConceptionDelayCheckScreen({super.key});

  @override
  State<ConceptionDelayCheckScreen> createState() =>
      _ConceptionDelayCheckScreenState();
}

class _ConceptionDelayCheckScreenState
    extends State<ConceptionDelayCheckScreen> {
  // Steps: 'risk_check', 'pregnancy_test'
  String _currentStep = 'risk_check';
  bool _isLoading = false;
  bool _couldBePregnant = false;

  Future<void> _logTestResult(String result) async {
    setState(() => _isLoading = true);
    final r = await ConceptionCycleService.logPregnancyTest(result: result);
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (r.isSuccess) {
      if (result == 'positive') {
        _showPositiveDialog();
      } else if (result == 'negative') {
        _showNegativeDialog();
      } else {
        _showNotYetDialog();
      }
    } else {
      AppMessenger.showError(r.errorMessage ?? 'Failed to save result');
    }
  }

  void _showPositiveDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              'Congratulations!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your test is positive!\nYou may want to switch to the Pregnancy Journey.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.primaryTextColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go(Routes.home);
            },
            child: Text('Stay here',
                style: GoogleFonts.poppins(color: AppColors.secondaryTextColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Navigate to Pregnancy Journey switch screen
              context.go(Routes.home);
            },
            child: Text('Switch Journey',
                style: GoogleFonts.poppins(color: AppColors.whiteColor)),
          ),
        ],
      ),
    );
  }

  void _showNegativeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💙', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              'Test Negative',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.babySizeColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The result is negative. Consider retesting after a few days if your period still hasn\'t started.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.primaryTextColor,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.babySizeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: Text('OK',
                style: GoogleFonts.poppins(color: AppColors.whiteColor)),
          ),
        ],
      ),
    );
  }

  void _showNotYetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🕐', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              'Reminder Set',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.warningColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We recommend taking a pregnancy test if your period remains delayed.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.primaryTextColor,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: Text('OK',
                style: GoogleFonts.poppins(color: AppColors.whiteColor)),
          ),
        ],
      ),
    );
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
              opacity: 0.85,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
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
                        'Test your pregnancy',
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
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _currentStep == 'risk_check'
                        ? _buildRiskCheck()
                        : _buildPregnancyTest(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiskCheck() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.pinkFFC2D1.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/mom_preg.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Period Delayed',
                style: GoogleFonts.poppins(
                  color: AppColors.warningColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your period hasn\'t arrived yet. Are you Pregnant?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.primaryTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Are you Pregnant?',
          style: GoogleFonts.poppins(
            color: AppColors.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        _buildRiskOption(
          emoji: '✅',
          label: 'Might Be',
          color: AppColors.primaryColor,
          onTap: () => setState(() {
            _couldBePregnant = true;
            _currentStep = 'pregnancy_test';
          }),
        ),
        const SizedBox(height: 12),
        _buildRiskOption(
          emoji: '❌',
          label: 'Not this time',
          color: AppColors.babySizeColor,
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('💙', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(
                      'Advise to Monitor',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.babySizeColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your period may be delayed due to stress, travel, illness, or lifestyle changes. Keep monitoring your cycle.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.babySizeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.pop();
                    },
                    child: Text('OK',
                        style:
                            GoogleFonts.poppins(color: AppColors.whiteColor)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPregnancyTest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.pinkFFC2D1.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/mom_son.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Have you taken a pregnancy test?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildTestOption(
          emoji: '✅',
          label: 'Positive',
          sublabel: 'Move to Pregnancy Journey',
          color: AppColors.successColor,
          onTap: () => _logTestResult('positive'),
        ),
        const SizedBox(height: 12),
        _buildTestOption(
          emoji: '❌',
          label: 'Negative',
          sublabel: 'Repeat test in a few days',
          color: AppColors.errorColor,
          onTap: () => _logTestResult('negative'),
        ),
        const SizedBox(height: 12),
        _buildTestOption(
          emoji: '⏳',
          label: 'Not Yet Taken',
          sublabel: 'Recommended if period remains delayed',
          color: AppColors.warningColor,
          onTap: () => _logTestResult('not_yet'),
        ),
        const SizedBox(height: 24),
        TextButton.icon(
          onPressed: () => setState(() => _currentStep = 'risk_check'),
          icon: const Icon(Icons.arrow_back_ios, size: 14),
          label: Text('Back',
              style: GoogleFonts.poppins(color: AppColors.secondaryTextColor)),
        ),
      ],
    );
  }

  Widget _buildRiskOption({
    required String emoji,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildTestOption({
    required String emoji,
    required String label,
    required String sublabel,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: color,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: GoogleFonts.poppins(
                      color: AppColors.secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}
