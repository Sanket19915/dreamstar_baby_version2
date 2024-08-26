import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F3FD),
        elevation: 0,
        // leading: InkWell(
        //   onTap: () {
        //     Navigator.of(context).pop();
        //   },
        //   child: const Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //     size: 24,
        //   ),
        // ),
        centerTitle: true,
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            _buildFAQItem('What makes DreamStar Baby™ unique?',
                "DreamStar Baby™ is a scientifically designed app based on a step by step ,structured process using 'Sonal’s Intelligence Model for HolisticDevelopment© ' Through this model the expectant mother can systematically achieve the PQ, IQ, EQ and SQ of her baby which makes it absolutely result oriented."),
            _buildFAQItem('What is the best time to start the course?',
                'Since the brain development of the baby starts from 16th day of conception, even before the planning mother gets to know that she is pregnant, so the best time to start the course is from the planning stage itself.'),
            _buildFAQItem('What is the investment required?',
                'The only investment required here is your time and commitment towards your baby. There is no financial investment. The entire course is available to you absolutely free of cost.'),
            _buildFAQItem('Does this course guarantee result?',
                'The course is designed very scientifically and so its bound to give results , however the extent of result depends upon the commitment, focus and dedication of the mother.'),
            _buildFAQItem('Does my partner also need to actively participate?',
                'As a part of the curriculum it is not required , however in order to create life long bond with the baby it is strongly advised that the fathers should also actively participate particularly in the Garbha Samvad activities.'),
            _buildFAQItem('How is the course structured?',
                "In order to holistically achieve the PQ,IQ, EQ and SQ the expectant mothers will be provided with 9 activities everyday, one from each intelligence as outlines in the 'Sonal’s Intelligence Model for Holistic Development© ' This  will ensure proper neural formation of the brain. Apart from that there is rich repository of activities available in the knowledge hub which the mothers can focus upon for more results."),
            // Add more FAQ items as needed
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      borderOnForeground: false,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ExpansionTile(
        backgroundColor: AppColors.mainColor.withOpacity(.7),
        title: Text(
          question,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
