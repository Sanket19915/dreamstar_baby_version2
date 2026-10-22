import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/features/conception/screens/darpan_result_screen.dart';

class DarpanHistoryScreen extends StatelessWidget {
  final List<int> completedCycles;

  const DarpanHistoryScreen({super.key, required this.completedCycles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Assessment Results',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.blackColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.blackColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Shuddhi Darpan Journey',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your progress through the 5 assessment cycles.',
                style: GoogleFonts.poppins(fontSize: 14, color: AppColors.primaryTextColor),
              ),
              const SizedBox(height: 40),
              
              // Graphical Timeline
              _buildTimeline(),
              
              const SizedBox(height: 50),
              Text(
                'Completed Assessments',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 16),
              if (completedCycles.isEmpty)
                Text(
                  'No assessments completed yet.',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                )
              else
                ...completedCycles.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DarpanResultScreen(cycleNumber: c),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.mainColor,
                        side: BorderSide(color: AppColors.mainColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Assessment $c Result', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final targets = [40, 50, 60, 70, 80];
    return Row(
      children: List.generate(5, (index) {
        final cycleNum = index + 1;
        final isCompleted = completedCycles.contains(cycleNum);
        
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  // Left connecting line
                  Expanded(
                    child: Container(
                      height: 3,
                      color: index == 0 ? Colors.transparent : (isCompleted ? AppColors.mainColor : Colors.grey.shade200),
                    ),
                  ),
                  // Node
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.mainColor : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted ? AppColors.mainColor : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : Text(
                              cycleNum.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500,
                              ),
                            ),
                    ),
                  ),
                  // Right connecting line
                  Expanded(
                    child: Container(
                      height: 3,
                      color: index == 4 
                          ? Colors.transparent 
                          : (completedCycles.contains(cycleNum + 1) ? AppColors.mainColor : Colors.grey.shade200),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Cycle $cycleNum',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? AppColors.mainColor : Colors.grey.shade500,
                ),
              ),
              Text(
                'T: ${targets[index]}%',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
