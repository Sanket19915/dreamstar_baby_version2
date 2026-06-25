import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  static const _faqItems = [
    (
      'What makes DreamStar Baby™ unique?',
      "DreamStar Baby™ is a scientifically designed app based on a step by step, structured process using 'Sonal's Intelligence Model for Holistic Development©'. Through this model the expectant mother can systematically achieve the PQ, IQ, EQ and SQ of her baby which makes it absolutely result oriented.",
    ),
    (
      'What is the best time to start the course?',
      'Since the brain development of the baby starts from 16th day of conception, even before the planning mother gets to know that she is pregnant, so the best time to start the course is from the planning stage itself.',
    ),
    (
      'What is the investment required?',
      'The only investment required here is your time and commitment towards your baby. There is no financial investment. The entire course is available to you absolutely free of cost.',
    ),
    (
      'Does this course guarantee result?',
      'The course is designed very scientifically and so it is bound to give results. However, the extent of result depends upon the commitment, focus and dedication of the mother.',
    ),
    (
      'Does my partner also need to actively participate?',
      'As a part of the curriculum it is not required. However, in order to create a lifelong bond with the baby it is strongly advised that fathers also actively participate, particularly in the Garbha Samvad activities.',
    ),
    (
      'How is the course structured?',
      "In order to holistically achieve the PQ, IQ, EQ and SQ, expectant mothers will be provided with 9 activities every day — one from each intelligence as outlined in 'Sonal's Intelligence Model for Holistic Development©'. This will ensure proper neural formation of the brain. Apart from that there is a rich repository of activities available in the Knowledge Hub which mothers can focus on for more results.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F3FD),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'FAQ',
          style: GoogleFonts.poppins(
            color: AppColors.mainColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.bg),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: _faqItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = _faqItems[index];
            return _FaqTile(
              question: item.$1,
              answer: item.$2,
            );
          },
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqTile({
    required this.question,
    required this.answer,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _expanded
              ? AppColors.mainColor.withValues(alpha: 0.35)
              : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(alpha: _expanded ? 0.12 : 0.05),
            blurRadius: _expanded ? 12 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: _expanded
                            ? AppColors.mainColor
                            : AppColors.blackColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.mainColor,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.mainColor.withValues(alpha: 0.12),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withValues(alpha: 0.06),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Text(
                    widget.answer,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.55,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black404155,
                    ),
                  ),
                ),
              ],
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
