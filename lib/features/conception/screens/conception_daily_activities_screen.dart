import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/features/questions/sq/existential.dart';
import 'package:shimmer/shimmer.dart';

class ConceptionDailyActivitiesScreen extends StatelessWidget {
  final Map<String, bool> quotientStatuses;
  final VoidCallback notifyWidget;
  final int? cycleDay;

  const ConceptionDailyActivitiesScreen({
    super.key,
    required this.quotientStatuses,
    required this.notifyWidget,
    this.cycleDay,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Atma Conception',
        'color': const Color(0xFFF0E6F8), // Soft Purple
        'iconColor': const Color(0xFF5B4182),
        'imagePath': AppImages.atmaConception,
      },
      {
        'title': 'Sharir Conception',
        'color': const Color(0xFFF0F4E8), // Soft Green
        'iconColor': const Color(0xFF4D7048),
        'imagePath': AppImages.sharirConception,
      },
      {
        'title': 'Bhav Conception',
        'color': const Color(0xFFFCE9EA), // Soft Pink
        'iconColor': const Color(0xFFC26D68),
        'imagePath': AppImages.bhavConception,
      },
      {
        'title': 'Mann Conception',
        'color': const Color(0xFFFCF5E3), // Soft Yellow
        'iconColor': const Color(0xFFC69B56),
        'imagePath': AppImages.mannConception,
      },
    ];

    bool allCompleted = false;
    if (quotientStatuses.isNotEmpty) {
      allCompleted = items.every((item) => quotientStatuses[item['title']] == true);
    }

    // Effective day — fall back to Day 1 if not available
    final int effectiveDay = cycleDay ?? 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
          onPressed: () {
            notifyWidget();
            context.pop();
          },
        ),
        title: Text(
          'Daily Activities',
          style: GoogleFonts.poppins(
            color: AppColors.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
            } else {
              return Column(
                children: [
                  // Day indicator chip
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
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
                  if (allCompleted)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final title = items[index]['title'] as String;
                      final color = items[index]['color'] as Color;
                      final iconColor = items[index]['iconColor'] as Color;
                      final imagePath = items[index]['imagePath'] as String;
                      final isCompleted = quotientStatuses[title] == true;

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ExistentialScreen(
                                from: title,
                                quotientStatuses: quotientStatuses,
                                index: index,
                                cycleDay: effectiveDay,
                                onExit: notifyWidget,
                              ),
                            ),
                          ).then((_) => notifyWidget());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isCompleted ? iconColor : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      imagePath,
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        title,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.blackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isCompleted)
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: iconColor,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
