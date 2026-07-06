import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JourneySelectionScreen extends StatelessWidget {
  final String userId;

  const JourneySelectionScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.loginbg),
                fit: BoxFit.cover,
                opacity: 1,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: 'Logo',
                      child: Image.asset(
                        AppImages.logoNew,
                        height: MediaQuery.of(context).size.height * .08,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'What is your goal?',
                      textAlign: TextAlign.center,
                      style: CustomLabels.pbody1TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.mainColor,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildJourneyCard(
                      context: context,
                      title: 'I\'m Pregnant',
                      subtitle: 'Track your baby\'s growth and pregnancy milestones.',
                      icon: Icons.pregnant_woman_rounded,
                      iconColor: AppColors.primaryColor,
                      onTap: () => context.push(Routes.moreDetails, extra: {'userId': userId, 'journeyType': 'pregnant'}),
                    ),
                    const SizedBox(height: 24),
                    _buildJourneyCard(
                      context: context,
                      title: 'Conception',
                      subtitle: 'Track your cycle, ovulation, and get fertility insights.',
                      icon: Icons.spa_rounded,
                      iconColor: AppColors.mainColor,
                      onTap: () => context.push(Routes.conceptionStep9),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      splashColor: iconColor.withValues(alpha: 0.1),
      highlightColor: iconColor.withValues(alpha: 0.05),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CustomLabels.pbody1TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: CustomLabels.body3GreyTextStyle(
                      fontSize: 13,
                      color: AppColors.greyTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.greyTextColor, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
