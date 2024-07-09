import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'About Us',
          style: GoogleFonts.poppins(
            color: AppColors.mainColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'), // Your background image
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                width: width * 0.5,
                height: height * 0.15,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.logoNew),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withOpacity(.9),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Created By
                    const Text(
                      'Created By',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/profile.jpg'), // Your creator's image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'DR Sonal Jaiswal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(color: AppColors.greyTextColor),
                    // Our Mission
                    const Text(
                      'Our Mission',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: AppColors.greyTextColor),
                    // Our Vision
                    const Text(
                      'Our Vision',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Connect with us
              const Text(
                'Connect with us:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/images/facebook.svg'),
                    onPressed: () {
                      _launchURL('https://facebook.com');
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/images/instagram.svg'),
                    onPressed: () {
                      _launchURL('https://instagram.com');
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/images/youtube.svg'),
                    onPressed: () {
                      _launchURL('https://youtube.com');
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/images/whatsapp.svg'),
                    onPressed: () {
                      _launchURL('https://wa.me/yourphonenumber');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
